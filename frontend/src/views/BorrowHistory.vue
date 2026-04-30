<template>
  <div class="borrow-history-container">
    <div class="page-header">
      <div>
        <h1 class="page-title">借阅历史与状态跟踪</h1>
        <p class="page-subtitle">查看所有借阅申请的审批状态和处理进度</p>
      </div>
      <el-tooltip content="查看所有借阅申请的审批状态和处理进度" placement="top">
        <el-icon class="help-icon"><QuestionFilled /></el-icon>
      </el-tooltip>
    </div>

    <el-card class="history-card" :body-style="{ padding: '24px' }">
      <!-- Search Section -->
      <div class="search-section">
        <el-form :model="searchForm" :inline="true" class="search-form">
          <el-form-item :label="t.status">
            <el-select v-model="searchForm.status" :placeholder="t.selectStatus" clearable style="width: 160px">
              <el-option :label="t.all" value="" />
              <el-option :label="t.pending" value="pending" />
              <el-option :label="t.deptApproved" value="dept_approved" />
              <el-option :label="t.approved" value="approved" />
              <el-option :label="t.rejected" value="rejected" />
              <el-option :label="t.picked" value="picked" />
              <el-option :label="t.completed" value="completed" />
              <el-option :label="t.cancelled" value="cancelled" />
              <el-option :label="t.overdue" value="overdue" />
            </el-select>
          </el-form-item>

          <el-form-item :label="t.borrowType">
            <el-select v-model="searchForm.borrowType" :placeholder="t.selectBorrowType" clearable style="width: 160px">
              <el-option :label="t.all" value="" />
              <el-option :label="t.internalBorrow" :value="t.internalBorrow" />
              <el-option :label="t.externalBorrow" :value="t.externalBorrow" />
            </el-select>
          </el-form-item>

          <el-form-item :label="t.submitTimeLabel">
            <el-date-picker v-model="searchForm.submitTimeStart" type="date" :placeholder="t.selectSubmitDate" clearable value-format="YYYY-MM-DD" style="width: 160px" />
          </el-form-item>

          <el-form-item :label="t.expectedReturnDate">
            <el-date-picker v-model="searchForm.expectedReturnDate" type="date" :placeholder="t.selectExactDate" clearable value-format="YYYY-MM-DD" style="width: 160px" />
          </el-form-item>

          <el-form-item>
            <el-button type="primary" @click="searchApplications">{{ t.search }}</el-button>
            <el-button @click="resetSearch">{{ t.reset }}</el-button>
          </el-form-item>
        </el-form>
      </div>

      <!-- Status Stats -->
      <div class="status-stats">
        <div class="status-stat-item">
          <span class="status-count status-count--warning">{{ pendingCount }}</span>
          <span class="status-label">{{ t.pending }}</span>
        </div>
        <div class="status-stat-item">
          <span class="status-count status-count--primary">{{ deptApprovedCount }}</span>
          <span class="status-label">{{ t.deptApproved }}</span>
        </div>
        <div class="status-stat-item">
          <span class="status-count status-count--success">{{ approvedCount }}</span>
          <span class="status-label">{{ t.approved }}</span>
        </div>
        <div class="status-stat-item">
          <span class="status-count status-count--danger">{{ rejectedCount }}</span>
          <span class="status-label">{{ t.rejected }}</span>
        </div>
        <div class="status-stat-item">
          <span class="status-count status-count--info">{{ pickedCount }}</span>
          <span class="status-label">{{ t.picked }}</span>
        </div>
        <div class="status-stat-item">
          <span class="status-count status-count--default">{{ completedCount }}</span>
          <span class="status-label">{{ t.completed }}</span>
        </div>
        <div class="status-stat-item">
          <span class="status-count status-count--danger">{{ overdueCount }}</span>
          <span class="status-label">{{ t.overdue }}</span>
        </div>
      </div>

      <!-- Table -->
      <el-table :data="filteredApplications" style="width: 100%; height: 500px" border class="data-table">
        <el-table-column prop="id" :label="t.applicationId" width="80" />
        <el-table-column prop="recordNumbers" :label="t.recordNumbers" show-overflow-tooltip />
        <el-table-column prop="borrowType" :label="t.borrowType" width="120">
          <template #default="{ row }">
            <el-tag :type="row.borrowType === t.internalBorrow ? 'success' : 'info'" effect="plain" size="small">{{ row.borrowType }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="reason" :label="t.reason" show-overflow-tooltip />
        <el-table-column prop="expectedReturnDate" :label="t.expectedReturnDate" width="130">
          <template #default="{ row }">
            <span :class="{ 'text-danger': isOverdue(row.expectedReturnDate) }">{{ row.expectedReturnDate || '-' }}</span>
          </template>
        </el-table-column>
        <el-table-column :label="t.status" width="140">
          <template #default="{ row }">
            <div class="status-cell">
              <el-tag :type="getStatusType(row)" effect="dark" size="small">{{ getStatusText(row) }}</el-tag>
              <el-tooltip :content="getStatusDescription(row)" placement="top">
                <el-icon class="status-info-icon"><InfoFilled /></el-icon>
              </el-tooltip>
            </div>
          </template>
        </el-table-column>
        <el-table-column prop="submitTime" :label="t.submitTime" width="160" />
        <el-table-column prop="updatedTime" :label="t.updateTime" width="160" />
        <el-table-column :label="t.actions" width="260" fixed="right">
          <template #default="{ row }">
            <div class="action-buttons">
              <el-button size="small" @click="viewDetail(row)">{{ t.detail }}</el-button>
              <el-button v-if="isOwnApplication(row) && (row.status === 'pending' || row.status === 'dept_approved')" type="danger" size="small" @click="cancelApplication(row.id)">{{ t.cancel }}</el-button>
              <el-button v-if="isOwnApplication(row) && row.status === 'approved'" type="primary" size="small" @click="pickupApplication(row.id)">{{ t.pickup }}</el-button>
              <el-button v-if="isOwnApplication(row) && row.status === 'picked'" type="success" size="small" @click="completeApplication(row.id)">{{ t.complete }}</el-button>
            </div>
          </template>
        </el-table-column>
      </el-table>
    </el-card>

    <!-- Detail Dialog -->
    <el-dialog v-model="detailDialogVisible" :title="t.detailTitle" width="700px" class="detail-dialog">
      <div v-if="selectedApplication" class="application-detail">
        <div class="detail-section">
          <h3 class="detail-section-title">{{ t.basicInfo }}</h3>
          <div class="detail-grid">
            <div class="detail-item">
              <span class="detail-label">{{ t.applicationId }}</span>
              <span class="detail-value">{{ selectedApplication.id }}</span>
            </div>
            <div class="detail-item">
              <span class="detail-label">{{ t.recordNumbers }}</span>
              <span class="detail-value">{{ selectedApplication.recordNumbers || '-' }}</span>
            </div>
            <div class="detail-item">
              <span class="detail-label">{{ t.borrowType }}</span>
              <span class="detail-value">{{ selectedApplication.borrowType || '-' }}</span>
            </div>
            <div class="detail-item">
              <span class="detail-label">{{ t.expectedReturnDate }}</span>
              <span class="detail-value">{{ selectedApplication.expectedReturnDate || '-' }}</span>
            </div>
            <div class="detail-item detail-item--full">
              <span class="detail-label">{{ t.reason }}</span>
              <span class="detail-value">{{ selectedApplication.reason || '-' }}</span>
            </div>
            <div class="detail-item">
              <span class="detail-label">{{ t.applicant }}</span>
              <span class="detail-value">{{ selectedApplication.userName || '-' }}</span>
            </div>
          </div>
        </div>

        <div class="detail-section">
          <h3 class="detail-section-title">{{ t.statusTimeline }}</h3>
          <el-timeline>
            <el-timeline-item
              v-for="(event, index) in selectedApplication.statusHistory"
              :key="index"
              :timestamp="event.time"
              :type="getStatusType(event.status)"
            >
              <div class="timeline-card">
                <div class="timeline-title">{{ getStatusText(event.status) }}</div>
                <div class="timeline-desc">{{ getStatusDescription(event.status) }}</div>
                <div v-if="event.comment" class="timeline-comment">{{ t.comment }}: {{ event.comment }}</div>
              </div>
            </el-timeline-item>
          </el-timeline>
        </div>
      </div>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, reactive, ref } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { InfoFilled, QuestionFilled } from '@element-plus/icons-vue'
