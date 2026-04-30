package com.medical.record.system.controller;

import com.medical.record.system.config.OperationLog;
import com.medical.record.system.entity.BorrowApplication;
import com.medical.record.system.entity.User;
import com.medical.record.system.service.BorrowApplicationService;
import com.medical.record.system.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/borrow-applications")
public class BorrowApplicationController {

    @Autowired
    private BorrowApplicationService borrowApplicationService;

    @Autowired
    private UserService userService;

    /**
     * 获取所有借阅申请列表
     */
    @GetMapping("/list")
    public List<BorrowApplication> getBorrowApplicationList() {
        // 使用自定义查询避免查询不存在的字段
        return borrowApplicationService.selectAllApplications();
    }

    /**
     * 根据用户ID获取借阅申请列表
     */
    @GetMapping("/by-user/{userId}")
    public List<BorrowApplication> getBorrowApplicationsByUserId(@PathVariable Long userId) {
        return borrowApplicationService.selectByUserId(userId);
    }

    /**
     * 根据状态获取借阅申请列表
     */
    @GetMapping("/by-status/{status}")
    public List<BorrowApplication> getBorrowApplicationsByStatus(@PathVariable String status) {
        return borrowApplicationService.selectByStatus(status);
    }

    /**
     * 获取待审批的借阅申请列表
     */
    @GetMapping("/pending")
    public List<BorrowApplication> getPendingBorrowApplications() {
        return borrowApplicationService.selectPendingApplications();
    }

    /**
     * 获取已过期的借阅申请列表
     */
    @GetMapping("/overdue")
    public List<BorrowApplication> getOverdueBorrowApplications() {
        return borrowApplicationService.selectOverdueApplications();
    }

    /**
     * 根据申请人科室获取借阅申请列表（科室主任用）
     */
    @GetMapping("/by-dept/{department}")
    public List<BorrowApplication> getBorrowApplicationsByDepartment(@PathVariable String department) {
        return borrowApplicationService.selectByUserDepartment(department);
    }

    /**
     * 获取科室已审批待病案科终审的申请列表（病案科主任用）
     */
    @GetMapping("/dept-approved")
    public List<BorrowApplication> getDeptApprovedApplications() {
        return borrowApplicationService.selectDeptApprovedApplications();
    }

    /**
     * 根据ID获取借阅申请详情
     */
    @GetMapping("/{id}")
    public BorrowApplication getBorrowApplicationById(@PathVariable Long id) {
        return borrowApplicationService.getById(id);
    }

    /**
     * 创建借阅申请
     */
    @PostMapping("/create")
    @OperationLog(module = "Borrow", operation = "BORROW_APPLY", detail = "'user=' + #p0.userName + ', records=' + #p0.recordIds")
    public Map<String, Object> createBorrowApplication(@RequestBody BorrowApplication borrowApplication) {
        try {
            boolean success = borrowApplicationService.createBorrowApplication(borrowApplication);
            return Map.of("success", success);
        } catch (Exception e) {
            return Map.of("success", false, "message", "申请提交失败: " + e.getMessage());
        }
    }

    /**
     * 审批借阅申请
     */
    @PutMapping("/{id}/approve")
    @OperationLog(module = "Borrow", operation = "BORROW_APPROVE", detail = "'id=' + #p0 + ', approver=' + #p1['approver']")
    public Map<String, Object> approveBorrowApplication(@PathVariable Long id, @RequestBody Map<String, String> params) {
        String approver = params.get("approver");
        boolean success = borrowApplicationService.approveBorrowApplication(id, approver);
        return Map.of("success", success);
    }

    /**
     * 驳回借阅申请
     */
    @PutMapping("/{id}/reject")
    @OperationLog(module = "Borrow", operation = "BORROW_REJECT", detail = "'id=' + #p0 + ', approver=' + #p1['approver']")
    public Map<String, Object> rejectBorrowApplication(@PathVariable Long id, @RequestBody Map<String, String> params) {
        String approver = params.get("approver");
        String rejectionReason = params.get("rejectionReason");
        boolean success = borrowApplicationService.rejectBorrowApplication(id, approver, rejectionReason);
        return Map.of("success", success);
    }

