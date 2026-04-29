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
public class BorrowApplicationTableInitializer implements ApplicationRunner {

    private final JdbcTemplate jdbcTemplate;

    @Override
    public void run(ApplicationArguments args) {
        try {
            try {
                jdbcTemplate.execute(
                        "CREATE TABLE BorrowApplications (" +
                        "  id BIGINT IDENTITY(1,1) PRIMARY KEY," +
                        "  recordIds VARCHAR(500)," +
                        "  reason VARCHAR(500)," +
                        "  borrowType VARCHAR(50)," +
                        "  expectedReturnDate VARCHAR(50)," +
                        "  status VARCHAR(50) DEFAULT 'pending'," +
                        "  submitTime DATETIME," +
                        "  userId BIGINT," +
                        "  userName VARCHAR(50)," +
                        "  approver VARCHAR(50)," +
                        "  approveTime DATETIME," +
                        "  rejectionReason VARCHAR(500)," +
                        "  returnTime DATETIME," +
                        "  deptApprover VARCHAR(50)," +
                        "  deptApproveTime DATETIME," +
                        "  deptRejectionReason VARCHAR(500)," +
                        "  userDepartment VARCHAR(50)," +
                        "  createdTime DATETIME," +
                        "  updatedTime DATETIME," +
                        "  deleted INT DEFAULT 0" +
                        ")");
                log.info("借阅申请表 BorrowApplications 创建成功");
            } catch (Exception e) {
                log.info("借阅申请表 BorrowApplications 已存在，尝试添加缺失列: {}", e.getMessage());
                addMissingColumns();
            }
        } catch (Exception e) {
            log.error("借阅申请表初始化失败（不影响系统启动）: {}", e.getMessage());
        }
    }

    private void addMissingColumns() {
        String[] columns = {
            "deptApprover VARCHAR(50)",
            "deptApproveTime DATETIME",
            "deptRejectionReason VARCHAR(500)",
            "userDepartment VARCHAR(50)"
        };
        for (String col : columns) {
            try {
                String colName = col.split(" ")[0];
                // 直接尝试添加列，如果已存在会抛出异常
                jdbcTemplate.execute("ALTER TABLE BorrowApplications ADD " + col);
                log.info("列 {} 添加成功", colName);
            } catch (Exception e) {
                log.info("列 {} 已存在或添加失败（可忽略）: {}", col.split(" ")[0], e.getMessage());
            }
        }
    }
}
