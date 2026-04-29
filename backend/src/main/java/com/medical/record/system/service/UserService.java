package com.medical.record.system.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.medical.record.system.entity.User;

import java.util.List;

public interface UserService extends IService<User> {

    /**
     * 根据用户名查询用户
     */
    User selectByUsername(String username);

    /**
     * 根据角色ID查询用户列表
     */
    List<User> selectByRoleId(Long roleId);

    /**
     * 批量更新用户状态
     */
    boolean updateStatusBatch(List<Long> ids, Integer status);

    /**
     * 登录验证
     */
    User login(String username, String password);

    /**
     * 注册用户
     */
    boolean register(User user);

    /**
     * 更新用户信息
     */
    boolean updateUserInfo(User user);

    /**
     * 重置用户密码
     */
    boolean resetPassword(Long userId, String newPassword);

    /**
     * 删除用户
     */
    boolean deleteUser(Long userId);

    /**
     * 更新单个用户状态（1启用，0禁用）
     */
    boolean updateUserStatus(Long userId, Integer status);

    /**
     * 根据科室查找科室主任
     */
    User findDirectorByDepartment(String department);

}