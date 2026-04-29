package com.medical.record.system.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.medical.record.system.entity.BorrowApplication;
import com.medical.record.system.entity.MedicalRecord;
import com.medical.record.system.entity.User;
import com.medical.record.system.mapper.BorrowApplicationMapper;
import com.medical.record.system.service.BorrowApplicationService;
import com.medical.record.system.service.MedicalRecordService;
import com.medical.record.system.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Service
public class BorrowApplicationServiceImpl extends ServiceImpl<BorrowApplicationMapper, BorrowApplication> implements BorrowApplicationService {

    @Autowired
    private MedicalRecordService medicalRecordService;

    @Autowired
    private UserService userService;

    private List<Long> parseRecordIds(String recordIds) {
        List<Long> result = new ArrayList<>();
        if (recordIds == null) {
            return result;
        }
        String cleanIds = recordIds.trim();
        if (cleanIds.isEmpty()) {
            return result;
        }
        // 兼容历史数据的JSON数组字符串，如 "[117,119]"
        if (cleanIds.startsWith("[") && cleanIds.endsWith("]")) {
            cleanIds = cleanIds.substring(1, cleanIds.length() - 1).trim();
        }
        if (cleanIds.isEmpty()) {
            return result;
        }
        String[] parts = cleanIds.split(",");
        for (String part : parts) {
            if (part == null) {
                continue;
            }
            String s = part.trim();
            if (s.isEmpty()) {
                continue;
            }
            try {
                result.add(Long.valueOf(s));
            } catch (NumberFormatException ignored) {
                // 忽略无法转换的ID，避免整条流程失败
            }
        }
        return result;
    }

    @Override
    public List<BorrowApplication> selectByUserId(Long userId) {
        List<BorrowApplication> applications = baseMapper.selectByUserId(userId);
        populateRecordNumbers(applications);
        return applications;
    }

    @Override
    public List<BorrowApplication> selectByStatus(String status) {
        return baseMapper.selectByStatus(status);
    }

    @Override
    public List<BorrowApplication> selectPendingApplications() {
        return baseMapper.selectPendingApplications();
    }

    @Override
    public List<BorrowApplication> selectOverdueApplications() {
        return baseMapper.selectOverdueApplications();
    }

    @Override
    public List<BorrowApplication> selectAllApplications() {
        List<BorrowApplication> applications = baseMapper.selectAllApplications();
        populateRecordNumbers(applications);
        return applications;
    }

    @Override
    public BorrowApplication selectById(Long id) {
        BorrowApplication application = baseMapper.selectById(id);
        if (application != null) {
            String recordIds = application.getRecordIds();
            if (recordIds != null && !recordIds.isEmpty()) {
                // 处理JSON格式的数组，如"[117,118]"
                String cleanIds = recordIds.trim();
                if (cleanIds.startsWith("[") && cleanIds.endsWith("]")) {
                    cleanIds = cleanIds.substring(1, cleanIds.length() - 1);
                }
                String[] ids = cleanIds.split(",");
                StringBuilder recordNumbers = new StringBuilder();
                for (String recordId : ids) {
                    try {
                        Long idValue = Long.valueOf(recordId.trim());
                        MedicalRecord record = medicalRecordService.getById(idValue);
                        if (record != null) {
                            if (recordNumbers.length() > 0) {
                                recordNumbers.append(", ");
                            }
                            recordNumbers.append(record.getRecordNumber());
                        }
                    } catch (NumberFormatException e) {
                        // 忽略无法转换的ID
                        continue;
                    }
                }
                application.setRecordNumbers(recordNumbers.toString());
            }
        }
        return application;
    }

