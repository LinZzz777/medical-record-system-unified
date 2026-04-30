<template>
  <div id="app">
    <router-view />
  </div>
</template>

<script setup lang="ts">
// App.vue root component
</script>

<style>
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

html, body {
  font-family: var(--font-family);
  font-size: var(--font-size-base);
  line-height: var(--line-height-normal);
  color: var(--color-text-primary);
  background-color: var(--color-bg-page);
  height: 100%;
  overflow-x: auto;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

#app {
  height: 100vh;
  width: 100vw;
  overflow: hidden;
}

/* Global Scrollbar */
::-webkit-scrollbar {
  width: 6px;
  height: 6px;
}

::-webkit-scrollbar-track {
  background: transparent;
}

::-webkit-scrollbar-thumb {
  background: #c1c1c1;
  border-radius: 3px;
}

::-webkit-scrollbar-thumb:hover {
  background: #a8a8a8;
}

/* Responsive Font Sizes */
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

@media (max-width: 320px) {
  html {
    font-size: 11px;
  }
}

/* Global Animations */
.fade-enter-active,
.fade-leave-active {
  transition: opacity var(--transition-normal);
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}

/* Element Plus Global Overrides */
.el-button {
  border-radius: var(--radius-md);
  font-weight: var(--font-weight-medium);
  transition: all var(--transition-fast);
}

.el-button--primary {
  background: var(--color-primary);
  border-color: var(--color-primary);
}

.el-button--primary:hover,
.el-button--primary:focus {
  background: var(--color-primary-light);
  border-color: var(--color-primary-light);
}

.el-card {
  border-radius: var(--radius-lg);
  border: 1px solid var(--color-border-light);
  box-shadow: var(--shadow-sm);
  overflow: hidden;
}

.el-card__header {
  border-bottom: 1px solid var(--color-divider);
  padding: var(--space-md) var(--space-lg);
}

.el-table {
  border-radius: var(--radius-md);
  overflow: hidden;
}

.el-table th {
  background-color: var(--color-bg-secondary) !important;
  font-weight: var(--font-weight-semibold);
  color: var(--color-text-primary);
  font-size: var(--font-size-sm);
}

.el-table td {
  color: var(--color-text-primary);
}

.el-dialog {
  border-radius: var(--radius-xl);
  overflow: hidden;
}

.el-dialog__header {
  padding: var(--space-lg);
  border-bottom: 1px solid var(--color-divider);
  margin-right: 0;
}

.el-dialog__body {
  padding: var(--space-lg);
}

.el-dialog__footer {
  padding: var(--space-md) var(--space-lg);
  border-top: 1px solid var(--color-divider);
}

/* Responsive Dialog */
@media (max-width: 768px) {
  .el-dialog {
    width: 92vw !important;
    margin: 5vh auto !important;
    max-height: 90vh;
  }

  .el-dialog__body {
    max-height: calc(90vh - 120px);
    overflow-y: auto;
  }
}

@media (max-width: 480px) {
  .el-dialog {
    width: 96vw !important;
    margin: 2vh auto !important;
  }
}

/* Responsive Tables */
.el-table {
  overflow-x: auto;
}

.el-table .cell {
  white-space: nowrap;
}

@media (max-width: 768px) {
  .el-table {
    font-size: var(--font-size-sm);
  }

  .el-table th,
  .el-table td {
    padding: 6px 0;
  }

  .el-table .el-table__fixed-right {
    right: 0 !important;
  }
}

/* Touch Target Minimum 44px */
@media (max-width: 768px) {
  .el-button {
    min-height: var(--touch-target-min);
    min-width: var(--touch-target-min);
  }

  .el-button + .el-button {
    margin-left: 8px;
  }

  .el-radio__input,
  .el-checkbox__input {
    min-width: var(--touch-target-min);
    min-height: var(--touch-target-min);
  }
}

/* Responsive Pagination */
@media (max-width: 768px) {
  .el-pagination {
    flex-wrap: wrap;
    justify-content: center;
    gap: 8px;
  }

  .el-pagination .el-pagination__sizes {
    display: none;
  }

  .el-pagination .el-pagination__jump {
    display: none;
  }
}

/* Responsive Date Picker */
@media (max-width: 768px) {
  .el-date-editor--datetimerange {
    width: 100% !important;
  }

  .el-date-editor--datetimerange .el-input__wrapper {
    width: 100%;
  }
}

.el-form-item__label {
  font-weight: var(--font-weight-medium);
  color: var(--color-text-primary);
}

.el-input__wrapper {
  border-radius: var(--radius-md);
}

.el-tag {
  border-radius: var(--radius-full);
  font-weight: var(--font-weight-medium);
  font-size: var(--font-size-xs);
}

.el-tag--dark {
  border: none;
}

/* Responsive Layout Helper */
.container {
  width: 100%;
  padding: 0 var(--space-lg);
  margin: 0 auto;
}

@media (max-width: 768px) {
  .container {
    padding: 0 var(--space-md);
  }
}

@media (max-width: 480px) {
  .container {
    padding: 0 var(--space-sm);
  }
}
</style>
