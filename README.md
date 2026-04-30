# 病案借阅管理系统 (Medical Record Borrow Management System)

## 1. 系统概述

病案借阅管理系统是一套面向医院内部的医疗信息管理平台，基于 **RBAC（基于角色的访问控制）** 架构设计，提供完整的病案借阅申请、多级审批、借阅追踪和数据统计分析功能。系统支持管理员、科室主任和普通员工三种角色，覆盖从申请提交到归还完成的完整业务闭环。

### 1.1 技术架构

| 层级          | 技术栈                | 版本      |
| ----------- | ------------------ | ------- |
| **前端框架**    | Vue 3 + TypeScript | 3.4.0   |
| **构建工具**    | Vite               | 5.0.0   |
| **UI组件库**   | Element Plus       | 2.13.5  |
| **图表可视化**   | ECharts            | 5.4.0   |
| **状态管理**    | Vuex               | 4.1.0   |
| **路由管理**    | Vue Router         | 4.2.5   |
| **HTTP客户端** | Axios              | 1.6.0   |
| **日期处理**    | Day.js             | 1.11.10 |
| **后端框架**    | Spring Boot        | 3.2.0   |
| **ORM框架**   | MyBatis-Plus       | 3.5.7   |
| **数据持久化**   | Spring Data JPA    | -       |
| **安全框架**    | Spring Security    | -       |
| **数据库**     | MySQL              | 8.0+    |
| **连接池**     | Druid              | 1.2.20  |
| **API文档**   | SpringDoc OpenAPI  | 2.3.0   |
| **Java版本**  | JDK                | 17+     |

### 1.2 系统架构图

```
┌─────────────────────────────────────────────────────────┐
│                    前端 (Vue 3 + Vite)                    │
│  ┌──────┐ ┌──────┐ ┌──────┐ ┌──────┐ ┌──────┐ ┌──────┐ │
│  │ 登录 │ │ 看板 │ │ 借阅 │ │ 历史 │ │ 审批 │ │ 审计 │ │
│  └──┬───┘ └──┬───┘ └──┬───┘ └──┬───┘ └──┬───┘ └──┬───┘ │
│     └─────────┴────────┴────────┴────────┴────────┘    │
│                         Axios HTTP                       │
└──────────────────────────┬──────────────────────────────┘
                           │ /api
┌──────────────────────────┴──────────────────────────────┐
│              后端 (Spring Boot 3.2.0)                     │
│  ┌────────────┐  ┌────────────┐  ┌────────────┐         │
│  │ Controller │→ │  Service   │→ │   Mapper   │         │
│  │    层      │  │    层      │  │    层      │         │
│  └────────────┘  └────────────┘  └────────────┘         │
│  ┌────────────┐  ┌────────────┐  ┌────────────┐         │
│  │ Security   │  │  AOP审计   │  │  日志脱敏  │         │
│  │   配置     │  │   切面     │  │   过滤器   │         │
│  └────────────┘  └────────────┘  └────────────┘         │
└──────────────────────────┬──────────────────────────────┘
                           │ SSL/TLS
┌──────────────────────────┴──────────────────────────────┐
│                   MySQL 8.0+                              │
│  ┌──────┐ ┌──────┐ ┌──────┐ ┌──────┐ ┌──────┐          │
│  │Users │ │Records│ │Borrow│ │Audit │ │ Menus│          │
│  └──────┘ └──────┘ └──────┘ └──────┘ └──────┘          │
└─────────────────────────────────────────────────────────┘
```

***

## 2. 功能模块

### 2.1 用户认证与授权

| 功能   | 说明               | 接口                         |
| ---- | ---------------- | -------------------------- |
| 用户登录 | 用户名/密码认证，返回Token | `POST /api/users/login`    |
| 用户登出 | 记录登出审计日志         | `POST /api/users/logout`   |
| 用户注册 | 创建新用户账号          | `POST /api/users/register` |

### 2.2 数据可视化看板

- 总病案数、已借出、待审批、逾期数量统计卡片
- 借阅趋势折线图（按月/周/日）
- 借阅类型分布饼图（院内/院外）
- 科室借阅统计柱状图
- 审批效率分析

### 2.3 病案管理

