-- 添加测试借阅申请数据
-- 执行日期: 2026-05-04
-- 说明: 此脚本用于向现有数据库添加不同状态的测试借阅申请

USE MedicalRecordDB;

-- 获取用户ID（假设用户已存在）
SET @user001_id = (SELECT id FROM Users WHERE username = 'user001' LIMIT 1);
SET @user003_id = (SELECT id FROM Users WHERE username = 'user003' LIMIT 1);
SET @user004_id = (SELECT id FROM Users WHERE username = 'user004' LIMIT 1);
SET @user005_id = (SELECT id FROM Users WHERE username = 'user005' LIMIT 1);
SET @user007_id = (SELECT id FROM Users WHERE username = 'user007' LIMIT 1);

-- 插入待科室审批的申请（内科医生申请）
INSERT INTO BorrowApplications (recordIds, reason, borrowType, expectedReturnDate, status, submitTime, userId, userName, createdTime, updatedTime, deleted)
VALUES 
('1', '病历复查需要', '院内借阅', '2026-06-01', 'pending_dept', NOW(), @user001_id, '张医生', NOW(), NOW(), 0),
('2,3', '会诊需要', '院内借阅', '2026-06-05', 'pending_dept', NOW(), @user003_id, '黄医生', NOW(), NOW(), 0);

-- 插入待病案室审批的申请（已通过科室审批）
INSERT INTO BorrowApplications (recordIds, reason, borrowType, expectedReturnDate, status, submitTime, userId, userName, deptApprover, deptApproveTime, createdTime, updatedTime, deleted)
VALUES 
('4', '学术研究', '院内借阅', '2026-06-10', 'pending_archive', DATE_SUB(NOW(), INTERVAL 2 DAY), @user004_id, '林医生', '杨主任', DATE_SUB(NOW(), INTERVAL 1 DAY), NOW(), NOW(), 0);

-- 插入已批准的申请
INSERT INTO BorrowApplications (recordIds, reason, borrowType, expectedReturnDate, status, submitTime, userId, userName, deptApprover, deptApproveTime, archiveApprover, archiveApproveTime, createdTime, updatedTime, deleted)
VALUES 
('5', '教学需要', '院内借阅', '2026-06-15', 'approved', DATE_SUB(NOW(), INTERVAL 5 DAY), @user005_id, '何医生', '赵主任', DATE_SUB(NOW(), INTERVAL 4 DAY), '马管理员', DATE_SUB(NOW(), INTERVAL 3 DAY), NOW(), NOW(), 0);

-- 插入已取件的申请
INSERT INTO BorrowApplications (recordIds, reason, borrowType, expectedReturnDate, status, submitTime, userId, userName, deptApprover, deptApproveTime, archiveApprover, archiveApproveTime, createdTime, updatedTime, deleted)
VALUES 
('6', '病例讨论', '院内借阅', '2026-06-20', 'picked', DATE_SUB(NOW(), INTERVAL 10 DAY), @user007_id, '罗医生', '周主任', DATE_SUB(NOW(), INTERVAL 9 DAY), '朱管理员', DATE_SUB(NOW(), INTERVAL 8 DAY), NOW(), NOW(), 0);

COMMIT;
