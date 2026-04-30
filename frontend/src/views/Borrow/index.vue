<template>
  <div class="borrow-container">
    <el-card class="borrow-card">
      <template #header>
        <div class="card-header">
          <span>病案借阅申请</span>
          <el-tag type="info">向导式流程</el-tag>
        </div>
      </template>
      
      <!-- 步骤条 -->
      <el-steps :active="currentStep" finish-status="success" align-center>
        <el-step title="病案检索" description="查找需要借阅的病案"></el-step>
        <el-step title="查看详情" description="确认病案信息"></el-step>
        <el-step title="填写申请" description="填写借阅申请表"></el-step>
        <el-step title="提交申请" description="提交并等待审批"></el-step>
      </el-steps>
      
      <!-- 步骤内容 -->
      <div class="step-content">
        <!-- 步骤1：病案检索 -->
        <div v-if="currentStep === 0" class="step-panel">
          <div class="help-tip">
            <el-alert
              title="检索帮助"
              type="info"
              :closable="false"
              show-icon
            >
              <div slot="description">
                <p>• 可通过病案号、患者姓名或科室进行检索</p>
                <p>• 系统会显示符合条件的可借阅病案</p>
                <p>• 请选择需要借阅的病案进行下一步</p>
              </div>
            </el-alert>
          </div>
          
          <el-form :model="searchForm" :inline="true" class="search-form">
            <el-form-item label="病案号">
              <el-input v-model="searchForm.recordNumber" placeholder="请输入病案号"></el-input>
            </el-form-item>
            <el-form-item label="患者姓名">
              <el-input v-model="searchForm.patientName" placeholder="请输入患者姓名"></el-input>
            </el-form-item>
            <el-form-item label="科室">
              <el-select v-model="searchForm.department" placeholder="请选择科室" clearable style="width: 160px">
                <el-option label="内科" value="内科"></el-option>
                <el-option label="外科" value="外科"></el-option>
                <el-option label="妇产科" value="妇产科"></el-option>
                <el-option label="儿科" value="儿科"></el-option>
                <el-option label="骨科" value="骨科"></el-option>
                <el-option label="神经内科" value="神经内科"></el-option>
                <el-option label="心血管内科" value="心血管内科"></el-option>
                <el-option label="消化内科" value="消化内科"></el-option>
                <el-option label="呼吸内科" value="呼吸内科"></el-option>
                <el-option label="泌尿外科" value="泌尿外科"></el-option>
                <el-option label="眼科" value="眼科"></el-option>
                <el-option label="耳鼻喉科" value="耳鼻喉科"></el-option>
                <el-option label="皮肤科" value="皮肤科"></el-option>
                <el-option label="感染科" value="感染科"></el-option>
                <el-option label="肿瘤科" value="肿瘤科"></el-option>
                <el-option label="康复科" value="康复科"></el-option>
                <el-option label="中医科" value="中医科"></el-option>
                <el-option label="内分泌科" value="内分泌科"></el-option>
                <el-option label="肾内科" value="肾内科"></el-option>
                <el-option label="口腔科" value="口腔科"></el-option>
                <el-option label="急诊科" value="急诊科"></el-option>
                <el-option label="风湿免疫科" value="风湿免疫科"></el-option>
                <el-option label="临床科" value="临床科"></el-option>
                <el-option label="护理部" value="护理部"></el-option>
                <el-option label="病案科" value="病案科"></el-option>
              </el-select>
            </el-form-item>
            <el-form-item>
              <el-button type="primary" @click="searchRecords">查询</el-button>
              <el-button @click="resetSearch">重置</el-button>
            </el-form-item>
          </el-form>
          
          <el-table :data="records" style="width: 100%; height: 400px" border @selection-change="handleSelectionChange">
            <el-table-column type="selection" width="55" :selectable="isRecordSelectable"></el-table-column>
            <el-table-column prop="recordNumber" label="病案号" width="180"></el-table-column>
            <el-table-column prop="patientName" label="患者姓名" width="120"></el-table-column>
            <el-table-column prop="department" label="科室" width="100"></el-table-column>
            <el-table-column prop="diagnosis" label="诊断" show-overflow-tooltip></el-table-column>
            <el-table-column prop="status" label="状态" width="100">
              <template #default="scope">
                <el-tag :type="getRecordStatusType(scope.row.status)">{{ scope.row.status }}</el-tag>
              </template>
            </el-table-column>
            <el-table-column prop="admissionDate" label="入院日期" width="150"></el-table-column>
            <el-table-column prop="dischargeDate" label="出院日期" width="150"></el-table-column>
          </el-table>
        </div>
        
        <!-- 步骤2：查看详情 -->
        <div v-if="currentStep === 1" class="step-panel">
          <div class="help-tip">
            <el-alert
              title="详情确认"
              type="warning"
              :closable="false"
              show-icon
            >
              <div slot="description">
                <p>• 请仔细核对所选病案的详细信息</p>
                <p>• 确认无误后点击"下一步"继续</p>
              </div>
            </el-alert>
          </div>
          
          <el-card v-if="selectedRecords.length > 0" class="detail-card">
            <template #header>
              <div class="detail-header">
                <span>所选病案信息</span>
                <el-tag type="success">{{ selectedRecords.length }} 份病案</el-tag>
              </div>
            </template>
            
            <el-table :data="selectedRecords" style="width: 100%" border>
              <el-table-column prop="recordNumber" label="病案号" width="180"></el-table-column>
              <el-table-column prop="patientName" label="患者姓名" width="120"></el-table-column>
              <el-table-column prop="department" label="科室" width="100"></el-table-column>
              <el-table-column prop="diagnosis" label="诊断" show-overflow-tooltip></el-table-column>
              <el-table-column prop="status" label="状态" width="100">
                <template #default="scope">
                  <el-tag :type="getRecordStatusType(scope.row.status)">{{ scope.row.status }}</el-tag>
                </template>
              </el-table-column>
            </el-table>
          </el-card>
          
          <div v-else class="empty-state">
            <el-empty description="请先选择病案"></el-empty>
          </div>
        </div>
        
        <!-- 步骤3：填写申请 -->
        <div v-if="currentStep === 2" class="step-panel">
          <div class="help-tip">
            <el-alert
              title="申请填写指南"
              type="info"
              :closable="false"
              show-icon
            >
              <div slot="description">
                <p>• 请如实填写借阅信息</p>
                <p>• 借阅原因需详细说明用途</p>
                <p>• 预计归还日期不能早于今天</p>
              </div>
            </el-alert>
          </div>
          
          <el-form :model="borrowForm" :rules="borrowRules" ref="borrowFormRef" label-width="120px">
            <el-form-item label="借阅类型" prop="borrowType">
              <el-select v-model="borrowForm.borrowType" placeholder="请选择借阅类型">
                <el-option label="院内借阅" value="院内借阅"></el-option>
                <el-option label="院外借阅" value="院外借阅"></el-option>
              </el-select>
            </el-form-item>
            <el-form-item label="借阅原因" prop="reason">
              <el-input v-model="borrowForm.reason" type="textarea" rows="4" placeholder="请详细说明借阅原因和用途"></el-input>
            </el-form-item>
            <el-form-item label="预计归还日期" prop="expectedReturnDate">
              <el-date-picker 
                v-model="borrowForm.expectedReturnDate" 
                type="date" 
                placeholder="请选择归还日期"
                :min-date="new Date()"
              ></el-date-picker>
            </el-form-item>
          </el-form>
        </div>
        
        <!-- 步骤4：提交申请 -->
        <div v-if="currentStep === 3" class="step-panel">
          <div class="help-tip">
            <el-alert
              title="提交确认"
              type="success"
              :closable="false"
              show-icon
            >
              <div slot="description">
                <p>• 请再次确认所有信息</p>
                <p>• 提交后将进入审批流程</p>
                <p>• 可在"借阅历史"中查看审批状态</p>
              </div>
            </el-alert>
          </div>
          
          <el-card class="summary-card">
            <template #header>
              <div class="summary-header">
                <span>申请信息汇总</span>
              </div>
            </template>
            
            <div class="summary-content">
              <div class="summary-item">
                <span class="label">借阅病案数：</span>
                <span class="value">{{ selectedRecords.length }} 份</span>
              </div>
              <div class="summary-item">
                <span class="label">借阅类型：</span>
                <span class="value">{{ borrowForm.borrowType }}</span>
              </div>
              <div class="summary-item">
                <span class="label">借阅原因：</span>
                <span class="value">{{ borrowForm.reason }}</span>
              </div>
              <div class="summary-item">
                <span class="label">预计归还日期：</span>
                <span class="value">{{ formatDate(borrowForm.expectedReturnDate) }}</span>
              </div>
              <div class="summary-item">
                <span class="label">申请人：</span>
                <span class="value">{{ currentUser.name }}</span>
              </div>
              <div class="summary-item">
                <span class="label">申请时间：</span>
                <span class="value">{{ new Date().toLocaleString() }}</span>
              </div>
            </div>
          </el-card>
        </div>
      </div>
      
      <!-- 步骤导航按钮 -->
      <div class="step-navigation">
        <el-button 
          type="primary" 
          plain 
          @click="prevStep" 
          :disabled="currentStep === 0"
        >
          上一步
        </el-button>
        
        <div class="right-buttons">
          <el-button 
            type="primary" 
            @click="nextStep" 
            :disabled="!canNextStep"
          >
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

