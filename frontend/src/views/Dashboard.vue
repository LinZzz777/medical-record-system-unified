<template>
  <div class="dashboard-container">
    <!-- Page Header -->
    <div class="page-header">
      <div>
        <h1 class="page-title">数据可视化看板</h1>
        <p class="page-subtitle">实时监控病案借阅数据，掌握业务动态</p>
      </div>
      <el-tag type="success" effect="dark" class="refresh-tag">实时更新</el-tag>
    </div>

    <!-- Stats Cards -->
    <div class="stats-grid">
      <div class="stat-card stat-card--total" @click="handleStatCardClick('totalRecords')">
        <div class="stat-card-icon">
          <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path d="M9 5H7C5.89543 5 5 5.89543 5 7V19C5 20.1046 5.89543 21 7 21H17C18.1046 21 19 20.1046 19 19V7C19 5.89543 18.1046 5 17 5H15M9 5C9 6.10457 9.89543 7 11 7H13C14.1046 7 15 6.10457 15 5M9 5C9 3.89543 9.89543 3 11 3H13C14.1046 3 15 3.89543 15 5" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
          </svg>
        </div>
        <div class="stat-card-content">
          <span class="stat-card-label">总病案数</span>
          <span class="stat-card-value">{{ stats.totalRecords || 0 }}</span>
        </div>
        <div class="stat-card-arrow">
          <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path d="M9 5L16 12L9 19" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
          </svg>
        </div>
      </div>

      <div class="stat-card stat-card--borrowed" @click="handleStatCardClick('borrowedCount')">
        <div class="stat-card-icon">
          <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path d="M12 8V12L15 15M3 12C3 7.02944 7.02944 3 12 3C16.9706 3 21 7.02944 21 12C21 16.9706 16.9706 21 12 21C7.02944 21 3 16.9706 3 12Z" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
          </svg>
        </div>
        <div class="stat-card-content">
          <span class="stat-card-label">已借出</span>
          <span class="stat-card-value">{{ stats.borrowedCount || 0 }}</span>
        </div>
        <div class="stat-card-arrow">
          <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path d="M9 5L16 12L9 19" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
          </svg>
        </div>
      </div>

      <div class="stat-card stat-card--pending" @click="handleStatCardClick('pendingCount')">
        <div class="stat-card-icon">
          <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path d="M12 8V12M12 16H12.01M21 12C21 16.9706 16.9706 21 12 21C7.02944 21 3 16.9706 3 12C3 7.02944 7.02944 3 12 3C16.9706 3 21 7.02944 21 12Z" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
          </svg>
        </div>
        <div class="stat-card-content">
          <span class="stat-card-label">待审批</span>
          <span class="stat-card-value">{{ stats.pendingCount || 0 }}</span>
        </div>
        <div class="stat-card-arrow">
          <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path d="M9 5L16 12L9 19" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
          </svg>
        </div>
      </div>

      <div class="stat-card stat-card--overdue" @click="handleStatCardClick('overdueCount')">
        <div class="stat-card-icon">
          <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path d="M12 9V13M12 17H12.01M21 12C21 16.9706 16.9706 21 12 21C7.02944 21 3 16.9706 3 12C3 7.02944 7.02944 3 12 3C16.9706 3 21 7.02944 21 12Z" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
          </svg>
        </div>
        <div class="stat-card-content">
          <span class="stat-card-label">已过期</span>
          <span class="stat-card-value">{{ stats.overdueCount || 0 }}</span>
        </div>
        <div class="stat-card-arrow">
          <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path d="M9 5L16 12L9 19" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
          </svg>
        </div>
      </div>
    </div>

    <!-- Charts Grid -->
    <div class="charts-grid">
      <el-card class="chart-card" :body-style="{ padding: '20px' }">
        <template #header>
          <div class="chart-header">
            <div class="chart-header-left">
              <div class="chart-header-icon chart-header-icon--blue">
                <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                  <path d="M3 3V21H21M7 16L12 11L16 15L21 10" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
                </svg>
              </div>
              <span>近30日借阅趋势</span>
            </div>
            <el-tooltip content="点击某个日期后，跳转到当天的借阅申请" placement="top">
              <el-icon><QuestionFilled /></el-icon>
            </el-tooltip>
          </div>
        </template>
        <div ref="borrowTrendChart" class="chart-container"></div>
      </el-card>

      <el-card class="chart-card" :body-style="{ padding: '20px' }">
        <template #header>
          <div class="chart-header">
            <div class="chart-header-left">
              <div class="chart-header-icon chart-header-icon--green">
                <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                  <path d="M12 2C6.47715 2 2 6.47715 2 12C2 17.5228 6.47715 22 12 22C17.5228 22 22 17.5228 22 12C22 6.47715 17.5228 2 12 2Z" stroke="currentColor" stroke-width="1.5"/>
                  <path d="M12 2C14.5 2 16.5 6.47715 16.5 12C16.5 17.5228 14.5 22 12 22C9.5 22 7.5 17.5228 7.5 12C7.5 6.47715 9.5 2 12 2Z" stroke="currentColor" stroke-width="1.5"/>
                  <path d="M2 12H22" stroke="currentColor" stroke-width="1.5"/>
                </svg>
              </div>
              <span>借阅类型分布</span>
            </div>
            <el-tooltip content="点击院内借阅或院外借阅后，跳转到对应的借阅历史" placement="top">
              <el-icon><QuestionFilled /></el-icon>
            </el-tooltip>
          </div>
        </template>
        <div ref="borrowTypeChart" class="chart-container"></div>
      </el-card>

      <el-card v-if="isAdmin" class="chart-card" :body-style="{ padding: '20px' }">
        <template #header>
          <div class="chart-header">
            <div class="chart-header-left">
              <div class="chart-header-icon chart-header-icon--purple">
                <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                  <path d="M3 3V21H21M7 14L11 10L15 14L19 10" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
                </svg>
              </div>
              <span>科室借阅活跃度</span>
            </div>
            <el-tooltip content="点击某个科室后，跳转到该科室的被借出病案" placement="top">
              <el-icon><QuestionFilled /></el-icon>
            </el-tooltip>
          </div>
        </template>
        <div ref="departmentChart" class="chart-container"></div>
      </el-card>

      <el-card class="chart-card" :body-style="{ padding: '20px' }">
        <template #header>
          <div class="chart-header">
            <div class="chart-header-left">
              <div class="chart-header-icon chart-header-icon--orange">
                <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                  <path d="M12 2C6.47715 2 2 6.47715 2 12C2 17.5228 6.47715 22 12 22C17.5228 22 22 17.5228 22 12C22 6.47715 17.5228 2 12 2Z" stroke="currentColor" stroke-width="1.5"/>
                  <path d="M8 12L11 15L16 9" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
                </svg>
              </div>
              <span>状态分布</span>
            </div>
            <el-tooltip content="点击某个状态扇区后，跳转到对应的病案数据" placement="top">
              <el-icon><QuestionFilled /></el-icon>
            </el-tooltip>
          </div>
        </template>
        <div ref="statusChart" class="chart-container"></div>
      </el-card>

      <el-card v-if="isAdmin" class="chart-card" :body-style="{ padding: '20px' }">
        <template #header>
          <div class="chart-header">
            <div class="chart-header-left">
              <div class="chart-header-icon chart-header-icon--red">
                <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                  <path d="M12 9V13M12 17H12.01M21 12C21 16.9706 16.9706 21 12 21C7.02944 21 3 16.9706 3 12C3 7.02944 7.02944 3 12 3C16.9706 3 21 7.02944 21 12Z" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
                </svg>
              </div>
              <span>近30日逾期趋势</span>
            </div>
            <el-tooltip content="点击某个日期后，查看该日应归还且已逾期的申请" placement="top">
              <el-icon><QuestionFilled /></el-icon>
            </el-tooltip>
          </div>
        </template>
        <div ref="overdueTrendChart" class="chart-container"></div>
      </el-card>

      <el-card v-if="isAdmin" class="chart-card" :body-style="{ padding: '20px' }">
        <template #header>
          <div class="chart-header">
            <div class="chart-header-left">
              <div class="chart-header-icon chart-header-icon--teal">
                <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                  <path d="M12 8V12L15 15M3 12C3 7.02944 7.02944 3 12 3C16.9706 3 21 7.02944 21 12C21 16.9706 16.9706 21 12 21C7.02944 21 3 16.9706 3 12Z" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
                </svg>
              </div>
              <span>审批效率分布</span>
            </div>
            <el-tooltip content="显示从申请提交到处理完成的耗时分布" placement="top">
              <el-icon><QuestionFilled /></el-icon>
            </el-tooltip>
          </div>
        </template>
        <div ref="approvalEfficiencyChart" class="chart-container"></div>
      </el-card>

      <el-card v-if="isAdmin" class="chart-card" :body-style="{ padding: '20px' }">
        <template #header>
          <div class="chart-header">
            <div class="chart-header-left">
              <div class="chart-header-icon chart-header-icon--cyan">
                <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                  <path d="M9 12L11 14L15 10M3 5C3 3.89543 3.89543 3 5 3H19C20.1046 3 21 3.89543 21 5V19C21 20.1046 20.1046 21 19 21H5C3.89543 21 3 20.1046 3 19V5Z" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
                </svg>
              </div>
              <span>归还及时率</span>
            </div>
            <el-tooltip content="显示按时间归还、逾期归还和未归还的分布" placement="top">
              <el-icon><QuestionFilled /></el-icon>
            </el-tooltip>
          </div>
        </template>
        <div ref="returnTimelinessChart" class="chart-container"></div>
      </el-card>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, onUnmounted, ref } from 'vue'
