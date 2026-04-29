-- 病案借阅管理系统 - 100条病案数据初始化脚本
-- 适用数据库: MySQL 8.0+
-- 创建日期: 2026-04-27
-- 说明: 插入100条涵盖20+科室的病案记录，状态分布在可借阅/已借出/已归档

USE MedicalRecordDB;

-- 删除已有的种子数据（仅删除编号范围 MR2024011-MR2024110 的记录）
--DELETE FROM BorrowApplications WHERE recordIds IN (
 --   SELECT CAST(id AS CHAR(20)) FROM MedicalRecords WHERE recordNumber BETWEEN 'MR2024011' AND 'MR2024110'
--);
--DELETE FROM MedicalRecords WHERE recordNumber BETWEEN 'MR2024011' AND 'MR2024110';

INSERT INTO MedicalRecords (recordNumber, patientName, patientId, department, diagnosis, status, admissionDate, dischargeDate, createdAt, updatedTime, deleted)
VALUES
-- ===== 内科 (8条) =====
('MR2024011', '张伟',     'P0001', '内科', '高血压2级',             '可借阅', '2024-01-03', '2024-01-15', DATE_SUB(NOW(), INTERVAL 100 DAY), DATE_SUB(NOW(), INTERVAL 100 DAY), 0),
('MR2024012', '李娜',     'P0002', '内科', '2型糖尿病',               '已借出', '2024-01-08', '2024-01-22', DATE_SUB(NOW(), INTERVAL 95 DAY),  DATE_SUB(NOW(), INTERVAL 90 DAY), 0),
('MR2024013', '王强',     'P0003', '内科', '慢性胃炎',               '可借阅', '2024-02-01', '2024-02-10', DATE_SUB(NOW(), INTERVAL 85 DAY),  DATE_SUB(NOW(), INTERVAL 85 DAY), 0),
('MR2024014', '刘洋',     'P0004', '内科', '急性支气管炎',           '已归档', '2023-06-15', '2023-06-25', DATE_SUB(NOW(), INTERVAL 80 DAY),  DATE_SUB(NOW(), INTERVAL 75 DAY), 0),
('MR2024015', '陈静',     'P0005', '内科', '缺铁性贫血',             '可借阅', '2024-02-15', '2024-02-28', DATE_SUB(NOW(), INTERVAL 70 DAY),  DATE_SUB(NOW(), INTERVAL 70 DAY), 0),
('MR2024016', '杨光',     'P0006', '内科', '甲状腺功能亢进',         '已借出', '2024-03-01', '2024-03-18', DATE_SUB(NOW(), INTERVAL 65 DAY),  DATE_SUB(NOW(), INTERVAL 60 DAY), 0),
('MR2024017', '赵敏',     'P0007', '内科', '急性胃肠炎',             '可借阅', '2024-03-10', '2024-03-17', DATE_SUB(NOW(), INTERVAL 55 DAY),  DATE_SUB(NOW(), INTERVAL 55 DAY), 0),
('MR2024018', '周杰',     'P0008', '内科', '冠心病不稳定型心绞痛',   '可借阅', '2024-03-15', '2024-03-30', DATE_SUB(NOW(), INTERVAL 50 DAY),  DATE_SUB(NOW(), INTERVAL 50 DAY), 0),

