package com.medical.record.system.controller;

import com.medical.record.system.entity.Menu;
import com.medical.record.system.service.MenuService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/menus")
public class MenuController {

    @Autowired
    private MenuService menuService;

    /**
     * 获取所有菜单
     */
    @GetMapping("/list")
    public List<Menu> getMenuList() {
        return menuService.selectAllMenus();
    }

    /**
     * 获取菜单树
     */
    @GetMapping("/tree")
    public List<Menu> getMenuTree() {
        List<Menu> menus = menuService.selectAllMenus();
        return menuService.buildMenuTree(menus);
    }

    /**
     * 根据角色ID获取菜单列表
     */
    @GetMapping("/by-role/{roleId}")
    public List<Menu> getMenusByRole(@PathVariable Long roleId) {
        return menuService.selectMenusByRoleId(roleId);
    }

    /**
     * 根据用户ID获取菜单列表
     */
    @GetMapping("/by-user/{userId}")
    public List<Menu> getMenusByUser(@PathVariable Long userId) {
        return menuService.selectMenusByUserId(userId);
    }

    /**
     * 根据用户ID获取菜单树
     */
    @GetMapping("/tree/by-user/{userId}")
    public List<Menu> getMenuTreeByUser(@PathVariable Long userId) {
        List<Menu> menus = menuService.selectMenusByUserId(userId);
        return menuService.buildMenuTree(menus);
    }

    /**
     * 创建菜单
     */
    @PostMapping("/create")
    public Map<String, Object> createMenu(@RequestBody Menu menu) {
        boolean success = menuService.save(menu);
        return Map.of("success", success);
    }

    /**
     * 更新菜单
     */
    @PutMapping("/update")
    public Map<String, Object> updateMenu(@RequestBody Menu menu) {
        boolean success = menuService.updateById(menu);
        return Map.of("success", success);
    }

    /**
     * 删除菜单
     */
    @DeleteMapping("/{id}")
    public Map<String, Object> deleteMenu(@PathVariable Long id) {
        boolean success = menuService.removeById(id);
        return Map.of("success", success);
    }

}