| 功能   | 说明             | 接口                                     |
| ---- | -------------- | -------------------------------------- |
| 病案列表 | 分页查询所有病案       | `GET /api/medical-records/list`        |
| 条件检索 | 按病案号/患者名/科室/状态 | `POST /api/medical-records/search`     |
| 新增病案 | 录入新病案信息        | `POST /api/medical-records/create`     |
| 编辑病案 | 更新病案信息         | `PUT /api/medical-records/update`      |
| 删除病案 | 单个/批量删除        | `DELETE /api/medical-records/{id}`     |
| 状态管理 | 更新病案借阅状态       | `PUT /api/medical-records/{id}/status` |

### 2.4 借阅申请

| 功能   | 说明          | 接口                                           |
| ---- | ----------- | -------------------------------------------- |
| 提交申请 | 选择病案、填写借阅信息 | `POST /api/borrow-applications/create`       |
| 取消申请 | 取消待审批的申请    | `PUT /api/borrow-applications/{id}/cancel`   |
| 取件操作 | 确认领取病案      | `PUT /api/borrow-applications/{id}/pickup`   |
| 归还操作 | 归还已取件病案     | `PUT /api/borrow-applications/{id}/complete` |

### 2.5 多级审批流程

系统支持**两级审批**机制：

```
普通员工提交申请
       │
       ▼
科室主任审批（一级）
  ┌────┴────┐
  │ 通过    │ 驳回
  ▼         ▼
病案科主任  退回申请人
终审（二级）
  ┌────┴────┐
  │ 通过    │ 驳回
  ▼         ▼
可取件     退回申请人
```

**特殊规则**：

- 病案科主任提交申请 → 自动审批通过（跳过科室审批）
- 科室主任只能审批本科室的申请
- 支持批量审批/驳回

| 功能   | 说明        | 接口                                               |
| ---- | --------- | ------------------------------------------------ |
| 科室审批 | 科室主任一级审批  | `PUT /api/borrow-applications/{id}/dept-approve` |
| 科室驳回 | 科室主任一级驳回  | `PUT /api/borrow-applications/{id}/dept-reject`  |
| 终审通过 | 病案科主任二级审批 | `PUT /api/borrow-applications/{id}/approve`      |
| 终审驳回 | 病案科主任二级驳回 | `PUT /api/borrow-applications/{id}/reject`       |
| 批量审批 | 批量通过/驳回   | `PUT /api/borrow-applications/batch-approve`     |

### 2.6 审计日志

| 功能    | 说明                     | 接口                                           |
| ----- | ---------------------- | -------------------------------------------- |
| 分页查询  | 支持按用户/操作/时间筛选          | `GET /api/audit-logs`                        |
| 按用户查询 | 查看指定用户操作记录             | `GET /api/audit-logs/by-username/{username}` |
| 按模块查询 | 按Auth/Borrow/Record等模块 | `GET /api/audit-logs/by-module/{module}`     |
| 按时间范围 | 查看指定时间段操作              | `GET /api/audit-logs/by-time-range`          |

**审计覆盖的操作类型**：

| 模块     | 操作                                                                                                                                          |
| ------ | ------------------------------------------------------------------------------------------------------------------------------------------- |
| Auth   | LOGIN, LOGOUT                                                                                                                               |
| Borrow | BORROW\_APPLY, BORROW\_APPROVE, BORROW\_REJECT, BORROW\_DEPT\_APPROVE, BORROW\_DEPT\_REJECT, BORROW\_CANCEL, BORROW\_PICKUP, BORROW\_RETURN |
| Record | RECORD\_CREATE, RECORD\_UPDATE, RECORD\_DELETE, RECORD\_STATUS                                                                              |
| User   | USER\_REGISTER, USER\_UPDATE, USER\_PASSWORD\_RESET, USER\_STATUS, USER\_DELETE                                                             |

### 2.7 用户管理（管理员）

| 功能   | 说明         | 接口                              |
| ---- | ---------- | ------------------------------- |
| 用户列表 | 查看所有用户     | `GET /api/users/list`           |
| 状态管理 | 启用/禁用用户    | `PUT /api/users/{id}/status`    |
| 密码重置 | 重置用户密码     | `PUT /api/users/reset-password` |
| 删除用户 | 删除无借阅记录的用户 | `DELETE /api/users/{id}`        |
| 批量状态 | 批量启用/禁用    | `PUT /api/users/batch-status`   |

### 2.8 统计分析