// 步骤控制
const currentStep = ref(0)
const currentUser = computed(() => store.state.user || { id: undefined, name: '', role: '' })
const route = useRoute()

// 搜索表单
const searchForm = reactive({
  recordNumber: '',
  patientName: '',
  department: '',
  status: ''
})

// 借阅表单
const borrowForm = reactive({
  borrowType: '',
  reason: '',
  expectedReturnDate: ''
})

// 表单验证规则
const borrowRules = {
  borrowType: [
    { required: true, message: '请选择借阅类型', trigger: 'change' }
  ],
  reason: [
    { required: true, message: '请填写借阅原因', trigger: 'blur' },
    { min: 10, message: '借阅原因至少10个字符', trigger: 'blur' }
  ],
  expectedReturnDate: [
    { required: true, message: '请选择预计归还日期', trigger: 'change' }
  ]
}

const borrowFormRef = ref()
const records = ref([])
const selectedRecords = ref([])

// 计算属性：是否可以进入下一步
const canNextStep = computed(() => {
  switch (currentStep.value) {
    case 0: // 病案检索
      return selectedRecords.value.length > 0
    case 1: // 查看详情
      return selectedRecords.value.length > 0
    case 2: // 填写申请
      return borrowForm.borrowType && borrowForm.reason && borrowForm.expectedReturnDate
    case 3: // 提交申请
      return true
    default:
      return false
  }
})

