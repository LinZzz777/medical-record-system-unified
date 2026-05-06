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
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
  font-size: 14px;
  line-height: 1.5;
  color: #333;
  background-color: #f5f7fa;
  height: 100%;
  overflow-x: hidden;
}

#app {
  height: 100vh;
  width: 100vw;
  overflow: hidden;
}

/* 全局滚动条样式 */
::-webkit-scrollbar {
  width: 8px;
  height: 8px;
}

::-webkit-scrollbar-track {
  background: #f1f1f1;
  border-radius: 4px;
}

::-webkit-scrollbar-thumb {
  background: #c1c1c1;
  border-radius: 4px;
}

::-webkit-scrollbar-thumb:hover {
  background: #a8a8a8;
}

/* 响应式字体大小 */
@media (max-width: 768px) {
  html {
    font-size: 13px;
  }
}

@media (max-width: 480px) {
  html {
    font-size: 12px;
  }
}

/* 全局动画 */
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.3s ease;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}

/* 全局按钮样式优化 */
.el-button {
  border-radius: 4px;
  font-weight: 500;
}

/* 全局卡片样式优化 */
.el-card {
  border-radius: 8px;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
}

/* 全局表格样式优化 */
.el-table {
  border-radius: 8px;
  overflow: hidden;
}

.el-table th {
  background-color: #fafafa;
  font-weight: 500;
}

/* 全局表单样式优化 */
.el-form-item__label {
  font-weight: 500;
}

.el-input__inner {
  border-radius: 4px;
}

/* 响应式布局辅助类 */
.container {
  width: 100%;
  padding: 0 20px;
  margin: 0 auto;
}

@media (max-width: 768px) {
  .container {
    padding: 0 15px;
  }
}

@media (max-width: 480px) {
  .container {
    padding: 0 10px;
  }
}
</style>
