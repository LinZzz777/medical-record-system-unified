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

    // 申请人科室
    private String department;

    // 科室审批相关字段
    private String deptApprover;              // 科室审批人
    private LocalDateTime deptApproveTime;   // 科室审批时间
    private String deptRejectionReason;      // 科室驳回原因

    // 病案室审批相关字段
    private String archiveApprover;          // 病案室审批人
    private LocalDateTime archiveApproveTime; // 病案室审批时间
    private String archiveRejectionReason;   // 病案室驳回原因

    // 兼容旧字段（保留用于向后兼容）
    private String approver;
    private LocalDateTime approveTime;
    private String rejectionReason;

    @TableField("returnTime")
    private LocalDateTime returnTime;

    @TableField(exist = false)
    private LocalDateTime cancelTime;

    private LocalDateTime createdTime;

    private LocalDateTime updatedTime;

    @TableLogic
    private Integer deleted;

    // 关联的病案列表
    @TableField(exist = false)
    private String recordNumbers;

}
