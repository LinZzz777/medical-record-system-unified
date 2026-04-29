-- 病案借阅管理系统 - 100条病案数据初始化脚本
-- 适用数据库: SQL Server
-- 创建日期: 2026-04-27
-- 说明: 插入100条涵盖20+科室的病案记录，状态分布在可借阅/已借出/已归档

SET NOCOUNT ON;

-- 删除已有的种子数据（仅删除编号范围 MR2024001-MR2024100 的记录，避免覆盖现有数据）
DELETE FROM BorrowApplications WHERE recordIds IN (
    SELECT CAST(id AS VARCHAR(20)) FROM MedicalRecords WHERE recordNumber BETWEEN 'MR2024001' AND 'MR2024100'
);
DELETE FROM MedicalRecords WHERE recordNumber BETWEEN 'MR2024001' AND 'MR2024100';

INSERT INTO MedicalRecords (recordNumber, patientName, patientId, department, diagnosis, status, admissionDate, dischargeDate, createdAt, updatedTime, deleted)
VALUES
-- ===== 内科 (8条) =====
('MR2024001', N'张伟',     'P0001', N'内科', N'高血压2级',             N'可借阅', '2024-01-03', '2024-01-15', DATEADD(day, -100, GETDATE()), DATEADD(day, -100, GETDATE()), 0),
('MR2024002', N'李娜',     'P0002', N'内科', N'2型糖尿病',               N'已借出', '2024-01-08', '2024-01-22', DATEADD(day, -95, GETDATE()),  DATEADD(day, -90, GETDATE()), 0),
('MR2024003', N'王强',     'P0003', N'内科', N'慢性胃炎',               N'可借阅', '2024-02-01', '2024-02-10', DATEADD(day, -85, GETDATE()),  DATEADD(day, -85, GETDATE()), 0),
('MR2024004', N'刘洋',     'P0004', N'内科', N'急性支气管炎',           N'已归档', '2023-06-15', '2023-06-25', DATEADD(day, -80, GETDATE()),  DATEADD(day, -75, GETDATE()), 0),
('MR2024005', N'陈静',     'P0005', N'内科', N'缺铁性贫血',             N'可借阅', '2024-02-15', '2024-02-28', DATEADD(day, -70, GETDATE()),  DATEADD(day, -70, GETDATE()), 0),
('MR2024006', N'杨光',     'P0006', N'内科', N'甲状腺功能亢进',         N'已借出', '2024-03-01', '2024-03-18', DATEADD(day, -65, GETDATE()),  DATEADD(day, -60, GETDATE()), 0),
('MR2024007', N'赵敏',     'P0007', N'内科', N'急性胃肠炎',             N'可借阅', '2024-03-10', '2024-03-17', DATEADD(day, -55, GETDATE()),  DATEADD(day, -55, GETDATE()), 0),
('MR2024008', N'周杰',     'P0008', N'内科', N'冠心病不稳定型心绞痛',   N'可借阅', '2024-03-15', '2024-03-30', DATEADD(day, -50, GETDATE()),  DATEADD(day, -50, GETDATE()), 0),