import { QuestionFilled } from '@element-plus/icons-vue'
import { useRouter } from 'vue-router'
import * as echarts from 'echarts/core'
import { BarChart, LineChart, PieChart } from 'echarts/charts'
import { GridComponent, LegendComponent, TooltipComponent } from 'echarts/components'
import { CanvasRenderer } from 'echarts/renderers'
import service from '../api/request'
import store from '../store'

echarts.use([BarChart, LineChart, PieChart, GridComponent, LegendComponent, TooltipComponent, CanvasRenderer])

interface DashboardStats {
  totalRecords: number
  borrowedCount: number
  pendingCount: number
  overdueCount: number
}

interface SeriesTrendData {
  months?: string[]
  dates?: string[]
  borrowData?: number[]
  overdueData?: number[]
}

interface ChartStats {
  borrowTrend?: SeriesTrendData
  borrowTypeStats?: Record<string, number>
  departmentStats?: Record<string, number>
  statusData?: Record<string, number>
  approvalEfficiency?: Record<string, number>
  overdueTrend?: SeriesTrendData
  returnTimeliness?: Record<string, number>
}

const router = useRouter()

const stats = ref<DashboardStats>({
  totalRecords: 0,
  borrowedCount: 0,
  pendingCount: 0,
  overdueCount: 0
})

