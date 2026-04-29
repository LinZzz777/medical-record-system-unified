<template>
  <div class="dashboard-container">
    <el-card class="dashboard-card">
      <template #header>
        <div class="card-header">
          <span>&#25968;&#25454;&#21487;&#35270;&#21270;&#30475;&#26495;</span>
          <el-tag type="success">&#23454;&#26102;&#26356;&#26032;</el-tag>
        </div>
      </template>

      <div class="stats-grid">
        <el-card shadow="hover" class="stat-card stat-card-clickable" @click="handleStatCardClick('totalRecords')">
          <div class="stat-content">
            <div class="stat-icon total-icon">&#128211;</div>
            <div class="stat-title">&#24635;&#30149;&#26696;&#25968;</div>
            <div class="stat-value">{{ stats.totalRecords || 0 }}</div>
          </div>
        </el-card>

        <el-card shadow="hover" class="stat-card stat-card-clickable" @click="handleStatCardClick('borrowedCount')">
          <div class="stat-content">
            <div class="stat-icon borrowed-icon">&#128214;</div>
            <div class="stat-title">&#24050;&#20511;&#20986;</div>
            <div class="stat-value">{{ stats.borrowedCount || 0 }}</div>
          </div>
        </el-card>

        <el-card shadow="hover" class="stat-card stat-card-clickable" @click="handleStatCardClick('pendingCount')">
          <div class="stat-content">
            <div class="stat-icon pending-icon">&#9203;</div>
            <div class="stat-title">&#24453;&#23457;&#25209;</div>
            <div class="stat-value">{{ stats.pendingCount || 0 }}</div>
          </div>
        </el-card>

        <el-card shadow="hover" class="stat-card stat-card-clickable" @click="handleStatCardClick('overdueCount')">
          <div class="stat-content">
            <div class="stat-icon overdue-icon">&#9888;</div>
            <div class="stat-title">&#24050;&#36807;&#26399;</div>
            <div class="stat-value">{{ stats.overdueCount || 0 }}</div>
          </div>
        </el-card>
      </div>

      <div class="charts-grid">
        <el-card class="chart-card">
          <template #header>
            <div class="chart-header">
              <span>&#36817;30&#26085;&#20511;&#38405;&#36235;&#21183;</span>
              <el-tooltip content="&#28857;&#20987;&#26576;&#20010;&#26085;&#26399;&#21518;&#65292;&#36339;&#36716;&#21040;&#24403;&#22825;&#30340;&#20511;&#38405;&#30003;&#35831;" placement="top">
                <el-icon><QuestionFilled /></el-icon>
              </el-tooltip>
            </div>
          </template>
          <div ref="borrowTrendChart" class="chart-container"></div>
        </el-card>

        <el-card class="chart-card">
          <template #header>
            <div class="chart-header">
              <span>&#20511;&#38405;&#31867;&#22411;&#20998;&#24067;</span>
              <el-tooltip content="&#28857;&#20987;&#38498;&#20869;&#20511;&#38405;&#25110;&#38498;&#22806;&#20511;&#38405;&#21518;&#65292;&#36339;&#36716;&#21040;&#23545;&#24212;&#30340;&#20511;&#38405;&#21382;&#21490;" placement="top">
                <el-icon><QuestionFilled /></el-icon>
              </el-tooltip>
            </div>
          </template>
          <div ref="borrowTypeChart" class="chart-container"></div>
        </el-card>

        <el-card v-if="isAdmin" class="chart-card">
          <template #header>
            <div class="chart-header">
              <span>&#31185;&#23460;&#20511;&#38405;&#27963;&#36291;&#24230;</span>
              <el-tooltip content="&#28857;&#20987;&#26576;&#20010;&#31185;&#23460;&#21518;&#65292;&#36339;&#36716;&#21040;&#35813;&#31185;&#23460;&#30340;&#34987;&#20511;&#20986;&#30149;&#26696;" placement="top">
                <el-icon><QuestionFilled /></el-icon>
              </el-tooltip>
            </div>
          </template>
          <div ref="departmentChart" class="chart-container"></div>
        </el-card>

        <el-card class="chart-card">
          <template #header>
            <div class="chart-header">
              <span>&#29366;&#24577;&#20998;&#24067;</span>
              <el-tooltip content="&#28857;&#20987;&#26576;&#20010;&#29366;&#24577;&#25159;&#21306;&#21518;&#65292;&#36339;&#36716;&#21040;&#23545;&#24212;&#30340;&#30149;&#26696;&#25968;&#25454;" placement="top">
                <el-icon><QuestionFilled /></el-icon>
              </el-tooltip>
            </div>
          </template>
          <div ref="statusChart" class="chart-container"></div>
        </el-card>

        <el-card v-if="isAdmin" class="chart-card">
          <template #header>
            <div class="chart-header">
              <span>&#36817;30&#26085;&#36807;&#26399;&#36235;&#21183;</span>
              <el-tooltip content="&#28857;&#20987;&#26576;&#20010;&#26085;&#26399;&#21518;&#65292;&#26597;&#30475;&#35813;&#26085;&#24212;&#24402;&#36824;&#19988;&#24050;&#36807;&#26399;&#30340;&#30003;&#35831;" placement="top">
                <el-icon><QuestionFilled /></el-icon>
              </el-tooltip>
            </div>
          </template>
          <div ref="overdueTrendChart" class="chart-container"></div>
        </el-card>

        <el-card v-if="isAdmin" class="chart-card">
          <template #header>
            <div class="chart-header">
              <span>&#23457;&#25209;&#25928;&#29575;&#20998;&#24067;</span>
              <el-tooltip content="&#26174;&#31034;&#20174;&#30003;&#35831;&#25552;&#20132;&#21040;&#22788;&#29702;&#23436;&#25104;&#30340;&#32791;&#26102;&#20998;&#24067;" placement="top">
                <el-icon><QuestionFilled /></el-icon>
              </el-tooltip>
            </div>
          </template>
          <div ref="approvalEfficiencyChart" class="chart-container"></div>
        </el-card>

        <el-card v-if="isAdmin" class="chart-card">
          <template #header>
            <div class="chart-header">
              <span>&#24402;&#36824;&#21450;&#26102;&#29575;</span>
              <el-tooltip content="&#26174;&#31034;&#25353;&#26102;&#24402;&#36824;&#12289;&#36807;&#26399;&#24402;&#36824;&#21644;&#26410;&#24402;&#36824;&#30340;&#20998;&#24067;" placement="top">
                <el-icon><QuestionFilled /></el-icon>
              </el-tooltip>
            </div>
          </template>
          <div ref="returnTimelinessChart" class="chart-container"></div>
        </el-card>
      </div>
    </el-card>
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

  if (Number.isNaN(parsedDate.getTime())) {
    return ''
  }

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
    router.push({
      path: '/borrow-history',
      query: buildBorrowHistoryQuery({ status: 'approved' })
    })
    return
  }

  if (type === 'pendingCount') {
    if (isDeptDirector.value) {
      router.push('/review')
      return
    }
    router.push({
      path: '/borrow-history',
      query: buildBorrowHistoryQuery({ status: 'pending' })
    })
    return
  }

  if (type === 'overdueCount') {
    router.push({
      path: '/borrow-history',
      query: buildBorrowHistoryQuery({ status: 'overdue', overdue: '1' })
    })
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
    xAxis: { type: 'category', boundaryGap: false, data: data?.months || [] },
    yAxis: { type: 'value', name: '\u501f\u9605\u6b21\u6570' },
    series: [
      {
        name: '\u501f\u9605\u91cf',
        type: 'line',
        smooth: true,
        data: data?.borrowData || [],
        lineStyle: { color: '#409eff', width: 3 },
        areaStyle: {
          color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
            { offset: 0, color: 'rgba(64, 158, 255, 0.5)' },
            { offset: 1, color: 'rgba(64, 158, 255, 0.1)' }
          ])
        },
        itemStyle: { color: '#409eff' }
      }
    ]
  })

  borrowTrendInstance.on('click', (params) => {
    const submitTimeDate = parseTrendLabelToDate(`${params?.name || ''}`)
    router.push({
      path: '/borrow-history',
      query: buildBorrowHistoryQuery({ submitTimeDate })
    })
  })
}