| 功能   | 说明          | 接口                                              |
| ---- | ----------- | ----------------------------------------------- |
| 用户统计 | 个人/全局数据概览   | `GET /api/statistics/user-stats`                |
| 图表数据 | 趋势/分布/科室统计  | `GET /api/statistics/chart-stats`               |
| 病案状态 | 可借阅/已借出/已归档 | `GET /api/statistics/medical-record-status`     |
| 借阅状态 | 各状态申请数量     | `GET /api/statistics/borrow-application-status` |
| 科室统计 | 各科室借阅数量     | `GET /api/statistics/department-borrow`         |
| 借阅趋势 | 按月借阅趋势      | `GET /api/statistics/borrow-trend`              |
| 审批效率 | 审批耗时分析      | `GET /api/statistics/approval-efficiency`       |

***

## 3. 用户角色与权限

### 3.1 角色定义

| 角色        | role值           | 权限范围                 |
| --------- | --------------- | -------------------- |
| **系统管理员** | `admin`         | 全部功能：用户管理、审批、审计日志、统计 |
| **科室主任**  | `dept_director` | 本科室审批、借阅申请、查看统计      |
| **普通员工**  | `employee`      | 借阅申请、个人借阅历史、个人统计     |

### 3.2 页面访问权限

| 页面   | 管理员  | 科室主任     | 普通员工  |
| ---- | ---- | -------- | ----- |
| 数据看板 | ✅    | ✅        | ✅     |
| 借阅申请 | ✅    | ✅        | ✅     |
| 借阅历史 | ✅ 全部 | ✅ 本科室+本人 | ✅ 仅本人 |
| 审批管理 | ✅ 全部 | ✅ 本科室    | ❌     |
| 用户管理 | ✅    | ❌        | ❌     |
| 审计日志 | ✅    | ❌        | ❌     |

### 3.3 默认账号

| 角色    | 用户名     | 密码         | 工号   |
| ----- | ------- | ---------- | ---- |
| 系统管理员 | `admin` | `admin123` | E001 |

> ⚠️ **安全提示**：首次部署后请立即修改默认管理员密码。

***

## 4. 项目结构

```
medical-record-system/
├── backend/                          # 后端 Spring Boot 项目
│   ├── src/main/java/com/medical/record/system/
│   │   ├── config/                   # 配置类
│   │   │   ├── ActuatorSecurityConfig.java    # Actuator安全配置
│   │   │   ├── AuditLogTableInitializer.java  # 审计日志表初始化
│   │   │   ├── BorrowApplicationTableInitializer.java # 借阅申请表初始化
│   │   │   ├── IpWhitelistFilter.java         # IP白名单过滤器
│   │   │   ├── LogDesensitizationFilter.java  # 日志脱敏过滤器
│   │   │   ├── OperationLog.java              # 操作日志注解
│   │   │   ├── OperationLogAspect.java        # 操作日志切面
│   │   │   ├── SecurityConfig.java            # Spring Security配置
│   │   │   └── UserTableInitializer.java      # 用户表初始化
│   │   ├── controller/               # 控制器层
│   │   │   ├── AuditLogController.java
│   │   │   ├── BorrowApplicationController.java
│   │   │   ├── MedicalRecordController.java
│   │   │   ├── MenuController.java
│   │   │   ├── RoleController.java
│   │   │   ├── StatisticsController.java
│   │   │   └── UserController.java
│   │   ├── entity/                   # 实体类
│   │   ├── mapper/                   # MyBatis Mapper接口
│   │   └── service/                  # 服务层（含impl子目录）
│   ├── src/main/resources/
│   │   ├── mapper/                   # MyBatis XML映射文件
│   │   ├── application.yml           # 应用配置文件
│   │   └── logback-spring.xml        # 日志框架配置
│   ├── ssl/                          # SSL证书文件
│   │   ├── ca.pem / ca-key.pem       # CA根证书
│   │   ├── server-cert.pem / server-key.pem  # 服务器证书
│   │   └── client-cert.pem / client-key.pem  # 客户端证书
│   └── pom.xml                       # Maven依赖配置
│
├── frontend/                         # 前端 Vue 3 项目
│   ├── src/
│   │   ├── api/request.ts            # Axios请求封装
│   │   ├── components/Layout/        # 布局组件
│   │   ├── router/index.ts           # 路由配置
│   │   ├── store/index.ts            # Vuex状态管理
│   │   ├── views/
│   │   │   ├── Login.vue             # 登录页
│   │   │   ├── Dashboard.vue         # 数据看板
│   │   │   ├── Borrow/index.vue      # 借阅申请
│   │   │   ├── BorrowHistory.vue     # 借阅历史
│   │   │   ├── Review.vue            # 审批管理
│   │   │   ├── Users.vue             # 用户管理
│   │   │   └── AuditLogs.vue         # 审计日志
│   │   └── main.ts                   # 应用入口
│   ├── vite.config.ts                # Vite构建配置
│   └── package.json                  # NPM依赖配置
│
├── seed_100_medical_records_mysql.sql # 初始病案数据脚本
├── Dump20260430.sql                  # 数据库完整备份
└── README.md                         # 本文档
```