-- ===== 外科 (8条) =====
('MR2024019', '吴昊',     'P0009', '外科', '急性阑尾炎',             '已归档', '2023-08-10', '2023-08-18', DATE_SUB(NOW(), INTERVAL 95 DAY),  DATE_SUB(NOW(), INTERVAL 85 DAY), 0),
('MR2024020', '孙鹏',     'P0010', '外科', '胆囊结石伴胆囊炎',       '可借阅', '2024-01-20', '2024-02-05', DATE_SUB(NOW(), INTERVAL 90 DAY),  DATE_SUB(NOW(), INTERVAL 90 DAY), 0),
('MR2024021', '黄丽',     'P0011', '外科', '右侧腹股沟疝',           '已借出', '2024-02-10', '2024-02-18', DATE_SUB(NOW(), INTERVAL 75 DAY),  DATE_SUB(NOW(), INTERVAL 70 DAY), 0),
('MR2024022', '马超',     'P0012', '外科', '甲状腺结节切除术',       '可借阅', '2024-02-20', '2024-03-05', DATE_SUB(NOW(), INTERVAL 65 DAY),  DATE_SUB(NOW(), INTERVAL 65 DAY), 0),
('MR2024023', '朱峰',     'P0013', '外科', '下肢静脉曲张',           '可借阅', '2024-03-05', '2024-03-15', DATE_SUB(NOW(), INTERVAL 55 DAY),  DATE_SUB(NOW(), INTERVAL 55 DAY), 0),
('MR2024024', '胡涛',     'P0014', '外科', '胃穿孔修补术后',         '已归档', '2023-11-01', '2023-11-20', DATE_SUB(NOW(), INTERVAL 50 DAY),  DATE_SUB(NOW(), INTERVAL 40 DAY), 0),
('MR2024025', '林海',     'P0015', '外科', '急性胰腺炎',             '可借阅', '2024-03-20', '2024-04-05', DATE_SUB(NOW(), INTERVAL 40 DAY),  DATE_SUB(NOW(), INTERVAL 40 DAY), 0),
('MR2024026', '何平',     'P0016', '外科', '胆总管结石',             '已借出', '2024-04-01', '2024-04-15', DATE_SUB(NOW(), INTERVAL 30 DAY),  DATE_SUB(NOW(), INTERVAL 25 DAY), 0),

-- ===== 妇产科 (7条) =====
('MR2024027', '郑爽',     'P0017', '妇产科', '产前检查',             '可借阅', '2024-02-01', '2024-02-05', DATE_SUB(NOW(), INTERVAL 90 DAY),  DATE_SUB(NOW(), INTERVAL 90 DAY), 0),
('MR2024028', '谢芳',     'P0018', '妇产科', '剖宫产术后',           '已归档', '2023-07-20', '2023-07-28', DATE_SUB(NOW(), INTERVAL 100 DAY), DATE_SUB(NOW(), INTERVAL 92 DAY), 0),
('MR2024029', '冯燕',     'P0019', '妇产科', '子宫肌瘤',             '已借出', '2024-01-15', '2024-01-28', DATE_SUB(NOW(), INTERVAL 80 DAY),  DATE_SUB(NOW(), INTERVAL 75 DAY), 0),
('MR2024030', '陈琳',     'P0020', '妇产科', '卵巢囊肿',             '可借阅', '2024-02-15', '2024-02-25', DATE_SUB(NOW(), INTERVAL 70 DAY),  DATE_SUB(NOW(), INTERVAL 70 DAY), 0),
('MR2024031', '韩雪',     'P0021', '妇产科', '产后复查',             '可借阅', '2024-03-10', '2024-03-12', DATE_SUB(NOW(), INTERVAL 50 DAY),  DATE_SUB(NOW(), INTERVAL 50 DAY), 0),
('MR2024032', '杨柳',     'P0022', '妇产科', '宫颈炎',               '可借阅', '2024-03-25', '2024-04-03', DATE_SUB(NOW(), INTERVAL 35 DAY),  DATE_SUB(NOW(), INTERVAL 35 DAY), 0),
('MR2024033', '方萍',     'P0023', '妇产科', '异位妊娠',             '已借出', '2024-04-05', '2024-04-18', DATE_SUB(NOW(), INTERVAL 22 DAY),  DATE_SUB(NOW(), INTERVAL 18 DAY), 0),