const initBorrowTypeChart = (data?: Record<string, number>) => {
  const container = initChartContainer(borrowTypeChart.value)
  if (!container) return

  borrowTypeInstance?.dispose()
  borrowTypeInstance = echarts.init(container)

  borrowTypeInstance.setOption({
    tooltip: { trigger: 'item', formatter: '{a}<br/>{b}: {c} ({d}%)' },
    legend: { orient: 'vertical', left: 'left' },
    series: [
      {
        name: '\u501f\u9605\u7c7b\u578b',
        type: 'pie',
        radius: ['40%', '70%'],
        avoidLabelOverlap: false,
        itemStyle: {
          borderRadius: 10,
          borderColor: '#fff',
          borderWidth: 2
        },
        label: { show: false, position: 'center' },
        emphasis: {
          label: { show: true, fontSize: 18, fontWeight: 'bold' }
        },
        labelLine: { show: false },
        data: Object.entries(data || {}).map(([name, value]) => ({ name, value }))
      }
    ]
  })

  borrowTypeInstance.on('click', (params) => {
    router.push({
      path: '/borrow-history',
      query: buildBorrowHistoryQuery({ borrowType: `${params?.name || ''}` })
    })
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
    xAxis: { type: 'value', name: '\u501f\u9605\u6b21\u6570' },
    yAxis: { type: 'category', data: Object.keys(data || {}) },
    series: [
      {
        name: '\u501f\u9605\u6b21\u6570',
        type: 'bar',
        data: Object.values(data || {}),
        itemStyle: {
          color: new echarts.graphic.LinearGradient(0, 0, 1, 0, [
            { offset: 0, color: '#83bff6' },
            { offset: 0.5, color: '#188df0' },
            { offset: 1, color: '#188df0' }
          ])
        },
        label: { show: true, position: 'right', formatter: '{c}' }
      }
    ]
  })

  departmentInstance.on('click', (params) => {
    router.push({
      path: '/borrow',
      query: {
        department: `${params?.name || ''}`,
        status: '\u5df2\u501f\u51fa'
      }
    })
  })
}

