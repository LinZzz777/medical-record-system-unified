<template>
  <div class="layout-container">
    <!-- 侧边栏 -->
    <el-aside 
      :width="isCollapse ? '64px' : '200px'" 
      class="layout-aside"
      :class="{ 'aside-collapsed': isCollapse }"
    >
      <div class="aside-header">
        <div class="logo" :class="{ 'logo-collapsed': isCollapse }">
          <span v-if="!isCollapse" class="logo-text">病案管理系统</span>
          <span v-else class="logo-icon">📋</span>
        </div>
        <el-button 
          type="text" 
          class="collapse-btn"
          @click="toggleCollapse"
        >
          <el-icon><ArrowLeft v-if="!isCollapse" /><ArrowRight v-else /></el-icon>
        </el-button>
      </div>
      
      <el-menu
        :default-active="activeMenu"
        class="layout-menu"
        :collapse="isCollapse"
        background-color="#001529"
        text-color="#fff"
        active-text-color="#ffd04b"
        router
      >
        <el-menu-item index="/dashboard">
          <el-icon><DataLine /></el-icon>
          <template #title>仪表盘</template>
        </el-menu-item>
        <el-menu-item index="/borrow">
          <el-icon><Document /></el-icon>
          <template #title>借阅申请</template>
        </el-menu-item>
        <el-menu-item index="/borrow-history">
          <el-icon><Timer /></el-icon>
          <template #title>借阅历史</template>
        </el-menu-item>
        
        <!-- 科室主任独立审核入口 -->
        <el-menu-item v-if="isDeptDirector && !isAdminOrDirector" index="/review">
          <el-icon><Checked /></el-icon>
          <template #title>审核管理</template>
        </el-menu-item>

        <!-- 只有管理员和主任才能看到管理功能 -->
        <el-sub-menu v-if="isAdminOrDirector" index="admin">
          <template #title>
            <el-icon><Tools /></el-icon>
            <span>管理功能</span>
          </template>
          <el-menu-item index="/review">
            <template #title>审核管理</template>
          </el-menu-item>
          <el-menu-item index="/users">
            <template #title>用户管理</template>
          </el-menu-item>
          <el-menu-item index="/audit">
            <template #title>审计日志</template>
          </el-menu-item>
        </el-sub-menu>
        
        <el-menu-item v-if="isAdmin" index="/test">
          <el-icon><Operation /></el-icon>
          <template #title>调试页面</template>
        </el-menu-item>
      </el-menu>
    </el-aside>
    
    <!-- 主内容区 -->
    <el-container class="layout-main">
      <!-- 顶部导航栏 -->
      <el-header class="layout-header">
        <div class="header-left">
          <el-button 
            type="text" 
            class="mobile-menu-btn"
            @click="toggleMobileMenu"
          >
            <el-icon><Menu /></el-icon>
          </el-button>
        </div>
        
        <div class="header-right">
          <el-dropdown trigger="click">
            <div class="user-info">
              <el-avatar :size="32">
                <img :src="userAvatar" />
              </el-avatar>
              <span class="user-name">{{ currentUser.name }}</span>
              <el-icon><ArrowDown /></el-icon>
            </div>
            <template #dropdown>
              <el-dropdown-menu>
                <el-dropdown-item>个人信息</el-dropdown-item>
                <el-dropdown-item divided @click="handleLogout">退出登录</el-dropdown-item>
              </el-dropdown-menu>
            </template>
          </el-dropdown>
        </div>
      </el-header>
      
      <!-- 内容区域 -->
      <el-main class="layout-content">
        <router-view v-slot="{ Component }">
          <transition name="fade" mode="out-in">
            <component :is="Component" />
          </transition>
        </router-view>
      </el-main>
    </el-container>
    
    <!-- 移动端菜单遮罩 -->
    <div 
      v-if="showMobileMenu" 
      class="mobile-menu-overlay"
      @click="toggleMobileMenu"
    ></div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, onUnmounted } from 'vue'
import {
  ArrowLeft, ArrowRight, DataLine, Document, Timer,
  Tools, Operation, Menu, ArrowDown, Checked
} from '@element-plus/icons-vue'
import { ElMessage } from 'element-plus'
import { useRouter, useRoute } from 'vue-router'
import store from '../../store'
import service from '../../api/request'

const router = useRouter()
const route = useRoute()

// 侧边栏折叠状态
const isCollapse = ref(false)
// 移动端菜单显示状态
const showMobileMenu = ref(false)
// 用户信息
const currentUser = computed(() => store.state.user || { name: '管理员', role: '' })
const isAdmin = computed(() => currentUser.value.role === 'admin')
const isDirector = computed(() => currentUser.value.role === '主任')
const isDeptDirector = computed(() => currentUser.value.role === 'dept_director')
const isAdminOrDirector = computed(() => currentUser.value.role === 'admin' || currentUser.value.role === '主任')
const canReview = computed(() => currentUser.value.role === 'admin' || currentUser.value.role === '主任' || currentUser.value.role === 'dept_director')
const userAvatar = 'https://cube.elemecdn.com/0/88/03b0d39583f48206768a7534e55bcpng.png'

