-- 添加多级审批相关字段到BorrowApplications表
-- 执行日期: 2026-05-04

USE MedicalRecordDB;

-- 添加科室审批相关字段（分开执行避免IF NOT EXISTS语法问题）
ALTER TABLE BorrowApplications ADD COLUMN deptApprover VARCHAR(50) COMMENT '科室审批人' AFTER userName;
ALTER TABLE BorrowApplications ADD COLUMN deptApproveTime DATETIME COMMENT '科室审批时间' AFTER deptApprover;
ALTER TABLE BorrowApplications ADD COLUMN deptRejectionReason VARCHAR(500) COMMENT '科室驳回原因' AFTER deptApproveTime;

-- 添加病案室审批相关字段
ALTER TABLE BorrowApplications ADD COLUMN archiveApprover VARCHAR(50) COMMENT '病案室审批人' AFTER deptRejectionReason;
ALTER TABLE BorrowApplications ADD COLUMN archiveApproveTime DATETIME COMMENT '病案室审批时间' AFTER archiveApprover;
ALTER TABLE BorrowApplications ADD COLUMN archiveRejectionReason VARCHAR(500) COMMENT '病案室驳回原因' AFTER archiveApproveTime;

-- 更新status字段的注释，反映新的状态值
ALTER TABLE BorrowApplications MODIFY COLUMN status VARCHAR(20) NOT NULL COMMENT '状态(pending_dept/pending_archive/approved/rejected/picked/completed/cancelled)';

-- 数据迁移：将现有的pending状态转换为pending_dept
UPDATE BorrowApplications SET status = 'pending_dept' WHERE status = 'pending';

COMMIT;