-- ===== 儿科 (7条) =====
('MR2024034', '雷明',     'P0024', '儿科', '小儿支气管肺炎',         '可借阅', '2024-01-10', '2024-01-22', DATE_SUB(NOW(), INTERVAL 95 DAY),  DATE_SUB(NOW(), INTERVAL 95 DAY), 0),
('MR2024035', '贺童',     'P0025', '儿科', '小儿腹泻病',             '已借出', '2024-02-05', '2024-02-12', DATE_SUB(NOW(), INTERVAL 75 DAY),  DATE_SUB(NOW(), INTERVAL 68 DAY), 0),
('MR2024036', '罗宇',     'P0026', '儿科', '手足口病',               '可借阅', '2024-02-20', '2024-03-01', DATE_SUB(NOW(), INTERVAL 65 DAY),  DATE_SUB(NOW(), INTERVAL 65 DAY), 0),
('MR2024037', '倪花',     'P0027', '儿科', '过敏性紫癜',             '已归档', '2023-10-01', '2023-10-20', DATE_SUB(NOW(), INTERVAL 60 DAY),  DATE_SUB(NOW(), INTERVAL 50 DAY), 0),
('MR2024038', '汤朔',     'P0028', '儿科', '新生儿黄疸',             '可借阅', '2024-03-15', '2024-03-25', DATE_SUB(NOW(), INTERVAL 45 DAY),  DATE_SUB(NOW(), INTERVAL 45 DAY), 0),
('MR2024039', '滕飞',     'P0029', '儿科', '急性上呼吸道感染',       '可借阅', '2024-04-01', '2024-04-08', DATE_SUB(NOW(), INTERVAL 20 DAY),  DATE_SUB(NOW(), INTERVAL 20 DAY), 0),
('MR2024040', '殷悦',     'P0030', '儿科', '婴幼儿哮喘',             '已借出', '2024-04-10', '2024-04-20', DATE_SUB(NOW(), INTERVAL 15 DAY),  DATE_SUB(NOW(), INTERVAL 10 DAY), 0),

-- ===== 骨科 (7条) =====
('MR2024041', '罗刚',     'P0031', '骨科', '右胫腓骨骨折',           '可借阅', '2024-01-05', '2024-01-25', DATE_SUB(NOW(), INTERVAL 100 DAY), DATE_SUB(NOW(), INTERVAL 100 DAY), 0),
('MR2024042', '毕磊',     'P0032', '骨科', '腰椎间盘突出症',         '已借出', '2024-02-01', '2024-02-18', DATE_SUB(NOW(), INTERVAL 80 DAY),  DATE_SUB(NOW(), INTERVAL 72 DAY), 0),
('MR2024043', '郝洁',     'P0033', '骨科', '颈椎病',                 '可借阅', '2024-02-15', '2024-02-28', DATE_SUB(NOW(), INTERVAL 68 DAY),  DATE_SUB(NOW(), INTERVAL 68 DAY), 0),
('MR2024044', '邬强',     'P0034', '骨科', '左膝半月板损伤',         '已归档', '2023-09-10', '2023-09-25', DATE_SUB(NOW(), INTERVAL 60 DAY),  DATE_SUB(NOW(), INTERVAL 52 DAY), 0),
('MR2024045', '安华',     'P0035', '骨科', '骨质疏松伴压缩性骨折',   '可借阅', '2024-03-10', '2024-04-01', DATE_SUB(NOW(), INTERVAL 45 DAY),  DATE_SUB(NOW(), INTERVAL 45 DAY), 0),
('MR2024046', '常温',     'P0036', '骨科', '肩袖损伤',               '已借出', '2024-03-25', '2024-04-10', DATE_SUB(NOW(), INTERVAL 30 DAY),  DATE_SUB(NOW(), INTERVAL 22 DAY), 0),
('MR2024047', '傅雷',     'P0037', '骨科', '股骨头坏死',             '可借阅', '2024-04-15', '2024-05-01', DATE_SUB(NOW(), INTERVAL 10 DAY),  DATE_SUB(NOW(), INTERVAL 10 DAY), 0),

