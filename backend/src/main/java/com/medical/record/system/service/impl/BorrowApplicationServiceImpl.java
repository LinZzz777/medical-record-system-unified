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
import java.util.stream.Collectors;

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
        // 为每个申请填充病案号
        for (BorrowApplication application : applications) {
            fillRecordNumbers(application);
        }
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
        // 为每个申请填充病案号
        for (BorrowApplication application : applications) {
            fillRecordNumbers(application);
        }
        return applications;
    }

    @Override
    public BorrowApplication selectById(Long id) {
        BorrowApplication application = baseMapper.selectById(id);
        if (application != null) {
            fillRecordNumbers(application);
        }
        return application;
    }

    /**
     * 填充病案号信息
     */
    private void fillRecordNumbers(BorrowApplication application) {
        String recordIds = application.getRecordIds();
        if (recordIds != null && !recordIds.isEmpty()) {
            // 处理JSON格式的数组，如"[117,118]"
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
                    // 忽略无法转换的ID
                    continue;
                }
            }
            application.setRecordNumbers(recordNumbers.toString());
        }
    }

    @Override
    public boolean createBorrowApplication(BorrowApplication borrowApplication) {
        // 新状态流转：提交后进入待科室审批状态
        borrowApplication.setStatus("pending_dept");
        borrowApplication.setSubmitTime(LocalDateTime.now());
        borrowApplication.setCreatedTime(LocalDateTime.now());
        borrowApplication.setUpdatedTime(LocalDateTime.now());
        borrowApplication.setDeleted(0);
        return save(borrowApplication);
    }

    /**
     * 科室审批通过：pending_dept -> pending_archive
     */
    @Override
    public boolean deptApprove(Long id, String approver) {
        BorrowApplication borrowApplication = selectById(id);
        if (borrowApplication != null && "pending_dept".equals(borrowApplication.getStatus())) {
            borrowApplication.setStatus("pending_archive");
            borrowApplication.setDeptApprover(approver);
            borrowApplication.setDeptApproveTime(LocalDateTime.now());
            borrowApplication.setUpdatedTime(LocalDateTime.now());
            return updateById(borrowApplication);
        }
        return false;
    }

    /**
     * 科室审批驳回：pending_dept -> rejected
     */
    @Override
    public boolean deptReject(Long id, String approver, String rejectionReason) {
        BorrowApplication borrowApplication = selectById(id);
        if (borrowApplication != null && "pending_dept".equals(borrowApplication.getStatus())) {
            borrowApplication.setStatus("rejected");
            borrowApplication.setDeptApprover(approver);
            borrowApplication.setDeptRejectionReason(rejectionReason);
            borrowApplication.setDeptApproveTime(LocalDateTime.now());
            borrowApplication.setUpdatedTime(LocalDateTime.now());
            return updateById(borrowApplication);
        }
        return false;
    }

    /**
     * 病案室审批通过：pending_archive -> approved（同时改变病案状态为"已借出"）
     */
    @Override
    public boolean archiveApprove(Long id, String approver) {
        BorrowApplication borrowApplication = selectById(id);
        if (borrowApplication != null && "pending_archive".equals(borrowApplication.getStatus())) {
            borrowApplication.setStatus("approved");
            borrowApplication.setArchiveApprover(approver);
            borrowApplication.setArchiveApproveTime(LocalDateTime.now());
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

    /**
     * 病案室审批驳回：pending_archive -> rejected
     */
    @Override
    public boolean archiveReject(Long id, String approver, String rejectionReason) {
        BorrowApplication borrowApplication = selectById(id);
        if (borrowApplication != null && "pending_archive".equals(borrowApplication.getStatus())) {
            borrowApplication.setStatus("rejected");
            borrowApplication.setArchiveApprover(approver);
            borrowApplication.setArchiveRejectionReason(rejectionReason);
            borrowApplication.setArchiveApproveTime(LocalDateTime.now());
            borrowApplication.setUpdatedTime(LocalDateTime.now());
            return updateById(borrowApplication);
        }
        return false;
    }

    /**
     * 审批借阅申请（兼容旧版，根据当前状态自动判断）
     * - 如果状态是pending_dept，执行科室审批
     * - 如果状态是pending_archive，执行病案室审批
     */
    @Override
    public boolean approveBorrowApplication(Long id, String approver) {
        BorrowApplication borrowApplication = selectById(id);
        if (borrowApplication == null) {
            return false;
        }

        String status = borrowApplication.getStatus();
        if ("pending_dept".equals(status)) {
            return deptApprove(id, approver);
        } else if ("pending_archive".equals(status)) {
            return archiveApprove(id, approver);
        }
        return false;
    }

    /**
     * 驳回借阅申请（兼容旧版，根据当前状态自动判断）
     * - 如果状态是pending_dept，执行科室驳回
     * - 如果状态是pending_archive，执行病案室驳回
     */
    @Override
    public boolean rejectBorrowApplication(Long id, String approver, String rejectionReason) {
        BorrowApplication borrowApplication = selectById(id);
        if (borrowApplication == null) {
            return false;
        }

        String status = borrowApplication.getStatus();
        if ("pending_dept".equals(status)) {
            return deptReject(id, approver, rejectionReason);
        } else if ("pending_archive".equals(status)) {
            return archiveReject(id, approver, rejectionReason);
        }
        return false;
    }

    /**
     * 取消借阅申请：pending_dept或pending_archive -> cancelled（仅申请人可操作）
     */
    @Override
    public boolean cancelBorrowApplication(Long id, Long userId) {
        System.out.println("取消申请请求：id=" + id + ", userId=" + userId);
        BorrowApplication borrowApplication = selectById(id);
        if (borrowApplication != null) {
            System.out.println("申请存在：id=" + id + ", status=" + borrowApplication.getStatus() + ", userId=" + borrowApplication.getUserId());
            // 只有在待审批状态下（pending_dept或pending_archive）才能取消
            if ("pending_dept".equals(borrowApplication.getStatus()) || "pending_archive".equals(borrowApplication.getStatus())) {
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
                System.out.println("申请状态不是pending_dept或pending_archive：" + borrowApplication.getStatus());
                return false;
            }
        } else {
            System.out.println("申请不存在：id=" + id);
            return false;
        }
    }

    /**
     * 取件操作：approved -> picked
     */
    @Override
    public boolean pickupBorrowApplication(Long id) {
        BorrowApplication borrowApplication = selectById(id);
        if (borrowApplication != null && "approved".equals(borrowApplication.getStatus())) {
            return baseMapper.updateStatusByIdIncludingNullDeleted(id, "picked", LocalDateTime.now()) > 0;
        }
        return false;
    }

    /**
     * 完成/归还：picked -> completed（联动病案状态变为"可借阅"）
     */
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

    /**
     * 批量科室审批通过
     */
    @Override
    public boolean batchDeptApprove(List<Long> ids, String approver) {
        for (Long id : ids) {
            if (!deptApprove(id, approver)) {
                return false;
            }
        }
        return true;
    }

    /**
     * 批量病案室审批通过
     */
    @Override
    public boolean batchArchiveApprove(List<Long> ids, String approver) {
        for (Long id : ids) {
            if (!archiveApprove(id, approver)) {
                return false;
            }
        }
        return true;
    }

    /**
     * 批量审批借阅申请（兼容旧版）
     */
    @Override
    public boolean batchApproveBorrowApplications(List<Long> ids, String approver) {
        for (Long id : ids) {
            if (!approveBorrowApplication(id, approver)) {
                return false;
            }
        }
        return true;
    }

    /**
     * 批量驳回借阅申请（兼容旧版）
     */
    @Override
    public boolean batchRejectBorrowApplications(List<Long> ids, String approver, String rejectionReason) {
        for (Long id : ids) {
            if (!rejectBorrowApplication(id, approver, rejectionReason)) {
                return false;
            }
        }
        return true;
    }

    /**
     * 根据科室查询待科室审批的申请列表
     * 只返回申请人属于指定科室的待科室审批申请
     */
    @Override
    public List<BorrowApplication> selectPendingDeptByDepartment(String department) {
        // 先获取所有待科室审批的申请
        List<BorrowApplication> allPending = baseMapper.selectByStatus("pending_dept");
        
        // 过滤出申请人属于指定科室的申请
        return allPending.stream()
            .filter(app -> {
                User applicant = userService.getById(app.getUserId());
                return applicant != null && department.equals(applicant.getDepartment());
            })
            .collect(Collectors.toList());
    }

    /**
     * 查询所有待病案室审批的申请列表
     */
    @Override
    public List<BorrowApplication> selectPendingArchiveAll() {
        return baseMapper.selectByStatus("pending_archive");
    }

}
