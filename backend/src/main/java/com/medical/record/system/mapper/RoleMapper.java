package com.medical.record.system.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.medical.record.system.entity.Role;

import java.util.List;

public interface RoleMapper extends BaseMapper<Role> {

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

}