<template>
  <div class="borrow-history-container">
    <el-card class="borrow-history-card">
      <template #header>
        <div class="card-header">
          <span>&#20511;&#38405;&#21382;&#21490;&#19982;&#29366;&#24577;&#36319;&#36394;</span>
          <el-tooltip
            content="&#26597;&#30475;&#25152;&#26377;&#20511;&#38405;&#30003;&#35831;&#30340;&#23457;&#25209;&#29366;&#24577;&#21644;&#22788;&#29702;&#36827;&#24230;"
            placement="top"
          >
            <el-icon><QuestionFilled /></el-icon>
          </el-tooltip>
        </div>
      </template>

      <div class="search-section">
        <el-form :model="searchForm" :inline="true" class="search-form">
          <el-form-item :label="t.status">
            <el-select v-model="searchForm.status" :placeholder="t.selectStatus" clearable>
              <el-option :label="t.all" value="" />
              <el-option :label="t.pendingDept" value="pending_dept" />
              <el-option :label="t.pendingArchive" value="pending_archive" />
              <el-option :label="t.approved" value="approved" />
              <el-option :label="t.rejected" value="rejected" />
              <el-option :label="t.picked" value="picked" />
              <el-option :label="t.completed" value="completed" />
              <el-option :label="t.cancelled" value="cancelled" />
              <el-option :label="t.overdue" value="overdue" />
            </el-select>
          </el-form-item>

          <el-form-item :label="t.borrowType">
            <el-select v-model="searchForm.borrowType" :placeholder="t.selectBorrowType" clearable>
              <el-option :label="t.all" value="" />
              <el-option :label="t.internalBorrow" :value="t.internalBorrow" />
              <el-option :label="t.externalBorrow" :value="t.externalBorrow" />
            </el-select>
          </el-form-item>

          <el-form-item :label="t.submitTimeLabel">
            <el-date-picker
              v-model="searchForm.submitTimeStart"
              type="date"
              :placeholder="t.selectSubmitDate"
              clearable
              value-format="YYYY-MM-DD"
            />
          </el-form-item>

          <el-form-item :label="t.expectedReturnDate">
            <el-date-picker
              v-model="searchForm.expectedReturnDate"
              type="date"
              :placeholder="t.selectExactDate"
              clearable
              value-format="YYYY-MM-DD"
            />
          </el-form-item>

          <el-form-item>
            <el-button type="primary" @click="searchApplications">{{ t.search }}</el-button>
            <el-button @click="resetSearch">{{ t.reset }}</el-button>
          </el-form-item>
        </el-form>

        <div class="status-stats">
          <div class="status-stat-item">
            <span class="status-count">{{ pendingDeptCount }}</span>
            <span class="status-label">{{ t.pendingDept }}</span>
          </div>
          <div class="status-stat-item">
            <span class="status-count">{{ pendingArchiveCount }}</span>
            <span class="status-label">{{ t.pendingArchive }}</span>
          </div>
          <div class="status-stat-item">
            <span class="status-count">{{ approvedCount }}</span>
            <span class="status-label">{{ t.approved }}</span>
          </div>
          <div class="status-stat-item">
            <span class="status-count">{{ rejectedCount }}</span>
            <span class="status-label">{{ t.rejected }}</span>
          </div>
          <div class="status-stat-item">
            <span class="status-count">{{ pickedCount }}</span>
            <span class="status-label">{{ t.picked }}</span>
          </div>
          <div class="status-stat-item">
            <span class="status-count">{{ completedCount }}</span>
            <span class="status-label">{{ t.completed }}</span>
          </div>
          <div class="status-stat-item">
            <span class="status-count">{{ overdueCount }}</span>
            <span class="status-label">{{ t.overdue }}</span>
          </div>
        </div>
      </div>

      <el-table :data="filteredApplications" style="width: 100%; height: 500px" border>
        <el-table-column prop="id" :label="t.applicationId" width="100" />
        <el-table-column prop="recordNumbers" :label="t.recordNumbers" show-overflow-tooltip />
        <el-table-column prop="borrowType" :label="t.borrowType" width="120">
          <template #default="{ row }">
            <el-tag :type="row.borrowType === t.internalBorrow ? 'success' : 'info'">
              {{ row.borrowType }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="reason" :label="t.reason" show-overflow-tooltip />
        <el-table-column prop="expectedReturnDate" :label="t.expectedReturnDate" width="150">
          <template #default="{ row }">
            <span :class="{ overdue: isOverdue(row.expectedReturnDate) }">
              {{ row.expectedReturnDate || '-' }}
            </span>
          </template>
        </el-table-column>
        <el-table-column :label="t.status" width="180">
          <template #default="{ row }">
            <div class="status-container">
              <el-tag :type="getStatusType(row)" effect="dark">
                {{ getStatusText(row) }}
              </el-tag>
              <el-tooltip :content="getStatusDescription(row)" placement="top">
                <el-icon class="status-icon"><InfoFilled /></el-icon>
              </el-tooltip>
            </div>
          </template>
        </el-table-column>
        <el-table-column prop="submitTime" :label="t.submitTime" width="180" />
        <el-table-column prop="updatedTime" :label="t.updateTime" width="180" />
        <el-table-column :label="t.actions" width="400" fixed="right">
          <template #default="{ row }">
            <el-button size="small" @click="viewDetail(row)">{{ t.detail }}</el-button>

            <!-- 科室审批员：只能审批待科室审批的申请 -->
            <template v-if="store.state.user?.role === 'dept_approver'">
              <el-button
                v-if="row.status === 'pending_dept'"
                type="success"
                size="small"
                @click="deptApproveApplication(row.id)"
              >
                {{ t.deptApprove }}
              </el-button>
              <el-button
                v-if="row.status === 'pending_dept'"
                type="danger"
                size="small"
                @click="deptRejectApplication(row.id)"
              >
                {{ t.reject }}
              </el-button>
            </template>

            <!-- 病案室审批员：只能审批待病案室审批的申请 -->
            <template v-else-if="store.state.user?.role === 'archive_approver'">
              <el-button
                v-if="row.status === 'pending_archive'"
                type="success"
                size="small"
                @click="archiveApproveApplication(row.id)"
              >
                {{ t.archiveApprove }}
              </el-button>
              <el-button
                v-if="row.status === 'pending_archive'"
                type="danger"
                size="small"
                @click="archiveRejectApplication(row.id)"
              >
                {{ t.reject }}
              </el-button>
            </template>

            <!-- 系统管理员：可以执行所有审批操作 -->
            <template v-else-if="isAdmin">
              <el-button
                v-if="row.status === 'pending_dept'"
                type="success"
                size="small"
                @click="deptApproveApplication(row.id)"
              >
                {{ t.deptApprove }}
              </el-button>
              <el-button
                v-if="row.status === 'pending_dept'"
                type="danger"
                size="small"
                @click="deptRejectApplication(row.id)"
              >
                {{ t.reject }}
              </el-button>
              <el-button
                v-if="row.status === 'pending_archive'"
                type="success"
                size="small"
                @click="archiveApproveApplication(row.id)"
              >
                {{ t.archiveApprove }}
              </el-button>
              <el-button
                v-if="row.status === 'pending_archive'"
                type="danger"
                size="small"
                @click="archiveRejectApplication(row.id)"
              >
                {{ t.reject }}
              </el-button>
            </template>

            <!-- 普通用户：只能对自己的申请进行操作 -->
            <template v-else>
              <el-button
                v-if="row.status === 'pending_dept' || row.status === 'pending_archive'"
                type="danger"
                size="small"
                @click="cancelApplication(row.id)"
              >
                {{ t.cancel }}
              </el-button>
              <el-button
                v-if="row.status === 'approved'"
                type="primary"
                size="small"
                @click="pickupApplication(row.id)"
              >
                {{ t.pickup }}
              </el-button>
              <el-button
                v-if="row.status === 'picked'"
                type="success"
                size="small"
                @click="completeApplication(row.id)"
              >
                {{ t.complete }}
              </el-button>
            </template>
          </template>
        </el-table-column>
      </el-table>

      <el-dialog v-model="detailDialogVisible" :title="t.detailTitle" width="800px">
        <div v-if="selectedApplication" class="application-detail">
          <div class="detail-section">
            <h3>{{ t.basicInfo }}</h3>
            <div class="detail-item">
              <span class="label">{{ t.applicationId }}:</span>
              <span class="value">{{ selectedApplication.id }}</span>
            </div>
            <div class="detail-item">
              <span class="label">{{ t.recordNumbers }}:</span>
              <span class="value">{{ selectedApplication.recordNumbers || '-' }}</span>
            </div>
            <div class="detail-item">
              <span class="label">{{ t.borrowType }}:</span>
              <span class="value">{{ selectedApplication.borrowType || '-' }}</span>
            </div>
            <div class="detail-item">
              <span class="label">{{ t.reason }}:</span>
              <span class="value">{{ selectedApplication.reason || '-' }}</span>
            </div>
            <div class="detail-item">
              <span class="label">{{ t.expectedReturnDate }}:</span>
              <span class="value">{{ selectedApplication.expectedReturnDate || '-' }}</span>
            </div>
            <div class="detail-item">
              <span class="label">{{ t.applicant }}:</span>
              <span class="value">{{ selectedApplication.userName || '-' }}</span>
            </div>
            <div class="detail-item">
              <span class="label">{{ t.department }}:</span>
              <span class="value">{{ selectedApplication.department || '-' }}</span>
            </div>
          </div>

          <div class="detail-section">
            <h3>{{ t.statusTimeline }}</h3>
            <el-timeline>
              <el-timeline-item
                v-for="(event, index) in selectedApplication.statusHistory"
                :key="index"
                :timestamp="event.time"
                :type="getStatusType(event.status)"
              >
                <el-card shadow="hover" class="timeline-card">
                  <div class="timeline-content">
                    <div class="status-title">{{ getStatusText(event.status) }}</div>
                    <div class="status-desc">{{ getStatusDescription(event.status) }}</div>
                    <div v-if="event.comment" class="status-comment">{{ t.comment }}: {{ event.comment }}</div>
                  </div>
                </el-card>
              </el-timeline-item>
            </el-timeline>
          </div>
        </div>
      </el-dialog>
    </el-card>
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
  department?: string
  // 科室审批相关字段
  deptApprover?: string
  deptApproveTime?: string
  deptRejectionReason?: string
  // 病案室审批相关字段
  archiveApprover?: string
  archiveApproveTime?: string
  archiveRejectionReason?: string
  // 兼容旧字段
  approver?: string
  rejectionReason?: string
  statusHistory?: StatusEvent[]
}