    @Override
    public boolean createBorrowApplication(BorrowApplication borrowApplication) {
        borrowApplication.setSubmitTime(LocalDateTime.now());
        borrowApplication.setCreatedTime(LocalDateTime.now());
        borrowApplication.setUpdatedTime(LocalDateTime.now());
        borrowApplication.setDeleted(0);
        // 填充申请人科室信息并判断审批流程
        if (borrowApplication.getUserId() != null) {
            User applicant = userService.getById(borrowApplication.getUserId());
            if (applicant != null) {
                if (applicant.getDepartment() != null) {
                    borrowApplication.setUserDepartment(applicant.getDepartment());
                }
                // 病案科主任申请：无需审批，直接通过
                if ("dept_director".equals(applicant.getRole()) && "病案科".equals(applicant.getDepartment())) {
                    borrowApplication.setStatus("approved");
                    borrowApplication.setApprover("自动审批");
                    borrowApplication.setApproveTime(LocalDateTime.now());
                    // 更新关联的病案状态为已借出
                    List<Long> ids = parseRecordIds(borrowApplication.getRecordIds());
                    for (Long recordId : ids) {
                        medicalRecordService.updateStatus(recordId, "已借出");
                    }
                    return save(borrowApplication);
                }
                // 科室主任申请：跳过科室审批，只需病案科主任终审
                if ("dept_director".equals(applicant.getRole())) {
                    borrowApplication.setStatus("dept_approved");
                    borrowApplication.setDeptApprover("跳过科室审批");
                    borrowApplication.setDeptApproveTime(LocalDateTime.now());
                    return save(borrowApplication);
                }
            }
        }
        // 普通用户申请：需要科室主任一级审批
        borrowApplication.setStatus("pending");
        return save(borrowApplication);
    }

    @Override
    public boolean approveBorrowApplication(Long id, String approver) {
        BorrowApplication borrowApplication = selectById(id);
        if (borrowApplication != null && "dept_approved".equals(borrowApplication.getStatus())) {
            borrowApplication.setStatus("approved");
            borrowApplication.setApprover(approver);
            borrowApplication.setApproveTime(LocalDateTime.now());
            borrowApplication.setUpdatedTime(LocalDateTime.now());

            // 更新关联的病案状态为已借出
            String recordIds = borrowApplication.getRecordIds();
            List<Long> ids = parseRecordIds(recordIds);
            for (Long recordId : ids) {
                medicalRecordService.updateStatus(recordId, "已借出");
            }

            return updateById(borrowApplication);
        }
        return false;
    }

    @Override
    public boolean rejectBorrowApplication(Long id, String approver, String rejectionReason) {
        BorrowApplication borrowApplication = selectById(id);
        if (borrowApplication != null && "dept_approved".equals(borrowApplication.getStatus())) {
            borrowApplication.setStatus("rejected");
            borrowApplication.setApprover(approver);
            borrowApplication.setRejectionReason(rejectionReason);
            borrowApplication.setApproveTime(LocalDateTime.now());
            borrowApplication.setUpdatedTime(LocalDateTime.now());
            return updateById(borrowApplication);
        }
        return false;
    }

    @Override
    public boolean deptApproveBorrowApplication(Long id, String deptApprover) {
        BorrowApplication borrowApplication = selectById(id);
        if (borrowApplication != null && "pending".equals(borrowApplication.getStatus())) {
            borrowApplication.setStatus("dept_approved");
            borrowApplication.setDeptApprover(deptApprover);
            borrowApplication.setDeptApproveTime(LocalDateTime.now());
            borrowApplication.setUpdatedTime(LocalDateTime.now());
            return updateById(borrowApplication);
        }
        return false;
    }

    @Override
    public boolean deptRejectBorrowApplication(Long id, String deptApprover, String rejectionReason) {
        BorrowApplication borrowApplication = selectById(id);
        if (borrowApplication != null && "pending".equals(borrowApplication.getStatus())) {
            borrowApplication.setStatus("rejected");
            borrowApplication.setDeptApprover(deptApprover);
            borrowApplication.setDeptApproveTime(LocalDateTime.now());
            borrowApplication.setDeptRejectionReason(rejectionReason);
            borrowApplication.setUpdatedTime(LocalDateTime.now());
            return updateById(borrowApplication);
        }
        return false;
    }

    @Override
    public List<BorrowApplication> selectByUserDepartment(String department) {
        List<BorrowApplication> applications = baseMapper.selectByUserDepartment(department);
        populateRecordNumbers(applications);
        return applications;
    }

