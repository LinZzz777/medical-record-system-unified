<template>
  <div class="audit-logs-container">
    <el-card class="audit-logs-card">
      <template #header>
        <div class="card-header">
          <span>审计日志</span>
        </div>
      </template>
      
      <el-form :inline="true" :model="searchForm" class="search-form">
        <el-form-item label="操作人">
          <el-input v-model="searchForm.username" placeholder="请输入操作人" />
        </el-form-item>
        <el-form-item label="操作类型">
          <el-select v-model="searchForm.operationType" placeholder="请选择操作类型">
            <el-option label="登录" value="LOGIN" />
            <el-option label="登出" value="LOGOUT" />
            <el-option label="借阅申请" value="BORROW_APPLY" />
            <el-option label="审批" value="APPROVE" />
            <el-option label="归还" value="RETURN" />
            <el-option label="用户管理" value="USER_MANAGE" />
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
      
      <el-table :data="auditLogs" style="width: 100%" border>
        <el-table-column prop="id" label="ID" width="80" />
        <el-table-column prop="username" label="操作人" width="120" />
        <el-table-column prop="module" label="模块" width="100" />
        <el-table-column prop="operation" label="操作类型" width="150" />
        <el-table-column prop="details" label="操作详情" show-overflow-tooltip />
        <el-table-column prop="ip" label="IP地址" width="150" />
        <el-table-column prop="status" label="状态" width="80">
          <template #default="scope">
            <el-tag :type="scope.row.status === 1 ? 'success' : 'danger'">
              {{ scope.row.status === 1 ? '成功' : '失败' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="createdTime" label="操作时间" width="180">
          <template #default="scope">
            {{ formatDate(scope.row.createdTime) }}
          </template>
        </el-table-column>
      </el-table>
      
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
const searchForm = ref({
  username: '',
  module: ''
})
const dateRange = ref<[string, string] | null>(null)

const formatDate = (date: string) => {
  return dayjs(date).format('YYYY-MM-DD HH:mm:ss')
}

const loadAuditLogs = async () => {
  try {
    const params: any = {
      page: currentPage.value,
      pageSize: pageSize.value
    }
    if (searchForm.value.username) {
      params.username = searchForm.value.username
    }
    if (searchForm.value.module) {
      params.operationType = searchForm.value.module  // 后端用operationType字段匹配module
    }
    if (dateRange.value && dateRange.value.length === 2) {
      params.startTime = dateRange.value[0] + ' 00:00:00'
      params.endTime = dateRange.value[1] + ' 23:59:59'
    }
    const response = await service.get('/audit-logs', { params })
    auditLogs.value = response.records || []
    total.value = response.total || 0
  } catch (error) {
    console.error('获取审计日志失败:', error)
    auditLogs.value = []
    total.value = 0
  }
}

const search = () => {
  currentPage.value = 1
  loadAuditLogs()
}

const reset = () => {
  searchForm.value = {
    username: '',
    module: ''
  }
  dateRange.value = null
  currentPage.value = 1
  loadAuditLogs()
}

const handleSizeChange = (size: number) => {
  pageSize.value = size
  loadAuditLogs()
}

const handleCurrentChange = (current: number) => {
  currentPage.value = current
  loadAuditLogs()
}

onMounted(() => {
  loadAuditLogs()
})
</script>

<style scoped>
.audit-logs-container {
  padding: 20px;
}

.audit-logs-card {
  margin-bottom: 20px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.search-form {
  margin-bottom: 20px;
}

.pagination-container {
  margin-top: 20px;
  display: flex;
  justify-content: flex-end;
}
</style>