-- ===== 神经内科 (5条) =====
('MR2024048', '沈斌',     'P0038', '神经内科', '脑梗塞急性期',       '已借出', '2024-01-12', '2024-01-30', DATE_SUB(NOW(), INTERVAL 90 DAY),  DATE_SUB(NOW(), INTERVAL 82 DAY), 0),
('MR2024049', '曾明',     'P0039', '神经内科', '偏头痛',             '可借阅', '2024-02-10', '2024-02-18', DATE_SUB(NOW(), INTERVAL 72 DAY),  DATE_SUB(NOW(), INTERVAL 72 DAY), 0),
('MR2024050', '邱红',     'P0040', '神经内科', '癫痫大发作',         '已归档', '2023-12-01', '2023-12-15', DATE_SUB(NOW(), INTERVAL 65 DAY),  DATE_SUB(NOW(), INTERVAL 55 DAY), 0),
('MR2024051', '秦刚',     'P0041', '神经内科', '帕金森病',           '可借阅', '2024-03-05', '2024-03-22', DATE_SUB(NOW(), INTERVAL 50 DAY),  DATE_SUB(NOW(), INTERVAL 50 DAY), 0),
('MR2024052', '江涛',     'P0042', '神经内科', '面神经麻痹',         '可借阅', '2024-04-02', '2024-04-15', DATE_SUB(NOW(), INTERVAL 25 DAY),  DATE_SUB(NOW(), INTERVAL 25 DAY), 0),

-- ===== 心血管内科 (5条) =====
('MR2024053', '史琳',     'P0043', '心血管内科', '冠心病支架术后',   '已借出', '2024-01-18', '2024-02-05', DATE_SUB(NOW(), INTERVAL 85 DAY),  DATE_SUB(NOW(), INTERVAL 78 DAY), 0),
('MR2024054', '顾宇',     'P0044', '心血管内科', '慢性心力衰竭',     '已归档', '2023-08-20', '2023-09-10', DATE_SUB(NOW(), INTERVAL 80 DAY),  DATE_SUB(NOW(), INTERVAL 70 DAY), 0),
('MR2024055', '侯伟',     'P0045', '心血管内科', '室性心律失常',     '可借阅', '2024-02-20', '2024-03-08', DATE_SUB(NOW(), INTERVAL 60 DAY),  DATE_SUB(NOW(), INTERVAL 60 DAY), 0),
('MR2024056', '邵阳',     'P0046', '心血管内科', '急性心肌梗死',     '可借阅', '2024-03-18', '2024-04-05', DATE_SUB(NOW(), INTERVAL 42 DAY),  DATE_SUB(NOW(), INTERVAL 42 DAY), 0),
('MR2024057', '孟超',     'P0047', '心血管内科', '高血压性心脏病',   '已借出', '2024-04-08', '2024-04-22', DATE_SUB(NOW(), INTERVAL 18 DAY),  DATE_SUB(NOW(), INTERVAL 12 DAY), 0),

-- ===== 消化内科 (5条) =====
('MR2024058', '龙飞',     'P0048', '消化内科', '胃溃疡伴出血',       '可借阅', '2024-01-22', '2024-02-08', DATE_SUB(NOW(), INTERVAL 88 DAY),  DATE_SUB(NOW(), INTERVAL 88 DAY), 0),
('MR2024059', '万芳',     'P0049', '消化内科', '肝硬化失代偿期',     '已归档', '2023-11-15', '2023-12-05', DATE_SUB(NOW(), INTERVAL 75 DAY),  DATE_SUB(NOW(), INTERVAL 65 DAY), 0),
('MR2024060', '段刚',     'P0050', '消化内科', '溃疡性结肠炎',       '可借阅', '2024-02-25', '2024-03-15', DATE_SUB(NOW(), INTERVAL 55 DAY),  DATE_SUB(NOW(), INTERVAL 55 DAY), 0),
('MR2024061', '雷蕾',     'P0051', '消化内科', '慢性乙型肝炎',       '已借出', '2024-03-20', '2024-04-05', DATE_SUB(NOW(), INTERVAL 40 DAY),  DATE_SUB(NOW(), INTERVAL 33 DAY), 0),
('MR2024062', '钱程',     'P0052', '消化内科', '急性胰腺炎',         '可借阅', '2024-04-12', '2024-04-26', DATE_SUB(NOW(), INTERVAL 12 DAY),  DATE_SUB(NOW(), INTERVAL 12 DAY), 0),