interface StatusEvent {
  status: string
  time: string
  comment?: string
}

const route = useRoute()

const t = {
  all: '\u5168\u90e8',
  status: '\u72b6\u6001',
  overdue: '\u5df2\u8fc7\u671f',
  pendingDept: '\u5f85\u79d1\u5ba4\u5ba1\u6279',
  pendingArchive: '\u5f85\u75c5\u6848\u5ba4\u5ba1\u6279',
  pending: '\u5f85\u5ba1\u6279',
  approved: '\u5df2\u6279\u51c6',
  rejected: '\u5df2\u9a73\u56de',
  picked: '\u5df2\u53d6\u4ef6',
  completed: '\u5df2\u5b8c\u6210',
  cancelled: '\u5df2\u53d6\u6d88',
  borrowType: '\u501f\u9605\u7c7b\u578b',
  internalBorrow: '\u9662\u5185\u501f\u9605',
  externalBorrow: '\u9662\u5916\u501f\u9605',
  submitTimeLabel: '\u7533\u8bf7\u65f6\u95f4',
  expectedReturnDate: '\u9884\u8ba1\u5f52\u8fd8\u65e5\u671f',
  selectStatus: '\u8bf7\u9009\u62e9\u72b6\u6001',
  selectBorrowType: '\u8bf7\u9009\u62e9\u501f\u9605\u7c7b\u578b',
  selectSubmitDate: '\u8bf7\u9009\u62e9\u7533\u8bf7\u65e5\u671f',
  selectExactDate: '\u8bf7\u9009\u62e9\u5177\u4f53\u65e5\u671f',
  search: '\u67e5\u8be2',
  reset: '\u91cd\u7f6e',
  applicationId: '\u7533\u8bf7ID',
  recordNumbers: '\u75c5\u6848\u53f7',
  reason: '\u501f\u9605\u539f\u56e0',
  submitTime: '\u63d0\u4ea4\u65f6\u95f4',
  updateTime: '\u66f4\u65b0\u65f6\u95f4',
  actions: '\u64cd\u4f5c',
  detail: '\u8be6\u60c5',
  approve: '\u6279\u51c6',
  deptApprove: '\u79d1\u5ba4\u540c\u610f',
  archiveApprove: '\u75c5\u6848\u5ba4\u540c\u610f',
  reject: '\u9a73\u56de',
  cancel: '\u53d6\u6d88',
  pickup: '\u53d6\u4ef6',
  complete: '\u5f52\u8fd8',
  detailTitle: '\u7533\u8bf7\u8be6\u60c5',
  basicInfo: '\u57fa\u672c\u4fe1\u606f',
  applicant: '\u7533\u8bf7\u4eba',
  department: '\u79d1\u5ba4',
  statusTimeline: '\u72b6\u6001\u8ddf\u8e2a',
  comment: '\u5907\u6ce8',
  deptApproval: '\u79d1\u5ba4\u5ba1\u6279',
  archiveApproval: '\u75c5\u6848\u5ba4\u5ba1\u6279',
  approvalInfo: '\u5ba1\u6279\u4fe1\u606f'
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
const isDeptApprover = computed(() => store.state.user?.role === 'dept_approver')
const isArchiveApprover = computed(() => store.state.user?.role === 'archive_approver')
const userDepartment = computed(() => store.state.user?.department || '')

const isOverdue = (expectedReturnDate?: string) => {
  if (!expectedReturnDate) return false
  const today = new Date()
  today.setHours(0, 0, 0, 0)
  const returnDate = new Date(expectedReturnDate)
  if (Number.isNaN(returnDate.getTime())) return false
  return returnDate < today
}

const isApplicationOverdue = (application: BorrowApplication | null | undefined) => {
  if (!application) return false
  if (['completed', 'cancelled', 'rejected'].includes(application.status)) return false
  return isOverdue(application.expectedReturnDate)
}

const isReturnedOnTime = (application: BorrowApplication) => {
  if (application.status !== 'completed' || !application.expectedReturnDate) return false
  const expectedDate = new Date(application.expectedReturnDate)
  const completedDate = new Date(getApprovalProcessedTime(application))
  if (Number.isNaN(expectedDate.getTime()) || Number.isNaN(completedDate.getTime())) return false
  expectedDate.setHours(23, 59, 59, 999)
  return completedDate.getTime() <= expectedDate.getTime()
}

const isReturnedOverdue = (application: BorrowApplication) => {
  if (application.status !== 'completed' || !application.expectedReturnDate) return false
  const expectedDate = new Date(application.expectedReturnDate)
  const completedDate = new Date(getApprovalProcessedTime(application))
  if (Number.isNaN(expectedDate.getTime()) || Number.isNaN(completedDate.getTime())) return false
  expectedDate.setHours(23, 59, 59, 999)
  return completedDate.getTime() > expectedDate.getTime()
}

const isUnreturned = (application: BorrowApplication) => isApplicationOverdue(application)

const getApprovalProcessedTime = (application: BorrowApplication) => {
  if (application.status === 'completed' && application.returnTime) {
    return application.returnTime
  }
  if (application.approveTime) {
    return application.approveTime
  }
  if (application.updatedTime) {
    return application.updatedTime
  }
  return ''
}

const getApprovalDurationHours = (application: BorrowApplication) => {
  if (!application.submitTime) return -1
  if (application.status === 'pending') return -1

  const start = new Date(application.submitTime).getTime()
  const end = new Date(getApprovalProcessedTime(application)).getTime()
  if (Number.isNaN(start) || Number.isNaN(end) || end < start) return -1

  return (end - start) / (1000 * 60 * 60)
}

const pendingDeptCount = computed(() => applications.value.filter((app) => app.status === 'pending_dept').length)
const pendingArchiveCount = computed(() => applications.value.filter((app) => app.status === 'pending_archive').length)
const pendingCount = computed(() => applications.value.filter((app) => ['pending', 'pending_dept', 'pending_archive'].includes(app.status)).length)
const approvedCount = computed(() => applications.value.filter((app) => app.status === 'approved').length)
const rejectedCount = computed(() => applications.value.filter((app) => app.status === 'rejected').length)
const pickedCount = computed(() => applications.value.filter((app) => app.status === 'picked').length)
const completedCount = computed(() => applications.value.filter((app) => app.status === 'completed').length)
const overdueCount = computed(() => applications.value.filter((app) => isApplicationOverdue(app)).length)

const filteredApplications = computed(() => {
  let filtered = applications.value.slice()

  if (searchForm.status) {
    if (searchForm.status === 'overdue') {
      filtered = filtered.filter((app) => isApplicationOverdue(app))
    } else {
      filtered = filtered.filter((app) => app.status === searchForm.status)
    }
  }

  if (searchForm.borrowType) {
    filtered = filtered.filter((app) => app.borrowType === searchForm.borrowType)
  }

  if (exactSubmitDate.value) {
    const start = new Date(`${exactSubmitDate.value}T00:00:00`).getTime()
    const end = new Date(`${exactSubmitDate.value}T23:59:59`).getTime()
    filtered = filtered.filter((app) => {
      if (!app.submitTime) return false
      const submit = new Date(app.submitTime).getTime()
      return !Number.isNaN(submit) && submit >= start && submit <= end
    })
  }

  if (searchForm.submitTimeStart) {
    const start = new Date(`${searchForm.submitTimeStart}T00:00:00`).getTime()
    const end = new Date(`${searchForm.submitTimeStart}T23:59:59`).getTime()
    filtered = filtered.filter((app) => {
      if (!app.submitTime) return false
      const submit = new Date(app.submitTime).getTime()
      return !Number.isNaN(submit) && submit >= start && submit <= end
    })
  }

  if (searchForm.expectedReturnDate) {
    filtered = filtered.filter((app) => {
      if (!app.expectedReturnDate) return false
      const returnDate = new Date(app.expectedReturnDate)
      if (Number.isNaN(returnDate.getTime())) return false
      const normalizedDate = `${returnDate.getFullYear()}-${String(returnDate.getMonth() + 1).padStart(2, '0')}-${String(returnDate.getDate()).padStart(2, '0')}`
      return normalizedDate === searchForm.expectedReturnDate
    })
  }

  if (returnStatusFilter.value === 'onTime') {
    filtered = filtered.filter((app) => isReturnedOnTime(app))
  } else if (returnStatusFilter.value === 'overdueReturn') {
    filtered = filtered.filter((app) => isReturnedOverdue(app))
  } else if (returnStatusFilter.value === 'unreturned') {
    filtered = filtered.filter((app) => isUnreturned(app))
  }

  if (approvalBucketFilter.value) {
    filtered = filtered.filter((app) => {
      const hours = getApprovalDurationHours(app)
      if (hours < 0) return false
      if (approvalBucketFilter.value === 'lt4h') return hours < 4
      if (approvalBucketFilter.value === '4to24h') return hours >= 4 && hours < 24
      if (approvalBucketFilter.value === '1to3d') return hours >= 24 && hours < 72
      if (approvalBucketFilter.value === 'gt3d') return hours >= 72
      return true
    })
  }

  if (onlyOverdue.value) {
    filtered = filtered.filter((app) => isApplicationOverdue(app))
  }

  return filtered
})

const getStatusType = (target: BorrowApplication | StatusEvent | string) => {
  const status = typeof target === 'string' ? target : target.status
  if (typeof target !== 'string' && 'expectedReturnDate' in target && isApplicationOverdue(target as BorrowApplication)) {
    return 'danger'
  }

  switch (status) {
    case 'pending_dept':
      return 'warning'
    case 'pending_archive':
      return 'warning'
    case 'pending':
      return 'warning'
    case 'approved':
      return 'success'
    case 'rejected':
      return 'danger'
    case 'picked':
      return 'primary'
    case 'completed':
      return 'info'
    case 'cancelled':
      return 'info'
    default:
      return ''
  }
}

const getStatusText = (target: BorrowApplication | StatusEvent | string) => {
  const status = typeof target === 'string' ? target : target.status
  if (typeof target !== 'string' && 'expectedReturnDate' in target && isApplicationOverdue(target as BorrowApplication)) {
    return t.overdue
  }

  switch (status) {
    case 'pending_dept':
      return t.pendingDept
    case 'pending_archive':
      return t.pendingArchive
    case 'pending':
      return t.pending
    case 'approved':
      return t.approved
    case 'rejected':
      return t.rejected
    case 'picked':
      return t.picked
    case 'completed':
      return t.completed
    case 'cancelled':
      return t.cancelled
    default:
      return status
  }
}

const getStatusDescription = (target: BorrowApplication | StatusEvent | string) => {
  const status = typeof target === 'string' ? target : target.status
  if (typeof target !== 'string' && 'expectedReturnDate' in target && isApplicationOverdue(target as BorrowApplication)) {
    return '\u5df2\u8d85\u8fc7\u9884\u8ba1\u5f52\u8fd8\u65e5\u671f\uff0c\u8bf7\u5c3d\u5feb\u5f52\u8fd8\u6216\u5904\u7406'
  }

  switch (status) {
    case 'pending_dept':
      return '\u7533\u8bf7\u5df2\u63d0\u4ea4\uff0c\u7b49\u5f85\u79d1\u5ba4\u5ba1\u6279\u5458\u5ba1\u6279'
    case 'pending_archive':
      return '\u79d1\u5ba4\u5df2\u540c\u610f\uff0c\u7b49\u5f85\u75c5\u6848\u5ba4\u5ba1\u6279\u5458\u5ba1\u6279'
    case 'pending':
      return '\u7533\u8bf7\u5df2\u63d0\u4ea4\uff0c\u7b49\u5f85\u7ba1\u7406\u5458\u5ba1\u6279'
    case 'approved':
      return '\u7533\u8bf7\u5df2\u6279\u51c6\uff0c\u53ef\u4ee5\u524d\u5f80\u53d6\u4ef6'
    case 'rejected':
      return '\u7533\u8bf7\u5df2\u88ab\u9a73\u56de\uff0c\u8bf7\u67e5\u770b\u9a73\u56de\u539f\u56e0'
    case 'picked':
      return '\u5df2\u6210\u529f\u53d6\u4ef6\uff0c\u8bf7\u6309\u65f6\u5f52\u8fd8'
    case 'completed':
      return '\u75c5\u6848\u5df2\u6210\u529f\u5f52\u8fd8'
    case 'cancelled':
      return '\u7533\u8bf7\u5df2\u53d6\u6d88'
    default:
      return ''
  }
}

const generateStatusHistory = (application: BorrowApplication): StatusEvent[] => {
  const history: StatusEvent[] = []
  const now = new Date()

  // 提交申请
  history.push({
    status: 'pending_dept',
    time: application.submitTime || now.toLocaleString(),
    comment: '\u7533\u8bf7\u5df2\u63d0\u4ea4\uff0c\u7b49\u5f85\u79d1\u5ba4\u5ba1\u6279'
  })

  // 科室审批
  if (['pending_archive', 'approved', 'picked', 'completed'].includes(application.status)) {
    history.push({
      status: 'pending_archive',
      time: application.deptApproveTime || new Date(now.getTime() - 86400000).toLocaleString(),
      comment: `\u79d1\u5ba4\u5df2\u540c\u610f${application.deptApprover ? '（审批人：' + application.deptApprover + '）' : ''}`
    })
  }

  // 病案室审批
  if (['approved', 'picked', 'completed'].includes(application.status)) {
    history.push({
      status: 'approved',
      time: application.archiveApproveTime || new Date(now.getTime() - 43200000).toLocaleString(),
      comment: `\u75c5\u6848\u5ba4\u5df2\u6279\u51c6${application.archiveApprover ? '（审批人：' + application.archiveApprover + '）' : ''}`
    })
  }

  // 取件
  if (['picked', 'completed'].includes(application.status)) {
    history.push({
      status: 'picked',
      time: new Date(now.getTime() - 21600000).toLocaleString(),
      comment: '\u5df2\u6210\u529f\u53d6\u4ef6'
    })
  }

  // 归还
  if (application.status === 'completed') {
    history.push({
      status: 'completed',
      time: now.toLocaleString(),
      comment: '\u5df2\u5f52\u8fd8\u75c5\u6848'
    })
  }

  // 驳回（科室驳回）
  if (application.status === 'rejected' && application.deptRejectionReason) {
    history.push({
      status: 'rejected',
      time: application.deptApproveTime || new Date(now.getTime() - 86400000).toLocaleString(),
      comment: `\u79d1\u5ba4\u9a73\u56de\uff1a${application.deptRejectionReason}`
    })
  }

  // 驳回（病案室驳回）
  if (application.status === 'rejected' && application.archiveRejectionReason) {
    history.push({
      status: 'rejected',
      time: application.archiveApproveTime || new Date(now.getTime() - 86400000).toLocaleString(),
      comment: `\u75c5\u6848\u5ba4\u9a73\u56de\uff1a${application.archiveRejectionReason}`
    })
  }

  // 兼容旧版驳回
  if (application.status === 'rejected' && !application.deptRejectionReason && !application.archiveRejectionReason) {
    history.push({
      status: 'rejected',
      time: application.approveTime || new Date(now.getTime() - 86400000).toLocaleString(),
      comment: `\u7533\u8bf7\u88ab\u9a73\u56de${application.rejectionReason ? '：' + application.rejectionReason : ''}`
    })
  }

  // 取消
  if (application.status === 'cancelled') {
    history.push({
      status: 'cancelled',
      time: new Date(now.getTime() - 86400000).toLocaleString(),
      comment: '\u7533\u8bf7\u4eba\u4e3b\u52a8\u53d6\u6d88'
    })
  }

  return history.reverse()
}

const searchApplications = async () => {
  try {
    const user = store.state.user
    if (!user?.id) {
      ElMessage.error('\u7528\u6237\u4fe1\u606f\u4e0d\u5b8c\u6574\uff0c\u8bf7\u91cd\u65b0\u767b\u5f55')
      return
    }

    let response: BorrowApplication[]

    // 根据角色获取不同的数据
    if (isAdmin.value && !forceMine.value) {
      // 管理员可以看到所有申请
      response = await service.get<BorrowApplication[]>('/borrow-applications/list')
    } else if (isDeptApprover.value) {
      // 科室审批员只能看到自己科室的待科室审批申请
      response = await service.get<BorrowApplication[]>(`/borrow-applications/pending-dept/by-department/${encodeURIComponent(userDepartment.value)}`)
    } else if (isArchiveApprover.value) {
      // 病案室审批员可以看到所有待病案室审批的申请
      response = await service.get<BorrowApplication[]>('/borrow-applications/pending-archive')
    } else {
      // 普通用户只能看到自己的申请
      response = await service.get<BorrowApplication[]>(`/borrow-applications/by-user/${user.id}`)
    }

    applications.value = (response || []).map((app) => ({
      ...app,
      statusHistory: generateStatusHistory(app)
    }))
  } catch (error) {
    console.error('Failed to load borrow applications:', error)
    ElMessage.error('\u67e5\u8be2\u501f\u9605\u7533\u8bf7\u5931\u8d25')
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
    await ElMessageBox.confirm('\u786e\u5b9a\u8981\u53d6\u6d88\u8fd9\u4e2a\u501f\u9605\u7533\u8bf7\u5417\uff1f', '\u786e\u8ba4\u53d6\u6d88', {
      confirmButtonText: '\u786e\u5b9a',
      cancelButtonText: '\u53d6\u6d88',
      type: 'warning'
    })

    const user = store.state.user
    const response = await service.put<{ success: boolean }>(`/borrow-applications/${id}/cancel`, { userId: user?.id })
    if (response?.success) {
      ElMessage.success('\u7533\u8bf7\u5df2\u53d6\u6d88')
      searchApplications()
    } else {
      ElMessage.error('\u53d6\u6d88\u7533\u8bf7\u5931\u8d25')
    }
  } catch (error: any) {
    if (error !== 'cancel' && error?.action !== 'cancel') {
      ElMessage.error('\u53d6\u6d88\u7533\u8bf7\u5931\u8d25')
    }
  }
}

const approveApplication = async (id: number) => {
  try {
    await ElMessageBox.confirm('\u786e\u5b9a\u8981\u6279\u51c6\u8fd9\u4e2a\u501f\u9605\u7533\u8bf7\u5417\uff1f', '\u786e\u8ba4\u6279\u51c6', {
      confirmButtonText: '\u786e\u5b9a',
      cancelButtonText: '\u53d6\u6d88',
      type: 'success'
    })

    const response = await service.put<{ success: boolean }>(`/borrow-applications/${id}/approve`, {
      approver: store.state.user?.name
    })
    if (response?.success) {
      ElMessage.success('\u7533\u8bf7\u5df2\u6279\u51c6')
      searchApplications()
    } else {
      ElMessage.error('\u6279\u51c6\u7533\u8bf7\u5931\u8d25')
    }
  } catch (error: any) {
    if (error !== 'cancel' && error?.action !== 'cancel') {
      ElMessage.error('\u6279\u51c6\u7533\u8bf7\u5931\u8d25')
    }
  }
}

const rejectApplication = async (id: number) => {
  try {
    const { value } = await ElMessageBox.prompt(
      '\u8bf7\u8f93\u5165\u9a73\u56de\u539f\u56e0',
      '\u786e\u8ba4\u9a73\u56de',
      {
        confirmButtonText: '\u786e\u5b9a',
        cancelButtonText: '\u53d6\u6d88',
        type: 'warning',
        inputPlaceholder: '\u8bf7\u8f93\u5165\u9a73\u56de\u539f\u56e0'
      }
    )

    if (!value?.trim()) {
      ElMessage.warning('\u9a73\u56de\u539f\u56e0\u4e0d\u80fd\u4e3a\u7a7a')
      return
    }

    const response = await service.put<{ success: boolean }>(`/borrow-applications/${id}/reject`, {
      approver: store.state.user?.name,
      rejectionReason: value
    })
    if (response?.success) {
      ElMessage.success('\u7533\u8bf7\u5df2\u9a73\u56de')
      searchApplications()
    } else {
      ElMessage.error('\u9a73\u56de\u7533\u8bf7\u5931\u8d25')
    }
  } catch (error: any) {
    if (error !== 'cancel' && error?.action !== 'cancel') {
      ElMessage.error('\u9a73\u56de\u7533\u8bf7\u5931\u8d25')
    }
  }
}

const pickupApplication = async (id: number) => {
  try {
    await ElMessageBox.confirm('\u786e\u8ba4\u5df2\u53d6\u5230\u75c5\u6848\u5417\uff1f', '\u786e\u8ba4\u53d6\u4ef6', {
      confirmButtonText: '\u786e\u5b9a',
      cancelButtonText: '\u53d6\u6d88',
      type: 'warning'
    })

    const response = await service.put<{ success: boolean }>(`/borrow-applications/${id}/pickup`, {})
    if (response?.success) {
      ElMessage.success('\u53d6\u4ef6\u6210\u529f')
      searchApplications()
    } else {
      ElMessage.error('\u53d6\u4ef6\u5931\u8d25')
    }
  } catch (error: any) {
    if (error !== 'cancel' && error?.action !== 'cancel') {
      ElMessage.error('\u53d6\u4ef6\u5931\u8d25')
    }
  }
}

const completeApplication = async (id: number) => {
  try {
    await ElMessageBox.confirm('\u786e\u8ba4\u5df2\u5f52\u8fd8\u75c5\u6848\u5417\uff1f', '\u786e\u8ba4\u5f52\u8fd8', {
      confirmButtonText: '\u786e\u5b9a',
      cancelButtonText: '\u53d6\u6d88',
      type: 'warning'
    })

    const response = await service.put<{ success: boolean }>(`/borrow-applications/${id}/complete`, {})
    if (response?.success) {
      ElMessage.success('\u5f52\u8fd8\u6210\u529f')
      searchApplications()
    } else {
      ElMessage.error('\u5f52\u8fd8\u5931\u8d25')
    }
  } catch (error: any) {
    if (error !== 'cancel' && error?.action !== 'cancel') {
      ElMessage.error('\u5f52\u8fd8\u5931\u8d25')
    }
  }
}

// 科室审批通过
const deptApproveApplication = async (id: number) => {
  try {
    await ElMessageBox.confirm('\u786e\u5b9a\u8981\u540c\u610f\u8fd9\u4e2a\u501f\u9605\u7533\u8bf7\u5417\uff1f', '\u786e\u8ba4\u79d1\u5ba4\u540c\u610f', {
      confirmButtonText: '\u786e\u5b9a',
      cancelButtonText: '\u53d6\u6d88',
      type: 'success'
    })

    const response = await service.put<{ success: boolean }>(`/borrow-applications/${id}/dept-approve`, {
      approver: store.state.user?.name
    })
    if (response?.success) {
      ElMessage.success('\u79d1\u5ba4\u5df2\u540c\u610f')
      searchApplications()
    } else {
      ElMessage.error('\u79d1\u5ba4\u5ba1\u6279\u5931\u8d25')
    }
  } catch (error: any) {
    if (error !== 'cancel' && error?.action !== 'cancel') {
      ElMessage.error('\u79d1\u5ba4\u5ba1\u6279\u5931\u8d25')
    }
  }
}

// 科室审批驳回
const deptRejectApplication = async (id: number) => {
  try {
    const { value } = await ElMessageBox.prompt(
      '\u8bf7\u8f93\u5165\u9a73\u56de\u539f\u56e0',
      '\u786e\u8ba4\u79d1\u5ba4\u9a73\u56de',
      {
        confirmButtonText: '\u786e\u5b9a',
        cancelButtonText: '\u53d6\u6d88',
        type: 'warning',
        inputPlaceholder: '\u8bf7\u8f93\u5165\u9a73\u56de\u539f\u56e0'
      }
    )

    if (!value?.trim()) {
      ElMessage.warning('\u9a73\u56de\u539f\u56e0\u4e0d\u80fd\u4e3a\u7a7a')
      return
    }

    const response = await service.put<{ success: boolean }>(`/borrow-applications/${id}/dept-reject`, {
      approver: store.state.user?.name,
      rejectionReason: value
    })
    if (response?.success) {
      ElMessage.success('\u79d1\u5ba4\u5df2\u9a73\u56de')
      searchApplications()
    } else {
      ElMessage.error('\u79d1\u5ba4\u9a73\u56de\u5931\u8d25')
    }
  } catch (error: any) {
    if (error !== 'cancel' && error?.action !== 'cancel') {
      ElMessage.error('\u79d1\u5ba4\u9a73\u56de\u5931\u8d25')
    }
  }
}

// 病案室审批通过
const archiveApproveApplication = async (id: number) => {
  try {
    await ElMessageBox.confirm('\u786e\u5b9a\u8981\u6279\u51c6\u8fd9\u4e2a\u501f\u9605\u7533\u8bf7\u5417\uff1f', '\u786e\u8ba4\u75c5\u6848\u5ba4\u6279\u51c6', {
      confirmButtonText: '\u786e\u5b9a',
      cancelButtonText: '\u53d6\u6d88',
      type: 'success'
    })

    const response = await service.put<{ success: boolean }>(`/borrow-applications/${id}/archive-approve`, {
      approver: store.state.user?.name
    })
    if (response?.success) {
      ElMessage.success('\u75c5\u6848\u5ba4\u5df2\u6279\u51c6')
      searchApplications()
    } else {
      ElMessage.error('\u75c5\u6848\u5ba4\u5ba1\u6279\u5931\u8d25')
    }
  } catch (error: any) {
    if (error !== 'cancel' && error?.action !== 'cancel') {
      ElMessage.error('\u75c5\u6848\u5ba4\u5ba1\u6279\u5931\u8d25')
    }
  }
}

// 病案室审批驳回
const archiveRejectApplication = async (id: number) => {
  try {
    const { value } = await ElMessageBox.prompt(
      '\u8bf7\u8f93\u5165\u9a73\u56de\u539f\u56e0',
      '\u786e\u8ba4\u75c5\u6848\u5ba4\u9a73\u56de',
      {
        confirmButtonText: '\u786e\u5b9a',
        cancelButtonText: '\u53d6\u6d88',
        type: 'warning',
        inputPlaceholder: '\u8bf7\u8f93\u5165\u9a73\u56de\u539f\u56e0'
      }
    )

    if (!value?.trim()) {
      ElMessage.warning('\u9a73\u56de\u539f\u56e0\u4e0d\u80fd\u4e3a\u7a7a')
      return
    }

    const response = await service.put<{ success: boolean }>(`/borrow-applications/${id}/archive-reject`, {
      approver: store.state.user?.name,
      rejectionReason: value
    })
    if (response?.success) {
      ElMessage.success('\u75c5\u6848\u5ba4\u5df2\u9a73\u56de')
      searchApplications()
    } else {
      ElMessage.error('\u75c5\u6848\u5ba4\u9a73\u56de\u5931\u8d25')
    }
  } catch (error: any) {
    if (error !== 'cancel' && error?.action !== 'cancel') {
      ElMessage.error('\u75c5\u6848\u5ba4\u9a73\u56de\u5931\u8d25')
    }
  }
}

const viewDetail = (application: BorrowApplication) => {
  selectedApplication.value = application
  detailDialogVisible.value = true
}

onMounted(() => {
  if (route.query.mine === '1') {
    forceMine.value = true
  }
  if (typeof route.query.status === 'string') {
    searchForm.status = route.query.status
  }
  if (typeof route.query.borrowType === 'string') {
    searchForm.borrowType = route.query.borrowType
  }
  if (typeof route.query.submitTimeStart === 'string') {
    searchForm.submitTimeStart = route.query.submitTimeStart
  }
  if (typeof route.query.submitTimeDate === 'string') {
    exactSubmitDate.value = route.query.submitTimeDate
    searchForm.submitTimeStart = route.query.submitTimeDate
  }
  if (typeof route.query.expectedReturnDate === 'string') {
    searchForm.expectedReturnDate = route.query.expectedReturnDate
  }
  if (typeof route.query.returnStatus === 'string') {
    returnStatusFilter.value = route.query.returnStatus
  }
  if (typeof route.query.approvalBucket === 'string') {
    approvalBucketFilter.value = route.query.approvalBucket
  }
  if (route.query.overdue === '1') {
    onlyOverdue.value = true
    if (!searchForm.status) {
      searchForm.status = 'overdue'
    }
  }
  searchApplications()
})
</script>

<style scoped>
.borrow-history-container {
  padding: 20px;
  overflow: auto;
}

.borrow-history-card {
  margin-bottom: 20px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.search-section {
  margin-bottom: 20px;
}

.search-form {
  margin-bottom: 20px;
  flex-wrap: wrap;
  gap: 10px;
}

.search-form .el-select {
  min-width: 180px;
}

.search-form :deep(.el-date-editor.el-input__wrapper),
.search-form :deep(.el-date-editor.el-range-editor) {
  min-width: 220px;
}

.status-stats {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(120px, 1fr));
  gap: 15px;
  margin-bottom: 20px;
}

.status-stat-item {
  text-align: center;
  padding: 15px;
  background: #f5f7fa;
  border-radius: 8px;
  border: 1px solid #e4e7ed;
}

.status-count {
  display: block;
  font-size: 24px;
  font-weight: bold;
  color: #303133;
}

.status-label {
  display: block;
  font-size: 14px;
  color: #606266;
  margin-top: 5px;
}

.status-container {
  display: flex;
  align-items: center;
  gap: 5px;
}

.status-icon {
  cursor: pointer;
  color: #909399;
}

.overdue {
  color: #f56c6c;
  font-weight: bold;
}

.application-detail {
  padding: 10px;
}

.detail-section {
  margin-bottom: 30px;
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
}

.detail-item .value {
  flex: 1;
  color: #303133;
  word-break: break-word;
}

.timeline-card {
  margin-bottom: 10px;
  border-radius: 8px;
}

.timeline-content {
  padding: 15px;
}

.status-title {
  font-weight: 500;
  color: #303133;
  margin-bottom: 5px;
}

.status-desc {
  font-size: 14px;
  color: #606266;
  margin-bottom: 8px;
}

.status-comment {
  font-size: 13px;
  color: #909399;
  font-style: italic;
}

@media (max-width: 768px) {
  .borrow-history-container {
    padding: 10px;
  }

  .search-form {
    flex-direction: column;
    align-items: stretch;
  }

  .search-form .el-form-item {
    margin-right: 0;
    margin-bottom: 15px;
  }

  .status-stats {
    grid-template-columns: repeat(2, 1fr);
    gap: 10px;
  }

  .detail-item {
    flex-direction: column;
    gap: 5px;
  }

  .detail-item .label {
    width: auto;
  }
}

@media (max-width: 480px) {
  .status-stats {
    grid-template-columns: 1fr;
  }

  .card-header {
    flex-direction: column;
    align-items: flex-start;
    gap: 10px;
  }
}
</style>
