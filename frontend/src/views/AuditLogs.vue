<template>
  <div class="audit-logs-container">
    <el-card class="audit-logs-card">
      <template #header>
        <div class="card-header">
          <span>审计日志</span>
        </div>
      </template>
      
      <div class="toolbar">
        <el-form :inline="true" :model="searchForm" class="search-form" :class="{ 'search-form-mobile': isMobile }">
          <el-form-item label="操作人">
            <el-input v-model="searchForm.username" placeholder="请输入操作人" />
          </el-form-item>
          <el-form-item label="操作类型">
            <el-select v-model="searchForm.operationType" placeholder="请选择操作类型" style="width: 200px">
              <el-option label="登录" value="login" />
              <el-option label="登出" value="logout" />
              <el-option label="注册" value="register" />
              <el-option label="创建" value="create" />
              <el-option label="更新" value="update" />
              <el-option label="删除" value="delete" />
              <el-option label="审批" value="approve" />
              <el-option label="驳回" value="reject" />
              <el-option label="科室审批" value="deptApprove" />
              <el-option label="科室驳回" value="deptReject" />
              <el-option label="病案室审批" value="archiveApprove" />
              <el-option label="病案室驳回" value="archiveReject" />
              <el-option label="取消" value="cancel" />
              <el-option label="重置密码" value="resetPassword" />
              <el-option label="修改状态" value="updateStatus" />
              <el-option label="批量修改状态" value="batchStatus" />
              <el-option label="完成" value="complete" />
              <el-option label="取件" value="pickup" />
            </el-select>
          </el-form-item>
          <el-form-item label="操作时间">
            <el-date-picker
              v-model="dateRange"
              type="daterange"
              range-separator="至"
              start-placeholder="开始日期"
              end-placeholder="结束日期"
              style="width: 200px"
            />
          </el-form-item>
          <el-form-item>
            <el-button type="primary" @click="search">查询</el-button>
            <el-button @click="reset">重置</el-button>
          </el-form-item>
        </el-form>

        <div v-if="isMobile" class="view-toggle">
          <el-button size="small" @click="useTableView = !useTableView">
            {{ useTableView ? '卡片视图' : '表格视图' }}
          </el-button>
        </div>
      </div>

      <div v-if="!isMobile || (isMobile && useTableView)" class="table-wrapper">
        <el-table
          :data="auditLogs"
          style="width: 100%"
          border
          height="100%"
          scrollbar-always-on
          :class="{ 'show-on-mobile': isMobile && useTableView }"
        >
          <el-table-column prop="id" label="ID" width="70" />
          <el-table-column prop="username" label="操作人" width="100" />
          <el-table-column prop="module" label="模块" width="80">
            <template #default="scope">
              {{ getModuleName(scope.row.module) }}
            </template>
          </el-table-column>
          <el-table-column prop="operation" label="操作类型" width="120">
            <template #default="scope">
              {{ getOperationName(scope.row.operation) }}
            </template>
          </el-table-column>
          <el-table-column prop="details" label="操作详情" min-width="120" show-overflow-tooltip />
          <el-table-column prop="ip" label="IP地址" width="130" />
          <el-table-column prop="status" label="状态" width="70">
            <template #default="scope">
              <el-tag :type="scope.row.status === 1 ? 'success' : 'danger'" size="small">
                {{ scope.row.status === 1 ? '成功' : '失败' }}
              </el-tag>
            </template>
          </el-table-column>
          <el-table-column prop="createdTime" label="操作时间" width="160">
            <template #default="scope">
              {{ formatDate(scope.row.createdTime) }}
            </template>
          </el-table-column>
        </el-table>
      </div>

      <!-- 移动端卡片布局 -->
      <div v-else class="mobile-card-list">
        <div v-for="row in auditLogs" :key="row.id" class="mobile-card">
          <div class="mobile-card-header">
            <span class="mobile-card-id">#{{ row.id }}</span>
            <el-tag :type="row.status === 1 ? 'success' : 'danger'" size="small">
              {{ row.status === 1 ? '成功' : '失败' }}
            </el-tag>
          </div>
          <div class="mobile-card-body">
            <div class="mobile-card-item">
              <span class="mobile-label">操作人：</span>
              <span class="mobile-value">{{ row.username || '-' }}</span>
            </div>
            <div class="mobile-card-item">
              <span class="mobile-label">模块：</span>
              <span class="mobile-value">{{ getModuleName(row.module) }}</span>
            </div>
            <div class="mobile-card-item">
              <span class="mobile-label">操作类型：</span>
              <span class="mobile-value">{{ getOperationName(row.operation) }}</span>
            </div>
            <div class="mobile-card-item">
              <span class="mobile-label">操作详情：</span>
              <span class="mobile-value mobile-value-break" :title="row.details">{{ row.details || '-' }}</span>
            </div>
            <div class="mobile-card-item">
              <span class="mobile-label">IP地址：</span>
              <span class="mobile-value">{{ row.ip || '-' }}</span>
            </div>
            <div class="mobile-card-item">
              <span class="mobile-label">操作时间：</span>
              <span class="mobile-value">{{ formatDate(row.createdTime) }}</span>
            </div>
          </div>
        </div>
      </div>
    </el-card>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import service from '../api/request'
