<template>
  <div class="review-container">
    <el-card class="review-card">
      <template #header>
        <div class="card-header">
          <span>审核管理</span>
          <el-tag type="warning">借阅申请审批</el-tag>
        </div>
      </template>

      <div class="status-stats">
        <div class="status-stat-item" :class="{ active: activeTab === 'pending' }" @click="activeTab = 'pending'">
          <span class="status-count">{{ pendingCount }}</span>
          <span class="status-label">待科室审批</span>
        </div>
        <div class="status-stat-item" :class="{ active: activeTab === 'dept_approved' }" @click="activeTab = 'dept_approved'">
          <span class="status-count">{{ deptApprovedCount }}</span>
          <span class="status-label">待终审</span>
        </div>
        <div class="status-stat-item" :class="{ active: activeTab === 'all' }" @click="activeTab = 'all'">
          <span class="status-count">{{ allCount }}</span>
          <span class="status-label">全部申请</span>
        </div>
      </div>

      <div class="toolbar">
        <el-select v-model="searchForm.status" placeholder="筛选状态" clearable style="width: 160px" @change="filterApplications">
          <el-option label="待科室审批" value="pending" />
          <el-option label="待终审" value="dept_approved" />
          <el-option label="已批准" value="approved" />
          <el-option label="已驳回" value="rejected" />
          <el-option label="已取件" value="picked" />
          <el-option label="已完成" value="completed" />
          <el-option label="已取消" value="cancelled" />
          <el-option label="已过期" value="overdue" />
        </el-select>
        <el-select v-model="searchForm.borrowType" placeholder="借阅类型" clearable style="width: 140px; margin-left: 10px" @change="filterApplications">
          <el-option label="院内借阅" value="院内借阅" />
          <el-option label="院外借阅" value="院外借阅" />
        </el-select>
        <el-input v-model="searchForm.keyword" placeholder="搜索申请人/病案号" clearable style="width: 200px; margin-left: 10px" @input="filterApplications" />
        <div class="toolbar-right">
          <el-button type="primary" @click="refreshData">刷新</el-button>
          <el-button
            v-if="selectedRows.length > 0"
            type="success"
            @click="batchApprove"
          >
            批量批准 ({{ selectedRows.length }})
          </el-button>
          <el-button
            v-if="selectedRows.length > 0"
            type="danger"
            @click="batchReject"
          >
            批量驳回 ({{ selectedRows.length }})
          </el-button>
        </div>
      </div>

      <el-table
        :data="filteredApplications"
        style="width: 100%"
        border
        @selection-change="handleSelectionChange"
      >
        <el-table-column type="selection" width="55" :selectable="canApprove" />
        <el-table-column prop="id" label="申请ID" width="80" />
        <el-table-column prop="recordNumbers" label="病案号" show-overflow-tooltip />
        <el-table-column prop="userName" label="申请人" width="100" />
        <el-table-column prop="userDepartment" label="申请科室" width="120" />
        <el-table-column prop="borrowType" label="借阅类型" width="100">
          <template #default="{ row }">
            <el-tag :type="row.borrowType === '院内借阅' ? 'success' : 'info'" size="small">
              {{ row.borrowType || '-' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="reason" label="借阅原因" show-overflow-tooltip />
        <el-table-column prop="submitTime" label="提交时间" width="160" />
        <el-table-column prop="expectedReturnDate" label="预计归还" width="120">
          <template #default="{ row }">
            <span :class="{ overdue: isOverdue(row.expectedReturnDate) }">
              {{ row.expectedReturnDate || '-' }}
            </span>
          </template>
        </el-table-column>
        <el-table-column label="状态" width="130">
          <template #default="{ row }">
            <el-tag :type="getStatusType(row)" effect="dark" size="small">
              {{ getStatusText(row) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="340" fixed="right">
          <template #default="{ row }">
            <el-button size="small" @click="viewDetail(row)">详情</el-button>

            <!-- 科室主任审批（一级审批） pending -> dept_approved -->
            <el-button
              v-if="canDeptApprove(row)"
              type="success"
              size="small"
              @click="deptApproveApplication(row.id)"
            >
              科室批准
            </el-button>
            <el-button
              v-if="canDeptApprove(row)"
              type="danger"
              size="small"
              @click="deptRejectApplication(row.id)"
            >
              驳回
            </el-button>

            <!-- 终审 dept_approved -> approved -->
            <el-button
              v-if="canFinalApprove(row)"
              type="success"
              size="small"
              @click="approveApplication(row.id)"
            >
              终审批准
            </el-button>
            <el-button
              v-if="canFinalApprove(row)"
              type="danger"
              size="small"
              @click="rejectApplication(row.id)"
            >
              驳回
            </el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>

    <el-dialog v-model="detailDialogVisible" title="申请详情" width="800px">
      <div v-if="selectedApplication" class="application-detail">
        <div class="detail-section">
          <h3>基本信息</h3>
          <div class="detail-item">
            <span class="label">申请ID:</span>
            <span class="value">{{ selectedApplication.id }}</span>
          </div>
          <div class="detail-item">
            <span class="label">病案号:</span>
            <span class="value">{{ selectedApplication.recordNumbers || '-' }}</span>
          </div>
          <div class="detail-item">
            <span class="label">借阅类型:</span>
            <span class="value">{{ selectedApplication.borrowType || '-' }}</span>
          </div>
          <div class="detail-item">
            <span class="label">借阅原因:</span>
            <span class="value">{{ selectedApplication.reason || '-' }}</span>
          </div>
          <div class="detail-item">
            <span class="label">预计归还日期:</span>
            <span class="value">{{ selectedApplication.expectedReturnDate || '-' }}</span>
          </div>
          <div class="detail-item">
            <span class="label">申请人:</span>
            <span class="value">{{ selectedApplication.userName || '-' }}</span>
          </div>
          <div class="detail-item">
            <span class="label">申请科室:</span>
            <span class="value">{{ selectedApplication.userDepartment || '-' }}</span>
          </div>
          <div class="detail-item" v-if="selectedApplication.deptApprover">
            <span class="label">科室审批人:</span>
            <span class="value">{{ selectedApplication.deptApprover }}</span>
          </div>
          <div class="detail-item" v-if="selectedApplication.deptApproveTime">
            <span class="label">科室审批时间:</span>
            <span class="value">{{ selectedApplication.deptApproveTime }}</span>
          </div>
          <div class="detail-item" v-if="selectedApplication.approver">
            <span class="label">终审人:</span>
            <span class="value">{{ selectedApplication.approver }}</span>
          </div>
          <div class="detail-item" v-if="selectedApplication.approveTime">
            <span class="label">终审时间:</span>
            <span class="value">{{ selectedApplication.approveTime }}</span>
          </div>
          <div class="detail-item" v-if="selectedApplication.rejectionReason">
            <span class="label">驳回原因:</span>
            <span class="value rejection-reason">{{ selectedApplication.rejectionReason }}</span>
          </div>
        </div>
      </div>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, reactive, ref } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import service from '../api/request'
import store from '../store'

interface BorrowApplication {
  id: number
  recordNumbers?: string
  borrowType?: string
  reason?: string
  expectedReturnDate?: string
  status: string
  submitTime?: string
  approveTime?: string
  returnTime?: string
  updatedTime?: string
  userName?: string
  userId?: number
  userDepartment?: string
  deptApprover?: string
  deptApproveTime?: string
  deptRejectionReason?: string
  approver?: string
  rejectionReason?: string
}

const applications = ref<BorrowApplication[]>([])
const selectedApplication = ref<BorrowApplication | null>(null)
const selectedRows = ref<BorrowApplication[]>([])
const detailDialogVisible = ref(false)
const activeTab = ref('pending')

const searchForm = reactive({
  status: '',
  borrowType: '',
  keyword: ''
})

const isAdmin = computed(() => store.state.user?.role === 'admin')
const isDirector = computed(() => store.getters.isDirector)
const isDeptDirector = computed(() => store.getters.isDeptDirector)

const pendingCount = computed(() => applications.value.filter(a => a.status === 'pending').length)
const deptApprovedCount = computed(() => applications.value.filter(a => a.status === 'dept_approved').length)
const allCount = computed(() => applications.value.length)

const filteredApplications = computed(() => {
  let filtered = applications.value.slice()

  // activeTab filter (primary)
  if (activeTab.value === 'pending') {
    filtered = filtered.filter(a => a.status === 'pending')
  } else if (activeTab.value === 'dept_approved') {
    filtered = filtered.filter(a => a.status === 'dept_approved')
  }

  // Additional filters
  if (searchForm.status) {
    if (searchForm.status === 'overdue') {
      filtered = filtered.filter(a => isApplicationOverdue(a))
    } else {
      filtered = filtered.filter(a => a.status === searchForm.status)
    }
  }
  if (searchForm.borrowType) {
    filtered = filtered.filter(a => a.borrowType === searchForm.borrowType)
  }
  if (searchForm.keyword) {
    const kw = searchForm.keyword.toLowerCase()
    filtered = filtered.filter(a =>
      (a.userName && a.userName.toLowerCase().includes(kw)) ||
      (a.recordNumbers && a.recordNumbers.toLowerCase().includes(kw))
    )
  }

  return filtered
})

const isOverdue = (expectedReturnDate?: string) => {
  if (!expectedReturnDate) return false
  const today = new Date()
  today.setHours(0, 0, 0, 0)
  const d = new Date(expectedReturnDate)
  if (Number.isNaN(d.getTime())) return false
  return d < today
}

const isApplicationOverdue = (app: BorrowApplication) => {
  if (['completed', 'cancelled', 'rejected'].includes(app.status)) return false
  return isOverdue(app.expectedReturnDate)
}

const getStatusType = (app: BorrowApplication) => {
  if (isApplicationOverdue(app)) return 'danger'
  switch (app.status) {
    case 'pending': return 'warning'
    case 'dept_approved': return 'primary'
    case 'approved': return 'success'
    case 'rejected': return 'danger'
    case 'picked': return 'primary'
    case 'completed': return 'info'
    case 'cancelled': return 'info'
    default: return ''
  }
}

const getStatusText = (app: BorrowApplication) => {
  if (isApplicationOverdue(app)) return '已过期'
  switch (app.status) {
    case 'pending': return '待科室审批'
    case 'dept_approved': return '待终审'
    case 'approved': return '已批准'
    case 'rejected': return '已驳回'
    case 'picked': return '已取件'
    case 'completed': return '已完成'
    case 'cancelled': return '已取消'
    default: return app.status
  }
}

// admin can approve everything; 主任/dept_director can only do department-level approval for their department
const canDeptApprove = (app: BorrowApplication) => {
  if (app.status !== 'pending') return false
  if (isAdmin.value) return true
  if (isDirector.value || isDeptDirector.value) {
    const userDept = store.state.user?.department
    return app.userDepartment === userDept
  }
  return false
}

const canFinalApprove = (app: BorrowApplication) => {
  if (app.status !== 'dept_approved') return false
  return isAdmin.value || isDirector.value
}

const canApprove = (row: BorrowApplication) => {
  return canDeptApprove(row) || canFinalApprove(row)
}

const handleSelectionChange = (rows: BorrowApplication[]) => {
  selectedRows.value = rows
}

const filterApplications = () => {
  // reactive filters already handled in computed
}

const refreshData = () => {
  searchForm.status = ''
  searchForm.borrowType = ''
  searchForm.keyword = ''
  activeTab.value = 'pending'
  loadApplications()
}

const loadApplications = async () => {
  try {
    const user = store.state.user
    if (!user?.id) {
      ElMessage.error('用户信息不完整，请重新登录')
      return
    }

    let response: BorrowApplication[]
    if (isAdmin.value) {
      response = await service.get<BorrowApplication[]>('/borrow-applications/list') || []
    } else if (isDirector.value) {
      const all = await service.get<BorrowApplication[]>('/borrow-applications/list') || []
      const userDept = user.department || ''
      // 主任 can see pending/dept_approved from their department + all dept_approved for final review
      response = all.filter(a =>
        (a.status === 'pending' && a.userDepartment === userDept) ||
        a.status === 'dept_approved' ||
        a.userDepartment === userDept
      )
    } else if (isDeptDirector.value) {
      const all = await service.get<BorrowApplication[]>('/borrow-applications/list') || []
      const userDept = user.department || ''
      response = all.filter(a => a.userDepartment === userDept)
    } else {
      response = []
    }

    applications.value = response || []
  } catch (error) {
    console.error('Failed to load applications:', error)
    ElMessage.error('加载借阅申请失败')
  }
}

const viewDetail = (app: BorrowApplication) => {
  selectedApplication.value = app
  detailDialogVisible.value = true
}

const deptApproveApplication = async (id: number) => {
  try {
    await ElMessageBox.confirm('确定要科室审批通过该借阅申请吗？', '确认科室审批', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'success'
    })

    const response = await service.put<{ success: boolean }>(`/borrow-applications/${id}/dept-approve`, {
      approver: store.state.user?.name,
      userId: String(store.state.user?.id || '')
    })
    if (response?.success) {
      ElMessage.success('科室审批已通过')
      loadApplications()
    } else {
      ElMessage.error((response as any)?.message || '科室审批失败')
    }
  } catch (error: any) {
    if (error !== 'cancel' && error?.action !== 'cancel') {
      ElMessage.error('科室审批失败')
    }
  }
}

const deptRejectApplication = async (id: number) => {
  try {
    const { value } = await ElMessageBox.prompt('请输入驳回原因', '确认驳回', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning',
      inputPlaceholder: '请输入驳回原因'
    })

    if (!value?.trim()) {
      ElMessage.warning('驳回原因不能为空')
      return
    }

    const response = await service.put<{ success: boolean }>(`/borrow-applications/${id}/dept-reject`, {
      approver: store.state.user?.name,
      rejectionReason: value,
      userId: String(store.state.user?.id || '')
    })
    if (response?.success) {
      ElMessage.success('申请已驳回')
      loadApplications()
    } else {
      ElMessage.error((response as any)?.message || '驳回失败')
    }
  } catch (error: any) {
    if (error !== 'cancel' && error?.action !== 'cancel') {
      ElMessage.error('驳回失败')
    }
  }
}

const approveApplication = async (id: number) => {
  try {
    await ElMessageBox.confirm('确定要终审通过该借阅申请吗？', '确认终审', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'success'
    })

    const response = await service.put<{ success: boolean }>(`/borrow-applications/${id}/approve`, {
      approver: store.state.user?.name
    })
    if (response?.success) {
      ElMessage.success('终审已通过')
      loadApplications()
    } else {
      ElMessage.error('终审失败')
    }
  } catch (error: any) {
    if (error !== 'cancel' && error?.action !== 'cancel') {
      ElMessage.error('终审失败')
    }
  }
}

