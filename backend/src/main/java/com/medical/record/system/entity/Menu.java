package com.medical.record.system.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;

@Data
@TableName("sys_menu")
public class Menu {

    @TableId(type = IdType.AUTO)
    private Long id;

    @TableField("parent_id")
    private Long parentId;

    private String name;

    private String path;

    private String component;

    private String icon;

    private Integer sort;

    private Integer status;

    @TableField("created_time")
    private LocalDateTime createdTime;

    @TableField("updated_time")
    private LocalDateTime updatedTime;

    @TableField("deleted")
    @TableLogic
    private Integer deleted;

    // 子菜单列表
    @TableField(exist = false)
    private List<Menu> children;

}