-- ===== 外科 (8条) =====
('MR2024009', N'吴昊',     'P0009', N'外科', N'急性阑尾炎',             N'已归档', '2023-08-10', '2023-08-18', DATEADD(day, -95, GETDATE()),  DATEADD(day, -85, GETDATE()), 0),
('MR2024010', N'孙鹏',     'P0010', N'外科', N'胆囊结石伴胆囊炎',       N'可借阅', '2024-01-20', '2024-02-05', DATEADD(day, -90, GETDATE()),  DATEADD(day, -90, GETDATE()), 0),
('MR2024011', N'黄丽',     'P0011', N'外科', N'右侧腹股沟疝',           N'已借出', '2024-02-10', '2024-02-18', DATEADD(day, -75, GETDATE()),  DATEADD(day, -70, GETDATE()), 0),
('MR2024012', N'马超',     'P0012', N'外科', N'甲状腺结节切除术',       N'可借阅', '2024-02-20', '2024-03-05', DATEADD(day, -65, GETDATE()),  DATEADD(day, -65, GETDATE()), 0),
('MR2024013', N'朱峰',     'P0013', N'外科', N'下肢静脉曲张',           N'可借阅', '2024-03-05', '2024-03-15', DATEADD(day, -55, GETDATE()),  DATEADD(day, -55, GETDATE()), 0),
('MR2024014', N'胡涛',     'P0014', N'外科', N'胃穿孔修补术后',         N'已归档', '2023-11-01', '2023-11-20', DATEADD(day, -50, GETDATE()),  DATEADD(day, -40, GETDATE()), 0),
('MR2024015', N'林海',     'P0015', N'外科', N'急性胰腺炎',             N'可借阅', '2024-03-20', '2024-04-05', DATEADD(day, -40, GETDATE()),  DATEADD(day, -40, GETDATE()), 0),
('MR2024016', N'何平',     'P0016', N'外科', N'胆总管结石',             N'已借出', '2024-04-01', '2024-04-15', DATEADD(day, -30, GETDATE()),  DATEADD(day, -25, GETDATE()), 0),

-- ===== 妇产科 (7条) =====
('MR2024017', N'郑爽',     'P0017', N'妇产科', N'产前检查',             N'可借阅', '2024-02-01', '2024-02-05', DATEADD(day, -90, GETDATE()),  DATEADD(day, -90, GETDATE()), 0),
('MR2024018', N'谢芳',     'P0018', N'妇产科', N'剖宫产术后',           N'已归档', '2023-07-20', '2023-07-28', DATEADD(day, -100, GETDATE()), DATEADD(day, -92, GETDATE()), 0),
('MR2024019', N'冯燕',     'P0019', N'妇产科', N'子宫肌瘤',             N'已借出', '2024-01-15', '2024-01-28', DATEADD(day, -80, GETDATE()),  DATEADD(day, -75, GETDATE()), 0),
('MR2024020', N'陈琳',     'P0020', N'妇产科', N'卵巢囊肿',             N'可借阅', '2024-02-15', '2024-02-25', DATEADD(day, -70, GETDATE()),  DATEADD(day, -70, GETDATE()), 0),
('MR2024021', N'韩雪',     'P0021', N'妇产科', N'产后复查',             N'可借阅', '2024-03-10', '2024-03-12', DATEADD(day, -50, GETDATE()),  DATEADD(day, -50, GETDATE()), 0),
('MR2024022', N'杨柳',     'P0022', N'妇产科', N'宫颈炎',               N'可借阅', '2024-03-25', '2024-04-03', DATEADD(day, -35, GETDATE()),  DATEADD(day, -35, GETDATE()), 0),
('MR2024023', N'方萍',     'P0023', N'妇产科', N'异位妊娠',             N'已借出', '2024-04-05', '2024-04-18', DATEADD(day, -22, GETDATE()),  DATEADD(day, -18, GETDATE()), 0),

-- ===== 儿科 (7条) =====
('MR2024024', N'雷明',     'P0024', N'儿科', N'小儿支气管肺炎',         N'可借阅', '2024-01-10', '2024-01-22', DATEADD(day, -95, GETDATE()),  DATEADD(day, -95, GETDATE()), 0),
('MR2024025', N'贺童',     'P0025', N'儿科', N'小儿腹泻病',             N'已借出', '2024-02-05', '2024-02-12', DATEADD(day, -75, GETDATE()),  DATEADD(day, -68, GETDATE()), 0),
('MR2024026', N'罗宇',     'P0026', N'儿科', N'手足口病',               N'可借阅', '2024-02-20', '2024-03-01', DATEADD(day, -65, GETDATE()),  DATEADD(day, -65, GETDATE()), 0),
('MR2024027', N'倪花',     'P0027', N'儿科', N'过敏性紫癜',             N'已归档', '2023-10-01', '2023-10-20', DATEADD(day, -60, GETDATE()),  DATEADD(day, -50, GETDATE()), 0),
('MR2024028', N'汤朔',     'P0028', N'儿科', N'新生儿黄疸',             N'可借阅', '2024-03-15', '2024-03-25', DATEADD(day, -45, GETDATE()),  DATEADD(day, -45, GETDATE()), 0),
('MR2024029', N'滕飞',     'P0029', N'儿科', N'急性上呼吸道感染',       N'可借阅', '2024-04-01', '2024-04-08', DATEADD(day, -20, GETDATE()),  DATEADD(day, -20, GETDATE()), 0),
('MR2024030', N'殷悦',     'P0030', N'儿科', N'婴幼儿哮喘',             N'已借出', '2024-04-10', '2024-04-20', DATEADD(day, -15, GETDATE()),  DATEADD(day, -10, GETDATE()), 0),