import { useRoute } from 'vue-router'
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
  approver?: string
  statusHistory?: StatusEvent[]
}

interface StatusEvent {
  status: string
  time: string
  comment?: string
}

const route = useRoute()

const t = {
  all: '全部',
  status: '状态',
  overdue: '已过期',
  pending: '待审批',
  deptApproved: '科室已批准',
  approved: '已批准',
  rejected: '已驳回',
  picked: '已取件',
  completed: '已完成',
  cancelled: '已取消',
  borrowType: '借阅类型',
  internalBorrow: '院内借阅',
  externalBorrow: '院外借阅',
  submitTimeLabel: '申请时间',
  expectedReturnDate: '预计归还日期',
  selectStatus: '请选择状态',
  selectBorrowType: '请选择借阅类型',
  selectSubmitDate: '请选择申请日期',
  selectExactDate: '请选择具体日期',
  search: '查询',
  reset: '重置',
  applicationId: '申请ID',
  recordNumbers: '病案号',
  reason: '借阅原因',
  submitTime: '提交时间',
  updateTime: '更新时间',
  actions: '操作',
  detail: '详情',
  approve: '批准',
  reject: '驳回',
  deptApprove: '科室审批',
  finalApprove: '终审',
  cancel: '取消',
  pickup: '取件',
  complete: '归还',
  detailTitle: '申请详情',
  basicInfo: '基本信息',
  applicant: '申请人',
  statusTimeline: '状态跟踪',
  comment: '备注'
}

