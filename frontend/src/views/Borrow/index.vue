<template>
  <div class="borrow-container">
    <div class="page-header">
      <div>
        <h1 class="page-title">病案借阅申请</h1>
        <p class="page-subtitle">向导式流程，快速完成借阅申请</p>
      </div>
      <el-tag type="info" effect="plain">向导式流程</el-tag>
    </div>

    <el-card class="borrow-card" :body-style="{ padding: '24px' }">
      <!-- Steps -->
      <el-steps :active="currentStep" finish-status="success" align-center class="borrow-steps">
        <el-step title="病案检索" description="查找需要借阅的病案" />
        <el-step title="查看详情" description="确认病案信息" />
        <el-step title="填写申请" description="填写借阅申请表" />
        <el-step title="提交申请" description="提交并等待审批" />
      </el-steps>

      <!-- Step Content -->
      <div class="step-content">
        <!-- Step 1: Search -->
        <div v-if="currentStep === 0" class="step-panel">
          <el-alert title="检索帮助" type="info" :closable="false" show-icon class="step-alert">
            <template #default>
              <p>可通过病案号、患者姓名或科室进行检索</p>
              <p>系统会显示符合条件的可借阅病案</p>
              <p>请选择需要借阅的病案进行下一步</p>
            </template>
          </el-alert>

          <el-form :model="searchForm" :inline="true" class="search-form">
            <el-form-item label="病案号">
              <el-input v-model="searchForm.recordNumber" placeholder="请输入病案号" clearable />
            </el-form-item>
            <el-form-item label="患者姓名">
              <el-input v-model="searchForm.patientName" placeholder="请输入患者姓名" clearable />
            </el-form-item>
            <el-form-item label="科室">
              <el-select v-model="searchForm.department" placeholder="请选择科室" clearable filterable style="width: 180px">
                <el-option v-for="dept in departments" :key="dept" :label="dept" :value="dept" />
              </el-select>
            </el-form-item>
            <el-form-item>
              <el-button type="primary" @click="searchRecords">查询</el-button>
              <el-button @click="resetSearch">重置</el-button>
            </el-form-item>
          </el-form>

          <el-table :data="records" style="width: 100%; height: 400px" border @selection-change="handleSelectionChange" class="data-table">
            <el-table-column type="selection" width="55" :selectable="isRecordSelectable" />
            <el-table-column prop="recordNumber" label="病案号" width="180" />
            <el-table-column prop="patientName" label="患者姓名" width="120" />
            <el-table-column prop="department" label="科室" width="100" />
            <el-table-column prop="diagnosis" label="诊断" show-overflow-tooltip />
            <el-table-column prop="status" label="状态" width="100">
              <template #default="scope">
                <el-tag :type="getRecordStatusType(scope.row.status)" effect="dark" size="small">{{ scope.row.status }}</el-tag>
              </template>
            </el-table-column>
            <el-table-column prop="admissionDate" label="入院日期" width="130" />
            <el-table-column prop="dischargeDate" label="出院日期" width="130" />
          </el-table>
        </div>

        <!-- Step 2: Review -->
        <div v-if="currentStep === 1" class="step-panel">
          <el-alert title="详情确认" type="warning" :closable="false" show-icon class="step-alert">
            <template #default>
              <p>请仔细核对所选病案的详细信息</p>
              <p>确认无误后点击"下一步"继续</p>
            </template>
          </el-alert>

          <el-card v-if="selectedRecords.length > 0" class="detail-card" :body-style="{ padding: '0' }">
            <template #header>
              <div class="detail-header">
                <span>所选病案信息</span>
                <el-tag type="success" effect="dark">{{ selectedRecords.length }} 份病案</el-tag>
              </div>
            </template>
            <el-table :data="selectedRecords" style="width: 100%" border>
              <el-table-column prop="recordNumber" label="病案号" width="180" />
              <el-table-column prop="patientName" label="患者姓名" width="120" />
              <el-table-column prop="department" label="科室" width="100" />
              <el-table-column prop="diagnosis" label="诊断" show-overflow-tooltip />
              <el-table-column prop="status" label="状态" width="100">
                <template #default="scope">
                  <el-tag :type="getRecordStatusType(scope.row.status)" effect="dark" size="small">{{ scope.row.status }}</el-tag>
                </template>
              </el-table-column>
            </el-table>
          </el-card>

          <div v-else class="empty-state">
            <el-empty description="请先选择病案" />
          </div>
        </div>

        <!-- Step 3: Form -->
        <div v-if="currentStep === 2" class="step-panel">
          <el-alert title="申请填写指南" type="info" :closable="false" show-icon class="step-alert">
            <template #default>
              <p>请如实填写借阅信息</p>
              <p>借阅原因需详细说明用途</p>
              <p>预计归还日期不能早于今天</p>
            </template>
          </el-alert>

          <el-form :model="borrowForm" :rules="borrowRules" ref="borrowFormRef" label-width="120px" class="borrow-form">
            <el-form-item label="借阅类型" prop="borrowType">
              <el-select v-model="borrowForm.borrowType" placeholder="请选择借阅类型" style="width: 100%">
                <el-option label="院内借阅" value="院内借阅" />
                <el-option label="院外借阅" value="院外借阅" />
              </el-select>
            </el-form-item>
            <el-form-item label="借阅原因" prop="reason">
              <el-input v-model="borrowForm.reason" type="textarea" rows="4" placeholder="请详细说明借阅原因和用途" />
            </el-form-item>
            <el-form-item label="预计归还日期" prop="expectedReturnDate">
              <el-date-picker
                v-model="borrowForm.expectedReturnDate"
                type="date"
                placeholder="请选择归还日期"
                :min-date="new Date()"
                style="width: 100%"
              />
            </el-form-item>
          </el-form>
        </div>

        <!-- Step 4: Summary -->
        <div v-if="currentStep === 3" class="step-panel">
          <el-alert title="提交确认" type="success" :closable="false" show-icon class="step-alert">
            <template #default>
              <p>请再次确认所有信息</p>
              <p>提交后将进入审批流程</p>
              <p>可在"借阅历史"中查看审批状态</p>
            </template>
          </el-alert>

          <el-card class="summary-card" :body-style="{ padding: '24px' }">
            <template #header>
              <div class="summary-header">
                <span>申请信息汇总</span>
              </div>
            </template>
            <div class="summary-grid">
              <div class="summary-item">
                <span class="summary-label">借阅病案数</span>
                <span class="summary-value">{{ selectedRecords.length }} 份</span>
              </div>
              <div class="summary-item">
                <span class="summary-label">借阅类型</span>
                <span class="summary-value">{{ borrowForm.borrowType }}</span>
              </div>
              <div class="summary-item">
                <span class="summary-label">借阅原因</span>
                <span class="summary-value">{{ borrowForm.reason }}</span>
              </div>
              <div class="summary-item">
                <span class="summary-label">预计归还日期</span>
                <span class="summary-value">{{ formatDate(borrowForm.expectedReturnDate) }}</span>
              </div>
              <div class="summary-item">
                <span class="summary-label">申请人</span>
                <span class="summary-value">{{ currentUser.name }}</span>
              </div>
              <div class="summary-item">
                <span class="summary-label">申请时间</span>
                <span class="summary-value">{{ new Date().toLocaleString() }}</span>
              </div>
            </div>
          </el-card>
        </div>
      </div>

      <!-- Navigation -->
      <div class="step-navigation">
        <el-button type="primary" plain @click="prevStep" :disabled="currentStep === 0">
          上一步
        </el-button>
        <div class="nav-right">
          <el-button type="primary" @click="nextStep" :disabled="!canNextStep">
            {{ currentStep === 3 ? '提交申请' : '下一步' }}
          </el-button>
        </div>
      </div>
    </el-card>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, computed, onMounted, watch } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { useRoute } from 'vue-router'