-- ===== 呼吸内科 (5条) =====
('MR2024063', '汤杰',     'P0053', '呼吸内科', '社区获得性肺炎',     '可借阅', '2024-01-08', '2024-01-20', DATE_SUB(NOW(), INTERVAL 95 DAY),  DATE_SUB(NOW(), INTERVAL 95 DAY), 0),
('MR2024064', '莫寒',     'P0054', '呼吸内科', '支气管哮喘急性发作', '已归档', '2023-09-05', '2023-09-18', DATE_SUB(NOW(), INTERVAL 82 DAY),  DATE_SUB(NOW(), INTERVAL 72 DAY), 0),
('MR2024065', '黎辉',     'P0055', '呼吸内科', '慢性阻塞性肺疾病',   '已借出', '2024-02-10', '2024-02-28', DATE_SUB(NOW(), INTERVAL 68 DAY),  DATE_SUB(NOW(), INTERVAL 60 DAY), 0),
('MR2024066', '池宁',     'P0056', '呼吸内科', '肺结节',             '可借阅', '2024-03-15', '2024-03-25', DATE_SUB(NOW(), INTERVAL 45 DAY),  DATE_SUB(NOW(), INTERVAL 45 DAY), 0),
('MR2024067', '乔磊',     'P0057', '呼吸内科', '结核性胸膜炎',       '可借阅', '2024-04-10', '2024-04-30', DATE_SUB(NOW(), INTERVAL 15 DAY),  DATE_SUB(NOW(), INTERVAL 15 DAY), 0),

-- ===== 泌尿外科 (5条) =====
('MR2024068', '白洁',     'P0058', '泌尿外科', '左肾结石',           '可借阅', '2024-01-15', '2024-01-28', DATE_SUB(NOW(), INTERVAL 92 DAY),  DATE_SUB(NOW(), INTERVAL 92 DAY), 0),
('MR2024069', '崔健',     'P0059', '泌尿外科', '前列腺增生',         '已借出', '2024-02-08', '2024-02-22', DATE_SUB(NOW(), INTERVAL 73 DAY),  DATE_SUB(NOW(), INTERVAL 65 DAY), 0),
('MR2024070', '康锐',     'P0060', '泌尿外科', '膀胱肿瘤术后',       '已归档', '2023-10-10', '2023-11-01', DATE_SUB(NOW(), INTERVAL 60 DAY),  DATE_SUB(NOW(), INTERVAL 50 DAY), 0),
('MR2024071', '范勇',     'P0061', '泌尿外科', '输尿管结石',         '可借阅', '2024-03-22', '2024-04-05', DATE_SUB(NOW(), INTERVAL 38 DAY),  DATE_SUB(NOW(), INTERVAL 38 DAY), 0),
('MR2024072', '丁宁',     'P0062', '泌尿外科', '肾囊肿',             '可借阅', '2024-04-18', '2024-04-28', DATE_SUB(NOW(), INTERVAL 8 DAY),   DATE_SUB(NOW(), INTERVAL 8 DAY), 0),

