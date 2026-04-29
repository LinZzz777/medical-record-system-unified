package com.medical.record.system.config;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;

@Slf4j
@Component
@RequiredArgsConstructor
public class SysTablesInitializer implements ApplicationRunner {

    private final JdbcTemplate jdbcTemplate;

    @Override
    public void run(ApplicationArguments args) {
        createRoleTable();
        createPermissionTable();
        createRolePermissionTable();
        createMenuTable();
        createRoleMenuTable();
        seedDefaultRoles();
    }

    private void createRoleTable() {
        try {
            jdbcTemplate.execute(
                "CREATE TABLE sys_role (" +
                "  id BIGINT IDENTITY(1,1) PRIMARY KEY," +
                "  role_name VARCHAR(50) NOT NULL," +
                "  description VARCHAR(200)," +
                "  status INT DEFAULT 1," +
                "  created_time DATETIME DEFAULT GETDATE()," +
                "  updated_time DATETIME," +
                "  deleted INT DEFAULT 0" +
                ")");
            log.info("角色表 sys_role 创建成功");
        } catch (Exception e) {
            log.info("角色表 sys_role 已存在: {}", e.getMessage());
        }
    }

    private void createPermissionTable() {
        try {
            jdbcTemplate.execute(
                "CREATE TABLE sys_permission (" +
                "  id BIGINT IDENTITY(1,1) PRIMARY KEY," +
                "  perm_code VARCHAR(50) NOT NULL," +
                "  perm_name VARCHAR(50) NOT NULL," +
                "  description VARCHAR(200)," +
                "  status INT DEFAULT 1," +
                "  created_time DATETIME DEFAULT GETDATE()," +
                "  updated_time DATETIME," +
                "  deleted INT DEFAULT 0" +
                ")");
            log.info("权限表 sys_permission 创建成功");
        } catch (Exception e) {
            log.info("权限表 sys_permission 已存在: {}", e.getMessage());
        }
    }

    private void createRolePermissionTable() {
        try {
            jdbcTemplate.execute(
                "CREATE TABLE sys_role_permission (" +
                "  role_id BIGINT NOT NULL," +
                "  permission_id BIGINT NOT NULL" +
                ")");
            log.info("角色权限关联表 sys_role_permission 创建成功");
        } catch (Exception e) {
            log.info("角色权限关联表 sys_role_permission 已存在: {}", e.getMessage());
        }
    }

    private void createMenuTable() {
        try {
            jdbcTemplate.execute(
                "CREATE TABLE sys_menu (" +
                "  id BIGINT IDENTITY(1,1) PRIMARY KEY," +
                "  parent_id BIGINT," +
                "  name VARCHAR(50) NOT NULL," +
                "  path VARCHAR(200)," +
                "  component VARCHAR(200)," +
                "  icon VARCHAR(50)," +
                "  sort INT," +
                "  status INT DEFAULT 1," +
                "  created_time DATETIME DEFAULT GETDATE()," +
                "  updated_time DATETIME," +
                "  deleted INT DEFAULT 0" +
                ")");
            log.info("菜单表 sys_menu 创建成功");
        } catch (Exception e) {
            log.info("菜单表 sys_menu 已存在: {}", e.getMessage());
        }
    }

    private void createRoleMenuTable() {
        try {
            jdbcTemplate.execute(
                "CREATE TABLE sys_role_menu (" +
                "  role_id BIGINT NOT NULL," +
                "  menu_id BIGINT NOT NULL" +
                ")");
            log.info("角色菜单关联表 sys_role_menu 创建成功");
        } catch (Exception e) {
            log.info("角色菜单关联表 sys_role_menu 已存在: {}", e.getMessage());
        }
    }

    private void seedDefaultRoles() {
        String[][] roles = {
            {"admin", "系统管理员，拥有所有权限"},
            {"主任", "主任，审核借阅申请"},
            {"dept_director", "科室主任，管理本科室病案和借阅审批"},
            {"doctor", "医生，可创建和编辑病案"},
            {"nurse", "护士，可查看病案"},
            {"user", "普通用户，基本查看权限"}
        };

        for (String[] role : roles) {
            try {
                jdbcTemplate.update(
                    "INSERT INTO sys_role (role_name, description) VALUES (?, ?)",
                    role[0], role[1]);
                log.info("默认角色 {} 创建成功", role[0]);
            } catch (Exception e) {
                log.info("默认角色 {} 创建失败（可能已存在）: {}", role[0], e.getMessage());
            }
        }
    }
}
