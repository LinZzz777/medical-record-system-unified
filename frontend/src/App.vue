<template>
  <div id="app">
    <router-view />
  </div>
</template>

<script setup lang="ts">
// App.vue 根组件
</script>

<style>
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

html, body {
  font-family: -apple-system, BlinkMacSystemFont, 'SF Pro', 'SF Pro Display', 'SF Pro Text', sans-serif;
  font-size: 14px;
  line-height: 1.5;
  color: #1D1D1F;
  background: linear-gradient(180deg, #87CEEB 0%, #B0E0E6 30%, #E8F4FD 60%, #F5F5F7 100%);
  height: 100%;
  overflow-x: hidden;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

#app {
  height: 100vh;
  width: 100vw;
  overflow: hidden;
}

::-webkit-scrollbar {
  width: 8px;
  height: 8px;
}

::-webkit-scrollbar-track {
  background: rgba(255, 255, 255, 0.3);
  border-radius: 4px;
}

::-webkit-scrollbar-thumb {
  background: rgba(0, 122, 255, 0.3);
  border-radius: 4px;
  backdrop-filter: blur(10px);
}

::-webkit-scrollbar-thumb:hover {
  background: rgba(0, 122, 255, 0.5);
}

.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}

.el-button {
  border-radius: 22px !important;
  font-weight: 500;
  transition: all 0.2s ease-out !important;
}

.el-button--primary {
  background: linear-gradient(135deg, #007AFF 0%, #1E90FF 100%) !important;
  border: none !important;
  box-shadow: 0 4px 12px rgba(0, 122, 255, 0.3) !important;
}

.el-button--primary:hover {
  transform: translateY(-1px);
  box-shadow: 0 6px 16px rgba(0, 122, 255, 0.4) !important;
}

.el-button--primary:active {
  transform: scale(0.97);
}

.el-card {
  border-radius: 24px !important;
  background: rgba(255, 255, 255, 0.75) !important;
  backdrop-filter: blur(20px) saturate(180%) !important;
  -webkit-backdrop-filter: blur(20px) saturate(180%) !important;
  border: 1px solid rgba(255, 255, 255, 0.5) !important;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.08) !important;
  transition: all 0.2s ease-out !important;
}

.el-card:hover {
  box-shadow: 0 12px 40px rgba(0, 0, 0, 0.12) !important;
}

.el-card__header {
  border-bottom: 1px solid rgba(0, 0, 0, 0.06) !important;
  padding: 20px 24px !important;
}

.el-table {
  border-radius: 16px !important;
  overflow: hidden;
  background: rgba(255, 255, 255, 0.5) !important;
}

.el-table th {
  background: rgba(245, 245, 247, 0.8) !important;
  font-weight: 600;
  color: #1D1D1F;
}

.el-table td {
  color: #1D1D1F;
}

.el-form-item__label {
  font-weight: 500;
  color: #1D1D1F;
}

.el-input__wrapper {
  border-radius: 16px !important;
  background: rgba(255, 255, 255, 0.6) !important;
  backdrop-filter: blur(10px) !important;
  box-shadow: 0 0 0 1px rgba(0, 0, 0, 0.08) inset !important;
  transition: all 0.2s ease-out !important;
}

.el-input__wrapper:hover {
  box-shadow: 0 0 0 1px rgba(0, 122, 255, 0.3) inset !important;
}

.el-input__wrapper.is-focus {
  box-shadow: 0 0 0 1px #007AFF inset, 0 0 0 4px rgba(0, 122, 255, 0.15) !important;
  background: #fff !important;
}

.el-select .el-input__wrapper {
  min-height: 44px;
}

.el-dialog {
  border-radius: 24px !important;
  overflow: hidden;
  background: rgba(255, 255, 255, 0.95) !important;
  backdrop-filter: blur(20px) !important;
}

.el-tag {
  border-radius: 12px !important;
  border: none !important;
  padding: 4px 12px !important;
  font-weight: 500;
}

.el-tag--success {
  background: rgba(39, 174, 96, 0.15) !important;
  color: #27AE60 !important;
}

.el-tag--warning {
  background: rgba(255, 149, 0, 0.15) !important;
  color: #FF9500 !important;
}

.el-tag--danger {
  background: rgba(255, 59, 48, 0.15) !important;
  color: #FF3B30 !important;
}

.el-tag--info {
  background: rgba(134, 134, 139, 0.15) !important;
  color: #86868B !important;
}

.el-pagination {
  background: rgba(255, 255, 255, 0.6);
  backdrop-filter: blur(10px);
  border-radius: 16px;
  padding: 8px 16px;
}

.container {
  width: 100%;
  padding: 0 20px;
  margin: 0 auto;
}

@media (max-width: 768px) {
  html {
    font-size: 13px;
  }
  .container {
    padding: 0 15px;
  }
}

@media (max-width: 480px) {
  html {
    font-size: 12px;
  }
  .container {
    padding: 0 10px;
  }
}

.slide-enter-active,
.slide-leave-active {
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.slide-enter-from {
  transform: translateX(20px);
  opacity: 0;
}

.slide-leave-to {
  transform: translateX(-20px);
  opacity: 0;
}
</style>
