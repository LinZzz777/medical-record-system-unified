<template>
  <div class="layout-container">
    <!-- Sidebar -->
    <aside
      class="layout-aside"
      :class="{ 'aside-collapsed': isCollapse, 'mobile-open': showMobileMenu }"
    >
      <div class="aside-header">
        <div class="logo-wrapper">
          <div class="logo-icon-box">
            <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
              <path d="M12 2L3 7V17L12 22L21 17V7L12 2Z" stroke="currentColor" stroke-width="1.5" stroke-linejoin="round"/>
              <path d="M12 8V16M8 12H16" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
            </svg>
          </div>
          <transition name="fade">
            <span v-if="!isCollapse" class="logo-text">病案管理系统</span>
          </transition>
        </div>
        <button class="collapse-btn" @click="toggleCollapse">
          <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg" :class="{ 'rotated': isCollapse }">
            <path d="M15 18L9 12L15 6" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
          </svg>
        </button>
      </div>

      <nav class="aside-nav">
        <router-link
          to="/dashboard"
          class="nav-item"
          :class="{ active: activeMenu === '/dashboard' }"
        >
          <span class="nav-icon">
            <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
              <path d="M3 12L5 10M5 10L12 3L19 10M5 10V20C5 20.5523 5.44772 21 6 21H9M19 10L21 12M19 10V20C19 20.5523 18.5523 21 18 21H15M9 21C9.55228 21 10 20.5523 10 20V16C10 15.4477 10.4477 15 11 15H13C13.5523 15 14 15.4477 14 16V20C14 20.5523 14.4477 21 15 21M9 21H15" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
          </span>
          <transition name="fade">
            <span v-if="!isCollapse" class="nav-label">仪表盘</span>
          </transition>
        </router-link>

        <router-link
          to="/borrow"
          class="nav-item"
          :class="{ active: activeMenu === '/borrow' }"
        >
          <span class="nav-icon">
            <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
              <path d="M9 12H15M12 9V15M3 5C3 3.89543 3.89543 3 5 3H19C20.1046 3 21 3.89543 21 5V19C21 20.1046 20.1046 21 19 21H5C3.89543 21 3 20.1046 3 19V5Z" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
          </span>
          <transition name="fade">
            <span v-if="!isCollapse" class="nav-label">借阅申请</span>
          </transition>
        </router-link>

        <router-link
          to="/borrow-history"
          class="nav-item"
          :class="{ active: activeMenu === '/borrow-history' }"
        >
          <span class="nav-icon">
            <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
              <path d="M12 8V12L15 15M3 12C3 7.02944 7.02944 3 12 3C16.9706 3 21 7.02944 21 12C21 16.9706 16.9706 21 12 21C7.02944 21 3 16.9706 3 12Z" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
          </span>
          <transition name="fade">
            <span v-if="!isCollapse" class="nav-label">借阅历史</span>
          </transition>
        </router-link>

        <!-- Dept Director standalone review entry -->
        <router-link
          v-if="isDeptDirector && !isAdminOrDirector"
          to="/review"
          class="nav-item"
          :class="{ active: activeMenu === '/review' }"
        >
          <span class="nav-icon">
            <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
              <path d="M9 12L11 14L15 10M3 5C3 3.89543 3.89543 3 5 3H19C20.1046 3 21 3.89543 21 5V19C21 20.1046 20.1046 21 19 21H5C3.89543 21 3 20.1046 3 19V5Z" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
          </span>
          <transition name="fade">
            <span v-if="!isCollapse" class="nav-label">审核管理</span>
          </transition>
        </router-link>

        <!-- Admin/Director Management Section -->
        <template v-if="isAdminOrDirector">
          <div class="nav-divider" v-if="!isCollapse">
            <span class="divider-label">管理功能</span>
          </div>
          <div v-else class="nav-divider-collapsed"></div>

          <router-link
            to="/review"
            class="nav-item"
            :class="{ active: activeMenu === '/review' }"
          >
            <span class="nav-icon">
              <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M9 12L11 14L15 10M3 5C3 3.89543 3.89543 3 5 3H19C20.1046 3 21 3.89543 21 5V19C21 20.1046 20.1046 21 19 21H5C3.89543 21 3 20.1046 3 19V5Z" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
              </svg>
            </span>
            <transition name="fade">
              <span v-if="!isCollapse" class="nav-label">审核管理</span>
            </transition>
          </router-link>

          <router-link
            to="/users"
            class="nav-item"
            :class="{ active: activeMenu === '/users' }"
          >
            <span class="nav-icon">
              <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M17 20C17 18.3431 15.6569 17 14 17H10C8.34315 17 7 18.3431 7 20M21 12C21 13.6569 19.6569 15 18 15C16.3431 15 15 13.6569 15 12C15 10.3431 16.3431 9 18 9C19.6569 9 21 10.3431 21 12ZM15 7C15 8.65685 13.6569 10 12 10C10.3431 10 9 8.65685 9 7C9 5.34315 10.3431 4 12 4C13.6569 4 15 5.34315 15 7ZM3 12C3 13.6569 1.65685 15 0 15V15C-1.65685 15 -3 13.6569 -3 12C-3 10.3431 -1.65685 9 0 9V9C1.65685 9 3 10.3431 3 12Z" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
              </svg>
            </span>
            <transition name="fade">
              <span v-if="!isCollapse" class="nav-label">用户管理</span>
            </transition>
          </router-link>

          <router-link
            to="/audit"
            class="nav-item"
            :class="{ active: activeMenu === '/audit' }"
          >
            <span class="nav-icon">
              <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M9 5H7C5.89543 5 5 5.89543 5 7V19C5 20.1046 5.89543 21 7 21H17C18.1046 21 19 20.1046 19 19V7C19 5.89543 18.1046 5 17 5H15M9 5C9 6.10457 9.89543 7 11 7H13C14.1046 7 15 6.10457 15 5M9 5C9 3.89543 9.89543 3 11 3H13C14.1046 3 15 3.89543 15 5M12 12H15M12 16H15M9 12H9.01M9 16H9.01" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
              </svg>
            </span>
            <transition name="fade">
              <span v-if="!isCollapse" class="nav-label">审计日志</span>
            </transition>
          </router-link>
        </template>

      </nav>

      <!-- Sidebar Footer -->
      <div class="aside-footer">
        <div class="aside-footer-info" v-if="!isCollapse">
          <span class="footer-version">v1.0.0</span>
        </div>
      </div>
    </aside>

    <!-- Main Content Area -->
    <div class="layout-main">
      <!-- Header -->
      <header class="layout-header">
        <div class="header-left">
          <button class="mobile-menu-btn" @click="toggleMobileMenu">
            <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
              <path d="M3 12H21M3 6H21M3 18H21" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
          </button>
          <div class="breadcrumb-area">
            <span class="breadcrumb-current">{{ currentPageTitle }}</span>
          </div>
        </div>

        <div class="header-right">
          <div class="header-action" title="通知">
            <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
              <path d="M15 17H20L18.5951 15.5951C18.2141 15.2141 18 14.6973 18 14.1585V11C18 8.38757 16.3304 6.16509 14 5.34142V5C14 3.89543 13.1046 3 12 3C10.8954 3 10 3.89543 10 5V5.34142C7.66962 6.16509 6 8.38757 6 11V14.1585C6 14.6973 5.78595 15.2141 5.40493 15.5951L4 17H9M15 17V18C15 19.6569 13.6569 21 12 21C10.3431 21 9 19.6569 9 18V17M15 17H9" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
          </div>

          <el-dropdown trigger="click" @command="handleCommand">
            <div class="user-info">
              <div class="user-avatar">
                <span class="avatar-initial">{{ currentUser.name ? currentUser.name[0] : 'U' }}</span>
              </div>
              <div class="user-details" v-if="currentUser.name">
                <span class="user-name">{{ currentUser.name }}</span>
                <span class="user-role">{{ roleLabel }}</span>
              </div>
              <svg class="dropdown-arrow" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M6 9L12 15L18 9" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
              </svg>
            </div>
            <template #dropdown>
              <el-dropdown-menu>
                <el-dropdown-item command="profile">
                  <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg" style="width:16px;height:16px;margin-right:8px;">
                    <path d="M16 7C16 9.20914 14.2091 11 12 11C9.79086 11 8 9.20914 8 7C8 4.79086 9.79086 3 12 3C14.2091 3 16 4.79086 16 7Z" stroke="currentColor" stroke-width="1.5"/>
                    <path d="M12 14C8.13401 14 5 17.134 5 21H19C19 17.134 15.866 14 12 14Z" stroke="currentColor" stroke-width="1.5"/>
                  </svg>
                  个人信息
                </el-dropdown-item>
                <el-dropdown-item divided command="logout">
                  <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg" style="width:16px;height:16px;margin-right:8px;">
                    <path d="M9 21H5C4.46957 21 3.96086 20.7893 3.58579 20.4142C3.21071 20.0391 3 19.5304 3 19V5C3 4.46957 3.21071 3.96086 3.58579 3.58579C3.96086 3.21071 4.46957 3 5 3H9M16 17L21 12M21 12L16 7M21 12H9" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
                  </svg>
                  退出登录
                </el-dropdown-item>
              </el-dropdown-menu>
            </template>
          </el-dropdown>
        </div>
      </header>

      <!-- Content Area -->
      <main class="layout-content">
        <router-view v-slot="{ Component }">
          <transition name="fade" mode="out-in">
            <component :is="Component" />
          </transition>
        </router-view>
      </main>
    </div>

    <!-- Mobile Menu Overlay -->
    <transition name="fade">
      <div
        v-if="showMobileMenu"
        class="mobile-menu-overlay"
        @click="toggleMobileMenu"
      ></div>
    </transition>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, onUnmounted, watch } from 'vue'