-- ===== 眼科 (5条) =====
('MR2024073', '甘霖',     'P0063', '眼科', '老年性白内障',           '已归档', '2023-07-05', '2023-07-12', DATE_SUB(NOW(), INTERVAL 100 DAY), DATE_SUB(NOW(), INTERVAL 88 DAY), 0),
('MR2024074', '宗文',     'P0064', '眼科', '急性闭角型青光眼',       '可借阅', '2024-01-25', '2024-02-05', DATE_SUB(NOW(), INTERVAL 83 DAY),  DATE_SUB(NOW(), INTERVAL 83 DAY), 0),
('MR2024075', '武华',     'P0065', '眼科', '糖尿病视网膜病变',       '已借出', '2024-02-18', '2024-03-05', DATE_SUB(NOW(), INTERVAL 65 DAY),  DATE_SUB(NOW(), INTERVAL 57 DAY), 0),
('MR2024076', '邹俊',     'P0066', '眼科', '角膜溃疡',               '可借阅', '2024-03-28', '2024-04-10', DATE_SUB(NOW(), INTERVAL 30 DAY),  DATE_SUB(NOW(), INTERVAL 30 DAY), 0),
('MR2024077', '石磊',     'P0067', '眼科', '视网膜脱离',             '已借出', '2024-04-20', '2024-05-02', DATE_SUB(NOW(), INTERVAL 5 DAY),   DATE_SUB(NOW(), INTERVAL 3 DAY), 0),

-- ===== 耳鼻喉科 (4条) =====
('MR2024078', '熊彪',     'P0068', '耳鼻喉科', '慢性鼻窦炎',         '可借阅', '2024-01-28', '2024-02-08', DATE_SUB(NOW(), INTERVAL 82 DAY),  DATE_SUB(NOW(), INTERVAL 82 DAY), 0),
('MR2024079', '阎丽',     'P0069', '耳鼻喉科', '分泌性中耳炎',       '已归档', '2023-08-15', '2023-08-25', DATE_SUB(NOW(), INTERVAL 78 DAY),  DATE_SUB(NOW(), INTERVAL 68 DAY), 0),
('MR2024080', '薛凯',     'P0070', '耳鼻喉科', '声带息肉',           '可借阅', '2024-03-01', '2024-03-10', DATE_SUB(NOW(), INTERVAL 52 DAY),  DATE_SUB(NOW(), INTERVAL 52 DAY), 0),
('MR2024081', '谭琳',     'P0071', '耳鼻喉科', '扁桃体周围脓肿',     '已借出', '2024-04-05', '2024-04-15', DATE_SUB(NOW(), INTERVAL 20 DAY),  DATE_SUB(NOW(), INTERVAL 14 DAY), 0),

-- ===== 皮肤科 (4条) =====
('MR2024082', '姜辉',     'P0072', '皮肤科', '带状疱疹',             '已借出', '2024-02-01', '2024-02-12', DATE_SUB(NOW(), INTERVAL 75 DAY),  DATE_SUB(NOW(), INTERVAL 66 DAY), 0),
('MR2024083', '于婷',     'P0073', '皮肤科', '慢性荨麻疹',           '可借阅', '2024-02-20', '2024-03-05', DATE_SUB(NOW(), INTERVAL 62 DAY),  DATE_SUB(NOW(), INTERVAL 62 DAY), 0),
('MR2024084', '田迪',     'P0074', '皮肤科', '寻常型银屑病',         '已归档', '2023-12-10', '2023-12-30', DATE_SUB(NOW(), INTERVAL 58 DAY),  DATE_SUB(NOW(), INTERVAL 46 DAY), 0),
('MR2024085', '邓超',     'P0075', '皮肤科', '湿疹',                 '可借阅', '2024-04-12', '2024-04-22', DATE_SUB(NOW(), INTERVAL 13 DAY),  DATE_SUB(NOW(), INTERVAL 13 DAY), 0),

