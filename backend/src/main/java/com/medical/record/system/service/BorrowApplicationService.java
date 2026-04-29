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
     * 审批借阅申请
     */
    boolean approveBorrowApplication(Long id, String approver);

    /**
     * 驳回借阅申请
     */
    boolean rejectBorrowApplication(Long id, String approver, String rejectionReason);

    /**
     * 取消借阅申请
     */
    boolean cancelBorrowApplication(Long id, Long userId);

    /**
     * 完成借阅申请（归还）
     */
    boolean completeBorrowApplication(Long id);
    
    /**
     * 取件操作
     */
    boolean pickupBorrowApplication(Long id);

    /**
     * 批量审批借阅申请
     */
    boolean batchApproveBorrowApplications(List<Long> ids, String approver);

    /**
     * 批量驳回借阅申请
     */
    boolean batchRejectBorrowApplications(List<Long> ids, String approver, String rejectionReason);

    /**
     * 科室主任审批借阅申请
     */
    boolean deptApproveBorrowApplication(Long id, String deptApprover);

    /**
     * 科室主任驳回借阅申请
     */
    boolean deptRejectBorrowApplication(Long id, String deptApprover, String rejectionReason);

    /**
     * 根据申请人科室查询借阅申请列表
     */
    List<BorrowApplication> selectByUserDepartment(String department);

    /**
     * 查询科室已审批待病案科终审的申请列表
     */
    List<BorrowApplication> selectDeptApprovedApplications();

}