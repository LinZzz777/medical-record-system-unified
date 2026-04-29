package com.medical.record.system.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("BorrowApplications")
public class BorrowApplication {

    @TableId(type = IdType.AUTO)
    private Long id;

    private String recordIds;

    private String reason;

    private String borrowType;

    private String expectedReturnDate;

    private String status;

    private LocalDateTime submitTime;

    private Long userId;

    private String userName;

    private String approver;

    private LocalDateTime approveTime;

    private String rejectionReason;

    @TableField("returnTime")
    private LocalDateTime returnTime;

    @TableField(exist = false)
    private LocalDateTime cancelTime;

    private String deptApprover;

    private LocalDateTime deptApproveTime;

    private String deptRejectionReason;

    private String userDepartment;

    private LocalDateTime createdTime;

    private LocalDateTime updatedTime;

    @TableLogic
    private Integer deleted;

    // 关联的病案列表
    @TableField(exist = false)
    private String recordNumbers;

}