-- ===== 感染科 (4条) =====
('MR2024086', '韦宁',     'P0076', '感染科', '继发性肺结核',         '已归档', '2023-06-01', '2023-06-30', DATE_SUB(NOW(), INTERVAL 110 DAY), DATE_SUB(NOW(), INTERVAL 80 DAY), 0),
('MR2024087', '苗青',     'P0077', '感染科', '急性细菌性痢疾',       '可借阅', '2024-01-18', '2024-01-28', DATE_SUB(NOW(), INTERVAL 88 DAY),  DATE_SUB(NOW(), INTERVAL 88 DAY), 0),
('MR2024088', '花蕾',     'P0078', '感染科', '流行性感冒重症',       '可借阅', '2024-03-01', '2024-03-12', DATE_SUB(NOW(), INTERVAL 50 DAY),  DATE_SUB(NOW(), INTERVAL 50 DAY), 0),
('MR2024089', '葛洪',     'P0079', '感染科', '慢性丙型病毒性肝炎',   '已借出', '2024-04-02', '2024-04-22', DATE_SUB(NOW(), INTERVAL 22 DAY),  DATE_SUB(NOW(), INTERVAL 16 DAY), 0),

-- ===== 肿瘤科 (4条) =====
('MR2024090', '潘杰',     'P0080', '肿瘤科', '右肺腺癌术后化疗',     '已借出', '2024-01-10', '2024-01-30', DATE_SUB(NOW(), INTERVAL 90 DAY),  DATE_SUB(NOW(), INTERVAL 82 DAY), 0),
('MR2024091', '柳春',     'P0081', '肿瘤科', '胃癌根治术后',         '已归档', '2023-10-20', '2023-11-25', DATE_SUB(NOW(), INTERVAL 72 DAY),  DATE_SUB(NOW(), INTERVAL 60 DAY), 0),
('MR2024092', '鲍峰',     'P0082', '肿瘤科', '乳腺癌术后放疗',       '可借阅', '2024-03-08', '2024-04-05', DATE_SUB(NOW(), INTERVAL 45 DAY),  DATE_SUB(NOW(), INTERVAL 45 DAY), 0),
('MR2024093', '费翔',     'P0083', '肿瘤科', '结肠癌辅助化疗',       '可借阅', '2024-04-15', '2024-05-05', DATE_SUB(NOW(), INTERVAL 10 DAY),  DATE_SUB(NOW(), INTERVAL 10 DAY), 0),

-- ===== 康复科 (3条) =====
('MR2024094', '廉杰',     'P0084', '康复科', '脑卒中后遗症康复',     '可借阅', '2024-02-01', '2024-03-01', DATE_SUB(NOW(), INTERVAL 78 DAY),  DATE_SUB(NOW(), INTERVAL 78 DAY), 0),
('MR2024095', '岑明',     'P0085', '康复科', '脊髓损伤康复训练',     '已借出', '2024-03-01', '2024-04-01', DATE_SUB(NOW(), INTERVAL 48 DAY),  DATE_SUB(NOW(), INTERVAL 40 DAY), 0),
('MR2024096', '薛平',     'P0086', '康复科', '膝关节置换术后康复',   '可借阅', '2024-04-01', '2024-04-20', DATE_SUB(NOW(), INTERVAL 17 DAY),  DATE_SUB(NOW(), INTERVAL 17 DAY), 0),

-- ===== 中医科 (3条) =====
('MR2024097', '申华',     'P0087', '中医科', '慢性腰腿痛',           '可借阅', '2024-01-05', '2024-01-20', DATE_SUB(NOW(), INTERVAL 96 DAY),  DATE_SUB(NOW(), INTERVAL 96 DAY), 0),
('MR2024098', '桂芬',     'P0088', '中医科', '顽固性失眠',           '已借出', '2024-02-15', '2024-03-05', DATE_SUB(NOW(), INTERVAL 60 DAY),  DATE_SUB(NOW(), INTERVAL 52 DAY), 0),
('MR2024099', '巩健',     'P0089', '中医科', '脾胃虚弱',             '可借阅', '2024-04-08', '2024-04-22', DATE_SUB(NOW(), INTERVAL 15 DAY),  DATE_SUB(NOW(), INTERVAL 15 DAY), 0),

