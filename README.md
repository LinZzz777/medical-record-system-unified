# 病案借阅管理系统

## 目录

1. [系统概述](#系统概述)
2. [环境要求](#环境要求)
3. [数据库配置](#数据库配置)
4. [系统启动](#系统启动)
5. [系统登录](#系统登录)
6. [角色说明](#角色说明)
7. [功能模块](#功能模块)
8. [操作流程](#操作流程)
9. [常见问题](#常见问题)
10. [技术支持](#技术支持)

***

## 系统概述

病案借阅管理系统是一个用于医院病案管理的Web应用系统，支持病案检索、借阅申请、多级审批、借阅历史跟踪等功能。

**系统特点：**

- 支持三级审批流程（科室审批 → 病案室审批）
- 提供病案状态实时跟踪
- 支持院内/院外两种借阅类型
- 完整的审计日志记录

**技术架构：**

- 前端：Vue 3 + Element Plus + TypeScript
- 后端：Spring Boot + MyBatis-Plus
- 数据库：MySQL 8.0+

***

## 环境要求

**后端：**

- JDK 17+
- Maven 3.6+
- MySQL 8.0+

**前端：**

- Node.js 16+
- npm 8+

***

## 数据库配置

首先删除之前创建的数据库，然后执行SQL文件进行初始化。

**访问地址：**

- 前端地址：[http://localhost:3000](http://localhost:5173)
- 后端API：<http://localhost:8080/api>

***

## 系统启动

数据库准备

```MySQL
将medicalrecorddb.sql导入MYSQL数据库
```

### 启动后端服务

1. 打开终端，进入后端目录
2. 启动Spring Boot服务：
   ```bash
   mvn spring-boot:run
   ```
3. 等待服务启动完成，控制台显示"Started MedicalRecordSystemApplication"即表示启动成功

### 启动前端服务

1. 打开新的终端，进入前端目录
2. 启动Vue开发服务器：
   ```bash
   npm run dev
   ```
3. 等待服务启动完成，终端会显示访问地址（通常是 <http://localhost:5173）>

### 端口占用处理

Windows系统查找占用端口的进程：

```bash
netstat -ano | findstr :8080
```

终止占用端口的进程（将1234替换为实际PID）：

```bash
taskkill /F /PID 1234
```

***

## 系统登录

### 登录步骤

1. 打开浏览器，访问前端地址
2. 在登录页面输入用户名和密码
3. 点击"登录"按钮
4. 登录成功后进入系统主界面

### 注意事项

- 首次使用请修改默认密码
- 连续输错密码可能导致账户锁定
- 长时间无操作会自动退出登录

***

## 角色说明

系统包含四种用户角色，每种角色有不同的权限：

### 1. 系统管理员 (admin)

**权限：**

- 查看所有借阅申请
- 执行所有审批操作
- 管理用户账户
- 查看审计日志
- 系统配置管理

### 2. 科室审批员 (dept\_approver)

**权限：**

- 查看本科室的待审批申请
- 审批/驳回本科室的借阅申请
- 查看审批历史记录

### 3. 病案室审批员 (archive\_approver)

**权限：**

- 查看所有待病案室审批的申请
- 审批/驳回病案室阶段的申请
- 管理病案归档状态

### 4. 普通用户 (user)

**权限：**

- 检索和浏览病案
- 提交借阅申请
- 查看自己的借阅历史
- 取消待审批的申请
- 确认取件和归还

***

## 功能模块

### 1. 仪表盘 (Dashboard)

**功能说明：**

- 显示系统统计数据
- 展示借阅申请趋势图表
- 显示待处理事项提醒

**主要指标：**

- 总病案数
- 待审批申请数
- 今日新增申请
- 逾期归还数

### 2. 病案检索与借阅申请

**功能说明：**

- 通过病案号、患者姓名、科室检索病案
- 查看病案详细信息
- 填写并提交借阅申请

**检索条件：**

- 病案号：精确匹配
- 患者姓名：模糊匹配
- 科室：下拉选择

**病案状态说明：**

- **可借阅**：病案可用，可以申请借阅
- **已借出**：病案已被借出，暂时不可用
- **已归档**：病案已归档，需要特殊权限才能调阅

**申请流程：**

1. **步骤1 - 病案检索**：输入检索条件，选择需要的病案
2. **步骤2 - 查看详情**：确认所选病案信息
3. **步骤3 - 填写申请**：填写借阅类型、原因、预计归还日期
4. **步骤4 - 提交申请**：确认信息后提交

**借阅类型：**

- **院内借阅**：医院内部人员借阅
- **院外借阅**：外部机构或人员借阅

### 3. 借阅历史与状态跟踪

**功能说明：**

- 查看所有借阅申请列表
- 跟踪申请审批状态
- 执行相关操作（审批、取件、归还等）

**申请状态流转：**

```
提交申请 → 待科室审批 → 待病案室审批 → 已批准 → 已取件 → 已完成
                ↓              ↓
            已驳回         已驳回
```

**状态说明：**

- **待科室审批** (pending\_dept)：等待科室审批员审批
- **待病案室审批** (pending\_archive)：科室已通过，等待病案室审批
- **已批准** (approved)：审批通过，可以取件
- **已驳回** (rejected)：申请被驳回，可查看驳回原因
- **已取件** (picked)：已取走病案，需按时归还
- **已完成** (completed)：病案已归还
- **已取消** (cancelled)：申请人主动取消
- **已逾期** (overdue)：超过预计归还日期未归还

**筛选功能：**

- 按状态筛选
- 按借阅类型筛选
- 按申请时间筛选
- 按预计归还日期筛选

### 4. 用户管理 (仅管理员)

**功能说明：**

- 查看系统所有用户
- 添加新用户
- 编辑用户信息
- 禁用/启用用户账户

**用户字段：**

- 工号
- 用户名
- 姓名
- 角色
- 部门
- 电话
- 邮箱
- 职位
- 状态

### 5. 审计日志 (仅管理员)

**功能说明：**

- 记录所有用户操作
- 查看操作历史记录
- 追踪异常行为

**记录内容：**

- 操作用户
- 操作类型
- 操作模块
- IP地址
- 操作时间
- 操作结果

***

## 操作流程

### 普通用户：提交借阅申请

1. **登录系统**
   - 使用普通用户账户登录
2. **进入借阅申请页面**
   - 点击左侧菜单"借阅申请"
3. **检索病案**
   - 输入病案号、患者姓名或选择科室
   - 点击"查询"按钮
   - 从结果中选择需要的病案（只能选择"可借阅"状态的病案）
4. **查看详情**
   - 确认所选病案信息是否正确
   - 点击"下一步"
5. **填写申请信息**
   - 选择借阅类型（院内借阅/院外借阅）
   - 填写借阅原因（至少10个字符）
   - 选择预计归还日期（不能早于今天）
6. **提交申请**
   - 确认申请信息汇总
   - 点击"提交申请"
   - 等待审批
7. **查看审批状态**
   - 进入"借阅历史"页面
   - 查看申请的当前状态
   - 根据状态执行相应操作
8. **取件**
   - 当状态变为"已批准"时
   - 点击"取件"按钮确认取件
9. **归还**
   - 使用完毕后
   - 点击"归还"按钮确认归还

### 科室审批员：审批申请

1. **登录系统**
   - 使用科室审批员账户登录
2. **查看待审批申请**
   - 进入"借阅历史"页面
   - 系统自动显示本科室待审批的申请
3. **审批操作**
   - 查看申请详情（病案信息、借阅原因等）
   - 点击"科室同意"批准申请
   - 或点击"驳回"并填写驳回原因
4. **查看审批结果**
   - 审批通过后，申请进入病案室审批阶段
   - 驳回后，申请状态变为"已驳回"

### 病案室审批员：审批申请

1. **登录系统**
   - 使用病案室审批员账户登录
2. **查看待审批申请**
   - 进入"借阅历史"页面
   - 系统显示所有待病案室审批的申请
3. **审批操作**
   - 查看申请详情
   - 点击"病案室同意"批准申请
   - 或点击"驳回"并填写驳回原因
4. **审批完成**
   - 审批通过后，申请人可以取件
   - 驳回后，申请状态变为"已驳回"

### 管理员：系统管理

1. **用户管理**
   - 进入"用户管理"页面
   - 可以添加、编辑、删除用户
   - 可以禁用/启用用户账户
2. **审计日志**
   - 进入"审计日志"页面
   - 查看所有用户操作记录
   - 可按条件筛选日志
3. **全局审批**
   - 可以执行所有审批操作
   - 处理特殊情况

***

## 常见问题

### Q1: 为什么有些病案无法选择？

**A:** 只有状态为"可借阅"的病案才能被选择。"已借出"和"已归档"的病案暂时不可借阅。

### Q2: 如何取消已提交的申请？

**A:** 在"借阅历史"页面，找到状态为"待科室审批"或"待病案室审批"的申请，点击"取消"按钮即可。

### Q3: 申请被驳回了怎么办？

**A:** 查看驳回原因，修改申请内容后重新提交新的申请。

### Q4: 逾期未归还有什么后果？

**A:** 逾期状态会显示为红色警告，可能影响后续借阅权限。请尽快归还病案。

### Q5: 如何修改个人信息？

**A:** 联系系统管理员进行修改。

### Q6: 忘记密码怎么办？

**A:** 联系系统管理员重置密码。

### Q7: 一次可以申请多份病案吗？

**A:** 可以，在检索结果中选择多份病案后一起提交申请。

### Q8: 预计归还日期可以修改吗？

**A:** 申请提交后无法修改。如需延长借阅时间，请联系病案室。

### Q9: 如何查看审批进度？

**A:** 在"借阅历史"页面点击"详情"按钮，可以看到完整的状态流转时间线。

### Q10: 系统支持哪些浏览器？

**A:** 推荐使用 Chrome、Firefox、Edge 等现代浏览器。不支持 IE11 及以下版本。

***

## 技术支持

如有技术问题，请联系系统管理员：

- 用户名：admin
- 部门：信息科
- 电话：13800138000
- 邮箱：<admin@hospital.com>

***

*文档版本：v1.0*
*更新日期：2026-05-05*
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
