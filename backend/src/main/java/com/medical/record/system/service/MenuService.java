package com.medical.record.system.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.medical.record.system.entity.Menu;

import java.util.List;

public interface MenuService extends IService<Menu> {

    /**
     * 查询所有菜单，包括子菜单
     */
    List<Menu> selectAllMenus();

    /**
     * 根据角色ID查询菜单列表
     */
    List<Menu> selectMenusByRoleId(Long roleId);

    /**
     * 根据用户ID查询菜单列表
     */
    List<Menu> selectMenusByUserId(Long userId);

    /**
     * 构建菜单树
     */
    List<Menu> buildMenuTree(List<Menu> menus);

}