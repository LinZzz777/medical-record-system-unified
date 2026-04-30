<template>
  <div class="review-container">
    <div class="page-header">
      <div>
        <h1 class="page-title">审核管理</h1>
        <p class="page-subtitle">借阅申请审批，支持批量操作</p>
      </div>
      <el-tag type="warning" effect="dark">借阅申请审批</el-tag>
    </div>

    <el-card class="review-card" :body-style="{ padding: '24px' }">
      <!-- Status Tabs -->
      <div class="status-tabs">
        <div class="status-tab" :class="{ active: activeTab === 'pending' }" @click="activeTab = 'pending'">
          <span class="tab-count tab-count--warning">{{ pendingCount }}</span>
          <span class="tab-label">待科室审批</span>
        </div>
        <div class="status-tab" :class="{ active: activeTab === 'dept_approved' }" @click="activeTab = 'dept_approved'">
          <span class="tab-count tab-count--primary">{{ deptApprovedCount }}</span>
          <span class="tab-label">待终审</span>
        </div>
        <div class="status-tab" :class="{ active: activeTab === 'all' }" @click="activeTab = 'all'">
          <span class="tab-count tab-count--default">{{ allCount }}</span>
          <span class="tab-label">全部申请</span>
        </div>
      </div>

      <!-- Toolbar -->
      <div class="toolbar">
        <div class="toolbar-left">
          <el-select v-model="searchForm.status" placeholder="筛选状态" clearable class="review-select-status" @change="filterApplications">
            <el-option label="待科室审批" value="pending" />
            <el-option label="待终审" value="dept_approved" />
            <el-option label="已批准" value="approved" />
            <el-option label="已驳回" value="rejected" />
            <el-option label="已取件" value="picked" />
            <el-option label="已完成" value="completed" />
            <el-option label="已取消" value="cancelled" />
            <el-option label="已过期" value="overdue" />
          </el-select>
          <el-select v-model="searchForm.borrowType" placeholder="借阅类型" clearable class="review-select-type" @change="filterApplications">
            <el-option label="院内借阅" value="院内借阅" />
            <el-option label="院外借阅" value="院外借阅" />
          </el-select>
          <el-input v-model="searchForm.keyword" placeholder="搜索申请人/病案号" clearable class="review-input-keyword" @input="filterApplications" />
        </div>
        <div class="toolbar-right">
          <el-button type="primary" @click="refreshData">刷新</el-button>
          <el-button v-if="selectedRows.length > 0" type="success" @click="batchApprove">
            批量批准 ({{ selectedRows.length }})
          </el-button>
          <el-button v-if="selectedRows.length > 0" type="danger" @click="batchReject">
            批量驳回 ({{ selectedRows.length }})
          </el-button>
        </div>
      </div>

      <!-- Table -->
      <div class="table-scroll-wrapper">
      <el-table :data="filteredApplications" style="width: 100%" border @selection-change="handleSelectionChange" class="data-table">
        <el-table-column type="selection" width="55" :selectable="canApprove" />
        <el-table-column prop="id" label="申请ID" width="70" />
        <el-table-column prop="recordNumbers" label="病案号" show-overflow-tooltip />
        <el-table-column prop="userName" label="申请人" width="100" />
        <el-table-column prop="userDepartment" label="申请科室" width="110" />
        <el-table-column prop="borrowType" label="借阅类型" width="100">
          <template #default="{ row }">
            <el-tag :type="row.borrowType === '院内借阅' ? 'success' : 'info'" effect="plain" size="small">{{ row.borrowType || '-' }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="reason" label="借阅原因" show-overflow-tooltip />
        <el-table-column prop="submitTime" label="提交时间" width="150" />
        <el-table-column prop="expectedReturnDate" label="预计归还" width="110">
          <template #default="{ row }">
            <span :class="{ 'text-danger': isOverdue(row.expectedReturnDate) }">{{ row.expectedReturnDate || '-' }}</span>
          </template>
        </el-table-column>
        <el-table-column label="状态" width="120">
          <template #default="{ row }">
            <el-tag :type="getStatusType(row)" effect="dark" size="small">{{ getStatusText(row) }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="300" fixed="right">
          <template #default="{ row }">
            <div class="action-buttons">
              <el-button size="small" @click="viewDetail(row)">详情</el-button>
              <el-button v-if="canDeptApprove(row)" type="success" size="small" @click="deptApproveApplication(row.id)">科室批准</el-button>
              <el-button v-if="canDeptApprove(row)" type="danger" size="small" @click="deptRejectApplication(row.id)">驳回</el-button>
              <el-button v-if="canFinalApprove(row)" type="success" size="small" @click="approveApplication(row.id)">终审批准</el-button>
              <el-button v-if="canFinalApprove(row)" type="danger" size="small" @click="rejectApplication(row.id)">驳回</el-button>
            </div>
          </template>
        </el-table-column>
      </el-table>
      </div>
    </el-card>

    <!-- Detail Dialog -->
    <el-dialog v-model="detailDialogVisible" title="申请详情" class="responsive-dialog">
      <div v-if="selectedApplication" class="application-detail">
        <div class="detail-section">
          <h3 class="detail-section-title">基本信息</h3>
          <div class="detail-grid">
            <div class="detail-item">
              <span class="detail-label">申请ID</span>
              <span class="detail-value">{{ selectedApplication.id }}</span>
            </div>
            <div class="detail-item">
              <span class="detail-label">病案号</span>
              <span class="detail-value">{{ selectedApplication.recordNumbers || '-' }}</span>
            </div>
            <div class="detail-item">
              <span class="detail-label">借阅类型</span>
              <span class="detail-value">{{ selectedApplication.borrowType || '-' }}</span>
            </div>
            <div class="detail-item">
              <span class="detail-label">预计归还日期</span>
              <span class="detail-value">{{ selectedApplication.expectedReturnDate || '-' }}</span>
            </div>
            <div class="detail-item detail-item--full">
              <span class="detail-label">借阅原因</span>
              <span class="detail-value">{{ selectedApplication.reason || '-' }}</span>
            </div>
            <div class="detail-item">
              <span class="detail-label">申请人</span>
              <span class="detail-value">{{ selectedApplication.userName || '-' }}</span>
            </div>
            <div class="detail-item">
              <span class="detail-label">申请科室</span>
              <span class="detail-value">{{ selectedApplication.userDepartment || '-' }}</span>
            </div>
            <div class="detail-item" v-if="selectedApplication.deptApprover">
              <span class="detail-label">科室审批人</span>
              <span class="detail-value">{{ selectedApplication.deptApprover }}</span>
            </div>
            <div class="detail-item" v-if="selectedApplication.deptApproveTime">
              <span class="detail-label">科室审批时间</span>
              <span class="detail-value">{{ selectedApplication.deptApproveTime }}</span>
            </div>
            <div class="detail-item" v-if="selectedApplication.approver">
              <span class="detail-label">终审人</span>
              <span class="detail-value">{{ selectedApplication.approver }}</span>
            </div>
            <div class="detail-item" v-if="selectedApplication.approveTime">
              <span class="detail-label">终审时间</span>
              <span class="detail-value">{{ selectedApplication.approveTime }}</span>
            </div>
            <div class="detail-item detail-item--full" v-if="selectedApplication.rejectionReason">
              <span class="detail-label">驳回原因</span>
              <span class="detail-value text-danger">{{ selectedApplication.rejectionReason }}</span>
            </div>
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

const searchForm = reactive({ status: '', borrowType: '', keyword: '' })

const isAdmin = computed(() => store.state.user?.role === 'admin')
const isDirector = computed(() => store.getters.isDirector)
const isDeptDirector = computed(() => store.getters.isDeptDirector)

const pendingCount = computed(() => applications.value.filter(a => a.status === 'pending').length)
const deptApprovedCount = computed(() => applications.value.filter(a => a.status === 'dept_approved').length)
const allCount = computed(() => applications.value.length)

const filteredApplications = computed(() => {
  let filtered = applications.value.slice()
  if (activeTab.value === 'pending') filtered = filtered.filter(a => a.status === 'pending')
  else if (activeTab.value === 'dept_approved') filtered = filtered.filter(a => a.status === 'dept_approved')
  if (searchForm.status) {
    if (searchForm.status === 'overdue') filtered = filtered.filter(a => isApplicationOverdue(a))
    else filtered = filtered.filter(a => a.status === searchForm.status)
  }
  if (searchForm.borrowType) filtered = filtered.filter(a => a.borrowType === searchForm.borrowType)
  if (searchForm.keyword) {
    const kw = searchForm.keyword.toLowerCase()
    filtered = filtered.filter(a =>
      (a.userName && a.userName.toLowerCase().includes(kw)) ||
      (a.recordNumbers && a.recordNumbers.toLowerCase().includes(kw))
    )
  }
  return filtered
})

const isOverdue = (d?: string) => {
  if (!d) return false
  const today = new Date(); today.setHours(0, 0, 0, 0)
  const date = new Date(d)
  return !Number.isNaN(date.getTime()) && date < today
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

const canDeptApprove = (app: BorrowApplication) => {
  if (app.status !== 'pending') return false
  if (isAdmin.value) return true
  if (isDirector.value || isDeptDirector.value) return app.userDepartment === store.state.user?.department
  return false
}

const canFinalApprove = (app: BorrowApplication) => {
  if (app.status !== 'dept_approved') return false
  return isAdmin.value || isDirector.value
}

const canApprove = (row: BorrowApplication) => canDeptApprove(row) || canFinalApprove(row)

const handleSelectionChange = (rows: BorrowApplication[]) => { selectedRows.value = rows }
const filterApplications = () => {}
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
    if (!user?.id) { ElMessage.error('用户信息不完整，请重新登录'); return }
    let response: BorrowApplication[]
    if (isAdmin.value) {
      response = await service.get<BorrowApplication[]>('/borrow-applications/list') || []
    } else if (isDirector.value) {
      const all = await service.get<BorrowApplication[]>('/borrow-applications/list') || []
      const userDept = user.department || ''
      response = all.filter(a => (a.status === 'pending' && a.userDepartment === userDept) || a.status === 'dept_approved' || a.userDepartment === userDept)
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

const viewDetail = (app: BorrowApplication) => { selectedApplication.value = app; detailDialogVisible.value = true }

const deptApproveApplication = async (id: number) => {
  try {
    await ElMessageBox.confirm('确定要科室审批通过该借阅申请吗？', '确认科室审批', { confirmButtonText: '确定', cancelButtonText: '取消', type: 'success' })
    const response = await service.put<{ success: boolean }>(`/borrow-applications/${id}/dept-approve`, { approver: store.state.user?.name, userId: String(store.state.user?.id || '') })
    if (response?.success) { ElMessage.success('科室审批已通过'); loadApplications() }
    else ElMessage.error((response as any)?.message || '科室审批失败')
  } catch (error: any) {
    if (error !== 'cancel' && error?.action !== 'cancel') ElMessage.error('科室审批失败')
  }
}

const deptRejectApplication = async (id: number) => {
  try {
    const { value } = await ElMessageBox.prompt('请输入驳回原因', '确认驳回', { confirmButtonText: '确定', cancelButtonText: '取消', type: 'warning', inputPlaceholder: '请输入驳回原因' })
    if (!value?.trim()) { ElMessage.warning('驳回原因不能为空'); return }
    const response = await service.put<{ success: boolean }>(`/borrow-applications/${id}/dept-reject`, { approver: store.state.user?.name, rejectionReason: value, userId: String(store.state.user?.id || '') })
    if (response?.success) { ElMessage.success('申请已驳回'); loadApplications() }
    else ElMessage.error((response as any)?.message || '驳回失败')
  } catch (error: any) {
    if (error !== 'cancel' && error?.action !== 'cancel') ElMessage.error('驳回失败')
  }
}

const approveApplication = async (id: number) => {
  try {
    await ElMessageBox.confirm('确定要终审通过该借阅申请吗？', '确认终审', { confirmButtonText: '确定', cancelButtonText: '取消', type: 'success' })
    const response = await service.put<{ success: boolean }>(`/borrow-applications/${id}/approve`, { approver: store.state.user?.name })
    if (response?.success) { ElMessage.success('终审已通过'); loadApplications() }
    else ElMessage.error('终审失败')
  } catch (error: any) {
    if (error !== 'cancel' && error?.action !== 'cancel') ElMessage.error('终审失败')
  }
}

const rejectApplication = async (id: number) => {
  try {
    const { value } = await ElMessageBox.prompt('请输入驳回原因', '确认驳回', { confirmButtonText: '确定', cancelButtonText: '取消', type: 'warning', inputPlaceholder: '请输入驳回原因' })
    if (!value?.trim()) { ElMessage.warning('驳回原因不能为空'); return }
    const response = await service.put<{ success: boolean }>(`/borrow-applications/${id}/reject`, { approver: store.state.user?.name, rejectionReason: value })
    if (response?.success) { ElMessage.success('申请已驳回'); loadApplications() }
    else ElMessage.error('驳回失败')
  } catch (error: any) {
    if (error !== 'cancel' && error?.action !== 'cancel') ElMessage.error('驳回失败')
  }
}

const batchApprove = async () => {
  if (selectedRows.value.length === 0) return
  const pendingOnes = selectedRows.value.filter(r => r.status === 'pending')
  const deptApprovedOnes = selectedRows.value.filter(r => r.status === 'dept_approved')
  try {
    await ElMessageBox.confirm(`确定要批量批准 ${selectedRows.value.length} 个申请吗？（其中待科室审批: ${pendingOnes.length}，待终审: ${deptApprovedOnes.length}）`, '批量批准确认', { confirmButtonText: '确定', cancelButtonText: '取消', type: 'success' })
    let successCount = 0
    for (const row of pendingOnes) {
      const resp = await service.put<{ success: boolean }>(`/borrow-applications/${row.id}/dept-approve`, { approver: store.state.user?.name, userId: String(store.state.user?.id || '') })
      if (resp?.success) successCount++
    }
    for (const row of deptApprovedOnes) {
      const resp = await service.put<{ success: boolean }>(`/borrow-applications/${row.id}/approve`, { approver: store.state.user?.name })
      if (resp?.success) successCount++
    }
    ElMessage.success(`批量批准完成: ${successCount}/${selectedRows.value.length}`)
    selectedRows.value = []
    loadApplications()
  } catch (error: any) {
    if (error !== 'cancel' && error?.action !== 'cancel') ElMessage.error('批量批准失败')
  }
}

const batchReject = async () => {
  if (selectedRows.value.length === 0) return
  try {
    const { value } = await ElMessageBox.prompt('请输入驳回原因', '批量驳回确认', { confirmButtonText: '确定', cancelButtonText: '取消', type: 'warning', inputPlaceholder: '请输入驳回原因' })
    if (!value?.trim()) { ElMessage.warning('驳回原因不能为空'); return }
    let successCount = 0
    for (const row of selectedRows.value) {
      let resp
      if (row.status === 'pending') {
        resp = await service.put<{ success: boolean }>(`/borrow-applications/${row.id}/dept-reject`, { approver: store.state.user?.name, rejectionReason: value, userId: String(store.state.user?.id || '') })
      } else if (row.status === 'dept_approved') {
        resp = await service.put<{ success: boolean }>(`/borrow-applications/${row.id}/reject`, { approver: store.state.user?.name, rejectionReason: value })
      }
      if (resp?.success) successCount++
    }
    ElMessage.success(`批量驳回完成: ${successCount}/${selectedRows.value.length}`)
    selectedRows.value = []
    loadApplications()
  } catch (error: any) {
    if (error !== 'cancel' && error?.action !== 'cancel') ElMessage.error('批量驳回失败')
  }
}

onMounted(() => { loadApplications() })
</script>

<style scoped>
.review-container {
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

.review-card {
  margin-bottom: var(--space-lg);
}

/* Status Tabs */
.status-tabs {
  display: flex;
  gap: 12px;
  margin-bottom: var(--space-lg);
}

.status-tab {
  flex: 1;
  text-align: center;
  padding: 16px;
  background: var(--color-bg-secondary);
  border-radius: var(--radius-md);
  border: 2px solid var(--color-border-light);
  cursor: pointer;
  transition: all var(--transition-fast);
}

.status-tab:hover {
  border-color: var(--color-primary);
  background: var(--color-primary-lighter);
}

.status-tab.active {
  border-color: var(--color-primary);
  background: var(--color-primary-lighter);
}

.tab-count {
  display: block;
  font-size: var(--font-size-3xl);
  font-weight: var(--font-weight-bold);
  line-height: 1.2;
}

.tab-count--warning { color: var(--color-warning); }
.tab-count--primary { color: var(--color-primary); }
.tab-count--default { color: var(--color-text-primary); }

.tab-label {
  display: block;
  font-size: var(--font-size-sm);
  color: var(--color-text-secondary);
  margin-top: 4px;
}

/* Toolbar */
.toolbar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: var(--space-lg);
  flex-wrap: wrap;
  gap: 12px;
}

.toolbar-left {
  display: flex;
  align-items: center;
  gap: 10px;
  flex-wrap: wrap;
}

.toolbar-right {
  display: flex;
  gap: 10px;
}

/* Table */
.data-table {
  border-radius: var(--radius-md);
  overflow: hidden;
}

.text-danger {
  color: var(--color-danger);
  font-weight: var(--font-weight-semibold);
}

.action-buttons {
  display: flex;
  gap: 6px;
  flex-wrap: wrap;
}

/* Responsive filter controls */
.review-select-status {
  width: 150px;
  max-width: 100%;
}

.review-select-type {
  width: 130px;
  max-width: 100%;
}

.review-input-keyword {
  width: 200px;
  max-width: 100%;
}

/* Responsive dialog */
.responsive-dialog {
  max-width: 700px;
}

/* Table scroll wrapper */
.table-scroll-wrapper {
  overflow-x: auto;
  -webkit-overflow-scrolling: touch;
}

/* Detail Dialog */
.application-detail {
  padding: 4px;
}

.detail-section {
  margin-bottom: var(--space-lg);
}

.detail-section-title {
  font-size: var(--font-size-lg);
  font-weight: var(--font-weight-semibold);
  color: var(--color-text-primary);
  margin: 0 0 var(--space-md);
  padding-bottom: 8px;
  border-bottom: 1px solid var(--color-divider);
}

.detail-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 12px;
}

.detail-item {
  display: flex;
  flex-direction: column;
  gap: 4px;
  padding: 10px 14px;
  background: var(--color-bg-secondary);
  border-radius: var(--radius-md);
}

.detail-item--full {
  grid-column: 1 / -1;
}

.detail-label {
  font-size: var(--font-size-xs);
  color: var(--color-text-tertiary);
  font-weight: var(--font-weight-medium);
}

.detail-value {
  font-size: var(--font-size-base);
  color: var(--color-text-primary);
  word-break: break-word;
}

/* Responsive */
@media (max-width: 768px) {
  .review-container {
    padding: var(--space-md);
  }

  .page-header {
    flex-direction: column;
    align-items: flex-start;
    gap: 8px;
  }

  .page-title {
    font-size: var(--font-size-2xl);
  }

  .status-tabs {
    flex-direction: column;
  }

  .toolbar {
    flex-direction: column;
    align-items: stretch;
  }

  .toolbar-left, .toolbar-right {
    flex-wrap: wrap;
  }

  .detail-grid {
    grid-template-columns: 1fr;
  }

  .review-select-status,
  .review-select-type,
  .review-input-keyword {
    width: 100%;
  }

  .action-buttons {
    flex-direction: column;
    gap: 4px;
  }

  .action-buttons .el-button {
    width: 100%;
  }

  .table-scroll-wrapper {
    margin: 0 -24px;
    padding: 0 24px;
  }
}

@media (max-width: 480px) {
  .review-container {
    padding: var(--space-sm);
  }

  .responsive-dialog {
    width: 96vw !important;
    max-width: none;
  }

  .table-scroll-wrapper {
    margin: 0 -16px;
    padding: 0 16px;
  }
}
</style>
