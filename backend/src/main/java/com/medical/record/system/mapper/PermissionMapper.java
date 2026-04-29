package com.medical.record.system.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.medical.record.system.entity.Permission;

import java.util.List;

public interface PermissionMapper extends BaseMapper<Permission> {

    /**
     * 根据角色ID查询权限列表
     */
    List<Permission> selectPermissionsByRoleId(Long roleId);

    /**
     * 根据用户ID查询权限列表
     */
    List<Permission> selectPermissionsByUserId(Long userId);

}