const searchForm = reactive({
  status: '',
  borrowType: '',
  submitTimeStart: '',
  expectedReturnDate: ''
})

const applications = ref<BorrowApplication[]>([])
const selectedApplication = ref<BorrowApplication | null>(null)
const detailDialogVisible = ref(false)
const forceMine = ref(false)
const onlyOverdue = ref(false)
const exactSubmitDate = ref('')
const returnStatusFilter = ref('')
const approvalBucketFilter = ref('')

const isAdmin = computed(() => store.state.user?.role === 'admin')
const isDeptDirector = computed(() => store.getters.isDeptDirector)
const isMedRecordsDirector = computed(() => store.getters.isMedRecordsDirector)
const currentUserDepartment = computed(() => store.getters.userDepartment)
const currentUserId = computed(() => store.state.user?.id)

const isOwnApplication = (app: BorrowApplication) => currentUserId.value != null && app.userId === currentUserId.value

const isOverdue = (expectedReturnDate?: string) => {
  if (!expectedReturnDate) return false
  const today = new Date(); today.setHours(0, 0, 0, 0)
  const d = new Date(expectedReturnDate)
  return !Number.isNaN(d.getTime()) && d < today
}

const isApplicationOverdue = (app: BorrowApplication | null | undefined) => {
  if (!app) return false
  if (['completed', 'cancelled', 'rejected'].includes(app.status)) return false
  return isOverdue(app.expectedReturnDate)
}

const isReturnedOnTime = (app: BorrowApplication) => {
  if (app.status !== 'completed' || !app.expectedReturnDate) return false
  const expectedDate = new Date(app.expectedReturnDate)
  const completedDate = new Date(getApprovalProcessedTime(app))
  if (Number.isNaN(expectedDate.getTime()) || Number.isNaN(completedDate.getTime())) return false
  expectedDate.setHours(23, 59, 59, 999)
  return completedDate.getTime() <= expectedDate.getTime()
}

