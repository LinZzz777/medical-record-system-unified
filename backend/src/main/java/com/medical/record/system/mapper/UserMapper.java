package com.medical.record.system.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.medical.record.system.entity.User;

import java.util.List;

public interface UserMapper extends BaseMapper<User> {

    /**
     * 根据角色ID查询用户列表
     */
    List<User> selectByRoleId(Long roleId);

    /**
     * 根据用户名查询用户
     */
    User selectByUsername(String username);

    /**
     * 批量更新用户状态
     */
    int updateStatusBatch(List<Long> ids, Integer status);

}