const borrowTrendChart = ref<HTMLElement | null>(null)
const borrowTypeChart = ref<HTMLElement | null>(null)
const departmentChart = ref<HTMLElement | null>(null)
const statusChart = ref<HTMLElement | null>(null)
const overdueTrendChart = ref<HTMLElement | null>(null)
const approvalEfficiencyChart = ref<HTMLElement | null>(null)
const returnTimelinessChart = ref<HTMLElement | null>(null)

let borrowTrendInstance: echarts.ECharts | null = null
let borrowTypeInstance: echarts.ECharts | null = null
let departmentInstance: echarts.ECharts | null = null
let statusInstance: echarts.ECharts | null = null
let overdueTrendInstance: echarts.ECharts | null = null
let approvalEfficiencyInstance: echarts.ECharts | null = null
let returnTimelinessInstance: echarts.ECharts | null = null

const isAdmin = computed(() => store.state.user?.role === 'admin')
const isDeptDirector = computed(() => store.state.user?.role === 'dept_director')
const canReview = computed(() => store.state.user?.role === 'admin' || store.state.user?.role === '主任' || store.state.user?.role === 'dept_director')

const buildBorrowHistoryQuery = (query: Record<string, string> = {}) => {
  return isAdmin.value ? query : { ...query, mine: '1' }
}