import service from '../../api/request'
import store from '../../store'

const currentStep = ref(0)
const currentUser = computed(() => store.state.user || { id: undefined, name: '', role: '' })
const route = useRoute()

const departments = ['内科', '外科', '妇产科', '儿科', '骨科', '神经内科', '心血管内科', '消化内科', '呼吸内科', '泌尿外科', '眼科', '耳鼻喉科', '皮肤科', '感染科', '肿瘤科', '康复科', '中医科', '内分泌科', '肾内科', '口腔科', '急诊科', '风湿免疫科', '临床科', '护理部', '病案科']

const searchForm = reactive({
  recordNumber: '',
  patientName: '',
  department: '',
  status: ''
})

const borrowForm = reactive({
  borrowType: '',
  reason: '',
  expectedReturnDate: ''
})

const borrowRules = {
  borrowType: [{ required: true, message: '请选择借阅类型', trigger: 'change' }],
  reason: [
    { required: true, message: '请填写借阅原因', trigger: 'blur' },
    { min: 10, message: '借阅原因至少10个字符', trigger: 'blur' }
  ],
  expectedReturnDate: [{ required: true, message: '请选择预计归还日期', trigger: 'change' }]
}

const borrowFormRef = ref()
const records = ref([])
const selectedRecords = ref([])

