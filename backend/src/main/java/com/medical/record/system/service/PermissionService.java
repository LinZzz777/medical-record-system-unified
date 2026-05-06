package com.medical.record.system.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.medical.record.system.entity.Permission;

import java.util.List;

public interface PermissionService extends IService<Permission> {

    /**
     * 根据角色ID查询权限列表
     */
    List<Permission> selectPermissionsByRoleId(Long roleId);

    /**
     * 根据用户ID查询权限列表
     */
    List<Permission> selectPermissionsByUserId(Long userId);

}