const formatDateString = (date: Date) => {
  const year = date.getFullYear()
  const month = `${date.getMonth() + 1}`.padStart(2, '0')
  const day = `${date.getDate()}`.padStart(2, '0')
  return `${year}-${month}-${day}`
}

const parseTrendLabelToDate = (label: string) => {
  const matched = label.match(/(\d{1,2})\D+(\d{1,2})/)
  if (!matched) return ''
  const currentYear = new Date().getFullYear()
  const month = Number(matched[1])
  const day = Number(matched[2])
  const parsedDate = new Date(currentYear, month - 1, day)
  if (Number.isNaN(parsedDate.getTime())) return ''
  return formatDateString(parsedDate)
}

const initChartContainer = (target: HTMLElement | null) => {
  if (!target) return null
  if (target.clientHeight === 0) {
    target.style.height = '320px'
  }
  return target
}

const handleStatCardClick = (type: string) => {
  if (type === 'totalRecords') {
    router.push('/borrow')
    return
  }
  if (type === 'borrowedCount') {
    router.push({ path: '/borrow-history', query: buildBorrowHistoryQuery({ status: 'approved' }) })
    return
  }
  if (type === 'pendingCount') {
    if (isDeptDirector.value) { router.push('/review'); return }
    router.push({ path: '/borrow-history', query: buildBorrowHistoryQuery({ status: 'pending' }) })
    return
  }
  if (type === 'overdueCount') {
    router.push({ path: '/borrow-history', query: buildBorrowHistoryQuery({ status: 'overdue', overdue: '1' }) })
  }
}

const loadStats = async () => {
  try {
    const user = store.state.user
    if (!user?.id || !user.role) return
    const [userStats, chartStats] = await Promise.all([
      service.get<DashboardStats>(`/statistics/user-stats?userId=${user.id}&role=${user.role}`),
      service.get<ChartStats>(`/statistics/chart-stats?userId=${user.id}&role=${user.role}`)
    ])
    stats.value = userStats
    initCharts(chartStats)
  } catch (error) {
    console.error('Failed to load dashboard stats:', error)
  }
}

const chartColors = {
  primary: '#667eea',
  primaryLight: 'rgba(102, 126, 234, 0.15)',
  success: '#34a853',
  successLight: 'rgba(52, 168, 83, 0.15)',
  danger: '#ea4335',
  dangerLight: 'rgba(234, 67, 53, 0.15)',
  warning: '#fbbc04',
  warningLight: 'rgba(251, 188, 4, 0.15)',
  purple: '#9c27b0',
  teal: '#009688',
  cyan: '#00bcd4',
  orange: '#ff9800'
}

const initCharts = (chartStats: ChartStats) => {
  initBorrowTrendChart(chartStats.borrowTrend)
  initBorrowTypeChart(chartStats.borrowTypeStats)
  initDepartmentChart(chartStats.departmentStats)
  initStatusChart(chartStats.statusData)
  initOverdueTrendChart(chartStats.overdueTrend)
  initApprovalEfficiencyChart(chartStats.approvalEfficiency)
  initReturnTimelinessChart(chartStats.returnTimeliness)
  requestAnimationFrame(() => requestAnimationFrame(handleResize))
}

