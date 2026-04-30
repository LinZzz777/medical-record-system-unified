<template>
  <div class="audit-logs-container">
    <div class="page-header">
      <div>
        <h1 class="page-title">审计日志</h1>
        <p class="page-subtitle">系统操作记录，支持按时间和类型筛选</p>
      </div>
    </div>

    <el-card class="audit-card" :body-style="{ padding: '24px' }">
      <!-- Search -->
      <el-form :inline="true" :model="searchForm" class="search-form">
        <el-form-item label="操作人">
          <el-input v-model="searchForm.username" placeholder="请输入操作人" clearable />
        </el-form-item>
        <el-form-item label="操作类型">
          <el-select v-model="searchForm.operationType" placeholder="请选择操作类型" clearable style="width: 140px">
            <el-option label="登录" value="LOGIN" />
            <el-option label="登出" value="LOGOUT" />
            <el-option label="借阅相关" value="BORROW" />
            <el-option label="用户管理" value="USER" />
            <el-option label="病案管理" value="RECORD" />
          </el-select>
        </el-form-item>
        <el-form-item label="操作时间">
          <el-date-picker
            v-model="dateRange"
            type="datetimerange"
            range-separator="至"
            start-placeholder="开始时间"
            end-placeholder="结束时间"
            format="YYYY-MM-DD HH:mm:ss"
            value-format="YYYY-MM-DD HH:mm:ss"
            :default-time="[new Date(2000, 1, 1, 0, 0, 0), new Date(2000, 1, 1, 23, 59, 59)]"
            style="width: 380px"
          />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="search">查询</el-button>
          <el-button @click="reset">重置</el-button>
        </el-form-item>
      </el-form>

      <!-- Table -->
      <el-table :data="auditLogs" style="width: 100%" border class="data-table">
        <el-table-column prop="id" label="ID" width="70" />
        <el-table-column prop="username" label="操作人" width="110" />
        <el-table-column prop="operation" label="操作类型" width="140">
          <template #default="scope">
            <el-tag :type="getOperationTagType(scope.row.operation)" effect="dark" size="small">
              {{ getOperationLabel(scope.row.operation) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="details" label="操作描述" min-width="200" show-overflow-tooltip />
        <el-table-column prop="ip" label="IP地址" width="140" />
        <el-table-column prop="userAgent" label="用户代理" width="180" show-overflow-tooltip />
        <el-table-column prop="createdTime" label="操作时间" width="170">
          <template #default="scope">
            {{ formatDate(scope.row.createdTime) }}
          </template>
        </el-table-column>
      </el-table>

      <!-- Pagination -->
      <div class="pagination-container">
        <el-pagination
          v-model:current-page="currentPage"
          v-model:page-size="pageSize"
          :page-sizes="[10, 20, 50, 100]"
          layout="total, sizes, prev, pager, next, jumper"
          :total="total"
          @size-change="handleSizeChange"
          @current-change="handleCurrentChange"
        />
      </div>
    </el-card>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import service from '../api/request'
import dayjs from 'dayjs'

const auditLogs = ref<any[]>([])
const currentPage = ref(1)
const pageSize = ref(10)
const total = ref(0)
const searchForm = ref({ username: '', operationType: '' })
const todayStart = dayjs().startOf('day').format('YYYY-MM-DD HH:mm:ss')
const todayEnd = dayjs().endOf('day').format('YYYY-MM-DD HH:mm:ss')
const dateRange = ref<[string, string]>([todayStart, todayEnd])

const formatDate = (date: any) => {
  if (!date) return '-'
  const d = dayjs(date)
  return d.isValid() ? d.format('YYYY-MM-DD HH:mm:ss') : '-'
}

const operationLabelMap: Record<string, string> = {
  'LOGIN': '登录', 'LOGOUT': '登出', 'USER_REGISTER': '用户注册', 'USER_UPDATE': '用户更新',
  'USER_DELETE': '用户删除', 'USER_STATUS': '用户状态变更', 'USER_BATCH_STATUS': '批量状态变更',
  'USER_PASSWORD_RESET': '密码重置', 'BORROW_APPLY': '借阅申请', 'BORROW_APPROVE': '审批通过',
  'BORROW_REJECT': '审批驳回', 'BORROW_CANCEL': '取消借阅', 'BORROW_PICKUP': '取件',
  'BORROW_RETURN': '归还病案', 'BORROW_DEPT_APPROVE': '科室主任审批通过', 'BORROW_DEPT_REJECT': '科室主任审批驳回',
  'BORROW_BATCH_APPROVE': '批量审批通过', 'BORROW_BATCH_REJECT': '批量审批驳回',
  'RECORD_CREATE': '病案创建', 'RECORD_UPDATE': '病案更新', 'RECORD_DELETE': '病案删除',
  'RECORD_BATCH_DELETE': '批量删除病案', 'RECORD_STATUS': '病案状态变更'
}

const getOperationLabel = (op: string) => operationLabelMap[op] || op

const getOperationTagType = (op: string) => {
  if (op.startsWith('LOGIN') || op.startsWith('LOGOUT')) return 'info'
  if (op.startsWith('BORROW_APPROVE') || op.startsWith('BORROW_BATCH_APPROVE')) return 'success'
  if (op.startsWith('BORROW_REJECT') || op.startsWith('BORROW_BATCH_REJECT')) return 'danger'
  if (op.startsWith('BORROW_RETURN')) return 'warning'
  if (op.startsWith('USER')) return 'primary'
  return ''
}

const loadAuditLogs = async () => {
  try {
    const params = {
      page: currentPage.value,
      pageSize: pageSize.value,
      username: searchForm.value.username,
      operationType: searchForm.value.operationType,
      startTime: dateRange.value ? dateRange.value[0] : undefined,
      endTime: dateRange.value ? dateRange.value[1] : undefined
    }
    const response = await service.get('/audit-logs', { params })
    auditLogs.value = response.records
    total.value = response.total
  } catch (error) {
    console.error('获取审计日志失败:', error)
  }
}

const search = () => { currentPage.value = 1; loadAuditLogs() }
const reset = () => {
  searchForm.value = { username: '', operationType: '' }
  dateRange.value = [dayjs().startOf('day').format('YYYY-MM-DD HH:mm:ss'), dayjs().endOf('day').format('YYYY-MM-DD HH:mm:ss')]
  currentPage.value = 1
  loadAuditLogs()
}
const handleSizeChange = (size: number) => { pageSize.value = size; loadAuditLogs() }
const handleCurrentChange = (current: number) => { currentPage.value = current; loadAuditLogs() }

onMounted(() => { loadAuditLogs() })
</script>

<style scoped>
.audit-logs-container {
  padding: var(--space-lg);
}

.page-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: var(--space-lg);
}

.page-title {
  font-size: var(--font-size-3xl);
  font-weight: var(--font-weight-bold);
  color: var(--color-text-primary);
  margin: 0;
}

.page-subtitle {
  color: var(--color-text-secondary);
  font-size: var(--font-size-base);
  margin: 4px 0 0;
}

.audit-card {
  margin-bottom: var(--space-lg);
}

.search-form {
  margin-bottom: var(--space-lg);
  flex-wrap: wrap;
  gap: 8px;
}

.search-form .el-form-item {
  margin-bottom: 12px;
}

.data-table {
  border-radius: var(--radius-md);
  overflow: hidden;
}

.pagination-container {
  margin-top: var(--space-lg);
  display: flex;
  justify-content: flex-end;
}

@media (max-width: 768px) {
  .audit-logs-container {
    padding: var(--space-md);
  }

  .page-title {
    font-size: var(--font-size-2xl);
  }

  .search-form {
    flex-direction: column;
    align-items: stretch;
  }

  .search-form .el-form-item {
    margin-right: 0;
  }
}
</style>