const initStatusChart = (data?: Record<string, number>) => {
  const container = initChartContainer(statusChart.value)
  if (!container) return

  statusInstance?.dispose()
  statusInstance = echarts.init(container)

  statusInstance.setOption({
    tooltip: { trigger: 'item', formatter: '{a}<br/>{b}: {c}' },
    legend: { orient: 'horizontal', bottom: 'bottom' },
    series: [
      {
        name: '\u72b6\u6001\u5206\u5e03',
        type: 'pie',
        radius: '60%',
        center: ['50%', '45%'],
        data: Object.entries(data || {}).map(([name, value]) => ({ name, value })),
        emphasis: {
          itemStyle: {
            shadowBlur: 10,
            shadowOffsetX: 0,
            shadowColor: 'rgba(0, 0, 0, 0.5)'
          }
        }
      }
    ]
  })

  statusInstance.on('click', (params) => {
    router.push({
      path: '/borrow',
      query: { status: `${params?.name || ''}` }
    })
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
    xAxis: { type: 'category', boundaryGap: false, data: data?.dates || [] },
    yAxis: { type: 'value', name: '\u903e\u671f\u6570\u91cf' },
    series: [
      {
        name: '\u903e\u671f\u6570\u91cf',
        type: 'line',
        smooth: true,
        data: data?.overdueData || [],
        lineStyle: { color: '#f56c6c', width: 3 },
        areaStyle: {
          color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
            { offset: 0, color: 'rgba(245, 108, 108, 0.4)' },
            { offset: 1, color: 'rgba(245, 108, 108, 0.08)' }
          ])
        },
        itemStyle: { color: '#f56c6c' }
      }
    ]
  })

  overdueTrendInstance.on('click', (params) => {
    const expectedReturnDate = parseTrendLabelToDate(`${params?.name || ''}`)
    router.push({
      path: '/borrow-history',
      query: buildBorrowHistoryQuery({
        status: 'overdue',
        overdue: '1',
        expectedReturnDate
      })
    })
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
    xAxis: { type: 'category', data: Object.keys(data || {}) },
    yAxis: { type: 'value', name: '\u7533\u8bf7\u6570\u91cf' },
    series: [
      {
        name: '\u5904\u7406\u6570\u91cf',
        type: 'bar',
        data: Object.values(data || {}),
        itemStyle: {
          color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
            { offset: 0, color: '#67c23a' },
            { offset: 1, color: '#95d475' }
          ])
        },
        label: { show: true, position: 'top', formatter: '{c}' }
      }
    ]
  })

  approvalEfficiencyInstance.on('click', (params) => {
    const label = `${params?.name || ''}`
    let approvalBucket = ''

    if (label.includes('4') && label.includes('\u5c0f\u65f6') && !label.includes('24')) {
      approvalBucket = 'lt4h'
    } else if (label.includes('24')) {
      approvalBucket = '4to24h'
    } else if (label.includes('1-3')) {
      approvalBucket = '1to3d'
    } else if (label.includes('3') && label.includes('\u4ee5\u4e0a')) {
      approvalBucket = 'gt3d'
    }

    router.push({
      path: '/borrow-history',
      query: buildBorrowHistoryQuery({ approvalBucket })
    })
  })
}