import dayjs from 'dayjs'

const auditLogs = ref<any[]>([])
const searchForm = ref({
  username: '',
  operationType: '',
  startTime: '',
  endTime: ''
})
const dateRange = ref<[string, string] | null>(null)
const isMobile = ref(false)
const useTableView = ref(false)

const checkMobile = () => {
  isMobile.value = window.innerWidth <= 768
  if (!isMobile.value) {
    useTableView.value = false
  }
}

const formatDate = (date: string) => {
  if (!date) return '-'
  const d = dayjs(date)
  if (!d.isValid()) return date
  return d.format('YYYY-MM-DD HH:mm:ss')
}

const operationMap: Record<string, string> = {
  login: '登录',
  logout: '登出',
  register: '注册',
  update: '更新',
  resetPassword: '重置密码',
  batchStatus: '批量修改状态',
  updateStatus: '修改状态',
  delete: '删除',
  create: '创建',
  deptApprove: '科室审批',
  deptReject: '科室驳回',
  archiveApprove: '病案室审批',
  archiveReject: '病案室驳回',
  approve: '审批',
  reject: '驳回',
  cancel: '取消',
  pickup: '取件',
  complete: '完成',
  batchDeptApprove: '批量科室审批',
  batchArchiveApprove: '批量病案室审批',
  batchApprove: '批量审批',
  batchReject: '批量驳回',
  batchDelete: '批量删除',
  LOGOUT: '登出',
  LOGIN: '登录'
}

const moduleMap: Record<string, string> = {
  Auth: '认证',
  User: '用户管理',
  Borrow: '借阅管理',
  MedicalRecord: '病历管理',
  Record: '病历管理'
}

const getOperationName = (operation: string) => {
  if (!operation) return '-'
  return operationMap[operation] || operationMap[operation.toLowerCase()] || operationMap[operation.toUpperCase()] || operation
}

const getModuleName = (module: string) => {
  return moduleMap[module] || module
}

const loadAuditLogs = async () => {
  try {
    const params: any = {
      page: 1,
      pageSize: 99999
    }
    if (searchForm.value.username) {
      params.username = searchForm.value.username
    }
    if (searchForm.value.operationType) {
      params.operationType = searchForm.value.operationType
    }
    if (searchForm.value.startTime) {
      params.startTime = searchForm.value.startTime
    }
    if (searchForm.value.endTime) {
      params.endTime = searchForm.value.endTime
    }
    const response: any = await service.get('/audit-logs', { params })
    auditLogs.value = response?.records || []
  } catch (error) {
    console.error('获取审计日志失败:', error)
  }
}

const search = () => {
  if (dateRange.value && dateRange.value.length === 2) {
    searchForm.value.startTime = dateRange.value[0] + ' 00:00:00'
    searchForm.value.endTime = dateRange.value[1] + ' 23:59:59'
  } else {
    searchForm.value.startTime = ''
    searchForm.value.endTime = ''
  }
  loadAuditLogs()
}

const reset = () => {
  searchForm.value = {
    username: '',
    operationType: '',
    startTime: '',
    endTime: ''
  }
  dateRange.value = null
  loadAuditLogs()
}

onMounted(() => {
  checkMobile()
  window.addEventListener('resize', checkMobile)
  loadAuditLogs()
})
</script>