const initBorrowTrendChart = (data?: SeriesTrendData) => {
  const container = initChartContainer(borrowTrendChart.value)
  if (!container) return
  borrowTrendInstance?.dispose()
  borrowTrendInstance = echarts.init(container)
  borrowTrendInstance.setOption({
    tooltip: { trigger: 'axis' },
    grid: { left: '3%', right: '4%', bottom: '3%', containLabel: true },
    xAxis: { type: 'category', boundaryGap: false, data: data?.months || [], axisLine: { lineStyle: { color: '#e0e0e0' } }, axisLabel: { color: '#5f6368', fontSize: window.innerWidth < 768 ? 10 : 13, rotate: window.innerWidth < 768 ? 45 : 0 } },
    yAxis: { type: 'value', name: '借阅次数', axisLine: { show: false }, splitLine: { lineStyle: { color: '#f0f0f0' } }, axisLabel: { color: '#5f6368', fontSize: window.innerWidth < 768 ? 10 : 13 } },
    series: [{
      name: '借阅量',
      type: 'line',
      smooth: true,
      data: data?.borrowData || [],
      lineStyle: { color: chartColors.primary, width: 3 },
      areaStyle: { color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [{ offset: 0, color: 'rgba(102, 126, 234, 0.3)' }, { offset: 1, color: 'rgba(102, 126, 234, 0.02)' }]) },
      itemStyle: { color: chartColors.primary },
      symbol: 'circle',
      symbolSize: 6
    }]
  })
  borrowTrendInstance.on('click', (params) => {
    const submitTimeDate = parseTrendLabelToDate(`${params?.name || ''}`)
    router.push({ path: '/borrow-history', query: buildBorrowHistoryQuery({ submitTimeDate }) })
  })
}

const initBorrowTypeChart = (data?: Record<string, number>) => {
  const container = initChartContainer(borrowTypeChart.value)
  if (!container) return
  borrowTypeInstance?.dispose()
  borrowTypeInstance = echarts.init(container)
  borrowTypeInstance.setOption({
    tooltip: { trigger: 'item', formatter: '{a}<br/>{b}: {c} ({d}%)' },
    legend: {
      orient: window.innerWidth < 768 ? 'horizontal' : 'vertical',
      left: window.innerWidth < 768 ? 'center' : 'left',
      bottom: window.innerWidth < 768 ? 'bottom' : undefined,
      textStyle: { color: '#5f6368', fontSize: window.innerWidth < 768 ? 11 : 13 }
    },
    color: [chartColors.primary, chartColors.success, chartColors.warning, chartColors.purple],
    series: [{
      name: '借阅类型',
      type: 'pie',
      radius: ['40%', '70%'],
      avoidLabelOverlap: false,
      itemStyle: { borderRadius: 10, borderColor: '#fff', borderWidth: 3 },
      label: { show: false, position: 'center' },
      emphasis: { label: { show: true, fontSize: 18, fontWeight: 'bold' } },
      labelLine: { show: false },
      data: Object.entries(data || {}).map(([name, value]) => ({ name, value }))
    }]
  })
  borrowTypeInstance.on('click', (params) => {
    router.push({ path: '/borrow-history', query: buildBorrowHistoryQuery({ borrowType: `${params?.name || ''}` }) })
  })
}

const initDepartmentChart = (data?: Record<string, number>) => {
  const container = initChartContainer(departmentChart.value)
  if (!container) return
  departmentInstance?.dispose()
  departmentInstance = echarts.init(container)
  departmentInstance.setOption({
    tooltip: { trigger: 'axis', axisPointer: { type: 'shadow' } },
    grid: { left: '3%', right: '4%', bottom: '3%', containLabel: true },
    xAxis: { type: 'value', name: '借阅次数', axisLine: { lineStyle: { color: '#e0e0e0' } }, axisLabel: { color: '#5f6368', fontSize: window.innerWidth < 768 ? 10 : 13 } },
    yAxis: { type: 'category', data: Object.keys(data || {}), axisLabel: { color: '#5f6368', fontSize: window.innerWidth < 768 ? 10 : 13, formatter: (val: string) => window.innerWidth < 768 && val.length > 6 ? val.slice(0, 6) + '...' : val } },
    series: [{
      name: '借阅次数',
      type: 'bar',
      data: Object.values(data || {}),
      itemStyle: { color: new echarts.graphic.LinearGradient(0, 0, 1, 0, [{ offset: 0, color: '#667eea' }, { offset: 1, color: '#764ba2' }]), borderRadius: [0, 4, 4, 0] },
      label: { show: true, position: 'right', formatter: '{c}', color: '#5f6368' }
    }]
  })
  departmentInstance.on('click', (params) => {
    router.push({ path: '/borrow', query: { department: `${params?.name || ''}`, status: '已借出' } })
  })
}

