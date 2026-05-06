package com.medical.record.system.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.medical.record.system.entity.Role;

import java.util.List;

public interface RoleService extends IService<Role> {

    /**
     * 查询角色及其关联的权限
     */
    Role selectRoleWithPermissions(Long roleId);

    /**
     * 查询角色及其关联的菜单
     */
    Role selectRoleWithMenus(Long roleId);

    /**
     * 根据用户ID查询角色列表
     */
    List<Role> selectRolesByUserId(Long userId);

    /**
     * 分配权限给角色
     */
    boolean assignPermissions(Long roleId, List<Long> permissionIds);

    /**
     * 分配菜单给角色
     */
    boolean assignMenus(Long roleId, List<Long> menuIds);

}