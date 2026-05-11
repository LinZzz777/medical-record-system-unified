/*
 Navicat Premium Dump SQL

 Source Server         : test
 Source Server Type    : MySQL
 Source Server Version : 90700 (9.7.0)
 Source Host           : localhost:3306
 Source Schema         : medicalrecorddb

 Target Server Type    : MySQL
 Target Server Version : 90700 (9.7.0)
 File Encoding         : 65001

 Date: 06/05/2026 14:47:04
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for audit_logs
-- ----------------------------
DROP TABLE IF EXISTS `audit_logs`;
CREATE TABLE `audit_logs`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '日志ID',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '用户名',
  `operation` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '操作类型',
  `module` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '模块名',
  `ip` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'IP地址',
  `user_agent` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '用户代理',
  `details` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '操作详情',
  `status` int NULL DEFAULT 1 COMMENT '状态(1:成功, 0:失败)',
  `created_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `deleted` int NULL DEFAULT 0 COMMENT '逻辑删除(1:已删除, 0:未删除)',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 18 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '审计日志表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of audit_logs
-- ----------------------------
INSERT INTO `audit_logs` VALUES (1, 'admin', 'update', 'User', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', 'username=neikeshenhe', 1, '2026-05-06 11:01:54', 0);
INSERT INTO `audit_logs` VALUES (2, 'admin', 'update', 'User', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', 'username=user001', 1, '2026-05-06 11:02:13', 0);
INSERT INTO `audit_logs` VALUES (3, 'neikeshenhe', 'create', 'Borrow', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', 'user=王主任, records=11', 1, '2026-05-06 11:02:29', 0);
INSERT INTO `audit_logs` VALUES (4, 'neikeshenhe', 'deptApprove', 'Borrow', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', 'id=13, approver=王主任', 1, '2026-05-06 11:02:36', 0);
INSERT INTO `audit_logs` VALUES (5, 'user001', 'create', 'Borrow', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', 'user=张医生, records=11', 1, '2026-05-06 11:03:00', 0);
INSERT INTO `audit_logs` VALUES (6, 'neikeshenhe', 'deptApprove', 'Borrow', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', 'id=14, approver=王主任', 1, '2026-05-06 11:03:13', 0);
INSERT INTO `audit_logs` VALUES (7, 'admin', 'archiveApprove', 'Borrow', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', 'id=14, approver=系统管理员', 1, '2026-05-06 11:03:23', 0);
INSERT INTO `audit_logs` VALUES (8, 'admin', 'update', 'User', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', 'username=binganshenhe1', 1, '2026-05-06 11:03:37', 0);
INSERT INTO `audit_logs` VALUES (9, 'binganshenhe1', 'archiveApprove', 'Borrow', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', 'id=13, approver=马管理员', 1, '2026-05-06 11:03:46', 0);
INSERT INTO `audit_logs` VALUES (10, 'admin', 'login', 'Auth', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', 'username=admin', 1, '2026-05-06 11:30:53', 0);
INSERT INTO `audit_logs` VALUES (11, 'neikeshenhe', 'login', 'Auth', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', 'username=neikeshenhe', 1, '2026-05-06 11:31:10', 0);
INSERT INTO `audit_logs` VALUES (12, 'user001', 'login', 'Auth', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', 'username=user001', 1, '2026-05-06 11:31:21', 0);
INSERT INTO `audit_logs` VALUES (13, 'user001', 'pickup', 'Borrow', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', 'id=14', 1, '2026-05-06 11:31:27', 0);
INSERT INTO `audit_logs` VALUES (14, 'user001', 'complete', 'Borrow', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', 'id=14', 1, '2026-05-06 11:31:28', 0);
INSERT INTO `audit_logs` VALUES (15, 'admin', 'login', 'Auth', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', 'username=admin', 1, '2026-05-06 11:35:22', 0);
INSERT INTO `audit_logs` VALUES (16, 'admin', 'LOGOUT', 'Auth', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', 'username=admin', 1, '2026-05-06 14:28:07', 0);
INSERT INTO `audit_logs` VALUES (17, 'admin', 'login', 'Auth', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', 'username=admin', 1, '2026-05-06 14:34:51', 0);

-- ----------------------------
-- Table structure for borrowapplications
-- ----------------------------
DROP TABLE IF EXISTS `borrowapplications`;
CREATE TABLE `borrowapplications`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `recordIds` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '病案ID列表，逗号分隔',
  `reason` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '借阅原因',
  `borrowType` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '借阅类型(院内借阅/院外借阅)',
  `expectedReturnDate` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '预计归还日期',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '状态(pending_dept/pending_archive/approved/rejected/picked/completed/cancelled)',
  `submitTime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '提交时间',
  `userId` bigint NOT NULL COMMENT '用户ID',
  `userName` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户姓名',
  `department` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '申请人科室',
  `deptApprover` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '科室审批人',
  `deptApproveTime` datetime NULL DEFAULT NULL COMMENT '科室审批时间',
  `deptRejectionReason` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '科室驳回原因',
  `archiveApprover` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '病案室审批人',
  `archiveApproveTime` datetime NULL DEFAULT NULL COMMENT '病案室审批时间',
  `archiveRejectionReason` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '病案室驳回原因',
  `approver` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '审批人(兼容旧版)',
  `approveTime` datetime NULL DEFAULT NULL COMMENT '审批时间(兼容旧版)',
  `rejectionReason` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '驳回原因(兼容旧版)',
  `returnTime` datetime NULL DEFAULT NULL COMMENT '归还时间',
  `createdTime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updatedTime` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` int NULL DEFAULT 0 COMMENT '逻辑删除(1:已删除, 0:未删除)',
  `userDepartment` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_borrow_applications_user_id`(`userId` ASC) USING BTREE,
  INDEX `idx_borrow_applications_status`(`status` ASC) USING BTREE,
  INDEX `idx_borrow_applications_submit_time`(`submitTime` ASC) USING BTREE,
  CONSTRAINT `borrowapplications_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 15 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '借阅申请表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of borrowapplications
-- ----------------------------
INSERT INTO `borrowapplications` VALUES (1, '1', '病历复查', '院内借阅', '2024-03-01', 'pending', '2026-05-06 10:58:47', 2, '张医生', '内科', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-06 10:58:47', '2026-05-06 10:59:58', 0, NULL);
INSERT INTO `borrowapplications` VALUES (2, '2', '会诊需要', '院内借阅', '2024-03-05', 'approved', '2026-05-06 10:58:47', 3, '李护士', '外科', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-06 10:58:47', '2026-05-06 10:59:58', 0, NULL);
INSERT INTO `borrowapplications` VALUES (3, '101', '科室会诊调阅', '院内借阅', '2026-04-09', 'approved', '2026-04-12 10:00:00', 1, '系统管理员', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '系统管理员', '2026-04-13 14:30:00', NULL, NULL, '2026-04-12 10:00:00', '2026-04-12 16:00:00', 0, NULL);
INSERT INTO `borrowapplications` VALUES (4, '102', '医保稽核查档', '院外借阅', '2026-04-11', 'picked', '2026-04-16 10:00:00', 2, '王主任', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '系统管理员', '2026-04-17 14:30:00', NULL, NULL, '2026-04-16 10:00:00', '2026-04-16 16:00:00', 0, NULL);
INSERT INTO `borrowapplications` VALUES (5, '103', '教学查房使用', '院内借阅', '2026-04-20', 'completed', '2026-04-19 10:00:00', 1, '系统管理员', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '系统管理员', '2026-04-20 14:30:00', NULL, NULL, '2026-04-19 10:00:00', '2026-04-19 16:00:00', 0, NULL);
INSERT INTO `borrowapplications` VALUES (6, '104', '病案质控复盘', '院外借阅', '2026-04-20', 'completed', '2026-04-22 10:00:00', 3, '刘主任', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '系统管理员', '2026-04-23 14:30:00', NULL, NULL, '2026-04-22 10:00:00', '2026-04-25 16:00:00', 0, NULL);
INSERT INTO `borrowapplications` VALUES (7, '105', '待主任审批', '院内借阅', '2026-05-12', 'pending', '2026-04-27 10:00:00', 1, '系统管理员', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-04-27 10:00:00', '2026-04-27 16:00:00', 0, NULL);
INSERT INTO `borrowapplications` VALUES (8, '106', '申请不符合规范', '院外借阅', '2026-05-10', 'rejected', '2026-04-28 10:00:00', 2, '王主任', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '系统管理员', '2026-04-28 14:30:00', '演示数据：材料不完整', NULL, '2026-04-28 10:00:00', '2026-04-29 16:00:00', 0, NULL);
INSERT INTO `borrowapplications` VALUES (9, '107', '申请人主动取消', '院内借阅', '2026-05-09', 'cancelled', '2026-04-29 10:00:00', 3, '刘主任', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-04-29 10:00:00', '2026-04-29 16:00:00', 0, NULL);
INSERT INTO `borrowapplications` VALUES (10, '108', '院外会诊调阅', '院外借阅', '2026-05-08', 'approved', '2026-05-01 10:00:00', 1, '系统管理员', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '系统管理员', '2026-05-01 14:30:00', NULL, NULL, '2026-05-01 10:00:00', '2026-05-01 16:00:00', 0, NULL);
INSERT INTO `borrowapplications` VALUES (11, '109', '科研课题查阅', '院内借阅', '2026-05-02', 'completed', '2026-05-02 10:00:00', 2, '王主任', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '系统管理员', '2026-05-02 14:30:00', NULL, NULL, '2026-05-02 10:00:00', '2026-05-02 16:00:00', 0, NULL);
INSERT INTO `borrowapplications` VALUES (12, '110', '医疗纠纷材料调取', '院外借阅', '2026-05-14', 'approved', '2026-05-04 10:00:00', 3, '刘主任', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '系统管理员', '2026-05-04 14:30:00', NULL, NULL, '2026-05-04 10:00:00', '2026-05-04 16:00:00', 0, NULL);
INSERT INTO `borrowapplications` VALUES (13, '11', 'neikeshenheneikeshenhe', '院内借阅', '2026/5/7', 'approved', '2026-05-06 11:02:29', 2, '王主任', '内科', '王主任', '2026-05-06 11:02:36', NULL, '马管理员', '2026-05-06 11:03:46', NULL, NULL, NULL, NULL, NULL, '2026-05-06 11:02:29', '2026-05-06 11:03:46', 0, NULL);
INSERT INTO `borrowapplications` VALUES (14, '11', 'neikeshenheneikeshenheneikeshenhe', '院内借阅', '2026/5/7', 'completed', '2026-05-06 11:03:00', 14, '张医生', '内科', '王主任', '2026-05-06 11:03:13', NULL, '系统管理员', '2026-05-06 11:03:23', NULL, NULL, NULL, NULL, NULL, '2026-05-06 11:03:00', '2026-05-06 11:31:28', 0, NULL);

-- ----------------------------
-- Table structure for medicalrecords
-- ----------------------------
DROP TABLE IF EXISTS `medicalrecords`;
CREATE TABLE `medicalrecords`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '病案ID',
  `recordNumber` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '病案号',
  `patientName` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '患者姓名',
  `patientId` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '患者ID',
  `department` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '科室',
  `diagnosis` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '诊断',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '状态(可借阅/已借出/已归档)',
  `admissionDate` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '入院日期',
  `dischargeDate` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '出院日期',
  `createdAt` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updatedTime` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` int NULL DEFAULT 0 COMMENT '逻辑删除(1:已删除, 0:未删除)',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `recordNumber`(`recordNumber` ASC) USING BTREE,
  INDEX `idx_medical_records_record_number`(`recordNumber` ASC) USING BTREE,
  INDEX `idx_medical_records_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 111 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '病案表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of medicalrecords
-- ----------------------------
INSERT INTO `medicalrecords` VALUES (1, 'MR2024001', '张三', 'P0001', '内科', '高血压', '可借阅', '2024-01-01', '2024-01-10', '2026-05-06 10:58:47', '2026-05-06 10:58:47', 0);
INSERT INTO `medicalrecords` VALUES (2, 'MR2024002', '李四', 'P0002', '外科', '阑尾炎', '可借阅', '2024-01-05', '2024-01-15', '2026-05-06 10:58:47', '2026-05-06 10:58:47', 0);
INSERT INTO `medicalrecords` VALUES (3, 'MR2024003', '王五', 'P0003', '儿科', '肺炎', '可借阅', '2024-01-10', '2024-01-20', '2026-05-06 10:58:47', '2026-05-06 10:58:47', 0);
INSERT INTO `medicalrecords` VALUES (4, 'MR2024004', '赵六', 'P0004', '妇产科', '产前检查', '可借阅', '2024-01-15', '2024-01-25', '2026-05-06 10:58:47', '2026-05-06 10:58:47', 0);
INSERT INTO `medicalrecords` VALUES (5, 'MR2024005', '钱七', 'P0005', '眼科', '结膜炎', '可借阅', '2024-01-20', '2024-01-30', '2026-05-06 10:58:47', '2026-05-06 10:58:47', 0);
INSERT INTO `medicalrecords` VALUES (6, 'MR2024006', '孙八', 'P0006', '耳鼻喉科', '中耳炎', '可借阅', '2024-01-25', '2024-02-04', '2026-05-06 10:58:47', '2026-05-06 10:58:47', 0);
INSERT INTO `medicalrecords` VALUES (7, 'MR2024007', '周九', 'P0007', '口腔科', '牙周炎', '可借阅', '2024-02-01', '2024-02-10', '2026-05-06 10:58:47', '2026-05-06 10:58:47', 0);
INSERT INTO `medicalrecords` VALUES (8, 'MR2024008', '吴十', 'P0008', '皮肤科', '湿疹', '可借阅', '2024-02-05', '2024-02-15', '2026-05-06 10:58:47', '2026-05-06 10:58:47', 0);
INSERT INTO `medicalrecords` VALUES (9, 'MR2024009', '郑十一', 'P0009', '骨科', '骨折', '可借阅', '2024-02-10', '2024-02-20', '2026-05-06 10:58:47', '2026-05-06 10:58:47', 0);
INSERT INTO `medicalrecords` VALUES (10, 'MR2024010', '王十二', 'P0010', '神经科', '头痛', '可借阅', '2024-02-15', '2024-02-25', '2026-05-06 10:58:47', '2026-05-06 10:58:47', 0);
INSERT INTO `medicalrecords` VALUES (11, 'MR2024011', '陈明华', 'P0011', '内科', '糖尿病', '可借阅', '2024-02-20', '2024-03-01', '2026-05-06 11:00:05', '2026-05-06 11:31:28', 0);
INSERT INTO `medicalrecords` VALUES (12, 'MR2024012', '林志强', 'P0012', '外科', '胆囊炎', '可借阅', '2024-02-25', '2024-03-05', '2026-05-06 11:00:05', '2026-05-06 11:00:05', 0);
INSERT INTO `medicalrecords` VALUES (13, 'MR2024013', '黄美玲', 'P0013', '儿科', '支气管炎', '可借阅', '2024-03-01', '2024-03-10', '2026-05-06 11:00:05', '2026-05-06 11:00:05', 0);
INSERT INTO `medicalrecords` VALUES (14, 'MR2024014', '吴建国', 'P0014', '妇产科', '妊娠高血压', '可借阅', '2024-03-05', '2024-03-15', '2026-05-06 11:00:05', '2026-05-06 11:00:05', 0);
INSERT INTO `medicalrecords` VALUES (15, 'MR2024015', '郑小芳', 'P0015', '眼科', '白内障', '可借阅', '2024-03-10', '2024-03-20', '2026-05-06 11:00:05', '2026-05-06 11:00:05', 0);
INSERT INTO `medicalrecords` VALUES (16, 'MR2024016', '王大鹏', 'P0016', '耳鼻喉科', '鼻窦炎', '可借阅', '2024-03-15', '2024-03-25', '2026-05-06 11:00:05', '2026-05-06 11:00:05', 0);
INSERT INTO `medicalrecords` VALUES (17, 'MR2024017', '李秀英', 'P0017', '口腔科', '龋齿', '可借阅', '2024-03-20', '2024-03-30', '2026-05-06 11:00:05', '2026-05-06 11:00:05', 0);
INSERT INTO `medicalrecords` VALUES (18, 'MR2024018', '张卫国', 'P0018', '皮肤科', '银屑病', '可借阅', '2024-03-25', '2024-04-04', '2026-05-06 11:00:05', '2026-05-06 11:00:05', 0);
INSERT INTO `medicalrecords` VALUES (19, 'MR2024019', '刘红梅', 'P0019', '骨科', '腰椎间盘突出', '可借阅', '2024-04-01', '2024-04-10', '2026-05-06 11:00:05', '2026-05-06 11:00:05', 0);
INSERT INTO `medicalrecords` VALUES (20, 'MR2024020', '赵建华', 'P0020', '神经科', '脑梗塞', '可借阅', '2024-04-05', '2024-04-15', '2026-05-06 11:00:05', '2026-05-06 11:00:05', 0);
INSERT INTO `medicalrecords` VALUES (21, 'MR2024021', '孙丽娟', 'P0021', '内科', '冠心病', '已借出', '2024-04-10', '2024-04-20', '2026-05-06 11:00:05', '2026-05-06 11:00:05', 0);
INSERT INTO `medicalrecords` VALUES (22, 'MR2024022', '周志远', 'P0022', '外科', '疝气', '可借阅', '2024-04-15', '2024-04-25', '2026-05-06 11:00:05', '2026-05-06 11:00:05', 0);
INSERT INTO `medicalrecords` VALUES (23, 'MR2024023', '吴雅婷', 'P0023', '儿科', '手足口病', '可借阅', '2024-04-20', '2024-04-30', '2026-05-06 11:00:05', '2026-05-06 11:00:05', 0);
INSERT INTO `medicalrecords` VALUES (24, 'MR2024024', '郑国强', 'P0024', '妇产科', '子宫肌瘤', '可借阅', '2024-04-25', '2024-05-05', '2026-05-06 11:00:05', '2026-05-06 11:00:05', 0);
INSERT INTO `medicalrecords` VALUES (25, 'MR2024025', '王小燕', 'P0025', '眼科', '青光眼', '可借阅', '2024-05-01', '2024-05-10', '2026-05-06 11:00:05', '2026-05-06 11:00:05', 0);
INSERT INTO `medicalrecords` VALUES (26, 'MR2024026', '李文博', 'P0026', '耳鼻喉科', '扁桃体炎', '可借阅', '2024-05-05', '2024-05-15', '2026-05-06 11:00:05', '2026-05-06 11:00:05', 0);
INSERT INTO `medicalrecords` VALUES (27, 'MR2024027', '张美华', 'P0027', '口腔科', '牙龈炎', '可借阅', '2024-05-10', '2024-05-20', '2026-05-06 11:00:05', '2026-05-06 11:00:05', 0);
INSERT INTO `medicalrecords` VALUES (28, 'MR2024028', '刘建军', 'P0028', '皮肤科', '荨麻疹', '可借阅', '2024-05-15', '2024-05-25', '2026-05-06 11:00:05', '2026-05-06 11:00:05', 0);
INSERT INTO `medicalrecords` VALUES (29, 'MR2024029', '陈丽娜', 'P0029', '骨科', '颈椎病', '可借阅', '2024-05-20', '2024-05-30', '2026-05-06 11:00:05', '2026-05-06 11:00:05', 0);
INSERT INTO `medicalrecords` VALUES (30, 'MR2024030', '杨志伟', 'P0030', '神经科', '癫痫', '可借阅', '2024-05-25', '2024-06-04', '2026-05-06 11:00:05', '2026-05-06 11:00:05', 0);
INSERT INTO `medicalrecords` VALUES (31, 'MR2024031', '赵敏', 'P0031', '内科', '慢性胃炎', '可借阅', '2024-06-01', '2024-06-10', '2026-05-06 11:00:05', '2026-05-06 11:00:05', 0);
INSERT INTO `medicalrecords` VALUES (32, 'MR2024032', '黄志强', 'P0032', '外科', '静脉曲张', '可借阅', '2024-06-05', '2024-06-15', '2026-05-06 11:00:05', '2026-05-06 11:00:05', 0);
INSERT INTO `medicalrecords` VALUES (33, 'MR2024033', '林小红', 'P0033', '儿科', '哮喘', '可借阅', '2024-06-10', '2024-06-20', '2026-05-06 11:00:05', '2026-05-06 11:00:05', 0);
INSERT INTO `medicalrecords` VALUES (34, 'MR2024034', '吴大伟', 'P0034', '妇产科', '卵巢囊肿', '可借阅', '2024-06-15', '2024-06-25', '2026-05-06 11:00:05', '2026-05-06 11:00:05', 0);
INSERT INTO `medicalrecords` VALUES (35, 'MR2024035', '郑美玲', 'P0035', '眼科', '近视', '可借阅', '2024-06-20', '2024-06-30', '2026-05-06 11:00:05', '2026-05-06 11:00:05', 0);
INSERT INTO `medicalrecords` VALUES (36, 'MR2024036', '王建国', 'P0036', '耳鼻喉科', '过敏性鼻炎', '可借阅', '2024-06-25', '2024-07-05', '2026-05-06 11:00:05', '2026-05-06 11:00:05', 0);
INSERT INTO `medicalrecords` VALUES (37, 'MR2024037', '李秀兰', 'P0037', '口腔科', '口腔溃疡', '可借阅', '2024-07-01', '2024-07-10', '2026-05-06 11:00:05', '2026-05-06 11:00:05', 0);
INSERT INTO `medicalrecords` VALUES (38, 'MR2024038', '张志强', 'P0038', '皮肤科', '痤疮', '可借阅', '2024-07-05', '2024-07-15', '2026-05-06 11:00:05', '2026-05-06 11:00:05', 0);
INSERT INTO `medicalrecords` VALUES (39, 'MR2024039', '刘芳', 'P0039', '骨科', '关节炎', '可借阅', '2024-07-10', '2024-07-20', '2026-05-06 11:00:05', '2026-05-06 11:00:05', 0);
INSERT INTO `medicalrecords` VALUES (40, 'MR2024040', '陈建华', 'P0040', '神经科', '帕金森病', '可借阅', '2024-07-15', '2024-07-25', '2026-05-06 11:00:05', '2026-05-06 11:00:05', 0);
INSERT INTO `medicalrecords` VALUES (41, 'MR2024041', '杨美丽', 'P0041', '内科', '甲状腺功能亢进', '可借阅', '2024-07-20', '2024-07-30', '2026-05-06 11:00:05', '2026-05-06 11:00:05', 0);
INSERT INTO `medicalrecords` VALUES (42, 'MR2024042', '赵国栋', 'P0042', '外科', '痔疮', '可借阅', '2024-07-25', '2024-08-04', '2026-05-06 11:00:05', '2026-05-06 11:00:05', 0);
INSERT INTO `medicalrecords` VALUES (43, 'MR2024043', '孙小燕', 'P0043', '儿科', '腹泻', '可借阅', '2024-08-01', '2024-08-10', '2026-05-06 11:00:05', '2026-05-06 11:00:05', 0);
INSERT INTO `medicalrecords` VALUES (44, 'MR2024044', '周建华', 'P0044', '妇产科', '宫外孕', '可借阅', '2024-08-05', '2024-08-15', '2026-05-06 11:00:05', '2026-05-06 11:00:05', 0);
INSERT INTO `medicalrecords` VALUES (45, 'MR2024045', '吴志远', 'P0045', '眼科', '散光', '可借阅', '2024-08-10', '2024-08-20', '2026-05-06 11:00:05', '2026-05-06 11:00:05', 0);
INSERT INTO `medicalrecords` VALUES (46, 'MR2024046', '郑丽娟', 'P0046', '耳鼻喉科', '咽喉炎', '可借阅', '2024-08-15', '2024-08-25', '2026-05-06 11:00:05', '2026-05-06 11:00:05', 0);
INSERT INTO `medicalrecords` VALUES (47, 'MR2024047', '王美华', 'P0047', '口腔科', '智齿冠周炎', '可借阅', '2024-08-20', '2024-08-30', '2026-05-06 11:00:05', '2026-05-06 11:00:05', 0);
INSERT INTO `medicalrecords` VALUES (48, 'MR2024048', '李大鹏', 'P0048', '皮肤科', '毛囊炎', '可借阅', '2024-08-25', '2024-09-04', '2026-05-06 11:00:05', '2026-05-06 11:00:05', 0);
INSERT INTO `medicalrecords` VALUES (49, 'MR2024049', '张小红', 'P0049', '骨科', '半月板损伤', '可借阅', '2024-09-01', '2024-09-10', '2026-05-06 11:00:05', '2026-05-06 11:00:05', 0);
INSERT INTO `medicalrecords` VALUES (50, 'MR2024050', '刘志强', 'P0050', '神经科', '面瘫', '可借阅', '2024-09-05', '2024-09-15', '2026-05-06 11:00:05', '2026-05-06 11:00:05', 0);
INSERT INTO `medicalrecords` VALUES (51, 'MR2024051', '陈雅婷', 'P0051', '内科', '贫血', '可借阅', '2024-09-10', '2024-09-20', '2026-05-06 11:00:05', '2026-05-06 11:00:05', 0);
INSERT INTO `medicalrecords` VALUES (52, 'MR2024052', '杨建国', 'P0052', '外科', '脂肪瘤', '可借阅', '2024-09-15', '2024-09-25', '2026-05-06 11:00:05', '2026-05-06 11:00:05', 0);
INSERT INTO `medicalrecords` VALUES (53, 'MR2024053', '赵美玲', 'P0053', '儿科', '水痘', '可借阅', '2024-09-20', '2024-09-30', '2026-05-06 11:00:05', '2026-05-06 11:00:05', 0);
INSERT INTO `medicalrecords` VALUES (54, 'MR2024054', '孙志伟', 'P0054', '妇产科', '盆腔炎', '可借阅', '2024-09-25', '2024-10-05', '2026-05-06 11:00:05', '2026-05-06 11:00:05', 0);
INSERT INTO `medicalrecords` VALUES (55, 'MR2024055', '周小芳', 'P0055', '眼科', '干眼症', '可借阅', '2024-10-01', '2024-10-10', '2026-05-06 11:00:05', '2026-05-06 11:00:05', 0);
INSERT INTO `medicalrecords` VALUES (56, 'MR2024056', '吴建华', 'P0056', '耳鼻喉科', '声带息肉', '可借阅', '2024-10-05', '2024-10-15', '2026-05-06 11:00:05', '2026-05-06 11:00:05', 0);
INSERT INTO `medicalrecords` VALUES (57, 'MR2024057', '郑志强', 'P0057', '口腔科', '牙周病', '可借阅', '2024-10-10', '2024-10-20', '2026-05-06 11:00:05', '2026-05-06 11:00:05', 0);
INSERT INTO `medicalrecords` VALUES (58, 'MR2024058', '王丽娜', 'P0058', '皮肤科', '白癜风', '可借阅', '2024-10-15', '2024-10-25', '2026-05-06 11:00:05', '2026-05-06 11:00:05', 0);
INSERT INTO `medicalrecords` VALUES (59, 'MR2024059', '李建军', 'P0059', '骨科', '腱鞘炎', '可借阅', '2024-10-20', '2024-10-30', '2026-05-06 11:00:05', '2026-05-06 11:00:05', 0);
INSERT INTO `medicalrecords` VALUES (60, 'MR2024060', '张美华', 'P0060', '神经科', '偏头痛', '可借阅', '2024-10-25', '2024-11-04', '2026-05-06 11:00:05', '2026-05-06 11:00:05', 0);
INSERT INTO `medicalrecords` VALUES (61, 'MR2024061', '刘国华', 'P0061', '内科', '脂肪肝', '可借阅', '2024-11-01', '2024-11-10', '2026-05-06 11:00:05', '2026-05-06 11:00:05', 0);
INSERT INTO `medicalrecords` VALUES (62, 'MR2024062', '陈志远', 'P0062', '外科', '乳腺增生', '可借阅', '2024-11-05', '2024-11-15', '2026-05-06 11:00:05', '2026-05-06 11:00:05', 0);
INSERT INTO `medicalrecords` VALUES (63, 'MR2024063', '杨小红', 'P0063', '儿科', '百日咳', '可借阅', '2024-11-10', '2024-11-20', '2026-05-06 11:00:05', '2026-05-06 11:00:05', 0);
INSERT INTO `medicalrecords` VALUES (64, 'MR2024064', '赵大鹏', 'P0064', '妇产科', '前置胎盘', '可借阅', '2024-11-15', '2024-11-25', '2026-05-06 11:00:05', '2026-05-06 11:00:05', 0);
INSERT INTO `medicalrecords` VALUES (65, 'MR2024065', '孙美玲', 'P0065', '眼科', '角膜炎', '可借阅', '2024-11-20', '2024-11-30', '2026-05-06 11:00:05', '2026-05-06 11:00:05', 0);
INSERT INTO `medicalrecords` VALUES (66, 'MR2024066', '周志强', 'P0066', '耳鼻喉科', '鼻息肉', '可借阅', '2024-11-25', '2024-12-05', '2026-05-06 11:00:05', '2026-05-06 11:00:05', 0);
INSERT INTO `medicalrecords` VALUES (67, 'MR2024067', '吴小燕', 'P0067', '口腔科', '舌炎', '可借阅', '2024-12-01', '2024-12-10', '2026-05-06 11:00:05', '2026-05-06 11:00:05', 0);
INSERT INTO `medicalrecords` VALUES (68, 'MR2024068', '郑建华', 'P0068', '皮肤科', '红斑狼疮', '可借阅', '2024-12-05', '2024-12-15', '2026-05-06 11:00:05', '2026-05-06 11:00:05', 0);
INSERT INTO `medicalrecords` VALUES (69, 'MR2024069', '王志明', 'P0069', '骨科', '骨质疏松', '可借阅', '2024-12-10', '2024-12-20', '2026-05-06 11:00:05', '2026-05-06 11:00:05', 0);
INSERT INTO `medicalrecords` VALUES (70, 'MR2024070', '李雅婷', 'P0070', '神经科', '失眠症', '可借阅', '2024-12-15', '2024-12-25', '2026-05-06 11:00:05', '2026-05-06 11:00:05', 0);
INSERT INTO `medicalrecords` VALUES (71, 'MR2024071', '张丽华', 'P0071', '内科', '高尿酸血症', '可借阅', '2024-12-20', '2024-12-30', '2026-05-06 11:00:05', '2026-05-06 11:00:05', 0);
INSERT INTO `medicalrecords` VALUES (72, 'MR2024072', '刘建国', 'P0072', '外科', '淋巴结核', '可借阅', '2024-12-25', '2025-01-04', '2026-05-06 11:00:05', '2026-05-06 11:00:05', 0);
INSERT INTO `medicalrecords` VALUES (73, 'MR2024073', '陈美华', 'P0073', '儿科', '腮腺炎', '可借阅', '2025-01-01', '2025-01-10', '2026-05-06 11:00:05', '2026-05-06 11:00:05', 0);
INSERT INTO `medicalrecords` VALUES (74, 'MR2024074', '杨志远', 'P0074', '妇产科', '宫颈炎', '可借阅', '2025-01-05', '2025-01-15', '2026-05-06 11:00:05', '2026-05-06 11:00:05', 0);
INSERT INTO `medicalrecords` VALUES (75, 'MR2024075', '赵小芳', 'P0075', '眼科', '视网膜脱落', '可借阅', '2025-01-10', '2025-01-20', '2026-05-06 11:00:05', '2026-05-06 11:00:05', 0);
INSERT INTO `medicalrecords` VALUES (76, 'MR2024076', '孙大鹏', 'P0076', '耳鼻喉科', '喉癌', '可借阅', '2025-01-15', '2025-01-25', '2026-05-06 11:00:05', '2026-05-06 11:00:05', 0);
INSERT INTO `medicalrecords` VALUES (77, 'MR2024077', '周丽娜', 'P0077', '口腔科', '口腔扁平苔藓', '可借阅', '2025-01-20', '2025-01-30', '2026-05-06 11:00:05', '2026-05-06 11:00:05', 0);
INSERT INTO `medicalrecords` VALUES (78, 'MR2024078', '吴志强', 'P0078', '皮肤科', '带状疱疹', '可借阅', '2025-01-25', '2025-02-04', '2026-05-06 11:00:05', '2026-05-06 11:00:05', 0);
INSERT INTO `medicalrecords` VALUES (79, 'MR2024079', '郑美华', 'P0079', '骨科', '肩周炎', '可借阅', '2025-02-01', '2025-02-10', '2026-05-06 11:00:05', '2026-05-06 11:00:05', 0);
INSERT INTO `medicalrecords` VALUES (80, 'MR2024080', '王建军', 'P0080', '神经科', '脑出血', '可借阅', '2025-02-05', '2025-02-15', '2026-05-06 11:00:05', '2026-05-06 11:00:05', 0);
INSERT INTO `medicalrecords` VALUES (81, 'MR2024081', '李小红', 'P0081', '内科', '心律失常', '可借阅', '2025-02-10', '2025-02-20', '2026-05-06 11:00:05', '2026-05-06 11:00:05', 0);
INSERT INTO `medicalrecords` VALUES (82, 'MR2024082', '张志明', 'P0082', '外科', '甲状腺结节', '可借阅', '2025-02-15', '2025-02-25', '2026-05-06 11:00:05', '2026-05-06 11:00:05', 0);
INSERT INTO `medicalrecords` VALUES (83, 'MR2024083', '刘雅婷', 'P0083', '儿科', '过敏性紫癜', '可借阅', '2025-02-20', '2025-03-01', '2026-05-06 11:00:05', '2026-05-06 11:00:05', 0);
INSERT INTO `medicalrecords` VALUES (84, 'MR2024084', '陈国华', 'P0084', '妇产科', '子宫内膜异位症', '可借阅', '2025-02-25', '2025-03-05', '2026-05-06 11:00:05', '2026-05-06 11:00:05', 0);
INSERT INTO `medicalrecords` VALUES (85, 'MR2024085', '杨美玲', 'P0085', '眼科', '玻璃体混浊', '可借阅', '2025-03-01', '2025-03-10', '2026-05-06 11:00:05', '2026-05-06 11:00:05', 0);
INSERT INTO `medicalrecords` VALUES (86, 'MR2024086', '赵志强', 'P0086', '耳鼻喉科', '梅尼埃病', '可借阅', '2025-03-05', '2025-03-15', '2026-05-06 11:00:05', '2026-05-06 11:00:05', 0);
INSERT INTO `medicalrecords` VALUES (87, 'MR2024087', '孙小燕', 'P0087', '口腔科', '颞下颌关节紊乱', '可借阅', '2025-03-10', '2025-03-20', '2026-05-06 11:00:05', '2026-05-06 11:00:05', 0);
INSERT INTO `medicalrecords` VALUES (88, 'MR2024088', '周建华', 'P0088', '皮肤科', '硬皮病', '可借阅', '2025-03-15', '2025-03-25', '2026-05-06 11:00:05', '2026-05-06 11:00:05', 0);
INSERT INTO `medicalrecords` VALUES (89, 'MR2024089', '吴丽娟', 'P0089', '骨科', '滑膜炎', '可借阅', '2025-03-20', '2025-03-30', '2026-05-06 11:00:05', '2026-05-06 11:00:05', 0);
INSERT INTO `medicalrecords` VALUES (90, 'MR2024090', '郑大鹏', 'P0090', '神经科', '重症肌无力', '可借阅', '2025-03-25', '2025-04-04', '2026-05-06 11:00:05', '2026-05-06 11:00:05', 0);
INSERT INTO `medicalrecords` VALUES (91, 'MR2024091', '王美华', 'P0091', '内科', '支气管扩张', '可借阅', '2025-04-01', '2025-04-10', '2026-05-06 11:00:05', '2026-05-06 11:00:05', 0);
INSERT INTO `medicalrecords` VALUES (92, 'MR2024092', '李志强', 'P0092', '外科', '腹股沟疝', '可借阅', '2025-04-05', '2025-04-15', '2026-05-06 11:00:05', '2026-05-06 11:00:05', 0);
INSERT INTO `medicalrecords` VALUES (93, 'MR2024093', '张小红', 'P0093', '儿科', '川崎病', '可借阅', '2025-04-10', '2025-04-20', '2026-05-06 11:00:05', '2026-05-06 11:00:05', 0);
INSERT INTO `medicalrecords` VALUES (94, 'MR2024094', '刘建国', 'P0094', '妇产科', '胎膜早破', '可借阅', '2025-04-15', '2025-04-25', '2026-05-06 11:00:05', '2026-05-06 11:00:05', 0);
INSERT INTO `medicalrecords` VALUES (95, 'MR2024095', '陈雅婷', 'P0095', '眼科', '视神经炎', '可借阅', '2025-04-20', '2025-04-30', '2026-05-06 11:00:05', '2026-05-06 11:00:05', 0);
INSERT INTO `medicalrecords` VALUES (96, 'MR2024096', '杨志伟', 'P0096', '耳鼻喉科', '咽鼓管功能障碍', '可借阅', '2025-04-25', '2025-05-05', '2026-05-06 11:00:05', '2026-05-06 11:00:05', 0);
INSERT INTO `medicalrecords` VALUES (97, 'MR2024097', '赵美玲', 'P0097', '口腔科', '复发性阿弗他溃疡', '可借阅', '2025-05-01', '2025-05-10', '2026-05-06 11:00:05', '2026-05-06 11:00:05', 0);
INSERT INTO `medicalrecords` VALUES (98, 'MR2024098', '孙小芳', 'P0098', '皮肤科', '鱼鳞病', '可借阅', '2025-05-05', '2025-05-15', '2026-05-06 11:00:05', '2026-05-06 11:00:05', 0);
INSERT INTO `medicalrecords` VALUES (99, 'MR2024099', '周志强', 'P0099', '骨科', '股骨头坏死', '可借阅', '2025-05-10', '2025-05-20', '2026-05-06 11:00:05', '2026-05-06 11:00:05', 0);
INSERT INTO `medicalrecords` VALUES (100, 'MR2024100', '吴建华', 'P0100', '神经科', '多发性硬化', '可借阅', '2025-05-15', '2025-05-25', '2026-05-06 11:00:05', '2026-05-06 11:00:05', 0);
INSERT INTO `medicalrecords` VALUES (101, 'DEMO-MR-001', '张某', 'PID-001', '妇产科', '产后复查', '已借出', '2026-04-06', '2026-04-11', '2026-04-11 11:01:05', '2026-04-11 13:01:05', 0);
INSERT INTO `medicalrecords` VALUES (102, 'DEMO-MR-002', '李某', 'PID-002', '妇产科', '妇科手术', '已借出', '2026-04-10', '2026-04-15', '2026-04-15 11:01:05', '2026-04-15 13:01:05', 0);
INSERT INTO `medicalrecords` VALUES (103, 'DEMO-MR-003', '王某', 'PID-003', '内科', '糖尿病', '已归档', '2026-04-13', '2026-04-18', '2026-04-18 11:01:05', '2026-04-18 13:01:05', 0);
INSERT INTO `medicalrecords` VALUES (104, 'DEMO-MR-004', '赵某', 'PID-004', '外科', '阑尾炎', '已归档', '2026-04-16', '2026-04-21', '2026-04-21 11:01:05', '2026-04-21 13:01:05', 0);
INSERT INTO `medicalrecords` VALUES (105, 'DEMO-MR-005', '陈某', 'PID-005', '儿科', '肺炎', '可借阅', '2026-04-19', '2026-04-24', '2026-04-24 11:01:05', '2026-04-24 13:01:05', 0);
INSERT INTO `medicalrecords` VALUES (106, 'DEMO-MR-006', '周某', 'PID-006', '骨科', '骨折', '可借阅', '2026-04-21', '2026-04-26', '2026-04-26 11:01:05', '2026-04-26 13:01:05', 0);
INSERT INTO `medicalrecords` VALUES (107, 'DEMO-MR-007', '吴某', 'PID-007', '眼科', '白内障', '已借出', '2026-04-23', '2026-04-28', '2026-04-28 11:01:05', '2026-04-28 13:01:05', 0);
INSERT INTO `medicalrecords` VALUES (108, 'DEMO-MR-008', '郑某', 'PID-008', '耳鼻喉科', '鼻窦炎', '可借阅', '2026-04-25', '2026-04-30', '2026-04-30 11:01:05', '2026-04-30 13:01:05', 0);
INSERT INTO `medicalrecords` VALUES (109, 'DEMO-MR-009', '冯某', 'PID-009', '口腔科', '智齿拔除', '已归档', '2026-04-27', '2026-05-02', '2026-05-02 11:01:05', '2026-05-02 13:01:05', 0);
INSERT INTO `medicalrecords` VALUES (110, 'DEMO-MR-010', '孙某', 'PID-010', '内科', '高血压', '已借出', '2026-04-29', '2026-05-04', '2026-05-04 11:01:05', '2026-05-04 13:01:05', 0);

-- ----------------------------
-- Table structure for menus
-- ----------------------------
DROP TABLE IF EXISTS `menus`;
CREATE TABLE `menus`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '菜单ID',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '菜单名称',
  `path` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '路由路径',
  `icon` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '图标',
  `parentId` bigint NULL DEFAULT 0 COMMENT '父菜单ID',
  `sortOrder` int NULL DEFAULT 0 COMMENT '排序',
  `permission` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '权限标识',
  `status` int NULL DEFAULT 1 COMMENT '状态(1:启用, 0:禁用)',
  `deleted` int NULL DEFAULT 0 COMMENT '逻辑删除(1:已删除, 0:未删除)',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '菜单表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of menus
-- ----------------------------
INSERT INTO `menus` VALUES (1, '仪表盘', '/dashboard', 'Dashboard', 0, 1, NULL, 1, 0);
INSERT INTO `menus` VALUES (2, '借阅申请', '/borrow', 'DocumentCopy', 0, 2, NULL, 1, 0);
INSERT INTO `menus` VALUES (3, '借阅历史', '/borrow-history', 'Time', 0, 3, NULL, 1, 0);
INSERT INTO `menus` VALUES (4, '用户管理', '/users', 'User', 0, 4, NULL, 1, 0);
INSERT INTO `menus` VALUES (5, '审计日志', '/audit', 'Monitor', 0, 5, NULL, 1, 0);

-- ----------------------------
-- Table structure for permissions
-- ----------------------------
DROP TABLE IF EXISTS `permissions`;
CREATE TABLE `permissions`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '权限ID',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '权限名称',
  `code` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '权限编码',
  `description` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '权限描述',
  `deleted` int NULL DEFAULT 0 COMMENT '逻辑删除(1:已删除, 0:未删除)',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `code`(`code` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '权限表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of permissions
-- ----------------------------
INSERT INTO `permissions` VALUES (1, '查看仪表盘', 'dashboard:view', '查看仪表盘数据', 0);
INSERT INTO `permissions` VALUES (2, '创建借阅申请', 'borrow:create', '创建借阅申请', 0);
INSERT INTO `permissions` VALUES (3, '查看借阅历史', 'borrow:history', '查看借阅历史', 0);
INSERT INTO `permissions` VALUES (4, '审批借阅申请', 'borrow:approve', '审批借阅申请', 0);
INSERT INTO `permissions` VALUES (5, '管理用户', 'user:manage', '管理用户信息', 0);
INSERT INTO `permissions` VALUES (6, '查看审计日志', 'audit:view', '查看审计日志', 0);

-- ----------------------------
-- Table structure for roles
-- ----------------------------
DROP TABLE IF EXISTS `roles`;
CREATE TABLE `roles`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '角色ID',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '角色名称',
  `description` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '角色描述',
  `status` int NULL DEFAULT 1 COMMENT '状态(1:启用, 0:禁用)',
  `deleted` int NULL DEFAULT 0 COMMENT '逻辑删除(1:已删除, 0:未删除)',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `name`(`name` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '角色表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of roles
-- ----------------------------
INSERT INTO `roles` VALUES (1, '管理员', '系统管理员', 1, 0);
INSERT INTO `roles` VALUES (2, '普通用户', '普通用户', 1, 0);

-- ----------------------------
-- Table structure for sys_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_menu`;
CREATE TABLE `sys_menu`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `parent_id` bigint NULL DEFAULT NULL,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `path` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `component` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `icon` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `sort` int NULL DEFAULT NULL,
  `status` int NULL DEFAULT 1,
  `created_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_time` datetime NULL DEFAULT NULL,
  `deleted` int NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_menu
-- ----------------------------

-- ----------------------------
-- Table structure for sys_permission
-- ----------------------------
DROP TABLE IF EXISTS `sys_permission`;
CREATE TABLE `sys_permission`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `perm_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `perm_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `status` int NULL DEFAULT 1,
  `created_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_time` datetime NULL DEFAULT NULL,
  `deleted` int NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_permission
-- ----------------------------

-- ----------------------------
-- Table structure for sys_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `role_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `status` int NULL DEFAULT 1,
  `created_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_time` datetime NULL DEFAULT NULL,
  `deleted` int NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_role
-- ----------------------------
INSERT INTO `sys_role` VALUES (1, 'admin', '系统管理员，拥有所有权限', 1, '2026-05-06 14:27:35', NULL, 0);
INSERT INTO `sys_role` VALUES (2, '主任', '主任，审核借阅申请', 1, '2026-05-06 14:27:35', NULL, 0);
INSERT INTO `sys_role` VALUES (3, 'dept_director', '科室主任，管理本科室病案和借阅审批', 1, '2026-05-06 14:27:35', NULL, 0);
INSERT INTO `sys_role` VALUES (4, 'doctor', '医生，可创建和编辑病案', 1, '2026-05-06 14:27:35', NULL, 0);
INSERT INTO `sys_role` VALUES (5, 'nurse', '护士，可查看病案', 1, '2026-05-06 14:27:35', NULL, 0);
INSERT INTO `sys_role` VALUES (6, 'user', '普通用户，基本查看权限', 1, '2026-05-06 14:27:35', NULL, 0);

-- ----------------------------
-- Table structure for sys_role_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_menu`;
CREATE TABLE `sys_role_menu`  (
  `role_id` bigint NOT NULL,
  `menu_id` bigint NOT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_role_menu
-- ----------------------------

-- ----------------------------
-- Table structure for sys_role_permission
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_permission`;
CREATE TABLE `sys_role_permission`  (
  `role_id` bigint NOT NULL,
  `permission_id` bigint NOT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_role_permission
-- ----------------------------

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `employeeNumber` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '工号',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户名',
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '密码',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '姓名',
  `role` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '角色(admin/user)',
  `department` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '部门',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '电话',
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '邮箱',
  `address` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '地址',
  `position` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '职位',
  `status` int NULL DEFAULT 1 COMMENT '状态(1:启用, 0:禁用)',
  `createdAt` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `deleted` int NULL DEFAULT 0 COMMENT '逻辑删除(1:已删除, 0:未删除)',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `username`(`username` ASC) USING BTREE,
  INDEX `idx_users_username`(`username` ASC) USING BTREE,
  INDEX `idx_users_role`(`role` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 24 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES (1, NULL, 'admin', 'admin123', '系统管理员', 'admin', '信息科', '13800138000', 'admin@hospital.com', NULL, NULL, 1, '2026-05-06 10:58:47', 0);
INSERT INTO `users` VALUES (2, NULL, 'neikeshenhe', '123456', '王主任', 'dept_approver', '内科', '13900139001', 'wang_neike@hospital.com', NULL, NULL, 1, '2026-05-06 10:58:47', 0);
INSERT INTO `users` VALUES (3, NULL, 'waikehsenhe', 'dept123', '刘主任', 'dept_approver', '外科', '13900139002', 'liu_waike@hospital.com', NULL, NULL, 1, '2026-05-06 10:58:47', 0);
INSERT INTO `users` VALUES (4, NULL, 'erkehenhe', 'dept123', '陈主任', 'dept_approver', '儿科', '13900139003', 'chen_erke@hospital.com', NULL, NULL, 1, '2026-05-06 10:58:47', 0);
INSERT INTO `users` VALUES (5, NULL, 'fuchankehenhe', 'dept123', '杨主任', 'dept_approver', '妇产科', '13900139004', 'yang_fuchanke@hospital.com', NULL, NULL, 1, '2026-05-06 10:58:47', 0);
INSERT INTO `users` VALUES (6, NULL, 'yankeheneh', 'dept123', '赵主任', 'dept_approver', '眼科', '13900139005', 'zhao_yanke@hospital.com', NULL, NULL, 1, '2026-05-06 10:58:47', 0);
INSERT INTO `users` VALUES (7, NULL, 'erbihoukeheneh', 'dept123', '孙主任', 'dept_approver', '耳鼻喉科', '13900139006', 'sun_erbihouke@hospital.com', NULL, NULL, 1, '2026-05-06 10:58:47', 0);
INSERT INTO `users` VALUES (8, NULL, 'kouqiangkeheneh', 'dept123', '周主任', 'dept_approver', '口腔科', '13900139007', 'zhou_kouqiangke@hospital.com', NULL, NULL, 1, '2026-05-06 10:58:47', 0);
INSERT INTO `users` VALUES (9, NULL, 'pifukehenhe', 'dept123', '吴主任', 'dept_approver', '皮肤科', '13900139008', 'wu_pifuke@hospital.com', NULL, NULL, 1, '2026-05-06 10:58:47', 0);
INSERT INTO `users` VALUES (10, NULL, 'gukehenhe', 'dept123', '郑主任', 'dept_approver', '骨科', '13900139009', 'zheng_guke@hospital.com', NULL, NULL, 1, '2026-05-06 10:58:47', 0);
INSERT INTO `users` VALUES (11, NULL, 'shenjingkehenhe', 'dept123', '冯主任', 'dept_approver', '神经科', '13900139010', 'feng_shenjingke@hospital.com', NULL, NULL, 1, '2026-05-06 10:58:47', 0);
INSERT INTO `users` VALUES (12, NULL, 'binganshenhe1', '123456', '马管理员', 'archive_approver', '病案室', '13900139011', 'ma_bingan@hospital.com', NULL, NULL, 1, '2026-05-06 10:58:47', 0);
INSERT INTO `users` VALUES (13, NULL, 'binganshenhe2', 'archive123', '朱管理员', 'archive_approver', '病案室', '13900139012', 'zhu_bingan@hospital.com', NULL, NULL, 1, '2026-05-06 10:58:47', 0);
INSERT INTO `users` VALUES (14, NULL, 'user001', '123456', '张医生', 'user', '内科', '13900139000', 'zhang@hospital.com', NULL, NULL, 1, '2026-05-06 10:58:47', 0);
INSERT INTO `users` VALUES (15, NULL, 'user002', 'password123', '李护士', 'user', '儿科', '13700137000', 'li@hospital.com', NULL, NULL, 1, '2026-05-06 10:58:47', 0);
INSERT INTO `users` VALUES (16, NULL, 'user003', 'password123', '黄医生', 'user', '外科', '13600136000', 'huang@hospital.com', NULL, NULL, 1, '2026-05-06 10:58:47', 0);
INSERT INTO `users` VALUES (17, NULL, 'user004', 'password123', '林医生', 'user', '妇产科', '13500135000', 'lin@hospital.com', NULL, NULL, 1, '2026-05-06 10:58:47', 0);
INSERT INTO `users` VALUES (18, NULL, 'user005', 'password123', '何医生', 'user', '眼科', '13400134000', 'he@hospital.com', NULL, NULL, 1, '2026-05-06 10:58:47', 0);
INSERT INTO `users` VALUES (19, NULL, 'user006', 'password123', '高医生', 'user', '耳鼻喉科', '13300133000', 'gao@hospital.com', NULL, NULL, 1, '2026-05-06 10:58:47', 0);
INSERT INTO `users` VALUES (20, NULL, 'user007', 'password123', '罗医生', 'user', '口腔科', '13200132000', 'luo@hospital.com', NULL, NULL, 1, '2026-05-06 10:58:47', 0);
INSERT INTO `users` VALUES (21, NULL, 'user008', 'password123', '梁医生', 'user', '皮肤科', '13100131000', 'liang@hospital.com', NULL, NULL, 1, '2026-05-06 10:58:47', 0);
INSERT INTO `users` VALUES (22, NULL, 'user009', 'password123', '宋医生', 'user', '骨科', '13000130000', 'song@hospital.com', NULL, NULL, 1, '2026-05-06 10:58:47', 0);
INSERT INTO `users` VALUES (23, NULL, 'user010', 'password123', '唐医生', 'user', '神经科', '12900129000', 'tang@hospital.com', NULL, NULL, 1, '2026-05-06 10:58:47', 0);

SET FOREIGN_KEY_CHECKS = 1;