-- ===== 骨科 (7条) =====
('MR2024031', N'罗刚',     'P0031', N'骨科', N'右胫腓骨骨折',           N'可借阅', '2024-01-05', '2024-01-25', DATEADD(day, -100, GETDATE()), DATEADD(day, -100, GETDATE()), 0),
('MR2024032', N'毕磊',     'P0032', N'骨科', N'腰椎间盘突出症',         N'已借出', '2024-02-01', '2024-02-18', DATEADD(day, -80, GETDATE()),  DATEADD(day, -72, GETDATE()), 0),
('MR2024033', N'郝洁',     'P0033', N'骨科', N'颈椎病',                 N'可借阅', '2024-02-15', '2024-02-28', DATEADD(day, -68, GETDATE()),  DATEADD(day, -68, GETDATE()), 0),
('MR2024034', N'邬强',     'P0034', N'骨科', N'左膝半月板损伤',         N'已归档', '2023-09-10', '2023-09-25', DATEADD(day, -60, GETDATE()),  DATEADD(day, -52, GETDATE()), 0),
('MR2024035', N'安华',     'P0035', N'骨科', N'骨质疏松伴压缩性骨折',   N'可借阅', '2024-03-10', '2024-04-01', DATEADD(day, -45, GETDATE()),  DATEADD(day, -45, GETDATE()), 0),
('MR2024036', N'常温',     'P0036', N'骨科', N'肩袖损伤',               N'已借出', '2024-03-25', '2024-04-10', DATEADD(day, -30, GETDATE()),  DATEADD(day, -22, GETDATE()), 0),
('MR2024037', N'傅雷',     'P0037', N'骨科', N'股骨头坏死',             N'可借阅', '2024-04-15', '2024-05-01', DATEADD(day, -10, GETDATE()),  DATEADD(day, -10, GETDATE()), 0),

-- ===== 神经内科 (5条) =====
('MR2024038', N'沈斌',     'P0038', N'神经内科', N'脑梗塞急性期',       N'已借出', '2024-01-12', '2024-01-30', DATEADD(day, -90, GETDATE()),  DATEADD(day, -82, GETDATE()), 0),
('MR2024039', N'曾明',     'P0039', N'神经内科', N'偏头痛',             N'可借阅', '2024-02-10', '2024-02-18', DATEADD(day, -72, GETDATE()),  DATEADD(day, -72, GETDATE()), 0),
('MR2024040', N'邱红',     'P0040', N'神经内科', N'癫痫大发作',         N'已归档', '2023-12-01', '2023-12-15', DATEADD(day, -65, GETDATE()),  DATEADD(day, -55, GETDATE()), 0),
('MR2024041', N'秦刚',     'P0041', N'神经内科', N'帕金森病',           N'可借阅', '2024-03-05', '2024-03-22', DATEADD(day, -50, GETDATE()),  DATEADD(day, -50, GETDATE()), 0),
('MR2024042', N'江涛',     'P0042', N'神经内科', N'面神经麻痹',         N'可借阅', '2024-04-02', '2024-04-15', DATEADD(day, -25, GETDATE()),  DATEADD(day, -25, GETDATE()), 0),

