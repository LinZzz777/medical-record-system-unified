package com.medical.record.system.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("Users")
public class User {

    @TableId(type = IdType.AUTO)
    private Long id;

    @TableField("employeeNumber")
    private String employeeNumber;

    private String username;

    private String password;

    private String name;

    private String role;

    private String department;

    private String phone;

    private String email;

    private String address;

    private String position;

    private Integer status;

    @TableField("createdAt")
    private LocalDateTime createdAt;

    @TableLogic
    private Integer deleted;

}