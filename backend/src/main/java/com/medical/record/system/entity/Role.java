package com.medical.record.system.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;

@Data
@TableName("sys_role")
public class Role {

    @TableId(type = IdType.AUTO)
    private Long id;

    @TableField("role_name")
    private String roleName;

    private String description;

    private Integer status;

    @TableField("created_time")
    private LocalDateTime createdTime;

    @TableField("updated_time")
    private LocalDateTime updatedTime;

    @TableField("deleted")
    @TableLogic
    private Integer deleted;

    // 关联权限列表
    @TableField(exist = false)
    private List<Permission> permissions;

    // 关联菜单列表
    @TableField(exist = false)
    private List<Menu> menus;

}