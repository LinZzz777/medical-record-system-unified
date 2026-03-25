SET NOCOUNT ON;

IF NOT EXISTS (SELECT 1 FROM MedicalRecords WHERE recordNumber = 'DEMO-MR-001')
BEGIN
    INSERT INTO MedicalRecords (recordNumber, patientName, patientId, department, diagnosis, status, admissionDate, dischargeDate, createdAt, updatedTime, deleted)
    VALUES
    ('DEMO-MR-001', N'Demo Patient 001', 'PID-001', N'妇产科', N'产后复查', N'已借出', '2026-02-20', '2026-02-25', DATEADD(day, -30, GETDATE()), DATEADD(day, -29, GETDATE()), 0),
    ('DEMO-MR-002', N'Demo Patient 002', 'PID-002', N'妇产科', N'妇科手术', N'已借出', '2026-02-24', '2026-03-01', DATEADD(day, -26, GETDATE()), DATEADD(day, -25, GETDATE()), 0),
    ('DEMO-MR-003', N'Demo Patient 003', 'PID-003', N'内科', N'糖尿病', N'已归档', '2026-03-01', '2026-03-05', DATEADD(day, -22, GETDATE()), DATEADD(day, -21, GETDATE()), 0),
    ('DEMO-MR-004', N'Demo Patient 004', 'PID-004', N'外科', N'阑尾炎', N'已归档', '2026-03-03', '2026-03-06', DATEADD(day, -20, GETDATE()), DATEADD(day, -18, GETDATE()), 0),
    ('DEMO-MR-005', N'Demo Patient 005', 'PID-005', N'儿科', N'肺炎', N'可借阅', '2026-03-06', '2026-03-08', DATEADD(day, -18, GETDATE()), DATEADD(day, -17, GETDATE()), 0),
    ('DEMO-MR-006', N'Demo Patient 006', 'PID-006', N'骨科', N'骨折', N'可借阅', '2026-03-08', '2026-03-10', DATEADD(day, -16, GETDATE()), DATEADD(day, -15, GETDATE()), 0),
    ('DEMO-MR-007', N'Demo Patient 007', 'PID-007', N'眼科', N'白内障', N'已借出', '2026-03-10', '2026-03-12', DATEADD(day, -14, GETDATE()), DATEADD(day, -13, GETDATE()), 0),
    ('DEMO-MR-008', N'Demo Patient 008', 'PID-008', N'耳鼻喉科', N'鼻窦炎', N'可借阅', '2026-03-12', '2026-03-14', DATEADD(day, -12, GETDATE()), DATEADD(day, -11, GETDATE()), 0),
    ('DEMO-MR-009', N'Demo Patient 009', 'PID-009', N'口腔科', N'智齿拔除', N'已归档', '2026-03-15', '2026-03-16', DATEADD(day, -10, GETDATE()), DATEADD(day, -9, GETDATE()), 0),
    ('DEMO-MR-010', N'Demo Patient 010', 'PID-010', N'内科', N'高血压', N'已借出', '2026-03-17', '2026-03-18', DATEADD(day, -8, GETDATE()), DATEADD(day, -7, GETDATE()), 0);
END;

DECLARE @r001 BIGINT = (SELECT id FROM MedicalRecords WHERE recordNumber = 'DEMO-MR-001');
DECLARE @r002 BIGINT = (SELECT id FROM MedicalRecords WHERE recordNumber = 'DEMO-MR-002');
DECLARE @r003 BIGINT = (SELECT id FROM MedicalRecords WHERE recordNumber = 'DEMO-MR-003');
DECLARE @r004 BIGINT = (SELECT id FROM MedicalRecords WHERE recordNumber = 'DEMO-MR-004');
DECLARE @r005 BIGINT = (SELECT id FROM MedicalRecords WHERE recordNumber = 'DEMO-MR-005');
DECLARE @r006 BIGINT = (SELECT id FROM MedicalRecords WHERE recordNumber = 'DEMO-MR-006');
DECLARE @r007 BIGINT = (SELECT id FROM MedicalRecords WHERE recordNumber = 'DEMO-MR-007');
DECLARE @r008 BIGINT = (SELECT id FROM MedicalRecords WHERE recordNumber = 'DEMO-MR-008');
DECLARE @r009 BIGINT = (SELECT id FROM MedicalRecords WHERE recordNumber = 'DEMO-MR-009');
DECLARE @r010 BIGINT = (SELECT id FROM MedicalRecords WHERE recordNumber = 'DEMO-MR-010');