***

## 5. 环境配置要求

### 5.1 运行环境

| 组件      | 最低版本 | 推荐版本 |
| ------- | ---- | ---- |
| JDK     | 17   | 17+  |
| Maven   | 3.6  | 3.9+ |
| MySQL   | 8.0  | 8.0+ |
| Node.js | 16   | 18+  |
| npm     | 8    | 9+   |

### 5.2 数据库配置

系统默认使用 MySQL 数据库，连接参数配置于 `backend/src/main/resources/application.yml`：

```yaml
spring:
  datasource:
    driver-class-name: com.mysql.cj.jdbc.Driver
    url: jdbc:mysql://localhost:3306/MedicalRecordDB?useUnicode=true&characterEncoding=utf-8&useSSL=false&serverTimezone=Asia/Shanghai&allowPublicKeyRetrieval=true
    username: root
    password: 123456
```

<br />

***

## 6. 部署与启动

### 6.1 开发环境启动

#### 步骤一：启动后端服务

```bash
cd medical-record-system/backend
mvn spring-boot:run
```

启动成功标志：控制台输出 `Started MedicalRecordSystemApplication`

#### 步骤二：启动前端服务

```bash
cd medical-record-system/frontend
npm install
npm run dev
```

启动成功标志：终端显示 `http://localhost:3000`

#### 步骤三：访问系统

浏览器打开 `http://localhost:3000`，使用默认账号登录。

### 6.2 生产环境部署

#### 前端构建

```bash
cd medical-record-system/frontend
npm run build
```

构建产物自动输出到 `backend/src/main/resources/static/` 目录。

#### 后端打包

```bash
cd medical-record-system/backend
mvn clean package -DskipTests
```

生成可执行JAR：`backend/target/medical-record-system-1.0.0.jar`

#### 启动生产服务

```bash
java -jar medical-record-system-1.0.0.jar --spring.profiles.active=prod
```

### 6.3 系统访问地址

| 服务    | 地址                                          |
| ----- | ------------------------------------------- |
| 前端应用  | <http://localhost:3000>                     |
| 后端API | <http://localhost:8080/api>                 |
| API文档 | <http://localhost:8080/api/swagger-ui.html> |

***

***

***

## 7. 版本历史

### v1.0.0 (2026-04-30)

**系统架构调整**：

- 数据库从 SQL Server 迁移至 MySQL 8.0
- 更新Hibernate方言为 `MySQLDialect`
- 更新JDBC驱动为 `com.mysql.cj.jdbc.Driver`
- 修正所有Mapper XML和实体类的表名/字段名映射

**新增功能模块**：

- 审计日志模块：支持分页查询、多维筛选、操作追踪
- 多级审批流程：科室主任一级审批 + 病案科主任终审
- 数据可视化看板：ECharts图表、实时统计卡片
- IP白名单过滤器：Actuator端点访问控制

**前端交互优化**：

- 借阅申请表单验证增强
- 审计日志时间格式修复（dayjs格式化）
- 路由守卫权限控制完善
- Vite构建优化：手动分包（vendor拆分）

***

## 8. 常见问题

### Q1: 启动后端报数据库连接错误

检查MySQL服务是否启动，以及 `application.yml` 中的连接参数是否正确：

```bash
# 验证MySQL连接
mysql -u root -p123456 -e "SELECT 1"
```

### Q2: 前端页面空白

确认后端服务已启动且API可访问，检查浏览器控制台是否有跨域错误。

### Q3: 借阅申请提交后无响应

检查后端日志是否有SQL错误，确认数据库表结构完整。

### Q4: 审计日志页面无数据

确认 `audit_logs` 表中存在数据，检查Mapper XML中的查询条件。

### Q5: 如何修改管理员密码

登录系统后，通过用户管理模块的"重置密码"功能修改。

***

**文档版本**: 2.0\
**更新日期**: 2026-04-30\
**适用系统版本**: v1.0.0