const initStatusChart = (data?: Record<string, number>) => {
  const container = initChartContainer(statusChart.value)
  if (!container) return
  statusInstance?.dispose()
  statusInstance = echarts.init(container)
  statusInstance.setOption({
    tooltip: { trigger: 'item', formatter: '{a}<br/>{b}: {c}' },
    legend: { orient: 'horizontal', bottom: 'bottom', textStyle: { color: '#5f6368' } },
    color: [chartColors.success, chartColors.primary, chartColors.warning, chartColors.danger, chartColors.purple, chartColors.orange],
    series: [{
      name: '状态分布',
      type: 'pie',
      radius: '60%',
      center: ['50%', '45%'],
      data: Object.entries(data || {}).map(([name, value]) => ({ name, value })),
      emphasis: { itemStyle: { shadowBlur: 10, shadowOffsetX: 0, shadowColor: 'rgba(0, 0, 0, 0.2)' } },
      itemStyle: { borderRadius: 6, borderColor: '#fff', borderWidth: 2 }
    }]
  })
  statusInstance.on('click', (params) => {
    router.push({ path: '/borrow', query: { status: `${params?.name || ''}` } })
  })
}

const initOverdueTrendChart = (data?: SeriesTrendData) => {
  const container = initChartContainer(overdueTrendChart.value)
  if (!container) return
  overdueTrendInstance?.dispose()
  overdueTrendInstance = echarts.init(container)
  overdueTrendInstance.setOption({
    tooltip: { trigger: 'axis' },
    grid: { left: '3%', right: '4%', bottom: '3%', containLabel: true },
    xAxis: { type: 'category', boundaryGap: false, data: data?.dates || [], axisLine: { lineStyle: { color: '#e0e0e0' } }, axisLabel: { color: '#5f6368', fontSize: window.innerWidth < 768 ? 10 : 13, rotate: window.innerWidth < 768 ? 45 : 0 } },
    yAxis: { type: 'value', name: '逾期数量', axisLine: { show: false }, splitLine: { lineStyle: { color: '#f0f0f0' } }, axisLabel: { color: '#5f6368', fontSize: window.innerWidth < 768 ? 10 : 13 } },
    series: [{
      name: '逾期数量',
      type: 'line',
      smooth: true,
      data: data?.overdueData || [],
      lineStyle: { color: chartColors.danger, width: 3 },
      areaStyle: { color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [{ offset: 0, color: 'rgba(234, 67, 53, 0.25)' }, { offset: 1, color: 'rgba(234, 67, 53, 0.02)' }]) },
      itemStyle: { color: chartColors.danger },
      symbol: 'circle',
      symbolSize: 6
    }]
  })
  overdueTrendInstance.on('click', (params) => {
    const expectedReturnDate = parseTrendLabelToDate(`${params?.name || ''}`)
    router.push({ path: '/borrow-history', query: buildBorrowHistoryQuery({ status: 'overdue', overdue: '1', expectedReturnDate }) })
  })
}