-- ===== 心血管内科 (5条) =====
('MR2024043', N'史琳',     'P0043', N'心血管内科', N'冠心病支架术后',   N'已借出', '2024-01-18', '2024-02-05', DATEADD(day, -85, GETDATE()),  DATEADD(day, -78, GETDATE()), 0),
('MR2024044', N'顾宇',     'P0044', N'心血管内科', N'慢性心力衰竭',     N'已归档', '2023-08-20', '2023-09-10', DATEADD(day, -80, GETDATE()),  DATEADD(day, -70, GETDATE()), 0),
('MR2024045', N'侯伟',     'P0045', N'心血管内科', N'室性心律失常',     N'可借阅', '2024-02-20', '2024-03-08', DATEADD(day, -60, GETDATE()),  DATEADD(day, -60, GETDATE()), 0),
('MR2024046', N'邵阳',     'P0046', N'心血管内科', N'急性心肌梗死',     N'可借阅', '2024-03-18', '2024-04-05', DATEADD(day, -42, GETDATE()),  DATEADD(day, -42, GETDATE()), 0),
('MR2024047', N'孟超',     'P0047', N'心血管内科', N'高血压性心脏病',   N'已借出', '2024-04-08', '2024-04-22', DATEADD(day, -18, GETDATE()),  DATEADD(day, -12, GETDATE()), 0),

-- ===== 消化内科 (5条) =====
('MR2024048', N'龙飞',     'P0048', N'消化内科', N'胃溃疡伴出血',       N'可借阅', '2024-01-22', '2024-02-08', DATEADD(day, -88, GETDATE()),  DATEADD(day, -88, GETDATE()), 0),
('MR2024049', N'万芳',     'P0049', N'消化内科', N'肝硬化失代偿期',     N'已归档', '2023-11-15', '2023-12-05', DATEADD(day, -75, GETDATE()),  DATEADD(day, -65, GETDATE()), 0),
('MR2024050', N'段刚',     'P0050', N'消化内科', N'溃疡性结肠炎',       N'可借阅', '2024-02-25', '2024-03-15', DATEADD(day, -55, GETDATE()),  DATEADD(day, -55, GETDATE()), 0),
('MR2024051', N'雷蕾',     'P0051', N'消化内科', N'慢性乙型肝炎',       N'已借出', '2024-03-20', '2024-04-05', DATEADD(day, -40, GETDATE()),  DATEADD(day, -33, GETDATE()), 0),
('MR2024052', N'钱程',     'P0052', N'消化内科', N'急性胰腺炎',         N'可借阅', '2024-04-12', '2024-04-26', DATEADD(day, -12, GETDATE()),  DATEADD(day, -12, GETDATE()), 0),

-- ===== 呼吸内科 (5条) =====
('MR2024053', N'汤杰',     'P0053', N'呼吸内科', N'社区获得性肺炎',     N'可借阅', '2024-01-08', '2024-01-20', DATEADD(day, -95, GETDATE()),  DATEADD(day, -95, GETDATE()), 0),
('MR2024054', N'莫寒',     'P0054', N'呼吸内科', N'支气管哮喘急性发作', N'已归档', '2023-09-05', '2023-09-18', DATEADD(day, -82, GETDATE()),  DATEADD(day, -72, GETDATE()), 0),
('MR2024055', N'黎辉',     'P0055', N'呼吸内科', N'慢性阻塞性肺疾病',   N'已借出', '2024-02-10', '2024-02-28', DATEADD(day, -68, GETDATE()),  DATEADD(day, -60, GETDATE()), 0),
('MR2024056', N'池宁',     'P0056', N'呼吸内科', N'肺结节',             N'可借阅', '2024-03-15', '2024-03-25', DATEADD(day, -45, GETDATE()),  DATEADD(day, -45, GETDATE()), 0),
('MR2024057', N'乔磊',     'P0057', N'呼吸内科', N'结核性胸膜炎',       N'可借阅', '2024-04-10', '2024-04-30', DATEADD(day, -15, GETDATE()),  DATEADD(day, -15, GETDATE()), 0),

