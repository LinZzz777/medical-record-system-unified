package com.medical.record.system.controller;

import com.medical.record.system.config.OperationLog;
import com.medical.record.system.entity.BorrowApplication;
import com.medical.record.system.service.BorrowApplicationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/borrow-applications")
public class BorrowApplicationController {

    @Autowired
    private BorrowApplicationService borrowApplicationService;

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
     * 获取待科室审批的借阅申请列表（所有）
     */
    @GetMapping("/pending-dept")
    public List<BorrowApplication> getPendingDeptApplications() {
        return borrowApplicationService.selectByStatus("pending_dept");
    }

    /**
     * 根据科室获取待科室审批的借阅申请列表
     */
    @GetMapping("/pending-dept/by-department/{department}")
    public List<BorrowApplication> getPendingDeptApplicationsByDepartment(@PathVariable String department) {
        return borrowApplicationService.selectPendingDeptByDepartment(department);
    }

    /**
     * 获取待病案室审批的借阅申请列表（所有已通过科室审批的）
     */
    @GetMapping("/pending-archive")
    public List<BorrowApplication> getPendingArchiveApplications() {
        return borrowApplicationService.selectPendingArchiveAll();
    }

    /**
     * 获取待审批的借阅申请列表（兼容旧版）
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
    @OperationLog(module = "Borrow", operation = "create", detail = "'user=' + #p0.userName + ', records=' + #p0.recordIds")
    public Map<String, Object> createBorrowApplication(@RequestBody BorrowApplication borrowApplication) {
        boolean success = borrowApplicationService.createBorrowApplication(borrowApplication);
        return Map.of("success", success);
    }

    /**
     * 科室审批通过
     */
    @PutMapping("/{id}/dept-approve")
    @OperationLog(module = "Borrow", operation = "deptApprove", detail = "'id=' + #p0 + ', approver=' + #p1['approver']")
    public Map<String, Object> deptApprove(@PathVariable Long id, @RequestBody Map<String, String> params) {
        String approver = params.get("approver");
        boolean success = borrowApplicationService.deptApprove(id, approver);
        return Map.of("success", success);
    }

    /**
     * 科室审批驳回
     */
    @PutMapping("/{id}/dept-reject")
    @OperationLog(module = "Borrow", operation = "deptReject", detail = "'id=' + #p0 + ', approver=' + #p1['approver']")
    public Map<String, Object> deptReject(@PathVariable Long id, @RequestBody Map<String, String> params) {
        String approver = params.get("approver");
        String rejectionReason = params.get("rejectionReason");
        boolean success = borrowApplicationService.deptReject(id, approver, rejectionReason);
        return Map.of("success", success);
    }

    /**
     * 病案室审批通过
     */
    @PutMapping("/{id}/archive-approve")
    @OperationLog(module = "Borrow", operation = "archiveApprove", detail = "'id=' + #p0 + ', approver=' + #p1['approver']")
    public Map<String, Object> archiveApprove(@PathVariable Long id, @RequestBody Map<String, String> params) {
        String approver = params.get("approver");
        boolean success = borrowApplicationService.archiveApprove(id, approver);
        return Map.of("success", success);
    }

    /**
     * 病案室审批驳回
     */
    @PutMapping("/{id}/archive-reject")
    @OperationLog(module = "Borrow", operation = "archiveReject", detail = "'id=' + #p0 + ', approver=' + #p1['approver']")
    public Map<String, Object> archiveReject(@PathVariable Long id, @RequestBody Map<String, String> params) {
        String approver = params.get("approver");
        String rejectionReason = params.get("rejectionReason");
        boolean success = borrowApplicationService.archiveReject(id, approver, rejectionReason);
        return Map.of("success", success);
    }

    /**
     * 审批借阅申请（兼容旧版）
     */
    @PutMapping("/{id}/approve")
    @OperationLog(module = "Borrow", operation = "approve", detail = "'id=' + #p0 + ', approver=' + #p1['approver']")
    public Map<String, Object> approveBorrowApplication(@PathVariable Long id, @RequestBody Map<String, String> params) {
        String approver = params.get("approver");
        boolean success = borrowApplicationService.approveBorrowApplication(id, approver);
        return Map.of("success", success);
    }

