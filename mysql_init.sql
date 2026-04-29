-- 病案借阅管理系统 - MySQL数据库初始化脚本
-- 创建日期: 2026-03-26
-- 适用版本: MySQL 8.0+

-- 创建数据库
CREATE DATABASE IF NOT EXISTS MedicalRecordDB DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE MedicalRecordDB;

-- 创建用户表
CREATE TABLE IF NOT EXISTS Users (
    id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '用户ID',
    employeeNumber VARCHAR(50) COMMENT '工号',
    username VARCHAR(50) NOT NULL UNIQUE COMMENT '用户名',
    password VARCHAR(100) NOT NULL COMMENT '密码',
    name VARCHAR(50) NOT NULL COMMENT '姓名',
    role VARCHAR(20) NOT NULL COMMENT '角色(admin/user)',
    department VARCHAR(50) COMMENT '部门',
    phone VARCHAR(20) COMMENT '电话',
    email VARCHAR(100) COMMENT '邮箱',
    address VARCHAR(200) COMMENT '地址',
    position VARCHAR(50) COMMENT '职位',
    status INT DEFAULT 1 COMMENT '状态(1:启用, 0:禁用)',
    createdAt DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    deleted INT DEFAULT 0 COMMENT '逻辑删除(1:已删除, 0:未删除)'
) COMMENT '用户表';

-- 创建病案表
CREATE TABLE IF NOT EXISTS MedicalRecords (
    id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '病案ID',
    recordNumber VARCHAR(50) NOT NULL UNIQUE COMMENT '病案号',
    patientName VARCHAR(50) NOT NULL COMMENT '患者姓名',
    patientId VARCHAR(50) NOT NULL COMMENT '患者ID',
    department VARCHAR(50) COMMENT '科室',
    diagnosis VARCHAR(200) COMMENT '诊断',
    status VARCHAR(20) NOT NULL COMMENT '状态(可借阅/已借出/已归档)',
    admissionDate VARCHAR(20) COMMENT '入院日期',
    dischargeDate VARCHAR(20) COMMENT '出院日期',
    createdAt DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updatedTime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    deleted INT DEFAULT 0 COMMENT '逻辑删除(1:已删除, 0:未删除)'
) COMMENT '病案表';

-- 创建借阅申请表
CREATE TABLE IF NOT EXISTS BorrowApplications (
    id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '申请ID',
    recordIds VARCHAR(500) NOT NULL COMMENT '病案ID列表，逗号分隔',
    reason VARCHAR(500) NOT NULL COMMENT '借阅原因',
    borrowType VARCHAR(20) NOT NULL COMMENT '借阅类型(院内借阅/院外借阅)',
    expectedReturnDate VARCHAR(20) NOT NULL COMMENT '预计归还日期',
    status VARCHAR(20) NOT NULL COMMENT '状态(pending/approved/rejected/picked/completed/cancelled)',
    submitTime DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '提交时间',
    userId BIGINT NOT NULL COMMENT '用户ID',
    userName VARCHAR(50) NOT NULL COMMENT '用户姓名',
    approver VARCHAR(50) COMMENT '审批人',
    approveTime DATETIME COMMENT '审批时间',
    rejectionReason VARCHAR(500) COMMENT '驳回原因',
    returnTime DATETIME COMMENT '归还时间',
    createdTime DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updatedTime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    deleted INT DEFAULT 0 COMMENT '逻辑删除(1:已删除, 0:未删除)',
    FOREIGN KEY (userId) REFERENCES Users(id) ON DELETE CASCADE
) COMMENT '借阅申请表';

-- 创建审计日志表
CREATE TABLE IF NOT EXISTS AuditLogs (
    id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '日志ID',
    userId BIGINT COMMENT '用户ID',
    userName VARCHAR(50) COMMENT '用户名',
    operation VARCHAR(100) NOT NULL COMMENT '操作类型',
    description VARCHAR(500) COMMENT '操作描述',
    ipAddress VARCHAR(50) COMMENT 'IP地址',
    userAgent VARCHAR(200) COMMENT '用户代理',
    createdAt DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '操作时间',
    deleted INT DEFAULT 0 COMMENT '逻辑删除(1:已删除, 0:未删除)',
    FOREIGN KEY (userId) REFERENCES Users(id) ON DELETE SET NULL
) COMMENT '审计日志表';

-- 创建菜单表
CREATE TABLE IF NOT EXISTS Menus (
    id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '菜单ID',
    name VARCHAR(50) NOT NULL COMMENT '菜单名称',
    path VARCHAR(100) COMMENT '路由路径',
    icon VARCHAR(50) COMMENT '图标',
    parentId BIGINT DEFAULT 0 COMMENT '父菜单ID',
    sortOrder INT DEFAULT 0 COMMENT '排序',
    permission VARCHAR(100) COMMENT '权限标识',
    status INT DEFAULT 1 COMMENT '状态(1:启用, 0:禁用)',
    deleted INT DEFAULT 0 COMMENT '逻辑删除(1:已删除, 0:未删除)'
) COMMENT '菜单表';