-- ===== 泌尿外科 (5条) =====
('MR2024058', N'白洁',     'P0058', N'泌尿外科', N'左肾结石',           N'可借阅', '2024-01-15', '2024-01-28', DATEADD(day, -92, GETDATE()),  DATEADD(day, -92, GETDATE()), 0),
('MR2024059', N'崔健',     'P0059', N'泌尿外科', N'前列腺增生',         N'已借出', '2024-02-08', '2024-02-22', DATEADD(day, -73, GETDATE()),  DATEADD(day, -65, GETDATE()), 0),
('MR2024060', N'康锐',     'P0060', N'泌尿外科', N'膀胱肿瘤术后',       N'已归档', '2023-10-10', '2023-11-01', DATEADD(day, -60, GETDATE()),  DATEADD(day, -50, GETDATE()), 0),
('MR2024061', N'范勇',     'P0061', N'泌尿外科', N'输尿管结石',         N'可借阅', '2024-03-22', '2024-04-05', DATEADD(day, -38, GETDATE()),  DATEADD(day, -38, GETDATE()), 0),
('MR2024062', N'丁宁',     'P0062', N'泌尿外科', N'肾囊肿',             N'可借阅', '2024-04-18', '2024-04-28', DATEADD(day, -8, GETDATE()),   DATEADD(day, -8, GETDATE()), 0),

-- ===== 眼科 (5条) =====
('MR2024063', N'甘霖',     'P0063', N'眼科', N'老年性白内障',           N'已归档', '2023-07-05', '2023-07-12', DATEADD(day, -100, GETDATE()), DATEADD(day, -88, GETDATE()), 0),
('MR2024064', N'宗文',     'P0064', N'眼科', N'急性闭角型青光眼',       N'可借阅', '2024-01-25', '2024-02-05', DATEADD(day, -83, GETDATE()),  DATEADD(day, -83, GETDATE()), 0),
('MR2024065', N'武华',     'P0065', N'眼科', N'糖尿病视网膜病变',       N'已借出', '2024-02-18', '2024-03-05', DATEADD(day, -65, GETDATE()),  DATEADD(day, -57, GETDATE()), 0),
('MR2024066', N'邹俊',     'P0066', N'眼科', N'角膜溃疡',               N'可借阅', '2024-03-28', '2024-04-10', DATEADD(day, -30, GETDATE()),  DATEADD(day, -30, GETDATE()), 0),
('MR2024067', N'石磊',     'P0067', N'眼科', N'视网膜脱离',             N'已借出', '2024-04-20', '2024-05-02', DATEADD(day, -5, GETDATE()),   DATEADD(day, -3, GETDATE()), 0),

-- ===== 耳鼻喉科 (4条) =====
('MR2024068', N'熊彪',     'P0068', N'耳鼻喉科', N'慢性鼻窦炎',         N'可借阅', '2024-01-28', '2024-02-08', DATEADD(day, -82, GETDATE()),  DATEADD(day, -82, GETDATE()), 0),
('MR2024069', N'阎丽',     'P0069', N'耳鼻喉科', N'分泌性中耳炎',       N'已归档', '2023-08-15', '2023-08-25', DATEADD(day, -78, GETDATE()),  DATEADD(day, -68, GETDATE()), 0),
('MR2024070', N'薛凯',     'P0070', N'耳鼻喉科', N'声带息肉',           N'可借阅', '2024-03-01', '2024-03-10', DATEADD(day, -52, GETDATE()),  DATEADD(day, -52, GETDATE()), 0),
('MR2024071', N'谭琳',     'P0071', N'耳鼻喉科', N'扁桃体周围脓肿',     N'已借出', '2024-04-05', '2024-04-15', DATEADD(day, -20, GETDATE()),  DATEADD(day, -14, GETDATE()), 0),

-- ===== 皮肤科 (4条) =====
('MR2024072', N'姜辉',     'P0072', N'皮肤科', N'带状疱疹',             N'已借出', '2024-02-01', '2024-02-12', DATEADD(day, -75, GETDATE()),  DATEADD(day, -66, GETDATE()), 0),
('MR2024073', N'于婷',     'P0073', N'皮肤科', N'慢性荨麻疹',           N'可借阅', '2024-02-20', '2024-03-05', DATEADD(day, -62, GETDATE()),  DATEADD(day, -62, GETDATE()), 0),
('MR2024074', N'田迪',     'P0074', N'皮肤科', N'寻常型银屑病',         N'已归档', '2023-12-10', '2023-12-30', DATEADD(day, -58, GETDATE()),  DATEADD(day, -46, GETDATE()), 0),
('MR2024075', N'邓超',     'P0075', N'皮肤科', N'湿疹',                 N'可借阅', '2024-04-12', '2024-04-22', DATEADD(day, -13, GETDATE()),  DATEADD(day, -13, GETDATE()), 0),