const isReturnedOverdue = (app: BorrowApplication) => {
  if (app.status !== 'completed' || !app.expectedReturnDate) return false
  const expectedDate = new Date(app.expectedReturnDate)
  const completedDate = new Date(getApprovalProcessedTime(app))
  if (Number.isNaN(expectedDate.getTime()) || Number.isNaN(completedDate.getTime())) return false
  expectedDate.setHours(23, 59, 59, 999)
  return completedDate.getTime() > expectedDate.getTime()
}

const isUnreturned = (app: BorrowApplication) => isApplicationOverdue(app)

const getApprovalProcessedTime = (app: BorrowApplication) => {
  if (app.status === 'completed' && app.returnTime) return app.returnTime
  if (app.approveTime) return app.approveTime
  if (app.updatedTime) return app.updatedTime
  return ''
}

const getApprovalDurationHours = (app: BorrowApplication) => {
  if (!app.submitTime || app.status === 'pending') return -1
  const start = new Date(app.submitTime).getTime()
  const end = new Date(getApprovalProcessedTime(app)).getTime()
  if (Number.isNaN(start) || Number.isNaN(end) || end < start) return -1
  return (end - start) / (1000 * 60 * 60)
}

const pendingCount = computed(() => applications.value.filter(a => a.status === 'pending').length)
const deptApprovedCount = computed(() => applications.value.filter(a => a.status === 'dept_approved').length)
const approvedCount = computed(() => applications.value.filter(a => a.status === 'approved').length)
const rejectedCount = computed(() => applications.value.filter(a => a.status === 'rejected').length)
const pickedCount = computed(() => applications.value.filter(a => a.status === 'picked').length)
const completedCount = computed(() => applications.value.filter(a => a.status === 'completed').length)
const overdueCount = computed(() => applications.value.filter(a => isApplicationOverdue(a)).length)

const filteredApplications = computed(() => {
  let filtered = applications.value.slice()
  if (searchForm.status) {
    if (searchForm.status === 'overdue') filtered = filtered.filter(a => isApplicationOverdue(a))
    else filtered = filtered.filter(a => a.status === searchForm.status)
  }
  if (searchForm.borrowType) filtered = filtered.filter(a => a.borrowType === searchForm.borrowType)
  if (exactSubmitDate.value) {
    const start = new Date(`${exactSubmitDate.value}T00:00:00`).getTime()
    const end = new Date(`${exactSubmitDate.value}T23:59:59`).getTime()
    filtered = filtered.filter(a => {
      if (!a.submitTime) return false
      const submit = new Date(a.submitTime).getTime()
      return !Number.isNaN(submit) && submit >= start && submit <= end
    })
  }
  if (searchForm.submitTimeStart) {
    const start = new Date(`${searchForm.submitTimeStart}T00:00:00`).getTime()
    const end = new Date(`${searchForm.submitTimeStart}T23:59:59`).getTime()
    filtered = filtered.filter(a => {
      if (!a.submitTime) return false
      const submit = new Date(a.submitTime).getTime()
      return !Number.isNaN(submit) && submit >= start && submit <= end
    })
  }
  if (searchForm.expectedReturnDate) {
    filtered = filtered.filter(a => {
      if (!a.expectedReturnDate) return false
      const d = new Date(a.expectedReturnDate)
      if (Number.isNaN(d.getTime())) return false
      const normalized = `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')}`
      return normalized === searchForm.expectedReturnDate
    })
  }
  if (returnStatusFilter.value === 'onTime') filtered = filtered.filter(a => isReturnedOnTime(a))
  else if (returnStatusFilter.value === 'overdueReturn') filtered = filtered.filter(a => isReturnedOverdue(a))
  else if (returnStatusFilter.value === 'unreturned') filtered = filtered.filter(a => isUnreturned(a))
  if (approvalBucketFilter.value) {
    filtered = filtered.filter(a => {
      const hours = getApprovalDurationHours(a)
      if (hours < 0) return false
      if (approvalBucketFilter.value === 'lt4h') return hours < 4
      if (approvalBucketFilter.value === '4to24h') return hours >= 4 && hours < 24
      if (approvalBucketFilter.value === '1to3d') return hours >= 24 && hours < 72
      if (approvalBucketFilter.value === 'gt3d') return hours >= 72
      return true
    })
  }
  if (onlyOverdue.value) filtered = filtered.filter(a => isApplicationOverdue(a))
  return filtered
})

