package com.medical.record.system.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.medical.record.system.entity.User;
import com.medical.record.system.mapper.UserMapper;
import com.medical.record.system.service.UserService;
import org.springframework.stereotype.Service;

import lombok.extern.slf4j.Slf4j;

import java.time.LocalDateTime;
import java.util.List;

@Slf4j
@Service
public class UserServiceImpl extends ServiceImpl<UserMapper, User> implements UserService {

    @Override
    public User selectByUsername(String username) {
        return baseMapper.selectByUsername(username);
    }

    @Override
    public List<User> selectByRoleId(Long roleId) {
        return baseMapper.selectByRoleId(roleId);
    }

    @Override
    public boolean updateStatusBatch(List<Long> ids, Integer status) {
        return baseMapper.updateStatusBatch(ids, status) > 0;
    }

    @Override
    public User login(String username, String password) {
        User user = baseMapper.selectByUsername(username);
        log.debug("登录查询: username={}, userFound={}", username, user != null);
        if (user != null) {
            log.debug("登录校验: status={}, passwordMatch={}", user.getStatus(), user.getPassword().equals(password));
            if (user.getPassword().equals(password) && !Integer.valueOf(0).equals(user.getStatus())) {
                return user;
            }
        }
        return null;
    }

    @Override
    public boolean register(User user) {
        user.setCreatedAt(LocalDateTime.now());
        if (user.getStatus() == null) {
            user.setStatus(1);
        }
        return save(user);
    }

    @Override
    public boolean updateUserInfo(User user) {
        if (user.getPassword() == null || user.getPassword().trim().isEmpty()) {
            User existingUser = getById(user.getId());
            if (existingUser != null) {
                user.setPassword(existingUser.getPassword());
            }
        }
        return updateById(user);
    }

    @Override
    public boolean resetPassword(Long userId, String newPassword) {
        User user = getById(userId);
        if (user != null) {
            user.setPassword(newPassword);
            return updateById(user);
        }
        return false;
    }

    @Override
    public boolean deleteUser(Long userId) {
        return removeById(userId);
    }

    @Override
    public boolean updateUserStatus(Long userId, Integer status) {
        User user = getById(userId);
        if (user == null) {
            return false;
        }
        user.setStatus(status);
        return updateById(user);
    }

    @Override
    public User findDirectorByDepartment(String department) {
        LambdaQueryWrapper<User> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(User::getRole, "dept_director")
               .eq(User::getDepartment, department)
               .eq(User::getStatus, 1);
        return getOne(wrapper);
    }

}
