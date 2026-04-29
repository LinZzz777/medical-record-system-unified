package com.medical.record.system.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.medical.record.system.entity.Permission;
import com.medical.record.system.mapper.PermissionMapper;
import com.medical.record.system.service.PermissionService;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class PermissionServiceImpl extends ServiceImpl<PermissionMapper, Permission> implements PermissionService {

    @Override
    public List<Permission> selectPermissionsByRoleId(Long roleId) {
        return baseMapper.selectPermissionsByRoleId(roleId);
    }

    @Override
    public List<Permission> selectPermissionsByUserId(Long userId) {
        return baseMapper.selectPermissionsByUserId(userId);
    }

}