// 搜索病案
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

// 重置搜索
const resetSearch = () => {
  searchForm.recordNumber = ''
  searchForm.patientName = ''
  searchForm.department = ''
  searchForm.status = ''
  records.value = []
  selectedRecords.value = []
}

// 处理选择变化
const handleSelectionChange = (val) => {
  selectedRecords.value = val
}

// 判断记录是否可选择
const isRecordSelectable = (row) => {
  // 只有状态为"可借阅"的病案才能被选择
  return row.status === '可借阅'
}

// 不同病案状态显示不同颜色
const getRecordStatusType = (status) => {
  switch (status) {
    case '可借阅':
      return 'success'
    case '已借出':
      return 'warning'
    case '已归档':
      return 'info'
    default:
      return 'danger'
  }
}

// 上一步
const prevStep = () => {
  if (currentStep.value > 0) {
    currentStep.value--
  }
}

// 下一步
const nextStep = async () => {
  if (currentStep.value === 2) {
    // 验证表单
    const valid = await borrowFormRef.value.validate()
    if (!valid) {
      return
    }
  }
  
  if (currentStep.value === 3) {
    // 提交申请
    await submitApplication()
  } else {
    currentStep.value++
  }
}

// 提交申请
const submitApplication = async () => {
  try {
    console.log('开始提交申请...')
    
    if (!currentUser.value?.id) {
      ElMessage.error('用户信息不完整，请重新登录')
      return
    }
    
    const recordIds = selectedRecords.value.map(record => record.id)
    
    if (recordIds.length === 0) {
      ElMessage.error('请先选择要借阅的病案')
      return
    }
    
    console.log('选择的病案ID:', recordIds)
    console.log('借阅信息:', {
      recordIds: recordIds.join(','),
      reason: borrowForm.reason,
      borrowType: borrowForm.borrowType,
      expectedReturnDate: borrowForm.expectedReturnDate,
      userId: currentUser.value.id,
      userName: currentUser.value.name
    })
    
    await ElMessageBox.confirm(
      '确定提交借阅申请吗？',
      '确认提交',
      {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }
    )
    
    // 格式化日期为 YYYY-MM-DD 格式
      const formattedDate = borrowForm.expectedReturnDate ? new Date(borrowForm.expectedReturnDate).toISOString().split('T')[0] : ''
      
      const response = await service.post('/borrow-applications/create', {
        recordIds: recordIds.join(','),
        reason: borrowForm.reason,
        borrowType: borrowForm.borrowType,
        expectedReturnDate: formattedDate,
        userId: currentUser.value.id,
        userName: currentUser.value.name
      })
    
    console.log('提交申请响应:', response)
    
    if (response.success) {
      ElMessage.success('申请提交成功')
      // 重置表单
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

// 重置表单
const resetForm = () => {
  currentStep.value = 0
  selectedRecords.value = []
  borrowForm.borrowType = ''
  borrowForm.reason = ''
  borrowForm.expectedReturnDate = ''
  searchRecords()
}

// 格式化日期
const formatDate = (date) => {
  if (!date) return ''
  const d = new Date(date)
  return d.toLocaleDateString('zh-CN')
}

onMounted(() => {
  syncSearchFormFromRoute()
})

watch(
  () => route.query.department,
  () => {
    syncSearchFormFromRoute()
  }
)

watch(
  () => route.query.status,
  () => {
    syncSearchFormFromRoute()
  }
)
</script>

<style scoped>
.borrow-container {
  padding: 20px;
}

.borrow-card {
  margin-bottom: 20px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

/* 步骤条样式 */
:deep(.el-steps) {
  margin: 20px 0;
}

:deep(.el-step__title) {
  font-weight: 500;
}

/* 步骤内容样式 */
.step-content {
  margin: 30px 0;
  overflow: auto;
}

.step-panel {
  min-height: 400px;
  overflow: auto;
}

/* 帮助提示样式 */
.help-tip {
  margin-bottom: 20px;
}

/* 搜索表单样式 */
.search-form {
  margin-bottom: 20px;
  flex-wrap: wrap;
  gap: 10px;
}

.search-form .el-form-item {
  margin-bottom: 15px;
}

/* 修复select组件宽度问题 */
:deep(.el-select) {
  min-width: 180px;
}

:deep(.el-input) {
  min-width: 180px;
}

/* 修复响应式布局中的select宽度 */
@media (max-width: 768px) {
  :deep(.el-select) {
    width: 100%;
  }
  
  :deep(.el-input) {
    width: 100%;
  }
}

/* 表格样式 */
:deep(.el-table) {
  margin-bottom: 20px;
}

/* 详情卡片样式 */
.detail-card {
  margin: 20px 0;
}

.detail-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

/* 空状态样式 */
.empty-state {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 200px;
}

/* 申请表单样式 */
:deep(.el-form) {
  max-width: 800px;
}

:deep(.el-form-item) {
  margin-bottom: 20px;
}

/* 汇总卡片样式 */
.summary-card {
  margin: 20px 0;
}

.summary-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.summary-content {
  padding: 20px;
}

.summary-item {
  display: flex;
  margin-bottom: 15px;
  align-items: flex-start;
}

.summary-item .label {
  font-weight: bold;
  width: 120px;
  color: #606266;
}

.summary-item .value {
  flex: 1;
  color: #303133;
  word-break: break-word;
}

/* 步骤导航样式 */
.step-navigation {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-top: 30px;
  padding-top: 20px;
  border-top: 1px solid #e4e7ed;
}

.right-buttons {
  display: flex;
  gap: 10px;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .borrow-container {
    padding: 10px;
  }
  
  :deep(.el-steps) {
    margin: 10px 0;
  }
  
  :deep(.el-step__title) {
    font-size: 12px;
  }
  
  :deep(.el-step__description) {
    font-size: 10px;
  }
  
  .search-form {
    flex-direction: column;
    align-items: stretch;
  }
  
  .search-form .el-form-item {
    margin-right: 0;
  }
  
  :deep(.el-table) {
    font-size: 12px;
  }
  
  :deep(.el-table__header-wrapper th) {
    font-size: 12px;
    padding: 8px 4px;
  }
  
  :deep(.el-table__cell) {
    padding: 8px 4px;
  }
  
  .summary-item {
    flex-direction: column;
    gap: 5px;
  }
  
  .summary-item .label {
    width: auto;
  }
  
  .step-navigation {
    flex-direction: column;
    gap: 15px;
    align-items: stretch;
  }
  
  .right-buttons {
    justify-content: center;
  }
}

@media (max-width: 480px) {
  :deep(.el-steps--align-center) {
    flex-direction: column;
    align-items: flex-start;
  }
  
  :deep(.el-step__title) {
    margin-left: 10px;
  }
  
  :deep(.el-date-picker) {
    width: 100%;
  }
  
  :deep(.el-select) {
    width: 100%;
  }
  
  :deep(.el-input) {
    width: 100%;
  }
}
</style>