const rejectApplication = async (id: number) => {
  try {
    const { value } = await ElMessageBox.prompt('请输入驳回原因', '确认驳回', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning',
      inputPlaceholder: '请输入驳回原因'
    })

    if (!value?.trim()) {
      ElMessage.warning('驳回原因不能为空')
      return
    }

    const response = await service.put<{ success: boolean }>(`/borrow-applications/${id}/reject`, {
      approver: store.state.user?.name,
      rejectionReason: value
    })
    if (response?.success) {
      ElMessage.success('申请已驳回')
      loadApplications()
    } else {
      ElMessage.error('驳回失败')
    }
  } catch (error: any) {
    if (error !== 'cancel' && error?.action !== 'cancel') {
      ElMessage.error('驳回失败')
    }
  }
}

const batchApprove = async () => {
  if (selectedRows.value.length === 0) return

  const pendingOnes = selectedRows.value.filter(r => r.status === 'pending')
  const deptApprovedOnes = selectedRows.value.filter(r => r.status === 'dept_approved')

  try {
    await ElMessageBox.confirm(
      `确定要批量批准 ${selectedRows.value.length} 个申请吗？（其中待科室审批: ${pendingOnes.length}，待终审: ${deptApprovedOnes.length}）`,
      '批量批准确认',
      { confirmButtonText: '确定', cancelButtonText: '取消', type: 'success' }
    )

    let successCount = 0
    for (const row of pendingOnes) {
      const resp = await service.put<{ success: boolean }>(`/borrow-applications/${row.id}/dept-approve`, {
        approver: store.state.user?.name,
        userId: String(store.state.user?.id || '')
      })
      if (resp?.success) successCount++
    }
    for (const row of deptApprovedOnes) {
      const resp = await service.put<{ success: boolean }>(`/borrow-applications/${row.id}/approve`, {
        approver: store.state.user?.name
      })
      if (resp?.success) successCount++
    }

    ElMessage.success(`批量批准完成: ${successCount}/${selectedRows.value.length}`)
    selectedRows.value = []
    loadApplications()
  } catch (error: any) {
    if (error !== 'cancel' && error?.action !== 'cancel') {
      ElMessage.error('批量批准失败')
    }
  }
}