// 当前激活的菜单
const activeMenu = computed(() => {
  const path = route.path
  return path || '/dashboard'
})

// 切换侧边栏折叠状态
const toggleCollapse = () => {
  isCollapse.value = !isCollapse.value
}

// 切换移动端菜单
const toggleMobileMenu = () => {
  showMobileMenu.value = !showMobileMenu.value
}

// 退出登录
const handleLogout = async () => {
  clearActivityTimer()
  try {
    const username = currentUser.value?.username || ''
    await service.post('/users/logout', { username })
  } catch (e) {
    // 即使登出接口失败也不影响前端登出流程
  }
  store.dispatch('logout')
  router.push('/login')
}

// 响应式处理
const handleResize = () => {
  const width = window.innerWidth
  if (width < 768) {
    showMobileMenu.value = false
  }
}

// 空闲超时自动登出
const IDLE_TIMEOUT_MS = 30 * 60 * 1000 // 30分钟
const WARNING_BEFORE_MS = 60 * 1000 // 超时前1分钟提醒
let idleTimer: ReturnType<typeof setTimeout> | null = null
let warningTimer: ReturnType<typeof setTimeout> | null = null

const resetActivityTimer = () => {
  clearActivityTimer()
  // 未登录不启动计时
  if (!store.state.token) return
  warningTimer = setTimeout(() => {
    ElMessage.warning('长时间未操作，即将自动退出登录')
  }, IDLE_TIMEOUT_MS - WARNING_BEFORE_MS)
  idleTimer = setTimeout(() => {
    ElMessage.error('长时间未操作，已自动退出登录')
    handleLogout()
  }, IDLE_TIMEOUT_MS)
}

const clearActivityTimer = () => {
  if (idleTimer) { clearTimeout(idleTimer); idleTimer = null }
  if (warningTimer) { clearTimeout(warningTimer); warningTimer = null }
}

const activityEvents = ['mousedown', 'mousemove', 'keydown', 'scroll', 'touchstart', 'wheel']

onMounted(() => {
  window.addEventListener('resize', handleResize)
  activityEvents.forEach(event => {
    window.addEventListener(event, resetActivityTimer)
  })
  resetActivityTimer()
})

onUnmounted(() => {
  window.removeEventListener('resize', handleResize)
  activityEvents.forEach(event => {
    window.removeEventListener(event, resetActivityTimer)
  })
  clearActivityTimer()
})
</script>

<style scoped>
.layout-container {
  display: flex;
  height: 100vh;
  overflow: hidden;
}

/* 侧边栏样式 */
.layout-aside {
  background-color: #001529;
  transition: width 0.3s ease;
  overflow: hidden;
  position: relative;
  z-index: 1000;
}

.aside-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 0 16px;
  height: 64px;
  border-bottom: 1px solid #000f1f;
}

.logo {
  display: flex;
  align-items: center;
  gap: 8px;
  color: #fff;
  font-size: 16px;
  font-weight: 500;
  transition: all 0.3s ease;
}

.logo-collapsed {
  font-size: 24px;
}

.logo-icon {
  font-size: 24px;
}

.collapse-btn {
  color: #fff;
  font-size: 16px;
}

.layout-menu {
  border-right: none;
  height: calc(100vh - 64px);
}

/* 主内容区样式 */
.layout-main {
  flex: 1;
  display: flex;
  flex-direction: column;
  overflow: hidden;
}

.layout-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 0 20px;
  height: 64px;
  background-color: #fff;
  border-bottom: 1px solid #e4e7ed;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
}

.header-left {
  display: flex;
  align-items: center;
}

.mobile-menu-btn {
  display: none;
  font-size: 20px;
  color: #606266;
}

.header-right {
  display: flex;
  align-items: center;
  gap: 16px;
}

.user-info {
  display: flex;
  align-items: center;
  gap: 8px;
  cursor: pointer;
  padding: 4px 8px;
  border-radius: 4px;
  transition: background-color 0.3s ease;
}

.user-info:hover {
  background-color: #f5f7fa;
}

.user-name {
  font-size: 14px;
  color: #303133;
}

/* 内容区域样式 */
.layout-content {
  flex: 1;
  padding: 0;
  margin: 0;
  overflow-y: auto;
  background-color: #f5f7fa;
}

/* 过渡动画 */
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.3s ease;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}

/* 移动端菜单遮罩 */
.mobile-menu-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(0, 0, 0, 0.5);
  z-index: 999;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .layout-container {
    flex-direction: column;
  }
  
  .layout-aside {
    position: fixed;
    left: -200px;
    top: 64px;
    bottom: 0;
    width: 200px !important;
    z-index: 1001;
    transition: left 0.3s ease;
  }
  
  .layout-aside.mobile-menu-open {
    left: 0;
  }
  
  .mobile-menu-btn {
    display: block;
  }
  
  .layout-header {
    padding: 0 16px;
  }
  
  .layout-content {
    padding: 10px;
  }
}

@media (max-width: 480px) {
  .aside-header {
    padding: 0 12px;
  }
  
  .layout-header {
    padding: 0 12px;
    height: 56px;
  }
  
  .layout-menu {
    height: calc(100vh - 56px);
  }
  
  .user-name {
    display: none;
  }
}
</style>
