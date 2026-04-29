package com.medical.record.system.controller;

import com.medical.record.system.entity.Role;
import com.medical.record.system.service.RoleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/roles")
public class RoleController {

    @Autowired
    private RoleService roleService;

    /**
     * 获取角色列表
     */
    @GetMapping("/list")
    public List<Role> getRoleList() {
        return roleService.list();
    }

    /**
     * 根据ID获取角色详情
     */
    @GetMapping("/{id}")
    public Role getRoleById(@PathVariable Long id) {
        return roleService.getById(id);
    }

    /**
     * 获取角色及其关联的权限
     */
    @GetMapping("/{id}/permissions")
    public Role getRoleWithPermissions(@PathVariable Long id) {
        return roleService.selectRoleWithPermissions(id);
    }

    /**
     * 获取角色及其关联的菜单
     */
    @GetMapping("/{id}/menus")
    public Role getRoleWithMenus(@PathVariable Long id) {
        return roleService.selectRoleWithMenus(id);
    }

    /**
     * 根据用户ID获取角色列表
     */
    @GetMapping("/by-user/{userId}")
    public List<Role> getRolesByUserId(@PathVariable Long userId) {
        return roleService.selectRolesByUserId(userId);
    }

    /**
     * 分配权限给角色
     */
    @PostMapping("/{id}/assign-permissions")
    public Map<String, Object> assignPermissions(@PathVariable Long id, @RequestBody Map<String, List<Long>> params) {
        List<Long> permissionIds = params.get("permissionIds");
        boolean success = roleService.assignPermissions(id, permissionIds);
        return Map.of("success", success);
    }

    /**
     * 分配菜单给角色
     */
    @PostMapping("/{id}/assign-menus")
    public Map<String, Object> assignMenus(@PathVariable Long id, @RequestBody Map<String, List<Long>> params) {
        List<Long> menuIds = params.get("menuIds");
        boolean success = roleService.assignMenus(id, menuIds);
        return Map.of("success", success);
    }

    /**
     * 创建角色
     */
    @PostMapping("/create")
    public Map<String, Object> createRole(@RequestBody Role role) {
        boolean success = roleService.save(role);
        return Map.of("success", success);
    }

    /**
     * 更新角色
     */
    @PutMapping("/update")
    public Map<String, Object> updateRole(@RequestBody Role role) {
        boolean success = roleService.updateById(role);
        return Map.of("success", success);
    }

    /**
     * 删除角色
     */
    @DeleteMapping("/{id}")
    public Map<String, Object> deleteRole(@PathVariable Long id) {
        boolean success = roleService.removeById(id);
        return Map.of("success", success);
    }

}