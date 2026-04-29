package com.medical.record.system.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.medical.record.system.entity.BorrowApplication;
import org.apache.ibatis.annotations.Param;

import java.time.LocalDateTime;
import java.util.List;

public interface BorrowApplicationMapper extends BaseMapper<BorrowApplication> {

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
     * 更新状态（兼容deleted字段为NULL的历史数据）
     */
    int updateStatusByIdIncludingNullDeleted(@Param("id") Long id,
                                             @Param("status") String status,
                                             @Param("updatedTime") LocalDateTime updatedTime);

    /**
     * 根据申请人科室查询借阅申请列表
     */
    List<BorrowApplication> selectByUserDepartment(String department);

    /**
     * 查询科室已审批待病案科终审的申请列表
     */
    List<BorrowApplication> selectDeptApprovedApplications();

}