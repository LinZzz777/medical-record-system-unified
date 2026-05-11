-- 添加测试用户账户
-- 执行日期: 2026-05-04
-- 说明: 此脚本用于向现有数据库添加科室审批员、病案室审批员和普通用户账户

USE MedicalRecordDB;

-- 插入科室审批员账户（如果不存在）
INSERT INTO Users (username, password, name, role, department, phone, email, status)
SELECT * FROM (
    SELECT 'dept_internal' as username, 'dept123' as password, '王主任' as name, 'dept_approver' as role, '内科' as department, '13900139001' as phone, 'wang_internal@hospital.com' as email, 1 as status
    UNION ALL SELECT 'dept_surgery', 'dept123', '刘主任', 'dept_approver', '外科', '13900139002', 'liu_surgery@hospital.com', 1
    UNION ALL SELECT 'dept_pediatrics', 'dept123', '陈主任', 'dept_approver', '儿科', '13900139003', 'chen_pediatrics@hospital.com', 1
    UNION ALL SELECT 'dept_obstetrics', 'dept123', '杨主任', 'dept_approver', '妇产科', '13900139004', 'yang_obstetrics@hospital.com', 1
    UNION ALL SELECT 'dept_ophthalmology', 'dept123', '赵主任', 'dept_approver', '眼科', '13900139005', 'zhao_ophthalmology@hospital.com', 1
    UNION ALL SELECT 'dept_ent', 'dept123', '孙主任', 'dept_approver', '耳鼻喉科', '13900139006', 'sun_ent@hospital.com', 1
    UNION ALL SELECT 'dept_stomatology', 'dept123', '周主任', 'dept_approver', '口腔科', '13900139007', 'zhou_stomatology@hospital.com', 1
    UNION ALL SELECT 'dept_dermatology', 'dept123', '吴主任', 'dept_approver', '皮肤科', '13900139008', 'wu_dermatology@hospital.com', 1
    UNION ALL SELECT 'dept_orthopedics', 'dept123', '郑主任', 'dept_approver', '骨科', '13900139009', 'zheng_orthopedics@hospital.com', 1
    UNION ALL SELECT 'dept_neurology', 'dept123', '冯主任', 'dept_approver', '神经科', '13900139010', 'feng_neurology@hospital.com', 1
) AS tmp
WHERE NOT EXISTS (
    SELECT 1 FROM Users WHERE username = tmp.username
);

-- 插入病案室审批员账户（如果不存在）
INSERT INTO Users (username, password, name, role, department, phone, email, status)
SELECT * FROM (
    SELECT 'archive_approver1' as username, 'archive123' as password, '马管理员' as name, 'archive_approver' as role, '病案室' as department, '13900139011' as phone, 'ma_archive@hospital.com' as email, 1 as status
    UNION ALL SELECT 'archive_approver2', 'archive123', '朱管理员', 'archive_approver', '病案室', '13900139012', 'zhu_archive@hospital.com', 1
) AS tmp
WHERE NOT EXISTS (
    SELECT 1 FROM Users WHERE username = tmp.username
);

-- 插入普通用户账户（如果不存在）
INSERT INTO Users (username, password, name, role, department, phone, email, status)
SELECT * FROM (
    SELECT 'user003' as username, 'password123' as password, '黄医生' as name, 'user' as role, '外科' as department, '13600136000' as phone, 'huang@hospital.com' as email, 1 as status
    UNION ALL SELECT 'user004', 'password123', '林医生', 'user', '妇产科', '13500135000', 'lin@hospital.com', 1
    UNION ALL SELECT 'user005', 'password123', '何医生', 'user', '眼科', '13400134000', 'he@hospital.com', 1
    UNION ALL SELECT 'user006', 'password123', '高医生', 'user', '耳鼻喉科', '13300133000', 'gao@hospital.com', 1
    UNION ALL SELECT 'user007', 'password123', '罗医生', 'user', '口腔科', '13200132000', 'luo@hospital.com', 1
    UNION ALL SELECT 'user008', 'password123', '梁医生', 'user', '皮肤科', '13100131000', 'liang@hospital.com', 1
    UNION ALL SELECT 'user009', 'password123', '宋医生', 'user', '骨科', '13000130000', 'song@hospital.com', 1
    UNION ALL SELECT 'user010', 'password123', '唐医生', 'user', '神经科', '12900129000', 'tang@hospital.com', 1
) AS tmp
WHERE NOT EXISTS (
    SELECT 1 FROM Users WHERE username = tmp.username
);

COMMIT;
