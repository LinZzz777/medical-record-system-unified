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
public class AuditLogTableInitializer implements ApplicationRunner {

    private final JdbcTemplate jdbcTemplate;

    @Override
    public void run(ApplicationArguments args) {
        try {
            jdbcTemplate.execute(
                    "CREATE TABLE audit_logs (" +
                    "  id BIGINT AUTO_INCREMENT PRIMARY KEY," +
                    "  username VARCHAR(50)," +
                    "  operation VARCHAR(100)," +
                    "  module VARCHAR(50)," +
                    "  ip VARCHAR(50)," +
                    "  user_agent VARCHAR(500)," +
                    "  details VARCHAR(500)," +
                    "  status INT DEFAULT 1," +
                    "  created_time DATETIME DEFAULT NOW()," +
                    "  deleted INT DEFAULT 0" +
                    ")");
            log.info("审计日志表 audit_logs 创建成功");
        } catch (Exception e) {
            log.info("审计日志表 audit_logs 已存在或创建失败（可忽略）: {}", e.getMessage());
        }
    }
}
