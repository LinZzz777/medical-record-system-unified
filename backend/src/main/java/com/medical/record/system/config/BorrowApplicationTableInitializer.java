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
                        "CREATE TABLE borrowapplications (" +
                        "  id INT AUTO_INCREMENT PRIMARY KEY," +
                        "  recordIds VARCHAR(255)," +
                        "  reason VARCHAR(500)," +
                        "  borrowType VARCHAR(20)," +
                        "  expectedReturnDate VARCHAR(20)," +
                        "  status VARCHAR(20) DEFAULT 'pending'," +
                        "  submitTime TIMESTAMP DEFAULT CURRENT_TIMESTAMP," +
                        "  userId INT," +
                        "  userName VARCHAR(100)," +
                        "  approver VARCHAR(100)," +
                        "  approveTime DATETIME," +
                        "  rejectionReason VARCHAR(500)," +
                        "  returnTime DATETIME," +
                        "  createdTime DATETIME," +
                        "  updatedTime DATETIME," +
                        "  deleted INT DEFAULT 0," +
                        "  deptApprover VARCHAR(50)," +
                        "  deptApproveTime DATETIME," +
                        "  deptRejectionReason VARCHAR(500)," +
                        "  userDepartment VARCHAR(50)" +
                        ")");
                log.info("借阅申请表 borrowapplications 创建成功");
            } catch (Exception e) {
                log.info("借阅申请表 borrowapplications 已存在，尝试添加缺失列: {}", e.getMessage());
                addMissingColumns();
            }
        } catch (Exception e) {
            log.error("借阅申请表初始化失败（不影响系统启动）: {}", e.getMessage());
        }
    }

    private void addMissingColumns() {
        // 修复 id 列缺少 AUTO_INCREMENT 的问题
        try {
            jdbcTemplate.execute("ALTER TABLE borrowapplications MODIFY COLUMN id INT AUTO_INCREMENT");
            log.info("id 列已设置为 AUTO_INCREMENT");
        } catch (Exception e) {
            log.info("id 列 AUTO_INCREMENT 设置失败（可能已存在）: {}", e.getMessage());
        }

        String[] columns = {
            "deptApprover VARCHAR(50)",
            "deptApproveTime DATETIME",
            "deptRejectionReason VARCHAR(500)",
            "userDepartment VARCHAR(50)"
        };
        for (String col : columns) {
            try {
                String colName = col.split(" ")[0];
                jdbcTemplate.execute("ALTER TABLE borrowapplications ADD " + col);
                log.info("列 {} 添加成功", colName);
            } catch (Exception e) {
                log.info("列 {} 已存在或添加失败（可忽略）: {}", col.split(" ")[0], e.getMessage());
            }
        }
    }
}