const batchReject = async () => {
  if (selectedRows.value.length === 0) return

  try {
    const { value } = await ElMessageBox.prompt('请输入驳回原因', '批量驳回确认', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning',
      inputPlaceholder: '请输入驳回原因'
    })

    if (!value?.trim()) {
      ElMessage.warning('驳回原因不能为空')
      return
    }

    let successCount = 0
    for (const row of selectedRows.value) {
      let resp
      if (row.status === 'pending') {
        resp = await service.put<{ success: boolean }>(`/borrow-applications/${row.id}/dept-reject`, {
          approver: store.state.user?.name,
          rejectionReason: value,
          userId: String(store.state.user?.id || '')
        })
      } else if (row.status === 'dept_approved') {
        resp = await service.put<{ success: boolean }>(`/borrow-applications/${row.id}/reject`, {
          approver: store.state.user?.name,
          rejectionReason: value
        })
      }
      if (resp?.success) successCount++
    }

    ElMessage.success(`批量驳回完成: ${successCount}/${selectedRows.value.length}`)
    selectedRows.value = []
    loadApplications()
  } catch (error: any) {
    if (error !== 'cancel' && error?.action !== 'cancel') {
      ElMessage.error('批量驳回失败')
    }
  }
}

onMounted(() => {
  loadApplications()
})
</script>