const initApprovalEfficiencyChart = (data?: Record<string, number>) => {
  const container = initChartContainer(approvalEfficiencyChart.value)
  if (!container) return
  approvalEfficiencyInstance?.dispose()
  approvalEfficiencyInstance = echarts.init(container)
  approvalEfficiencyInstance.setOption({
    tooltip: { trigger: 'axis', axisPointer: { type: 'shadow' } },
    grid: { left: '3%', right: '4%', bottom: '3%', containLabel: true },
    xAxis: { type: 'category', data: Object.keys(data || {}), axisLine: { lineStyle: { color: '#e0e0e0' } }, axisLabel: { color: '#5f6368', fontSize: window.innerWidth < 768 ? 10 : 13 } },
    yAxis: { type: 'value', name: '申请数量', axisLine: { show: false }, splitLine: { lineStyle: { color: '#f0f0f0' } }, axisLabel: { color: '#5f6368', fontSize: window.innerWidth < 768 ? 10 : 13 } },
    series: [{
      name: '处理数量',
      type: 'bar',
      data: Object.values(data || {}),
      itemStyle: { color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [{ offset: 0, color: chartColors.success }, { offset: 1, color: '#81c784' }]), borderRadius: [4, 4, 0, 0] },
      label: { show: true, position: 'top', formatter: '{c}', color: '#5f6368' }
    }]
  })
  approvalEfficiencyInstance.on('click', (params) => {
    const label = `${params?.name || ''}`
    let approvalBucket = ''
    if (label.includes('4') && label.includes('小时') && !label.includes('24')) approvalBucket = 'lt4h'
    else if (label.includes('24')) approvalBucket = '4to24h'
    else if (label.includes('1-3')) approvalBucket = '1to3d'
    else if (label.includes('3') && label.includes('以上')) approvalBucket = 'gt3d'
    router.push({ path: '/borrow-history', query: buildBorrowHistoryQuery({ approvalBucket }) })
  })
}

const initReturnTimelinessChart = (data?: Record<string, number>) => {
  const container = initChartContainer(returnTimelinessChart.value)
  if (!container) return
  returnTimelinessInstance?.dispose()
  returnTimelinessInstance = echarts.init(container)
  returnTimelinessInstance.setOption({
    tooltip: { trigger: 'item', formatter: '{a}<br/>{b}: {c} ({d}%)' },
    legend: { orient: 'horizontal', bottom: 'bottom', textStyle: { color: '#5f6368' } },
    color: [chartColors.success, chartColors.warning, chartColors.danger],
    series: [{
      name: '归还及时率',
      type: 'pie',
      radius: ['35%', '65%'],
      center: ['50%', '45%'],
      data: Object.entries(data || {}).map(([name, value]) => ({ name, value })),
      itemStyle: { borderRadius: 8, borderColor: '#fff', borderWidth: 3 },
      emphasis: { itemStyle: { shadowBlur: 10, shadowOffsetX: 0, shadowColor: 'rgba(0, 0, 0, 0.18)' } }
    }]
  })
  returnTimelinessInstance.on('click', (params) => {
    const label = `${params?.name || ''}`
    let returnStatus = ''
    if (label.includes('按时')) returnStatus = 'onTime'
    else if (label.includes('逾期')) returnStatus = 'overdueReturn'
    else if (label.includes('未归')) returnStatus = 'unreturned'
    router.push({ path: '/borrow-history', query: buildBorrowHistoryQuery({ returnStatus }) })
  })
}

let chartResizeTimer: ReturnType<typeof setTimeout> | null = null
const handleResize = () => {
  if (chartResizeTimer) clearTimeout(chartResizeTimer)
  chartResizeTimer = setTimeout(() => {
    borrowTrendInstance?.resize()
    borrowTypeInstance?.resize()
    departmentInstance?.resize()
    statusInstance?.resize()
    overdueTrendInstance?.resize()
    approvalEfficiencyInstance?.resize()
    returnTimelinessInstance?.resize()
  }, 200)
}

onMounted(() => {
  loadStats()
  window.addEventListener('resize', handleResize)
})

onUnmounted(() => {
  window.removeEventListener('resize', handleResize)
  borrowTrendInstance?.dispose()
  borrowTypeInstance?.dispose()
  departmentInstance?.dispose()
  statusInstance?.dispose()
  overdueTrendInstance?.dispose()
  approvalEfficiencyInstance?.dispose()
  returnTimelinessInstance?.dispose()
})
</script>

<style scoped>
.dashboard-container {
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

.refresh-tag {
  border-radius: var(--radius-full);
}

/* Stats Grid */
.stats-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: var(--space-md);
  margin-bottom: var(--space-lg);
}

