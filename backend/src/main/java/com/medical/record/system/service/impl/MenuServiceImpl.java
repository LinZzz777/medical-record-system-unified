package com.medical.record.system.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.medical.record.system.entity.Menu;
import com.medical.record.system.mapper.MenuMapper;
import com.medical.record.system.service.MenuService;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class MenuServiceImpl extends ServiceImpl<MenuMapper, Menu> implements MenuService {

    @Override
    public List<Menu> selectAllMenus() {
        return baseMapper.selectAllMenus();
    }

    @Override
    public List<Menu> selectMenusByRoleId(Long roleId) {
        return baseMapper.selectMenusByRoleId(roleId);
    }

    @Override
    public List<Menu> selectMenusByUserId(Long userId) {
        return baseMapper.selectMenusByUserId(userId);
    }

    @Override
    public List<Menu> buildMenuTree(List<Menu> menus) {
        // 构建菜单树结构
        Map<Long, Menu> menuMap = menus.stream()
                .collect(Collectors.toMap(Menu::getId, menu -> {
                    menu.setChildren(new ArrayList<>());
                    return menu;
                }));

        List<Menu> rootMenus = new ArrayList<>();

        for (Menu menu : menus) {
            if (menu.getParentId() == 0) {
                // 根菜单
                rootMenus.add(menu);
            } else {
                // 子菜单
                Menu parentMenu = menuMap.get(menu.getParentId());
                if (parentMenu != null) {
                    parentMenu.getChildren().add(menu);
                }
            }
        }

        return rootMenus;
    }

}