<style scoped>
.review-container {
  padding: 20px;
}

.review-card {
  margin-bottom: 20px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.status-stats {
  display: flex;
  gap: 15px;
  margin-bottom: 20px;
}

.status-stat-item {
  text-align: center;
  padding: 15px 30px;
  background: #f5f7fa;
  border-radius: 8px;
  border: 2px solid #e4e7ed;
  cursor: pointer;
  transition: all 0.3s ease;
}

.status-stat-item:hover {
  border-color: #409eff;
  background: #ecf5ff;
}

.status-stat-item.active {
  border-color: #409eff;
  background: #ecf5ff;
}

.status-count {
  display: block;
  font-size: 28px;
  font-weight: bold;
  color: #303133;
}

.status-label {
  display: block;
  font-size: 13px;
  color: #606266;
  margin-top: 4px;
}

.toolbar {
  display: flex;
  align-items: center;
  margin-bottom: 20px;
  flex-wrap: wrap;
  gap: 10px;
}

.toolbar-right {
  margin-left: auto;
  display: flex;
  gap: 10px;
}

.overdue {
  color: #f56c6c;
  font-weight: bold;
}

.application-detail {
  padding: 10px;
}

.detail-section {
  margin-bottom: 20px;
}

.detail-section h3 {
  margin-bottom: 15px;
  font-size: 16px;
  font-weight: 500;
  color: #303133;
}

.detail-item {
  display: flex;
  margin-bottom: 12px;
  align-items: flex-start;
}

.detail-item .label {
  width: 120px;
  font-weight: 500;
  color: #606266;
  flex-shrink: 0;
}

.detail-item .value {
  flex: 1;
  color: #303133;
  word-break: break-word;
}

.rejection-reason {
  color: #f56c6c;
}

@media (max-width: 768px) {
  .review-container {
    padding: 10px;
  }

  .status-stats {
    flex-wrap: wrap;
  }

  .status-stat-item {
    flex: 1;
    min-width: 100px;
    padding: 10px 15px;
  }

  .toolbar {
    flex-direction: column;
    align-items: stretch;
  }

  .toolbar-right {
    margin-left: 0;
    flex-wrap: wrap;
  }

  .detail-item {
    flex-direction: column;
    gap: 5px;
  }

  .detail-item .label {
    width: auto;
  }
}
</style>