import { ElMessage } from 'element-plus'
import { useRouter, useRoute } from 'vue-router'
import store from '../../store'
import service from '../../api/request'

const router = useRouter()
const route = useRoute()

const isCollapse = ref(false)
const showMobileMenu = ref(false)
const currentUser = computed(() => store.state.user || { name: '用户', role: '' })
const isAdmin = computed(() => currentUser.value.role === 'admin')
const isDirector = computed(() => currentUser.value.role === '主任')
const isDeptDirector = computed(() => currentUser.value.role === 'dept_director')
const isAdminOrDirector = computed(() => currentUser.value.role === 'admin' || currentUser.value.role === '主任')

const roleLabel = computed(() => {
  const role = currentUser.value.role
  if (role === 'admin') return '管理员'
  if (role === '主任') return '病案科主任'
  if (role === 'dept_director') return '科室主任'
  return '普通用户'
})

const activeMenu = computed(() => route.path || '/dashboard')

const pageTitles: Record<string, string> = {
  '/dashboard': '仪表盘',
  '/borrow': '借阅申请',
  '/borrow-history': '借阅历史',
  '/review': '审核管理',
  '/users': '用户管理',
  '/audit': '审计日志'
}

const currentPageTitle = computed(() => pageTitles[route.path] || '仪表盘')