    @Override
    public List<BorrowApplication> selectDeptApprovedApplications() {
        List<BorrowApplication> applications = baseMapper.selectDeptApprovedApplications();
        populateRecordNumbers(applications);
        return applications;
    }

    private void populateRecordNumbers(List<BorrowApplication> applications) {
        for (BorrowApplication application : applications) {
            String recordIds = application.getRecordIds();
            if (recordIds != null && !recordIds.isEmpty()) {
                String cleanIds = recordIds.trim();
                if (cleanIds.startsWith("[") && cleanIds.endsWith("]")) {
                    cleanIds = cleanIds.substring(1, cleanIds.length() - 1);
                }
                String[] ids = cleanIds.split(",");
                StringBuilder recordNumbers = new StringBuilder();
                for (String id : ids) {
                    try {
                        Long recordId = Long.valueOf(id.trim());
                        MedicalRecord record = medicalRecordService.getById(recordId);
                        if (record != null) {
                            if (recordNumbers.length() > 0) {
                                recordNumbers.append(", ");
                            }
                            recordNumbers.append(record.getRecordNumber());
                        }
                    } catch (NumberFormatException e) {
                        continue;
                    }
                }
                application.setRecordNumbers(recordNumbers.toString());
            }
        }
    }

    @Override
    public boolean cancelBorrowApplication(Long id, Long userId) {
        System.out.println("取消申请请求：id=" + id + ", userId=" + userId);
        BorrowApplication borrowApplication = selectById(id);
        if (borrowApplication != null) {
            System.out.println("申请存在：id=" + id + ", status=" + borrowApplication.getStatus() + ", userId=" + borrowApplication.getUserId());
            if ("pending".equals(borrowApplication.getStatus()) || "dept_approved".equals(borrowApplication.getStatus())) {
                // 验证用户权限，只有申请人才可以取消自己的申请
                if (!userId.equals(borrowApplication.getUserId())) {
                    System.out.println("用户权限验证失败：当前用户id=" + userId + ", 申请用户id=" + borrowApplication.getUserId());
                    return false;
                }
                borrowApplication.setStatus("cancelled");
                borrowApplication.setUpdatedTime(LocalDateTime.now());
                boolean result = updateById(borrowApplication);
                System.out.println("取消申请结果：" + result);
                return result;
            } else {
                System.out.println("申请状态不是pending或dept_approved：" + borrowApplication.getStatus());
                return false;
            }
        } else {
            System.out.println("申请不存在：id=" + id);
            return false;
        }
    }

    @Override
    public boolean pickupBorrowApplication(Long id) {
        BorrowApplication borrowApplication = selectById(id);
        if (borrowApplication != null && "approved".equals(borrowApplication.getStatus())) {
            return baseMapper.updateStatusByIdIncludingNullDeleted(id, "picked", LocalDateTime.now()) > 0;
        }
        return false;
    }

    @Override
    public boolean completeBorrowApplication(Long id) {
        BorrowApplication borrowApplication = selectById(id);
        if (borrowApplication != null && "picked".equals(borrowApplication.getStatus())) {
            boolean updated = baseMapper.updateStatusByIdIncludingNullDeleted(id, "completed", LocalDateTime.now()) > 0;
            if (!updated) {
                return false;
            }

            // 更新关联的病案状态为可借阅
            String recordIds = borrowApplication.getRecordIds();
            List<Long> ids = parseRecordIds(recordIds);
            for (Long recordId : ids) {
                medicalRecordService.updateStatus(recordId, "可借阅");
            }

            return true;
        }
        return false;
    }

    @Override
    public boolean batchApproveBorrowApplications(List<Long> ids, String approver) {
        for (Long id : ids) {
            if (!approveBorrowApplication(id, approver)) {
                return false;
            }
        }
        return true;
    }

    @Override
    public boolean batchRejectBorrowApplications(List<Long> ids, String approver, String rejectionReason) {
        for (Long id : ids) {
            if (!rejectBorrowApplication(id, approver, rejectionReason)) {
                return false;
            }
        }
        return true;
    }

}