<style scoped>
.audit-logs-container {
  padding: 20px;
  height: calc(100vh - 64px);
  display: flex;
  flex-direction: column;
  overflow: hidden;
}

.audit-logs-card {
  flex: 1;
  display: flex;
  flex-direction: column;
  margin-bottom: 24px;
  background: rgba(255, 255, 255, 0.75) !important;
  backdrop-filter: blur(20px) saturate(180%) !important;
  border: 1px solid rgba(255, 255, 255, 0.5) !important;
  border-radius: 24px !important;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.08) !important;
}

.audit-logs-card :deep(.el-card__body) {
  flex: 1;
  display: flex;
  flex-direction: column;
  min-height: 0;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-size: 18px;
  font-weight: 600;
  color: #1D1D1F;
}

.toolbar {
  flex-shrink: 0;
}

.search-form {
  margin-bottom: 16px;
}

.search-form-mobile {
  display: flex;
  flex-direction: column;
  align-items: stretch;
}

.search-form-mobile .el-form-item {
  margin-right: 0;
  margin-bottom: 12px;
  width: 100%;
}

.search-form-mobile .el-form-item__content {
  width: 100%;
}

.search-form-mobile .el-select,
.search-form-mobile .el-date-editor {
  width: 100% !important;
}

.table-wrapper {
  flex: 1;
  overflow: hidden;
  display: flex;
  flex-direction: column;
}

.table-wrapper :deep(.el-table) {
  flex: 1;
  height: 100%;
}

.table-wrapper :deep(.el-table__body-wrapper) {
  overflow-y: auto !important;
}

.view-toggle {
  display: flex;
  justify-content: flex-end;
  margin-bottom: 12px;
}

.mobile-card-list {
  display: flex;
  flex-direction: column;
  gap: 14px;
  padding: 4px 0;
  overflow-y: auto;
  flex: 1;
}

.mobile-card {
  background: linear-gradient(135deg, rgba(255, 255, 255, 0.85) 0%, rgba(255, 255, 255, 0.7) 100%);
  backdrop-filter: blur(10px);
  border-radius: 16px;
  border: 1px solid rgba(255, 255, 255, 0.5);
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.06);
  overflow: hidden;
  transition: all 0.2s ease-out;
}

.mobile-card:active {
  transform: scale(0.99);
}

.mobile-card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 12px 14px;
  background: linear-gradient(135deg, #007AFF 0%, #5AC8FA 100%);
  color: white;
}

.mobile-card-id {
  font-weight: 600;
  font-size: 14px;
}

.mobile-card-body {
  padding: 14px;
}

.mobile-card-item {
  display: flex;
  margin-bottom: 10px;
  align-items: flex-start;
  padding-bottom: 10px;
  border-bottom: 1px solid rgba(0, 0, 0, 0.06);
}

.mobile-card-item:last-child {
  margin-bottom: 0;
  padding-bottom: 0;
  border-bottom: none;
}

.mobile-label {
  font-weight: 500;
  color: #86868B;
  font-size: 13px;
  min-width: 80px;
  flex-shrink: 0;
}

.mobile-value {
  flex: 1;
  color: #1D1D1F;
  word-break: break-word;
  font-size: 14px;
  line-height: 1.5;
}

.mobile-value-break {
  word-break: break-all;
  overflow-wrap: break-word;
  hyphens: auto;
}

@media (max-width: 768px) {
  .audit-logs-container {
    padding: 10px;
  }

  .search-form {
    display: none;
  }

  .search-form-mobile {
    display: flex;
  }

  .el-table {
    display: none;
  }

  .el-table.show-on-mobile {
    display: table;
  }

  .mobile-label {
    min-width: 70px;
    font-size: 12px;
  }

  .mobile-value {
    font-size: 13px;
  }
}

@media (max-width: 480px) {
  .audit-logs-container {
    padding: 8px;
  }

  .card-header {
    font-size: 16px;
  }

  .mobile-card-header {
    padding: 10px 12px;
  }

  .mobile-card-body {
    padding: 12px;
  }

  .mobile-label {
    min-width: 60px;
    font-size: 11px;
  }

  .mobile-value {
    font-size: 12px;
  }

  .mobile-card-item {
    margin-bottom: 8px;
    padding-bottom: 8px;
  }
}
</style>