const toggleCollapse = () => {
  isCollapse.value = !isCollapse.value
}

const toggleMobileMenu = () => {
  showMobileMenu.value = !showMobileMenu.value
}

const handleCommand = (command: string) => {
  if (command === 'logout') {
    handleLogout()
  }
}

const handleLogout = async () => {
  clearActivityTimer()
  try {
    const username = currentUser.value?.username || ''
    await service.post('/users/logout', { username })
  } catch (e) {
    // ignore
  }
  store.dispatch('logout')
  router.push('/login')
}

let resizeTimer: ReturnType<typeof setTimeout> | null = null
const handleResize = () => {
  if (resizeTimer) clearTimeout(resizeTimer)
  resizeTimer = setTimeout(() => {
    if (window.innerWidth >= 768) {
      showMobileMenu.value = false
    }
  }, 150)
}

watch(showMobileMenu, (isOpen) => {
  document.body.style.overflow = isOpen ? 'hidden' : ''
})

// Idle timeout
const IDLE_TIMEOUT_MS = 30 * 60 * 1000
const WARNING_BEFORE_MS = 60 * 1000
let idleTimer: ReturnType<typeof setTimeout> | null = null
let warningTimer: ReturnType<typeof setTimeout> | null = null

const resetActivityTimer = () => {
  clearActivityTimer()
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
  document.body.style.overflow = ''
})
</script>

<style scoped>
.layout-container {
  display: flex;
  height: 100vh;
  overflow: hidden;
  background: var(--color-bg-page);
}