-- ===== 内分泌科 (3条) =====
('MR2024100', '耿华',     'P0090', '内分泌科', '2型糖尿病伴并发症',  '已借出', '2024-01-20', '2024-02-10', DATE_SUB(NOW(), INTERVAL 85 DAY),  DATE_SUB(NOW(), INTERVAL 76 DAY), 0),
('MR2024101', '尚明',     'P0091', '内分泌科', '甲状腺功能减退症',   '可借阅', '2024-03-05', '2024-03-20', DATE_SUB(NOW(), INTERVAL 48 DAY),  DATE_SUB(NOW(), INTERVAL 48 DAY), 0),
('MR2024102', '丛兰',     'P0092', '内分泌科', '高脂血症',           '已归档', '2023-11-20', '2023-12-05', DATE_SUB(NOW(), INTERVAL 42 DAY),  DATE_SUB(NOW(), INTERVAL 35 DAY), 0),

-- ===== 肾内科 (3条) =====
('MR2024103', '井源',     'P0093', '肾内科', '慢性肾小球肾炎',       '可借阅', '2024-02-10', '2024-03-01', DATE_SUB(NOW(), INTERVAL 68 DAY),  DATE_SUB(NOW(), INTERVAL 68 DAY), 0),
('MR2024104', '竺平',     'P0094', '肾内科', '肾病综合征',           '已借出', '2024-03-15', '2024-04-10', DATE_SUB(NOW(), INTERVAL 38 DAY),  DATE_SUB(NOW(), INTERVAL 30 DAY), 0),
('MR2024105', '权明',     'P0095', '肾内科', '急性肾损伤',           '可借阅', '2024-04-20', '2024-05-01', DATE_SUB(NOW(), INTERVAL 6 DAY),   DATE_SUB(NOW(), INTERVAL 6 DAY), 0),

-- ===== 口腔科 (3条) =====
('MR2024106', '蔚峰',     'P0096', '口腔科', '慢性牙周炎',           '可借阅', '2024-01-30', '2024-02-08', DATE_SUB(NOW(), INTERVAL 80 DAY),  DATE_SUB(NOW(), INTERVAL 80 DAY), 0),
('MR2024107', '查隆',     'P0097', '口腔科', '阻生智齿拔除术',       '已归档', '2023-12-05', '2023-12-12', DATE_SUB(NOW(), INTERVAL 55 DAY),  DATE_SUB(NOW(), INTERVAL 42 DAY), 0),
('MR2024108', '甯静',     'P0098', '口腔科', '口腔黏膜白斑',         '可借阅', '2024-04-05', '2024-04-15', DATE_SUB(NOW(), INTERVAL 18 DAY),  DATE_SUB(NOW(), INTERVAL 18 DAY), 0),

-- ===== 急诊科 (1条) =====
('MR2024109', '蒲敏',     'P0099', '急诊科', '急性一氧化碳中毒',     '可借阅', '2024-04-01', '2024-04-10', DATE_SUB(NOW(), INTERVAL 22 DAY),  DATE_SUB(NOW(), INTERVAL 22 DAY), 0),

-- ===== 风湿免疫科 (1条) =====
('MR2024110', '全杰',     'P0100', '风湿免疫科', '类风湿性关节炎',   '已借出', '2024-03-01', '2024-03-25', DATE_SUB(NOW(), INTERVAL 42 DAY),  DATE_SUB(NOW(), INTERVAL 35 DAY), 0);

-- 统计各类状态数量
SELECT '======= 病案数据插入完成 =======' AS message;
SELECT status AS '状态', COUNT(*) AS '数量' FROM MedicalRecords WHERE recordNumber BETWEEN 'MR2024011' AND 'MR2024110' GROUP BY status ORDER BY status;
SELECT department AS '科室', COUNT(*) AS '数量' FROM MedicalRecords WHERE recordNumber BETWEEN 'MR2024011' AND 'MR2024110' GROUP BY department ORDER BY COUNT(*) DESC;
SELECT COUNT(*) AS '总计' FROM MedicalRecords WHERE recordNumber BETWEEN 'MR2024011' AND 'MR2024110';