    /**
     * 科室主任审批借阅申请（一级审批）
     */
    @PutMapping("/{id}/dept-approve")
    @OperationLog(module = "Borrow", operation = "BORROW_DEPT_APPROVE", detail = "'id=' + #p0 + ', deptApprover=' + #p1['approver']")
    public Map<String, Object> deptApproveBorrowApplication(@PathVariable Long id, @RequestBody Map<String, String> params) {
        String deptApprover = params.get("approver");
        String userIdStr = params.get("userId");
        // 验证科室主任只能审批本科室申请
        if (userIdStr != null) {
            try {
                Long userId = Long.valueOf(userIdStr);
                User approverUser = userService.getById(userId);
                if (approverUser != null && "dept_director".equals(approverUser.getRole())
                        && !"病案科".equals(approverUser.getDepartment())) {
                    BorrowApplication app = borrowApplicationService.getById(id);
                    if (app != null && !approverUser.getDepartment().equals(app.getUserDepartment())) {
                        return Map.of("success", false, "message", "只能审批本科室的借阅申请");
                    }
                }
            } catch (NumberFormatException ignored) {
            }
        }
        boolean success = borrowApplicationService.deptApproveBorrowApplication(id, deptApprover);
        return Map.of("success", success);
    }

    /**
     * 科室主任驳回借阅申请（一级驳回）
     */
    @PutMapping("/{id}/dept-reject")
    @OperationLog(module = "Borrow", operation = "BORROW_DEPT_REJECT", detail = "'id=' + #p0 + ', deptApprover=' + #p1['approver']")
    public Map<String, Object> deptRejectBorrowApplication(@PathVariable Long id, @RequestBody Map<String, String> params) {
        String deptApprover = params.get("approver");
        String rejectionReason = params.get("rejectionReason");
        String userIdStr = params.get("userId");
        // 验证科室主任只能审批本科室申请
        if (userIdStr != null) {
            try {
                Long userId = Long.valueOf(userIdStr);
                User approverUser = userService.getById(userId);
                if (approverUser != null && "dept_director".equals(approverUser.getRole())
                        && !"病案科".equals(approverUser.getDepartment())) {
                    BorrowApplication app = borrowApplicationService.getById(id);
                    if (app != null && !approverUser.getDepartment().equals(app.getUserDepartment())) {
                        return Map.of("success", false, "message", "只能审批本科室的借阅申请");
                    }
                }
            } catch (NumberFormatException ignored) {
            }
        }
        boolean success = borrowApplicationService.deptRejectBorrowApplication(id, deptApprover, rejectionReason);
        return Map.of("success", success);
    }

    /**
     * 取消借阅申请
     */
    @PutMapping("/{id}/cancel")
    @OperationLog(module = "Borrow", operation = "BORROW_CANCEL", detail = "'id=' + #p0 + ', userId=' + #p1['userId']")
    public Map<String, Object> cancelBorrowApplication(@PathVariable Long id, @RequestBody Map<String, Long> params) {
        Long userId = params.get("userId");
        boolean success = borrowApplicationService.cancelBorrowApplication(id, userId);
        return Map.of("success", success);
    }

    /**
     * 取件操作
     */
    @PutMapping("/{id}/pickup")
    @OperationLog(module = "Borrow", operation = "BORROW_PICKUP", detail = "'id=' + #p0")
    public Map<String, Object> pickupBorrowApplication(@PathVariable Long id) {
        boolean success = borrowApplicationService.pickupBorrowApplication(id);
        return Map.of("success", success);
    }

    /**
     * 完成借阅申请（归还）
     */
    @PutMapping("/{id}/complete")
    @OperationLog(module = "Borrow", operation = "BORROW_RETURN", detail = "'id=' + #p0")
    public Map<String, Object> completeBorrowApplication(@PathVariable Long id) {
        boolean success = borrowApplicationService.completeBorrowApplication(id);
        return Map.of("success", success);
    }

    /**
     * 批量审批借阅申请
     */
    @PutMapping("/batch-approve")
    @OperationLog(module = "Borrow", operation = "BORROW_BATCH_APPROVE", detail = "'ids=' + #p0['ids'] + ', approver=' + #p0['approver']")
    public Map<String, Object> batchApproveBorrowApplications(@RequestBody Map<String, Object> params) {
        List<Long> ids = (List<Long>) params.get("ids");
        String approver = params.get("approver").toString();
        boolean success = borrowApplicationService.batchApproveBorrowApplications(ids, approver);
        return Map.of("success", success);
    }

    /**
     * 批量驳回借阅申请
     */
    @PutMapping("/batch-reject")
    @OperationLog(module = "Borrow", operation = "BORROW_BATCH_REJECT", detail = "'ids=' + #p0['ids'] + ', approver=' + #p0['approver']")
    public Map<String, Object> batchRejectBorrowApplications(@RequestBody Map<String, Object> params) {
        List<Long> ids = (List<Long>) params.get("ids");
        String approver = params.get("approver").toString();
        String rejectionReason = params.get("rejectionReason").toString();
        boolean success = borrowApplicationService.batchRejectBorrowApplications(ids, approver, rejectionReason);
        return Map.of("success", success);
    }

}