const getStatusType = (target: BorrowApplication | StatusEvent | string) => {
  const status = typeof target === 'string' ? target : target.status
  if (typeof target !== 'string' && 'expectedReturnDate' in target && isApplicationOverdue(target as BorrowApplication)) return 'danger'
  switch (status) {
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

const getStatusText = (target: BorrowApplication | StatusEvent | string) => {
  const status = typeof target === 'string' ? target : target.status
  if (typeof target !== 'string' && 'expectedReturnDate' in target && isApplicationOverdue(target as BorrowApplication)) return t.overdue
  switch (status) {
    case 'pending': return t.pending
    case 'dept_approved': return t.deptApproved
    case 'approved': return t.approved
    case 'rejected': return t.rejected
    case 'picked': return t.picked
    case 'completed': return t.completed
    case 'cancelled': return t.cancelled
    default: return status
  }
}

const getStatusDescription = (target: BorrowApplication | StatusEvent | string) => {
  const status = typeof target === 'string' ? target : target.status
  if (typeof target !== 'string' && 'expectedReturnDate' in target && isApplicationOverdue(target as BorrowApplication)) return '已超过预计归还日期，请尽快归还或处理'
  switch (status) {
    case 'pending': return '申请已提交，等待科室主任批准'
    case 'dept_approved': return '等待病案科主任终审'
    case 'approved': return '申请已批准，可以前往取件'
    case 'rejected': return '申请已被驳回，请查看驳回原因'
    case 'picked': return '已成功取件，请按时归还'
    case 'completed': return '病案已成功归还'
    case 'cancelled': return '申请已取消'
    default: return ''
  }
}

const generateStatusHistory = (app: BorrowApplication): StatusEvent[] => {
  const history: StatusEvent[] = []
  const isAutoApproved = app.approver === '自动审批'
  const isSkipDept = app.deptApprover === '跳过科室审批'
  if (!isAutoApproved && !isSkipDept) {
    history.push({ status: 'pending', time: app.submitTime || '', comment: '申请已提交' })
  }
  if (['dept_approved', 'approved', 'picked', 'completed'].includes(app.status)) {
    if (isSkipDept) {
      history.push({ status: 'dept_approved', time: app.deptApproveTime || app.submitTime || '', comment: '科室主任申请，跳过科室审批' })
    } else if (!isAutoApproved) {
      history.push({ status: 'dept_approved', time: app.deptApproveTime || '', comment: `科室主任${app.deptApprover || ''}已审批通过` })
    }
  }
  if (['approved', 'picked', 'completed'].includes(app.status)) {
    if (isAutoApproved) {
      history.push({ status: 'approved', time: app.approveTime || '', comment: '病案科主任申请，自动审批通过' })
    } else {
      history.push({ status: 'approved', time: app.approveTime || '', comment: `病案科主任${app.approver || ''}已终审通过` })
    }
  }
  if (['picked', 'completed'].includes(app.status)) {
    history.push({ status: 'picked', time: app.updatedTime || '', comment: '已成功取件' })
  }
  if (app.status === 'completed') {
    history.push({ status: 'completed', time: app.returnTime || '', comment: '已归还病案' })
  }
  if (app.status === 'rejected') {
    history.push({ status: 'rejected', time: app.approveTime || app.deptApproveTime || '', comment: '申请被驳回' })
  }
  if (app.status === 'cancelled') {
    history.push({ status: 'cancelled', time: app.updatedTime || '', comment: '申请人主动取消' })
  }
  return history.reverse()
}

const searchApplications = async () => {
  try {
    const user = store.state.user
    if (!user?.id) { ElMessage.error('用户信息不完整，请重新登录'); return }
    let response: BorrowApplication[]
    if (isMedRecordsDirector.value && !forceMine.value) {
      const deptApproved = await service.get<BorrowApplication[]>('/borrow-applications/dept-approved') || []
      const myOwn = await service.get<BorrowApplication[]>(`/borrow-applications/by-user/${user.id}`) || []
      const merged = new Map<number, BorrowApplication>()
      for (const app of deptApproved) merged.set(app.id, app)
      for (const app of myOwn) merged.set(app.id, app)
      response = Array.from(merged.values())
    } else if (isDeptDirector.value && !forceMine.value) {
      response = await service.get<BorrowApplication[]>(`/borrow-applications/by-dept/${encodeURIComponent(currentUserDepartment.value)}`)
    } else if (isAdmin.value && !forceMine.value) {
      response = await service.get<BorrowApplication[]>('/borrow-applications/list')
    } else {
      response = await service.get<BorrowApplication[]>(`/borrow-applications/by-user/${user.id}`)
    }
    applications.value = (response || []).map(app => ({ ...app, statusHistory: generateStatusHistory(app) }))
  } catch (error) {
    console.error('Failed to load borrow applications:', error)
    ElMessage.error('查询借阅申请失败')
  }
}

const resetSearch = () => {
  searchForm.status = ''
  searchForm.borrowType = ''
  searchForm.submitTimeStart = ''
  searchForm.expectedReturnDate = ''
  onlyOverdue.value = false
  exactSubmitDate.value = ''
  returnStatusFilter.value = ''
  approvalBucketFilter.value = ''
  forceMine.value = route.query.mine === '1'
}

const cancelApplication = async (id: number) => {
  try {
    await ElMessageBox.confirm('确定要取消这个借阅申请吗？', '确认取消', { confirmButtonText: '确定', cancelButtonText: '取消', type: 'warning' })
    const user = store.state.user
    const response = await service.put<{ success: boolean }>(`/borrow-applications/${id}/cancel`, { userId: user?.id })
    if (response?.success) { ElMessage.success('申请已取消'); searchApplications() }
    else ElMessage.error('取消申请失败')
  } catch (error: any) {
    if (error !== 'cancel' && error?.action !== 'cancel') ElMessage.error('取消申请失败')
  }
}

const pickupApplication = async (id: number) => {
  try {
    await ElMessageBox.confirm('确认已取到病案吗？', '确认取件', { confirmButtonText: '确定', cancelButtonText: '取消', type: 'warning' })
    const response = await service.put<{ success: boolean }>(`/borrow-applications/${id}/pickup`, {})
    if (response?.success) { ElMessage.success('取件成功'); searchApplications() }
    else ElMessage.error('取件失败')
  } catch (error: any) {
    if (error !== 'cancel' && error?.action !== 'cancel') ElMessage.error('取件失败')
  }
}

const completeApplication = async (id: number) => {
  try {
    await ElMessageBox.confirm('确认已归还病案吗？', '确认归还', { confirmButtonText: '确定', cancelButtonText: '取消', type: 'warning' })
    const response = await service.put<{ success: boolean }>(`/borrow-applications/${id}/complete`, {})
    if (response?.success) { ElMessage.success('归还成功'); searchApplications() }
    else ElMessage.error('归还失败')
  } catch (error: any) {
    if (error !== 'cancel' && error?.action !== 'cancel') ElMessage.error('归还失败')
  }
}

const viewDetail = (app: BorrowApplication) => {
  selectedApplication.value = app
  detailDialogVisible.value = true
}

onMounted(() => {
  if (route.query.mine === '1') forceMine.value = true
  if (typeof route.query.status === 'string') searchForm.status = route.query.status
  if (typeof route.query.borrowType === 'string') searchForm.borrowType = route.query.borrowType
  if (typeof route.query.submitTimeStart === 'string') searchForm.submitTimeStart = route.query.submitTimeStart
  if (typeof route.query.submitTimeDate === 'string') { exactSubmitDate.value = route.query.submitTimeDate; searchForm.submitTimeStart = route.query.submitTimeDate }
  if (typeof route.query.expectedReturnDate === 'string') searchForm.expectedReturnDate = route.query.expectedReturnDate
  if (typeof route.query.returnStatus === 'string') returnStatusFilter.value = route.query.returnStatus
  if (typeof route.query.approvalBucket === 'string') approvalBucketFilter.value = route.query.approvalBucket
  if (route.query.overdue === '1') { onlyOverdue.value = true; if (!searchForm.status) searchForm.status = 'overdue' }
  searchApplications()
})
</script>

<style scoped>
.borrow-history-container {
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

.help-icon {
  color: var(--color-text-tertiary);
  cursor: pointer;
  font-size: 20px;
}

.help-icon:hover { color: var(--color-primary); }

.history-card {
  margin-bottom: var(--space-lg);
}

.search-section {
  margin-bottom: var(--space-lg);
}

.search-form {
  flex-wrap: wrap;
  gap: 8px;
}

.search-form .el-form-item {
  margin-bottom: 12px;
}

/* Status Stats */
.status-stats {
  display: grid;
  grid-template-columns: repeat(7, 1fr);
  gap: 12px;
  margin-bottom: var(--space-lg);
}

.status-stat-item {
  text-align: center;
  padding: 16px 12px;
  background: var(--color-bg-secondary);
  border-radius: var(--radius-md);
  border: 1px solid var(--color-border-light);
  transition: all var(--transition-fast);
}

.status-stat-item:hover {
  border-color: var(--color-primary);
  background: var(--color-primary-lighter);
}

.status-count {
  display: block;
  font-size: var(--font-size-3xl);
  font-weight: var(--font-weight-bold);
  line-height: 1.2;
}

.status-count--warning { color: var(--color-warning); }
.status-count--primary { color: var(--color-primary); }
.status-count--success { color: var(--color-success); }
.status-count--danger { color: var(--color-danger); }
.status-count--info { color: var(--color-info); }
.status-count--default { color: var(--color-text-primary); }

.status-label {
  display: block;
  font-size: var(--font-size-sm);
  color: var(--color-text-secondary);
  margin-top: 4px;
}

/* Table */
.data-table {
  border-radius: var(--radius-md);
  overflow: hidden;
}

.status-cell {
  display: flex;
  align-items: center;
  gap: 4px;
}

.status-info-icon {
  cursor: pointer;
  color: var(--color-text-tertiary);
  font-size: 14px;
}

.status-info-icon:hover { color: var(--color-primary); }

.text-danger {
  color: var(--color-danger);
  font-weight: var(--font-weight-semibold);
}

.action-buttons {
  display: flex;
  gap: 6px;
  flex-wrap: wrap;
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

.timeline-card {
  padding: 2px 0;
}

.timeline-title {
  font-weight: var(--font-weight-semibold);
  color: var(--color-text-primary);
  margin-bottom: 4px;
}

.timeline-desc {
  font-size: var(--font-size-sm);
  color: var(--color-text-secondary);
  margin-bottom: 4px;
}

.timeline-comment {
  font-size: var(--font-size-xs);
  color: var(--color-text-tertiary);
  font-style: italic;
}

/* Responsive */
@media (max-width: 1200px) {
  .status-stats {
    grid-template-columns: repeat(4, 1fr);
  }
}

@media (max-width: 768px) {
  .borrow-history-container {
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

  .search-form {
    flex-direction: column;
    align-items: stretch;
  }

  .search-form .el-form-item {
    margin-right: 0;
  }

  .status-stats {
    grid-template-columns: repeat(2, 1fr);
  }

  .detail-grid {
    grid-template-columns: 1fr;
  }
}

@media (max-width: 480px) {
  .status-stats {
    grid-template-columns: 1fr;
  }
}
</style>
