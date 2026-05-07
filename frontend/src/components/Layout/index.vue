<template>
  <div class="layout-container">
    <!-- 侧边栏 -->
    <el-aside 
      :width="isCollapse ? '64px' : '200px'" 
      class="layout-aside"
      :class="{ 'aside-collapsed': isCollapse, 'mobile-menu-open': showMobileMenu }"
    >
      <div class="aside-header">
        <div class="logo-container" :class="{ 'logo-container-collapsed': isCollapse }">
          <transition name="logo-fade" mode="out-in">
            <span v-if="!isCollapse" key="logo-text" class="logo-text">病案管理系统</span>
            <span v-else key="logo-icon" class="logo-icon">📋</span>
          </transition>
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
        background-color="transparent"
        text-color="#1D1D1F"
        active-text-color="#007AFF"
        router
        @select="onMenuSelect"
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
        
        <!-- 只有管理员才能看到管理功能和调试页面 -->
        <el-sub-menu v-if="isAdmin" index="admin">
          <template #title>
            <el-icon><Tools /></el-icon>
            <span>管理功能</span>
          </template>
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
                <el-dropdown-item @click="showUserInfo">个人信息</el-dropdown-item>
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
    
    <!-- 个人信息对话框 -->
    <el-dialog 
      v-model="userInfoDialogVisible" 
      title="个人信息" 
      width="500px"
      :close-on-click-modal="false"
    >
      <div class="user-info-detail">
        <div class="info-avatar">
          <el-avatar :size="80" :src="userAvatar" />
        </div>
        
        <div class="info-content">
          <div class="info-item">
            <span class="info-label">用户名:</span>
            <span class="info-value">{{ currentUser.username }}</span>
          </div>
          
          <div class="info-item">
            <span class="info-label">角色:</span>
            <span class="info-value">
              <el-tag :type="getRoleType(currentUser.role)" size="small">
                {{ getRoleName(currentUser.role) }}
              </el-tag>
            </span>
          </div>
          
          <div class="info-item">
            <span class="info-label">部门:</span>
            <span class="info-value">{{ currentUser.department || '-' }}</span>
          </div>
          
          <div class="info-item">
            <span class="info-label">姓名:</span>
            <span class="info-value">{{ currentUser.name }}</span>
          </div>
          
          <div class="info-item">
            <span class="info-label">电话:</span>
            <span class="info-value">{{ currentUser.phone || '-' }}</span>
          </div>
          
          <div class="info-item">
            <span class="info-label">邮箱:</span>
            <span class="info-value">{{ currentUser.email || '-' }}</span>
          </div>
          
          <div class="info-item" v-if="currentUser.position">
            <span class="info-label">职位:</span>
            <span class="info-value">{{ currentUser.position }}</span>
          </div>
        </div>
      </div>
      
      <template #footer>
        <el-button @click="userInfoDialogVisible = false">关闭</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, onUnmounted } from 'vue'
import { 
  ArrowLeft, ArrowRight, DataLine, Document, Timer, 
  Tools, Operation, Menu, ArrowDown 
} from '@element-plus/icons-vue'
import { useRouter, useRoute } from 'vue-router'
import store from '../../store'

const router = useRouter()
const route = useRoute()

// 侧边栏折叠状态
const isCollapse = ref(false)
// 移动端菜单显示状态
const showMobileMenu = ref(false)
// 用户信息对话框
const userInfoDialogVisible = ref(false)
// 用户信息
const currentUser = computed(() => store.state.user || { name: '管理员', role: '' })
const isAdmin = computed(() => currentUser.value.role === 'admin')
const userAvatar = 'https://cube.elemecdn.com/0/88/03b0d39583f48206768a7534e55bcpng.png'

// 获取角色类型（用于tag颜色）
const getRoleType = (role: string) => {
  switch (role) {
    case 'admin':
      return 'danger'
    case 'dept_approver':
      return 'warning'
    case 'archive_approver':
      return 'primary'
    default:
      return 'info'
  }
}

// 获取角色名称
const getRoleName = (role: string) => {
  switch (role) {
    case 'admin':
      return '系统管理员 (admin)'
    case 'dept_approver':
      return '科室审批员 (dept_approver)'
    case 'archive_approver':
      return '病案室审批员 (archive_approver)'
    case 'user':
      return '普通用户 (user)'
    default:
      return role || '-'
  }
}

// 显示个人信息对话框
const showUserInfo = () => {
  userInfoDialogVisible.value = true
}

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

