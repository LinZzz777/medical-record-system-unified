package com.medical.record.system.config;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;

import java.util.List;

@Slf4j
@Component
@RequiredArgsConstructor
public class UserTableInitializer implements ApplicationRunner {

    private final JdbcTemplate jdbcTemplate;

    @Override
    public void run(ApplicationArguments args) {
        try {
            jdbcTemplate.execute(
                "CREATE TABLE Users (" +
                "  id BIGINT AUTO_INCREMENT PRIMARY KEY," +
                "  employeeNumber VARCHAR(50)," +
                "  username VARCHAR(50) NOT NULL UNIQUE," +
                "  password VARCHAR(100) NOT NULL," +
                "  name VARCHAR(50) NOT NULL," +
                "  role VARCHAR(50) NOT NULL," +
                "  department VARCHAR(50)," +
                "  phone VARCHAR(20)," +
                "  email VARCHAR(100)," +
                "  address VARCHAR(200)," +
                "  position VARCHAR(50)," +
                "  status INT DEFAULT 1," +
                "  createdAt DATETIME DEFAULT NOW()," +
                "  deleted INT DEFAULT 0" +
                ")");
            log.info("用户表 Users 创建成功");
            seedDefaultUsers();
        } catch (Exception e) {
            log.info("用户表 Users 已存在，检查约束: {}", e.getMessage());
            removeRoleConstraints();
            ensureDeletedColumn();
            fixNullDeletedValues();
            ensureDefaultUsersExist();
        }
    }

    private void fixNullDeletedValues() {
        try {
            int updated = jdbcTemplate.update("UPDATE Users SET deleted = 0 WHERE deleted IS NULL");
            if (updated > 0) {
                log.info("已修复 {} 个用户的 deleted=NULL 问题，设置为 deleted=0", updated);
            }
        } catch (Exception e) {
            log.info("修复 deleted=NULL 值失败（可忽略）: {}", e.getMessage());
        }
    }

    private void seedDefaultUsers() {
        try {
            jdbcTemplate.execute(
                "INSERT INTO Users (employeeNumber, username, password, name, role, department, phone, email, status) " +
                "VALUES ('E001', 'admin', 'admin123', '系统管理员', 'admin', '病案科', '13800138000', 'admin@hospital.com', 1)");
            log.info("默认管理员 admin 创建成功");
        } catch (Exception e) {
            log.info("默认管理员创建失败（可能已存在）: {}", e.getMessage());
        }
        try {
            jdbcTemplate.execute(
                "INSERT INTO Users (employeeNumber, username, password, name, role, department, phone, email, status) " +
                "VALUES ('E002', 'director_med', 'director123', '病案科主任', 'dept_director', '病案科', '13800138001', 'med_director@hospital.com', 1)");
            log.info("默认病案科主任 director_med 创建成功");
        } catch (Exception e) {
            log.info("默认病案科主任创建失败（可能已存在）: {}", e.getMessage());
        }
        try {
            jdbcTemplate.execute(
                "INSERT INTO Users (employeeNumber, username, password, name, role, department, phone, email, status) " +
                "VALUES ('E003', 'doctor_zhang', 'doctor123', '张医生', 'doctor', '内科', '13900139000', 'zhang@hospital.com', 1)");
            log.info("默认医生 doctor_zhang 创建成功");
        } catch (Exception e) {
            log.info("默认医生创建失败（可能已存在）: {}", e.getMessage());
        }
    }

    private void ensureDefaultUsersExist() {
        try {
            Integer count = jdbcTemplate.queryForObject("SELECT COUNT(*) FROM Users WHERE deleted = 0", Integer.class);
            if (count == null || count == 0) {
                log.info("Users 表为空，插入默认用户");
                seedDefaultUsers();
            }
        } catch (Exception e) {
            log.info("检查默认用户失败（可忽略）: {}", e.getMessage());
        }
    }

    private void removeRoleConstraints() {
        try {
            List<String> constraints = jdbcTemplate.queryForList(
                "SELECT CONSTRAINT_NAME " +
                "FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS " +
                "WHERE TABLE_NAME = 'Users' AND CONSTRAINT_TYPE = 'CHECK'",
                String.class
            );
            for (String constraint : constraints) {
                try {
                    jdbcTemplate.execute("ALTER TABLE Users DROP CHECK `" + constraint + "`");
                    log.info("已删除角色列约束: {}", constraint);
                } catch (Exception ex) {
                    log.info("删除约束失败（可忽略）: {} - {}", constraint, ex.getMessage());
                }
            }
            if (constraints.isEmpty()) {
                log.info("Users 表角色列无 CHECK 约束，无需处理");
            }
        } catch (Exception e) {
            log.info("查询或删除约束失败（可忽略）: {}", e.getMessage());
        }
    }

    private void ensureDeletedColumn() {
        try {
            jdbcTemplate.execute("ALTER TABLE Users ADD deleted INT DEFAULT 0");
            log.info("deleted 列添加成功");
        } catch (Exception e) {
            log.info("deleted 列已存在或添加失败（可忽略）: {}", e.getMessage());
        }
    }
}