-- 创建角色表
CREATE TABLE IF NOT EXISTS Roles (
    id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '角色ID',
    name VARCHAR(50) NOT NULL UNIQUE COMMENT '角色名称',
    description VARCHAR(200) COMMENT '角色描述',
    status INT DEFAULT 1 COMMENT '状态(1:启用, 0:禁用)',
    deleted INT DEFAULT 0 COMMENT '逻辑删除(1:已删除, 0:未删除)'
) COMMENT '角色表';

-- 创建权限表
CREATE TABLE IF NOT EXISTS Permissions (
    id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '权限ID',
    name VARCHAR(50) NOT NULL COMMENT '权限名称',
    code VARCHAR(100) NOT NULL UNIQUE COMMENT '权限编码',
    description VARCHAR(200) COMMENT '权限描述',
    deleted INT DEFAULT 0 COMMENT '逻辑删除(1:已删除, 0:未删除)'
) COMMENT '权限表';

-- 插入初始数据

-- 插入管理员用户
INSERT INTO Users (username, password, name, role, department, phone, email, status)
VALUES 
('admin', 'admin123', '系统管理员', 'admin', '病案科', '13800138000', 'admin@hospital.com', 1),
('user001', 'password123', '张医生', 'user', '内科', '13900139000', 'zhang@hospital.com', 1),
('user002', 'password123', '李护士', 'user', '儿科', '13700137000', 'li@hospital.com', 1);

-- 插入示例病案数据
INSERT INTO MedicalRecords (recordNumber, patientName, patientId, department, diagnosis, status, admissionDate, dischargeDate)
VALUES 
('MR2024001', '张三', 'P0001', '内科', '高血压', '可借阅', '2024-01-01', '2024-01-10'),
('MR2024002', '李四', 'P0002', '外科', '阑尾炎', '可借阅', '2024-01-05', '2024-01-15'),
('MR2024003', '王五', 'P0003', '儿科', '肺炎', '可借阅', '2024-01-10', '2024-01-20'),
('MR2024004', '赵六', 'P0004', '妇产科', '产前检查', '可借阅', '2024-01-15', '2024-01-25'),
('MR2024005', '钱七', 'P0005', '眼科', '结膜炎', '可借阅', '2024-01-20', '2024-01-30'),
('MR2024006', '孙八', 'P0006', '耳鼻喉科', '中耳炎', '可借阅', '2024-01-25', '2024-02-04'),
('MR2024007', '周九', 'P0007', '口腔科', '牙周炎', '可借阅', '2024-02-01', '2024-02-10'),
('MR2024008', '吴十', 'P0008', '皮肤科', '湿疹', '可借阅', '2024-02-05', '2024-02-15'),
('MR2024009', '郑十一', 'P0009', '骨科', '骨折', '可借阅', '2024-02-10', '2024-02-20'),
('MR2024010', '王十二', 'P0010', '神经科', '头痛', '可借阅', '2024-02-15', '2024-02-25');

-- 插入示例借阅申请数据
INSERT INTO BorrowApplications (recordIds, reason, borrowType, expectedReturnDate, status, userId, userName)
VALUES 
('1', '病历复查', '院内借阅', '2024-03-01', 'pending', 2, '张医生'),
('2', '会诊需要', '院内借阅', '2024-03-05', 'approved', 3, '李护士');

-- 插入菜单数据
INSERT INTO Menus (name, path, icon, parentId, sortOrder)
VALUES 
('仪表盘', '/dashboard', 'Dashboard', 0, 1),
('借阅申请', '/borrow', 'DocumentCopy', 0, 2),
('借阅历史', '/borrow-history', 'Time', 0, 3),
('用户管理', '/users', 'User', 0, 4),
('审计日志', '/audit', 'Monitor', 0, 5);

-- 插入角色数据
INSERT INTO Roles (name, description)
VALUES 
('管理员', '系统管理员'),
('普通用户', '普通用户');

-- 插入权限数据
INSERT INTO Permissions (name, code, description)
VALUES 
('查看仪表盘', 'dashboard:view', '查看仪表盘数据'),
('创建借阅申请', 'borrow:create', '创建借阅申请'),
('查看借阅历史', 'borrow:history', '查看借阅历史'),
('审批借阅申请', 'borrow:approve', '审批借阅申请'),
('管理用户', 'user:manage', '管理用户信息'),
('查看审计日志', 'audit:view', '查看审计日志');

-- 创建索引
CREATE INDEX idx_users_username ON Users(username);
CREATE INDEX idx_users_role ON Users(role);
CREATE INDEX idx_medical_records_record_number ON MedicalRecords(recordNumber);
CREATE INDEX idx_medical_records_status ON MedicalRecords(status);
CREATE INDEX idx_borrow_applications_user_id ON BorrowApplications(userId);
CREATE INDEX idx_borrow_applications_status ON BorrowApplications(status);
CREATE INDEX idx_borrow_applications_submit_time ON BorrowApplications(submitTime);

-- 提交事务
COMMIT;

-- 输出成功信息
SELECT '数据库初始化完成' AS message;