IF NOT EXISTS (SELECT 1 FROM BorrowApplications WHERE reason = N'演示数据-逾期未归还-妇产科')
BEGIN
    INSERT INTO BorrowApplications (recordIds, reason, borrowType, expectedReturnDate, status, submitTime, userId, userName, approver, approveTime, rejectionReason, returnTime, createdTime, updatedTime, deleted)
    VALUES
    (CAST(@r001 AS varchar(20)), N'演示数据-逾期未归还-妇产科', N'院内借阅', CONVERT(varchar(10), DATEADD(day, -6, GETDATE()), 23), 'approved', DATEADD(day, -18, GETDATE()), 2, N'系统管理员', N'系统管理员', DATEADD(day, -17, GETDATE()), NULL, NULL, DATEADD(day, -18, GETDATE()), DATEADD(day, -17, GETDATE()), 0),
    (CAST(@r002 AS varchar(20)), N'演示数据-逾期未归还-已取件', N'院外借阅', CONVERT(varchar(10), DATEADD(day, -4, GETDATE()), 23), 'picked', DATEADD(day, -15, GETDATE()), 3, N'吴医师', N'系统管理员', DATEADD(day, -14, GETDATE()), NULL, NULL, DATEADD(day, -15, GETDATE()), DATEADD(day, -13, GETDATE()), 0),
    (CAST(@r003 AS varchar(20)), N'演示数据-按时归还-内科', N'院内借阅', CONVERT(varchar(10), DATEADD(day, -8, GETDATE()), 23), 'completed', DATEADD(day, -12, GETDATE()), 1, N'张三', N'系统管理员', DATEADD(day, -11, GETDATE()), NULL, DATEADD(day, -8, GETDATE()), DATEADD(day, -12, GETDATE()), DATEADD(day, -8, GETDATE()), 0),
    (CAST(@r004 AS varchar(20)), N'演示数据-逾期归还-外科', N'院外借阅', CONVERT(varchar(10), DATEADD(day, -16, GETDATE()), 23), 'completed', DATEADD(day, -20, GETDATE()), 2, N'系统管理员', N'系统管理员', DATEADD(day, -19, GETDATE()), NULL, DATEADD(day, -12, GETDATE()), DATEADD(day, -20, GETDATE()), DATEADD(day, -12, GETDATE()), 0),
    (CAST(@r005 AS varchar(20)), N'演示数据-待审批-儿科', N'院内借阅', CONVERT(varchar(10), DATEADD(day, 5, GETDATE()), 23), 'pending', DATEADD(day, -5, GETDATE()), 1, N'张三', NULL, NULL, NULL, NULL, DATEADD(day, -5, GETDATE()), DATEADD(day, -5, GETDATE()), 0),
    (CAST(@r006 AS varchar(20)), N'演示数据-已驳回-骨科', N'院外借阅', CONVERT(varchar(10), DATEADD(day, 7, GETDATE()), 23), 'rejected', DATEADD(day, -9, GETDATE()), 3, N'吴医师', N'系统管理员', DATEADD(day, -8, GETDATE()), N'演示数据：材料不完整', NULL, DATEADD(day, -9, GETDATE()), DATEADD(day, -8, GETDATE()), 0),
    (CAST(@r007 AS varchar(20)), N'演示数据-已取消-眼科', N'院内借阅', CONVERT(varchar(10), DATEADD(day, 6, GETDATE()), 23), 'cancelled', DATEADD(day, -7, GETDATE()), 1, N'张三', NULL, NULL, NULL, NULL, DATEADD(day, -7, GETDATE()), DATEADD(day, -6, GETDATE()), 0),
    (CAST(@r008 AS varchar(20)), N'演示数据-正常借出-耳鼻喉科', N'院外借阅', CONVERT(varchar(10), DATEADD(day, 3, GETDATE()), 23), 'approved', DATEADD(day, -3, GETDATE()), 2, N'系统管理员', N'系统管理员', DATEADD(day, -2, GETDATE()), NULL, NULL, DATEADD(day, -3, GETDATE()), DATEADD(day, -2, GETDATE()), 0),
    (CAST(@r009 AS varchar(20)), N'演示数据-按时归还-口腔科', N'院内借阅', CONVERT(varchar(10), DATEADD(day, -1, GETDATE()), 23), 'completed', DATEADD(day, -4, GETDATE()), 3, N'吴医师', N'系统管理员', DATEADD(day, -3, GETDATE()), NULL, DATEADD(day, -1, GETDATE()), DATEADD(day, -4, GETDATE()), DATEADD(day, -1, GETDATE()), 0),
    (CAST(@r010 AS varchar(20)), N'演示数据-近期借出-内科', N'院外借阅', CONVERT(varchar(10), DATEADD(day, 4, GETDATE()), 23), 'approved', DATEADD(day, -1, GETDATE()), 2, N'系统管理员', N'系统管理员', DATEADD(day, -1, GETDATE()), NULL, NULL, DATEADD(day, -1, GETDATE()), GETDATE(), 0);
END;
