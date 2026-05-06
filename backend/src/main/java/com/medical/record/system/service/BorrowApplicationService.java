package com.medical.record.system.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.medical.record.system.entity.BorrowApplication;

import java.util.List;

public interface BorrowApplicationService extends IService<BorrowApplication> {

    /**
     * 根据用户ID查询借阅申请列表
     */
    List<BorrowApplication> selectByUserId(Long userId);

    /**
     * 根据状态查询借阅申请列表
     */
    List<BorrowApplication> selectByStatus(String status);

    /**
     * 查询待审批的借阅申请列表
     */
    List<BorrowApplication> selectPendingApplications();

    /**
     * 查询已过期的借阅申请列表
     */
    List<BorrowApplication> selectOverdueApplications();

    /**
     * 查询所有借阅申请列表
     */
    List<BorrowApplication> selectAllApplications();

    /**
     * 根据ID查询借阅申请
     */
    BorrowApplication selectById(Long id);

    /**
     * 创建借阅申请
     */
    boolean createBorrowApplication(BorrowApplication borrowApplication);

    /**
     * 科室审批通过（pending_dept -> pending_archive）
     */
    boolean deptApprove(Long id, String approver);

    /**
     * 科室审批驳回（pending_dept -> rejected）
     */
    boolean deptReject(Long id, String approver, String rejectionReason);

    /**
     * 病案室审批通过（pending_archive -> approved）
     */
    boolean archiveApprove(Long id, String approver);

    /**
     * 病案室审批驳回（pending_archive -> rejected）
     */
    boolean archiveReject(Long id, String approver, String rejectionReason);

    /**
     * 审批借阅申请（兼容旧版，根据当前状态自动判断）
     */
    boolean approveBorrowApplication(Long id, String approver);

    /**
     * 驳回借阅申请（兼容旧版，根据当前状态自动判断）
     */
    boolean rejectBorrowApplication(Long id, String approver, String rejectionReason);

    /**
     * 取消借阅申请（仅申请人可在pending_dept或pending_archive状态下取消）
     */
    boolean cancelBorrowApplication(Long id, Long userId);

    /**
     * 完成借阅申请（归还，picked -> completed）
     */
    boolean completeBorrowApplication(Long id);

    /**
     * 取件操作（approved -> picked）
     */
    boolean pickupBorrowApplication(Long id);

    /**
     * 批量科室审批通过
     */
    boolean batchDeptApprove(List<Long> ids, String approver);

    /**
     * 批量病案室审批通过
     */
    boolean batchArchiveApprove(List<Long> ids, String approver);

    /**
     * 批量审批借阅申请（兼容旧版）
     */
    boolean batchApproveBorrowApplications(List<Long> ids, String approver);

    /**
     * 批量驳回借阅申请（兼容旧版）
     */
    boolean batchRejectBorrowApplications(List<Long> ids, String approver, String rejectionReason);

    /**
     * 根据科室查询待科室审批的申请列表
     */
    List<BorrowApplication> selectPendingDeptByDepartment(String department);

    /**
     * 查询所有待病案室审批的申请列表
     */
    List<BorrowApplication> selectPendingArchiveAll();

}