/* Sidebar */
.layout-aside {
  width: var(--sidebar-width);
  min-width: var(--sidebar-width);
  background: var(--sidebar-bg);
  display: flex;
  flex-direction: column;
  transition: width var(--transition-normal), min-width var(--transition-normal);
  position: relative;
  z-index: var(--z-fixed);
  overflow: hidden;
}

.layout-aside.aside-collapsed {
  width: var(--sidebar-collapsed-width);
  min-width: var(--sidebar-collapsed-width);
}

.layout-aside.aside-collapsed .aside-header {
  padding: 20px 12px;
  justify-content: center;
}

.layout-aside.aside-collapsed .logo-wrapper {
  display: none;
}

.layout-aside.aside-collapsed .collapse-btn {
  width: 40px;
  height: 40px;
}

.aside-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 20px 16px;
  height: 72px;
  flex-shrink: 0;
}

.logo-wrapper {
  display: flex;
  align-items: center;
  gap: 12px;
  overflow: hidden;
}

.logo-icon-box {
  width: 36px;
  height: 36px;
  min-width: 36px;
  border-radius: var(--radius-md);
  background: var(--color-primary);
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
}

.logo-icon-box svg {
  width: 20px;
  height: 20px;
}

.logo-text {
  color: var(--sidebar-text-active);
  font-size: var(--font-size-lg);
  font-weight: var(--font-weight-bold);
  white-space: nowrap;
  letter-spacing: 0.5px;
}

.collapse-btn {
  width: 28px;
  height: 28px;
  border: none;
  background: rgba(255, 255, 255, 0.08);
  border-radius: var(--radius-sm);
  color: var(--sidebar-text);
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all var(--transition-fast);
  flex-shrink: 0;
}

.collapse-btn:hover {
  background: rgba(255, 255, 255, 0.15);
  color: var(--sidebar-text-active);
}

.collapse-btn svg {
  width: 16px;
  height: 16px;
  transition: transform var(--transition-normal);
}

.collapse-btn svg.rotated {
  transform: rotate(180deg);
}

/* Navigation */
.aside-nav {
  flex: 1;
  overflow-y: auto;
  overflow-x: hidden;
  padding: 8px 12px;
}

.nav-item {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 10px 12px;
  margin-bottom: 2px;
  border-radius: var(--radius-md);
  color: var(--sidebar-text);
  text-decoration: none;
  transition: all var(--transition-fast);
  cursor: pointer;
  position: relative;
}

.nav-item:hover {
  background: rgba(255, 255, 255, 0.06);
  color: var(--sidebar-text-active);
}

.nav-item.active {
  background: var(--color-primary);
  color: var(--sidebar-text-active);
  box-shadow: 0 2px 8px rgba(26, 115, 232, 0.3);
}