-- ===== 感染科 (4条) =====
('MR2024076', N'韦宁',     'P0076', N'感染科', N'继发性肺结核',         N'已归档', '2023-06-01', '2023-06-30', DATEADD(day, -110, GETDATE()), DATEADD(day, -80, GETDATE()), 0),
('MR2024077', N'苗青',     'P0077', N'感染科', N'急性细菌性痢疾',       N'可借阅', '2024-01-18', '2024-01-28', DATEADD(day, -88, GETDATE()),  DATEADD(day, -88, GETDATE()), 0),
('MR2024078', N'花蕾',     'P0078', N'感染科', N'流行性感冒重症',       N'可借阅', '2024-03-01', '2024-03-12', DATEADD(day, -50, GETDATE()),  DATEADD(day, -50, GETDATE()), 0),
('MR2024079', N'葛洪',     'P0079', N'感染科', N'慢性丙型病毒性肝炎',   N'已借出', '2024-04-02', '2024-04-22', DATEADD(day, -22, GETDATE()),  DATEADD(day, -16, GETDATE()), 0),

-- ===== 肿瘤科 (4条) =====
('MR2024080', N'潘杰',     'P0080', N'肿瘤科', N'右肺腺癌术后化疗',     N'已借出', '2024-01-10', '2024-01-30', DATEADD(day, -90, GETDATE()),  DATEADD(day, -82, GETDATE()), 0),
('MR2024081', N'柳春',     'P0081', N'肿瘤科', N'胃癌根治术后',         N'已归档', '2023-10-20', '2023-11-25', DATEADD(day, -72, GETDATE()),  DATEADD(day, -60, GETDATE()), 0),
('MR2024082', N'鲍峰',     'P0082', N'肿瘤科', N'乳腺癌术后放疗',       N'可借阅', '2024-03-08', '2024-04-05', DATEADD(day, -45, GETDATE()),  DATEADD(day, -45, GETDATE()), 0),
('MR2024083', N'费翔',     'P0083', N'肿瘤科', N'结肠癌辅助化疗',       N'可借阅', '2024-04-15', '2024-05-05', DATEADD(day, -10, GETDATE()),  DATEADD(day, -10, GETDATE()), 0),

-- ===== 康复科 (3条) =====
('MR2024084', N'廉杰',     'P0084', N'康复科', N'脑卒中后遗症康复',     N'可借阅', '2024-02-01', '2024-03-01', DATEADD(day, -78, GETDATE()),  DATEADD(day, -78, GETDATE()), 0),
('MR2024085', N'岑明',     'P0085', N'康复科', N'脊髓损伤康复训练',     N'已借出', '2024-03-01', '2024-04-01', DATEADD(day, -48, GETDATE()),  DATEADD(day, -40, GETDATE()), 0),
('MR2024086', N'薛平',     'P0086', N'康复科', N'膝关节置换术后康复',   N'可借阅', '2024-04-01', '2024-04-20', DATEADD(day, -17, GETDATE()),  DATEADD(day, -17, GETDATE()), 0),

-- ===== 中医科 (3条) =====
('MR2024087', N'申华',     'P0087', N'中医科', N'慢性腰腿痛',           N'可借阅', '2024-01-05', '2024-01-20', DATEADD(day, -96, GETDATE()),  DATEADD(day, -96, GETDATE()), 0),
('MR2024088', N'桂芬',     'P0088', N'中医科', N'顽固性失眠',           N'已借出', '2024-02-15', '2024-03-05', DATEADD(day, -60, GETDATE()),  DATEADD(day, -52, GETDATE()), 0),
('MR2024089', N'巩健',     'P0089', N'中医科', N'脾胃虚弱',             N'可借阅', '2024-04-08', '2024-04-22', DATEADD(day, -15, GETDATE()),  DATEADD(day, -15, GETDATE()), 0),