const initReturnTimelinessChart = (data?: Record<string, number>) => {
  const container = initChartContainer(returnTimelinessChart.value)
  if (!container) return

  returnTimelinessInstance?.dispose()
  returnTimelinessInstance = echarts.init(container)

  returnTimelinessInstance.setOption({
    tooltip: { trigger: 'item', formatter: '{a}<br/>{b}: {c} ({d}%)' },
    legend: { orient: 'horizontal', bottom: 'bottom' },
    series: [
      {
        name: '\u5f52\u8fd8\u53ca\u65f6\u7387',
        type: 'pie',
        radius: ['35%', '65%'],
        center: ['50%', '45%'],
        data: Object.entries(data || {}).map(([name, value]) => ({ name, value })),
        itemStyle: {
          borderRadius: 8,
          borderColor: '#fff',
          borderWidth: 2
        },
        emphasis: {
          itemStyle: {
            shadowBlur: 10,
            shadowOffsetX: 0,
            shadowColor: 'rgba(0, 0, 0, 0.18)'
          }
        }
      }
    ]
  })

  returnTimelinessInstance.on('click', (params) => {
    const label = `${params?.name || ''}`
    let returnStatus = ''

    if (label.includes('\u6309\u65f6')) {
      returnStatus = 'onTime'
    } else if (label.includes('\u903e\u671f')) {
      returnStatus = 'overdueReturn'
    } else if (label.includes('\u672a\u5f52')) {
      returnStatus = 'unreturned'
    }

    router.push({
      path: '/borrow-history',
      query: buildBorrowHistoryQuery({ returnStatus })
    })
  })
}

const handleResize = () => {
  borrowTrendInstance?.resize()
  borrowTypeInstance?.resize()
  departmentInstance?.resize()
  statusInstance?.resize()
  overdueTrendInstance?.resize()
  approvalEfficiencyInstance?.resize()
  returnTimelinessInstance?.resize()
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
  padding: 20px;
}

.dashboard-card {
  margin-bottom: 20px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.stats-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 20px;
  margin: 20px 0 24px;
}

.stat-card {
  transition: all 0.3s ease;
  border-radius: 8px;
}

.stat-card-clickable {
  cursor: pointer;
}

.stat-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1) !important;
}

.stat-content {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 20px;
}

.stat-icon {
  font-size: 32px;
  margin-bottom: 10px;
}

.stat-title {
  font-size: 14px;
  color: #606266;
  margin-bottom: 10px;
}

.stat-value {
  font-size: 28px;
  font-weight: 700;
  color: #303133;
}

.total-icon {
  color: #409eff;
}

.borrowed-icon {
  color: #67c23a;
}

.pending-icon {
  color: #e6a23c;
}

.overdue-icon {
  color: #f56c6c;
}

.charts-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(340px, 1fr));
  gap: 20px;
}

.chart-card {
  min-height: 380px;
}

.chart-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  font-weight: 600;
}

.chart-container {
  width: 100%;
  height: 320px;
}

@media (max-width: 768px) {
  .dashboard-container {
    padding: 10px;
  }

  .stats-grid,
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
</style>