.stat-card {
  background: white;
  border-radius: var(--radius-lg);
  padding: 20px;
  display: flex;
  align-items: center;
  gap: 16px;
  cursor: pointer;
  transition: all var(--transition-fast);
  border: 1px solid var(--color-border-light);
  box-shadow: var(--shadow-xs);
}

.stat-card:hover {
  transform: translateY(-2px);
  box-shadow: var(--shadow-md);
}

.stat-card-icon {
  width: 48px;
  height: 48px;
  min-width: 48px;
  border-radius: var(--radius-md);
  display: flex;
  align-items: center;
  justify-content: center;
}

.stat-card-icon svg {
  width: 24px;
  height: 24px;
}

.stat-card--total .stat-card-icon {
  background: var(--color-primary-lighter);
  color: var(--color-primary);
}

.stat-card--borrowed .stat-card-icon {
  background: var(--color-success-light);
  color: var(--color-success);
}

.stat-card--pending .stat-card-icon {
  background: var(--color-warning-light);
  color: var(--color-warning);
}

.stat-card--overdue .stat-card-icon {
  background: var(--color-danger-light);
  color: var(--color-danger);
}

.stat-card-content {
  flex: 1;
  min-width: 0;
}

.stat-card-label {
  display: block;
  font-size: var(--font-size-sm);
  color: var(--color-text-secondary);
  margin-bottom: 4px;
}

.stat-card-value {
  display: block;
  font-size: var(--font-size-4xl);
  font-weight: var(--font-weight-bold);
  color: var(--color-text-primary);
  line-height: 1.1;
}

.stat-card-arrow {
  color: var(--color-text-tertiary);
  opacity: 0;
  transition: all var(--transition-fast);
}

.stat-card-arrow svg {
  width: 18px;
  height: 18px;
}

.stat-card:hover .stat-card-arrow {
  opacity: 1;
  transform: translateX(2px);
}

/* Charts Grid */
.charts-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: var(--space-md);
}

.chart-card {
  min-height: 400px;
}

.chart-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  font-weight: var(--font-weight-semibold);
  color: var(--color-text-primary);
}

.chart-header-left {
  display: flex;
  align-items: center;
  gap: 10px;
}

.chart-header-icon {
  width: 32px;
  height: 32px;
  min-width: 32px;
  border-radius: var(--radius-sm);
  display: flex;
  align-items: center;
  justify-content: center;
}

.chart-header-icon svg {
  width: 18px;
  height: 18px;
}

.chart-header-icon--blue { background: var(--color-primary-lighter); color: var(--color-primary); }
.chart-header-icon--green { background: var(--color-success-light); color: var(--color-success); }
.chart-header-icon--purple { background: #f3e5f5; color: #9c27b0; }
.chart-header-icon--orange { background: #fff3e0; color: #ff9800; }
.chart-header-icon--red { background: var(--color-danger-light); color: var(--color-danger); }
.chart-header-icon--teal { background: #e0f2f1; color: #009688; }
.chart-header-icon--cyan { background: #e0f7fa; color: #00bcd4; }

.chart-container {
  width: 100%;
  height: 320px;
}

/* Responsive */
@media (max-width: 1200px) {
  .stats-grid {
    grid-template-columns: repeat(2, 1fr);
  }
}

@media (max-width: 768px) {
  .dashboard-container {
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

  .stats-grid {
    grid-template-columns: 1fr;
  }

  .charts-grid {
    grid-template-columns: 1fr;
  }

  .chart-card {
    min-height: 340px;
  }

  .chart-container {
    height: 280px;
  }
}

@media (max-width: 480px) {
  .dashboard-container {
    padding: var(--space-sm);
  }

  .stat-card {
    padding: 14px;
    gap: 12px;
  }

  .stat-card-icon {
    width: 40px;
    height: 40px;
    min-width: 40px;
  }

  .stat-card-value {
    font-size: var(--font-size-3xl);
  }

  .chart-container {
    height: 240px;
  }
}
</style>