    /**
     * 驳回借阅申请（兼容旧版）
     */
    @PutMapping("/{id}/reject")
    @OperationLog(module = "Borrow", operation = "reject", detail = "'id=' + #p0 + ', approver=' + #p1['approver']")
    public Map<String, Object> rejectBorrowApplication(@PathVariable Long id, @RequestBody Map<String, String> params) {
        String approver = params.get("approver");
        String rejectionReason = params.get("rejectionReason");
        boolean success = borrowApplicationService.rejectBorrowApplication(id, approver, rejectionReason);
        return Map.of("success", success);
    }

    /**
     * 取消借阅申请
     */
    @PutMapping("/{id}/cancel")
    @OperationLog(module = "Borrow", operation = "cancel", detail = "'id=' + #p0 + ', userId=' + #p1['userId']")
    public Map<String, Object> cancelBorrowApplication(@PathVariable Long id, @RequestBody Map<String, Long> params) {
        Long userId = params.get("userId");
        boolean success = borrowApplicationService.cancelBorrowApplication(id, userId);
        return Map.of("success", success);
    }

    /**
     * 取件操作
     */
    @PutMapping("/{id}/pickup")
    @OperationLog(module = "Borrow", operation = "pickup", detail = "'id=' + #p0")
    public Map<String, Object> pickupBorrowApplication(@PathVariable Long id) {
        boolean success = borrowApplicationService.pickupBorrowApplication(id);
        return Map.of("success", success);
    }

    /**
     * 完成借阅申请（归还）
     */
    @PutMapping("/{id}/complete")
    @OperationLog(module = "Borrow", operation = "complete", detail = "'id=' + #p0")
    public Map<String, Object> completeBorrowApplication(@PathVariable Long id) {
        boolean success = borrowApplicationService.completeBorrowApplication(id);
        return Map.of("success", success);
    }

    /**
     * 批量科室审批通过
     */
    @PutMapping("/batch-dept-approve")
    @OperationLog(module = "Borrow", operation = "batchDeptApprove", detail = "'ids=' + #p0['ids'] + ', approver=' + #p0['approver']")
    public Map<String, Object> batchDeptApprove(@RequestBody Map<String, Object> params) {
        List<Long> ids = (List<Long>) params.get("ids");
        String approver = params.get("approver").toString();
        boolean success = borrowApplicationService.batchDeptApprove(ids, approver);
        return Map.of("success", success);
    }

    /**
     * 批量病案室审批通过
     */
    @PutMapping("/batch-archive-approve")
    @OperationLog(module = "Borrow", operation = "batchArchiveApprove", detail = "'ids=' + #p0['ids'] + ', approver=' + #p0['approver']")
    public Map<String, Object> batchArchiveApprove(@RequestBody Map<String, Object> params) {
        List<Long> ids = (List<Long>) params.get("ids");
        String approver = params.get("approver").toString();
        boolean success = borrowApplicationService.batchArchiveApprove(ids, approver);
        return Map.of("success", success);
    }

    /**
     * 批量审批借阅申请（兼容旧版）
     */
    @PutMapping("/batch-approve")
    @OperationLog(module = "Borrow", operation = "batchApprove", detail = "'ids=' + #p0['ids'] + ', approver=' + #p0['approver']")
    public Map<String, Object> batchApproveBorrowApplications(@RequestBody Map<String, Object> params) {
        List<Long> ids = (List<Long>) params.get("ids");
        String approver = params.get("approver").toString();
        boolean success = borrowApplicationService.batchApproveBorrowApplications(ids, approver);
        return Map.of("success", success);
    }

    /**
     * 批量驳回借阅申请（兼容旧版）
     */
    @PutMapping("/batch-reject")
    @OperationLog(module = "Borrow", operation = "batchReject", detail = "'ids=' + #p0['ids'] + ', approver=' + #p0['approver']")
    public Map<String, Object> batchRejectBorrowApplications(@RequestBody Map<String, Object> params) {
        List<Long> ids = (List<Long>) params.get("ids");
        String approver = params.get("approver").toString();
        String rejectionReason = params.get("rejectionReason").toString();
        boolean success = borrowApplicationService.batchRejectBorrowApplications(ids, approver, rejectionReason);
        return Map.of("success", success);
    }

}