// 移动端菜单项选中时关闭菜单
const onMenuSelect = () => {
  if (window.innerWidth < 768) {
    showMobileMenu.value = false
  }
}

// 退出登录
const handleLogout = () => {
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

onMounted(() => {
  window.addEventListener('resize', handleResize)
})

onUnmounted(() => {
  window.removeEventListener('resize', handleResize)
})
</script>

<style scoped>
.layout-container {
  display: flex;
  height: 100vh;
  overflow: hidden;
  position: relative;
}

.layout-container::before {
  content: '';
  position: absolute;
  inset: 0;
  background: linear-gradient(180deg, #4A9FE5 0%, #87CEEB 40%, #B0E0E6 70%, #E8F4FD 100%);
  z-index: 0;
  pointer-events: none;
}

.layout-container::after {
  content: '';
  position: absolute;
  top: -100px;
  right: -100px;
  width: 400px;
  height: 400px;
  border-radius: 50%;
  background: radial-gradient(circle, rgba(255, 255, 255, 0.4) 0%, transparent 70%);
  z-index: 0;
  pointer-events: none;
}

.layout-aside {
  position: relative;
  z-index: 10;
  background: rgba(255, 255, 255, 0.65) !important;
  backdrop-filter: blur(20px) saturate(180%) !important;
  -webkit-backdrop-filter: blur(20px) saturate(180%) !important;
  border-right: 1px solid rgba(255, 255, 255, 0.5);
  box-shadow: 4px 0 24px rgba(0, 0, 0, 0.05);
  transition: width 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  overflow: hidden;
}

.aside-header {
  display: flex;
  align-items: center;
  padding: 0 16px;
  height: 64px;
  border-bottom: 1px solid rgba(0, 0, 0, 0.06);
  position: relative;
}

.aside-collapsed .aside-header {
  padding: 0;
  display: flex;
  justify-content: center;
  align-items: center;
  position: relative;
}

.logo-container {
  display: flex;
  align-items: center;
  justify-content: center;
  min-width: 0;
  flex: 1;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.logo-container-collapsed {
  flex: 0 0 auto;
}

.aside-collapsed .logo-container {
  flex: 0 0 auto;
}

.logo-text {
  color: #007AFF;
  font-size: 16px;
  font-weight: 600;
  white-space: nowrap;
}

.logo-icon {
  font-size: 24px;
  display: inline-flex;
  align-items: center;
  justify-content: center;
}

.logo-fade-enter-active,
.logo-fade-leave-active {
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.logo-fade-enter-from {
  opacity: 0;
  transform: translateY(-10px);
}

.logo-fade-leave-to {
  opacity: 0;
  transform: translateY(10px);
}

.collapse-btn {
  color: #007AFF;
  font-size: 16px;
  background: rgba(0, 122, 255, 0.1);
  border-radius: 8px;
  width: 32px;
  height: 32px;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.2s ease-out;
  flex-shrink: 0;
}

.collapse-btn:hover {
  background: rgba(0, 122, 255, 0.2);
}

.aside-collapsed .collapse-btn {
  position: absolute;
  right: 8px;
}

.layout-menu {
  border-right: none !important;
  height: calc(100vh - 64px);
  background: transparent !important;
}

/* Expanded state: align icons and text properly */
:deep(.layout-menu .el-menu-item) {
  border-radius: 12px !important;
  margin: 4px 8px;
  padding: 0 20px !important;
  height: 48px;
  line-height: 48px;
  display: flex !important;
  align-items: center !important;
  transition: all 0.2s ease-out;
}

:deep(.layout-menu .el-menu-item .el-icon) {
  margin-right: 12px;
  font-size: 18px;
  flex-shrink: 0;
  width: 18px;
  height: 18px;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  vertical-align: middle;
}

:deep(.layout-menu .el-menu-item span) {
  white-space: nowrap;
  line-height: 1;
}

/* Collapsed state: center icons */
:deep(.aside-collapsed .layout-menu .el-menu-item) {
  margin: 4px 8px !important;
  padding: 0 !important;
  justify-content: center !important;
  align-items: center !important;
  height: 48px !important;
}

:deep(.aside-collapsed .layout-menu .el-menu-item .el-icon) {
  margin-right: 0 !important;
  font-size: 20px;
  width: auto !important;
  height: auto !important;
}

:deep(.aside-collapsed .layout-menu .el-menu-item span:not(.el-icon)) {
  display: none !important;
}

:deep(.layout-menu .el-menu-item:hover) {
  background: rgba(0, 122, 255, 0.08) !important;
}

:deep(.layout-menu .el-menu-item.is-active) {
  background: rgba(0, 122, 255, 0.15) !important;
  color: #007AFF !important;
}

.layout-main {
  flex: 1;
  display: flex;
  flex-direction: column;
  overflow: hidden;
  position: relative;
  z-index: 1;
}

.layout-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 0 20px;
  height: 64px;
  background: rgba(255, 255, 255, 0.6);
  backdrop-filter: blur(20px);
  -webkit-backdrop-filter: blur(20px);
  border-bottom: 1px solid rgba(255, 255, 255, 0.5);
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
}

.header-left {
  display: flex;
  align-items: center;
}

.mobile-menu-btn {
  display: none;
  font-size: 20px;
  color: #1D1D1F;
  background: rgba(0, 0, 0, 0.05);
  border-radius: 8px;
  width: 36px;
  height: 36px;
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
  padding: 6px 12px;
  border-radius: 20px;
  background: rgba(255, 255, 255, 0.6);
  backdrop-filter: blur(10px);
  transition: all 0.2s ease-out;
}

.user-info:hover {
  background: rgba(255, 255, 255, 0.8);
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
}

.user-name {
  font-size: 14px;
  color: #1D1D1F;
  font-weight: 500;
}

.user-info-detail {
  display: flex;
  flex-direction: column;
  align-items: center;
}

.info-avatar {
  margin-bottom: 24px;
}

.info-content {
  width: 100%;
}

.info-item {
  display: flex;
  align-items: center;
  padding: 12px 0;
  border-bottom: 1px solid rgba(0, 0, 0, 0.06);
}

.info-item:last-child {
  border-bottom: none;
}

.info-label {
  width: 80px;
  font-weight: 500;
  color: #86868B;
  font-size: 14px;
}

.info-value {
  flex: 1;
  color: #1D1D1F;
  font-size: 14px;
}

.layout-content {
  flex: 1;
  padding: 20px;
  overflow-y: auto;
  background: transparent;
}

.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}

.mobile-menu-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.45);
  backdrop-filter: blur(4px);
  z-index: 1000;
  transition: opacity 0.3s ease;
}

