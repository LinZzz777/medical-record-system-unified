package com.medical.record.system.entity;

import com.baomidou.mybatisplus.annotation.*;
import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("audit_logs")
public class AuditLog {

    @TableId(type = IdType.AUTO)
    private Long id;

    private String username;

    private String operation;

    private String module;

    private String ip;

    @TableField("user_agent")
    private String userAgent;

    private String details;

    private Integer status;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @TableField("created_time")
    private LocalDateTime createdTime;

    @TableField("deleted")
    @TableLogic
    private Integer deleted;

}