.nav-icon {
  width: 22px;
  height: 22px;
  min-width: 22px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.nav-icon svg {
  width: 20px;
  height: 20px;
}

.nav-label {
  font-size: var(--font-size-base);
  font-weight: var(--font-weight-medium);
  white-space: nowrap;
  overflow: hidden;
}

.nav-divider {
  padding: 16px 12px 8px;
  display: flex;
  align-items: center;
}

.divider-label {
  font-size: var(--font-size-xs);
  font-weight: var(--font-weight-semibold);
  color: rgba(255, 255, 255, 0.3);
  text-transform: uppercase;
  letter-spacing: 1px;
  white-space: nowrap;
}

.nav-divider-collapsed {
  height: 1px;
  background: rgba(255, 255, 255, 0.1);
  margin: 12px 8px;
}

/* Sidebar Footer */
.aside-footer {
  padding: 16px;
  border-top: 1px solid rgba(255, 255, 255, 0.06);
  flex-shrink: 0;
}

.aside-footer-info {
  display: flex;
  align-items: center;
  justify-content: center;
}

.footer-version {
  font-size: var(--font-size-xs);
  color: rgba(255, 255, 255, 0.25);
}

/* Main Layout */
.layout-main {
  flex: 1;
  display: flex;
  flex-direction: column;
  overflow: hidden;
  min-width: 0;
}

/* Header */
.layout-header {
  height: var(--header-height);
  min-height: var(--header-height);
  background: var(--header-bg);
  border-bottom: 1px solid var(--color-divider);
  box-shadow: var(--header-shadow);
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 var(--space-lg);
  z-index: var(--z-sticky);
}

.header-left {
  display: flex;
  align-items: center;
  gap: 16px;
}

.mobile-menu-btn {
  display: none;
  width: 36px;
  height: 36px;
  border: none;
  background: none;
  color: var(--color-text-secondary);
  cursor: pointer;
  border-radius: var(--radius-md);
  align-items: center;
  justify-content: center;
}

.mobile-menu-btn:hover {
  background: var(--color-bg-tertiary);
}

.mobile-menu-btn svg {
  width: 22px;
  height: 22px;
}

.breadcrumb-area {
  display: flex;
  align-items: center;
}

.breadcrumb-current {
  font-size: var(--font-size-lg);
  font-weight: var(--font-weight-semibold);
  color: var(--color-text-primary);
}

.header-right {
  display: flex;
  align-items: center;
  gap: 8px;
}

.header-action {
  width: 36px;
  height: 36px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: var(--radius-md);
  color: var(--color-text-secondary);
  cursor: pointer;
  transition: all var(--transition-fast);
  position: relative;
}

.header-action:hover {
  background: var(--color-bg-tertiary);
  color: var(--color-text-primary);
}

.header-action svg {
  width: 20px;
  height: 20px;
}

.user-info {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 6px 10px;
  border-radius: var(--radius-md);
  cursor: pointer;
  transition: all var(--transition-fast);
}

.user-info:hover {
  background: var(--color-bg-tertiary);
}

.user-avatar {
  width: 34px;
  height: 34px;
  border-radius: var(--radius-full);
  background: var(--color-primary);
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

.avatar-initial {
  color: white;
  font-size: var(--font-size-sm);
  font-weight: var(--font-weight-semibold);
}

.user-details {
  display: flex;
  flex-direction: column;
}

.user-name {
  font-size: var(--font-size-sm);
  font-weight: var(--font-weight-semibold);
  color: var(--color-text-primary);
  line-height: 1.2;
}

.user-role {
  font-size: var(--font-size-xs);
  color: var(--color-text-tertiary);
  line-height: 1.2;
}

.dropdown-arrow {
  width: 16px;
  height: 16px;
  color: var(--color-text-tertiary);
}

/* Content Area */
.layout-content {
  flex: 1;
  overflow-y: auto;
  overflow-x: hidden;
  background: var(--color-bg-page);
}

/* Mobile Menu Overlay */
.mobile-menu-overlay {
  position: fixed;
  inset: 0;
  background: rgba(0, 0, 0, 0.5);
  z-index: calc(var(--z-fixed) - 1);
  backdrop-filter: blur(2px);
}

/* Responsive */
@media (max-width: 768px) {
  .layout-aside {
    position: fixed;
    left: 0;
    top: 0;
    bottom: 0;
    z-index: var(--z-fixed);
    transform: translateX(-100%);
    transition: transform var(--transition-normal);
  }

  .layout-aside.mobile-open {
    transform: translateX(0);
  }

  .mobile-menu-btn {
    display: flex;
  }

  .layout-header {
    padding: 0 var(--space-md);
  }

  .user-details {
    display: none;
  }
}

@media (max-width: 480px) {
  .layout-header {
    height: 56px;
    min-height: 56px;
    padding: 0 var(--space-sm);
  }

  .breadcrumb-current {
    font-size: var(--font-size-base);
  }

  .mobile-menu-btn {
    width: var(--touch-target-min);
    height: var(--touch-target-min);
  }

  .header-action {
    width: var(--touch-target-min);
    height: var(--touch-target-min);
  }

  .user-avatar {
    width: 32px;
    height: 32px;
  }
}

/* Scrollbar for sidebar nav */
.aside-nav::-webkit-scrollbar {
  width: 4px;
}

.aside-nav::-webkit-scrollbar-track {
  background: transparent;
}

.aside-nav::-webkit-scrollbar-thumb {
  background: rgba(255, 255, 255, 0.1);
  border-radius: 2px;
}

.aside-nav::-webkit-scrollbar-thumb:hover {
  background: rgba(255, 255, 255, 0.2);
}
</style>
