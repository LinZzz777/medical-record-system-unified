<template>
  <div class="test-container">
    <h1>调试页面</h1>
    
    <div class="debug-section">
      <h2>LocalStorage 信息</h2>
      <div class="debug-item">
        <span>Token:</span>
        <pre>{{ token }}</pre>
      </div>
      <div class="debug-item">
        <span>User:</span>
        <pre>{{ user }}</pre>
      </div>
    </div>

    <div class="debug-section">
      <h2>API 测试</h2>
      <button @click="testStats" :disabled="loading">测试统计接口</button>
      <div v-if="statsResponse" class="response">
        <h3>统计接口响应:</h3>
        <pre>{{ statsResponse }}</pre>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import service from '../api/request'

const token = ref('')
const user = ref('')
const statsResponse = ref('')
const loading = ref(false)

onMounted(() => {
  token.value = localStorage.getItem('token') || '无'
  user.value = localStorage.getItem('user') || '无'
})

const testStats = async () => {
  loading.value = true
  try {
    const userJson = localStorage.getItem('user')
    const userObj = JSON.parse(userJson || '{}')
    
    if (!userObj.id || !userObj.role) {
      statsResponse.value = '用户信息不完整'
      return
    }
    
    const response = await service.get(`/statistics/user-stats?userId=${userObj.id}&role=${userObj.role}`)
    statsResponse.value = JSON.stringify(response, null, 2)
  } catch (error: any) {
    statsResponse.value = `错误: ${error.response?.data || error.message}`
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
.test-container {
  padding: 20px;
}

.debug-section {
  margin-bottom: 30px;
  padding: 15px;
  border: 1px solid #ddd;
  border-radius: 5px;
}

.debug-item {
  margin-bottom: 10px;
}

.debug-item span {
  font-weight: bold;
  display: block;
  margin-bottom: 5px;
}

pre {
  background: #f5f5f5;
  padding: 10px;
  border-radius: 3px;
  overflow-x: auto;
}

button {
  padding: 10px 20px;
  background: #409eff;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

button:disabled {
  background: #909399;
  cursor: not-allowed;
}

.response {
  margin-top: 15px;
}
</style>
