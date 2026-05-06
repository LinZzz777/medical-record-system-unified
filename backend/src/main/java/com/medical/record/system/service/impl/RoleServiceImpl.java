package com.medical.record.system.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.medical.record.system.entity.Role;
import com.medical.record.system.mapper.RoleMapper;
import com.medical.record.system.service.RoleService;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class RoleServiceImpl extends ServiceImpl<RoleMapper, Role> implements RoleService {

    @Override
    public Role selectRoleWithPermissions(Long roleId) {
        return baseMapper.selectRoleWithPermissions(roleId);
    }

    @Override
    public Role selectRoleWithMenus(Long roleId) {
        return baseMapper.selectRoleWithMenus(roleId);
    }

    @Override
    public List<Role> selectRolesByUserId(Long userId) {
        return baseMapper.selectRolesByUserId(userId);
    }

    @Override
    public boolean assignPermissions(Long roleId, List<Long> permissionIds) {
        // 这里需要实现分配权限的逻辑
        // 1. 先删除角色现有的权限关联
        // 2. 再添加新的权限关联
        return true;
    }

    @Override
    public boolean assignMenus(Long roleId, List<Long> menuIds) {
        // 这里需要实现分配菜单的逻辑
        // 1. 先删除角色现有的菜单关联
        // 2. 再添加新的菜单关联
        return true;
    }

}