const canNextStep = computed(() => {
  switch (currentStep.value) {
    case 0: return selectedRecords.value.length > 0
    case 1: return selectedRecords.value.length > 0
    case 2: return borrowForm.borrowType && borrowForm.reason && borrowForm.expectedReturnDate
    case 3: return true
    default: return false
  }
})

const searchRecords = async () => {
  try {
    const response = await service.post('/medical-records/search', searchForm)
    records.value = response
    selectedRecords.value = []
  } catch (error) {
    console.error('查询病案失败:', error)
    ElMessage.error('查询病案失败')
  }
}

const syncSearchFormFromRoute = async () => {
  searchForm.department = typeof route.query.department === 'string' ? route.query.department : ''
  searchForm.status = typeof route.query.status === 'string' ? route.query.status : ''
  await searchRecords()
}

const resetSearch = () => {
  searchForm.recordNumber = ''
  searchForm.patientName = ''
  searchForm.department = ''
  searchForm.status = ''
  records.value = []
  selectedRecords.value = []
}

const handleSelectionChange = (val) => { selectedRecords.value = val }
const isRecordSelectable = (row) => row.status === '可借阅'

const getRecordStatusType = (status) => {
  switch (status) {
    case '可借阅': return 'success'
    case '已借出': return 'warning'
    case '已归档': return 'info'
    default: return 'danger'
  }
}

const prevStep = () => { if (currentStep.value > 0) currentStep.value-- }

const nextStep = async () => {
  if (currentStep.value === 2) {
    const valid = await borrowFormRef.value.validate()
    if (!valid) return
  }
  if (currentStep.value === 3) {
    await submitApplication()
  } else {
    currentStep.value++
  }
}

const submitApplication = async () => {
  try {
    if (!currentUser.value?.id) {
      ElMessage.error('用户信息不完整，请重新登录')
      return
    }
    const recordIds = selectedRecords.value.map(record => record.id)
    if (recordIds.length === 0) {
      ElMessage.error('请先选择要借阅的病案')
      return
    }
    await ElMessageBox.confirm('确定提交借阅申请吗？', '确认提交', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    })
    const formattedDate = borrowForm.expectedReturnDate ? new Date(borrowForm.expectedReturnDate).toISOString().split('T')[0] : ''
    const response = await service.post('/borrow-applications/create', {
      recordIds: recordIds.join(','),
      reason: borrowForm.reason,
      borrowType: borrowForm.borrowType,
      expectedReturnDate: formattedDate,
      userId: currentUser.value.id,
      userName: currentUser.value.name
    })
    if (response.success) {
      ElMessage.success('申请提交成功')
      resetForm()
    } else {
      ElMessage.error('申请提交失败')
    }
  } catch (error) {
    if (error !== 'cancel') {
      console.error('提交申请失败:', error)
      ElMessage.error('提交申请失败')
    }
  }
}