-- ===== 内分泌科 (3条) =====
('MR2024090', N'耿华',     'P0090', N'内分泌科', N'2型糖尿病伴并发症',  N'已借出', '2024-01-20', '2024-02-10', DATEADD(day, -85, GETDATE()),  DATEADD(day, -76, GETDATE()), 0),
('MR2024091', N'尚明',     'P0091', N'内分泌科', N'甲状腺功能减退症',   N'可借阅', '2024-03-05', '2024-03-20', DATEADD(day, -48, GETDATE()),  DATEADD(day, -48, GETDATE()), 0),
('MR2024092', N'丛兰',     'P0092', N'内分泌科', N'高脂血症',           N'已归档', '2023-11-20', '2023-12-05', DATEADD(day, -42, GETDATE()),  DATEADD(day, -35, GETDATE()), 0),

-- ===== 肾内科 (3条) =====
('MR2024093', N'井源',     'P0093', N'肾内科', N'慢性肾小球肾炎',       N'可借阅', '2024-02-10', '2024-03-01', DATEADD(day, -68, GETDATE()),  DATEADD(day, -68, GETDATE()), 0),
('MR2024094', N'竺平',     'P0094', N'肾内科', N'肾病综合征',           N'已借出', '2024-03-15', '2024-04-10', DATEADD(day, -38, GETDATE()),  DATEADD(day, -30, GETDATE()), 0),
('MR2024095', N'权明',     'P0095', N'肾内科', N'急性肾损伤',           N'可借阅', '2024-04-20', '2024-05-01', DATEADD(day, -6, GETDATE()),   DATEADD(day, -6, GETDATE()), 0),

-- ===== 口腔科 (3条) =====
('MR2024096', N'蔚峰',     'P0096', N'口腔科', N'慢性牙周炎',           N'可借阅', '2024-01-30', '2024-02-08', DATEADD(day, -80, GETDATE()),  DATEADD(day, -80, GETDATE()), 0),
('MR2024097', N'查隆',     'P0097', N'口腔科', N'阻生智齿拔除术',       N'已归档', '2023-12-05', '2023-12-12', DATEADD(day, -55, GETDATE()),  DATEADD(day, -42, GETDATE()), 0),
('MR2024098', N'甯静',     'P0098', N'口腔科', N'口腔黏膜白斑',         N'可借阅', '2024-04-05', '2024-04-15', DATEADD(day, -18, GETDATE()),  DATEADD(day, -18, GETDATE()), 0),

-- ===== 急诊科 (1条) =====
('MR2024099', N'蒲敏',     'P0099', N'急诊科', N'急性一氧化碳中毒',     N'可借阅', '2024-04-01', '2024-04-10', DATEADD(day, -22, GETDATE()),  DATEADD(day, -22, GETDATE()), 0),

-- ===== 风湿免疫科 (1条) =====
('MR2024100', N'全杰',     'P0100', N'风湿免疫科', N'类风湿性关节炎',   N'已借出', '2024-03-01', '2024-03-25', DATEADD(day, -42, GETDATE()),  DATEADD(day, -35, GETDATE()), 0);

-- 统计各类状态数量
SELECT '======= 病案数据插入完成 =======' AS message;
SELECT status AS N'状态', COUNT(*) AS N'数量' FROM MedicalRecords WHERE recordNumber BETWEEN 'MR2024001' AND 'MR2024100' GROUP BY status ORDER BY status;
SELECT department AS N'科室', COUNT(*) AS N'数量' FROM MedicalRecords WHERE recordNumber BETWEEN 'MR2024001' AND 'MR2024100' GROUP BY department ORDER BY COUNT(*) DESC;
SELECT COUNT(*) AS N'总计' FROM MedicalRecords WHERE recordNumber BETWEEN 'MR2024001' AND 'MR2024100';
