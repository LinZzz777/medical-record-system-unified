<template>
  <div class="test-container">
    <h1>测试页面</h1>
    <p>这是一个简单的测试页面</p>
    <el-button type="primary" @click="testButton">测试按钮</el-button>
    <div>{{ message }}</div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'

const message = ref('Hello World')

const testButton = () => {
  message.value = '按钮被点击了！'
}
</script>

<style scoped>
.test-container {
  padding: 20px;
  text-align: center;
}
</style>