const resetForm = () => {
  currentStep.value = 0
  selectedRecords.value = []
  borrowForm.borrowType = ''
  borrowForm.reason = ''
  borrowForm.expectedReturnDate = ''
  searchRecords()
}

const formatDate = (date) => {
  if (!date) return ''
  return new Date(date).toLocaleDateString('zh-CN')
}

onMounted(() => { syncSearchFormFromRoute() })
watch(() => route.query.department, () => { syncSearchFormFromRoute() })
watch(() => route.query.status, () => { syncSearchFormFromRoute() })
</script>

<style scoped>
.borrow-container {
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

.borrow-card {
  margin-bottom: var(--space-lg);
}

.borrow-steps {
  margin: 0 0 var(--space-lg);
}

:deep(.el-step__title) {
  font-weight: var(--font-weight-medium);
}

.step-content {
  margin: var(--space-lg) 0;
  min-height: 400px;
}

.step-panel {
  animation: fadeIn 0.3s ease;
}

@keyframes fadeIn {
  from { opacity: 0; transform: translateY(8px); }
  to { opacity: 1; transform: translateY(0); }
}

.step-alert {
  margin-bottom: var(--space-lg);
  border-radius: var(--radius-md);
}

.step-alert p {
  margin: 2px 0;
  font-size: var(--font-size-sm);
  color: var(--color-text-secondary);
}

.search-form {
  margin-bottom: var(--space-md);
  flex-wrap: wrap;
  gap: 8px;
}

.search-form .el-form-item {
  margin-bottom: 12px;
}

:deep(.el-select) { min-width: 180px; }
:deep(.el-input) { min-width: 180px; }

.data-table {
  border-radius: var(--radius-md);
  overflow: hidden;
}

.detail-card {
  margin: var(--space-md) 0;
}

.detail-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.empty-state {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 200px;
}

.borrow-form {
  max-width: 700px;
}

:deep(.el-form-item) {
  margin-bottom: 22px;
}

.summary-card {
  margin: var(--space-md) 0;
}

.summary-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-weight: var(--font-weight-semibold);
}

.summary-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: var(--space-md);
}

.summary-item {
  display: flex;
  flex-direction: column;
  gap: 4px;
  padding: 12px 16px;
  background: var(--color-bg-secondary);
  border-radius: var(--radius-md);
}

.summary-label {
  font-size: var(--font-size-sm);
  color: var(--color-text-secondary);
  font-weight: var(--font-weight-medium);
}

.summary-value {
  font-size: var(--font-size-base);
  color: var(--color-text-primary);
  font-weight: var(--font-weight-medium);
  word-break: break-word;
}

.step-navigation {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-top: var(--space-lg);
  padding-top: var(--space-lg);
  border-top: 1px solid var(--color-divider);
}

.nav-right {
  display: flex;
  gap: 10px;
}

/* Responsive */
@media (max-width: 768px) {
  .borrow-container {
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

  :deep(.el-steps) {
    margin: 10px 0;
  }

  :deep(.el-step__title) { font-size: 12px; }
  :deep(.el-step__description) { font-size: 10px; }

  .search-form {
    flex-direction: column;
    align-items: stretch;
  }

  .search-form .el-form-item {
    margin-right: 0;
  }

  .summary-grid {
    grid-template-columns: 1fr;
  }

  .step-navigation {
    flex-direction: column;
    gap: 12px;
    align-items: stretch;
  }

  .nav-right {
    justify-content: center;
  }
}
</style>