@media (max-width: 768px) {
  .layout-container {
    flex-direction: column;
  }
  
  .layout-aside {
    position: fixed;
    left: -260px;
    top: 64px;
    bottom: 0;
    width: 260px !important;
    z-index: 1001;
    transition: left 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    background: rgba(255, 255, 255, 0.95) !important;
    backdrop-filter: blur(20px) saturate(180%) !important;
    box-shadow: 4px 0 32px rgba(0, 0, 0, 0.15);
    overflow-y: auto;
  }
  
  .layout-aside.mobile-menu-open {
    left: 0;
  }
  
  .mobile-menu-btn {
    display: flex;
    align-items: center;
    justify-content: center;
  }
  
  .layout-header {
    padding: 0 16px;
  }
  
  .layout-content {
    padding: 10px;
  }
  
  .aside-header {
    padding: 0 16px;
    height: 56px;
    border-bottom: 1px solid rgba(0, 0, 0, 0.08);
  }
  
  .logo-text {
    font-size: 15px;
    font-weight: 600;
  }
  
  .layout-menu {
    height: calc(100vh - 56px);
    padding: 8px 0;
  }
  
  .layout-menu .el-menu-item {
    margin: 4px 12px !important;
    padding: 0 16px !important;
    height: 50px !important;
    line-height: 50px !important;
    font-size: 15px !important;
    border-radius: 10px !important;
  }
  
  .layout-menu .el-menu-item .el-icon {
    font-size: 20px !important;
    width: 20px !important;
    height: 20px !important;
    margin-right: 14px !important;
  }
  
  .layout-menu .el-sub-menu__title {
    height: 50px !important;
    line-height: 50px !important;
    font-size: 15px !important;
    margin: 4px 12px !important;
    border-radius: 10px !important;
  }
  
  .layout-menu .el-sub-menu__title .el-icon {
    font-size: 20px !important;
    margin-right: 14px !important;
  }
  
  .layout-menu .el-sub-menu .el-menu-item {
    margin: 2px 12px 2px 24px !important;
    padding: 0 16px !important;
    height: 48px !important;
    line-height: 48px !important;
    font-size: 14px !important;
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
  
  .layout-aside {
    width: 240px !important;
    left: -240px;
  }
  
  .mobile-menu-overlay {
    z-index: 1000;
  }
}
</style>
