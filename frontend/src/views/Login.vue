<template>
  <div class="login-page">
    <div class="login-container">
      <div class="login-card">
        <div class="login-header">
          <div class="medical-cross-logo">
            <span class="cross-h"></span>
            <span class="cross-v"></span>
          </div>
          <h1 class="app-title">Medical Records Borrowing</h1>
        </div>

        <el-form
          ref="loginFormRef"
          :model="loginForm"
          :rules="rules"
          class="login-form"
          @keyup.enter="handleLogin"
        >
          <el-form-item prop="username">
            <el-input
              v-model="loginForm.username"
              placeholder="Username"
              size="large"
              :prefix-icon="User"
            />
          </el-form-item>

          <el-form-item prop="password">
            <el-input
              v-model="loginForm.password"
              type="password"
              show-password
              placeholder="Password"
              size="large"
              :prefix-icon="Lock"
            />
          </el-form-item>

          <el-form-item>
            <el-button
              type="primary"
              :loading="loading"
              class="login-button"
              @click="handleLogin"
            >
              Login
            </el-button>
          </el-form-item>
        </el-form>

        <a class="forgot-link" href="javascript:;">Forgot password?</a>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { reactive, ref } from 'vue'
import { ElMessage } from 'element-plus'
import { User, Lock } from '@element-plus/icons-vue'
import { useRouter } from 'vue-router'
import service from '../api/request'
import store from '../store'

const router = useRouter()
const loginFormRef = ref()
const loading = ref(false)

const loginForm = reactive({
  username: '',
  password: ''
})

const rules = {
  username: [{ required: true, message: 'Please enter username', trigger: 'blur' }],
  password: [{ required: true, message: 'Please enter password', trigger: 'blur' }]
}

const handleLogin = async () => {
  if (!loginFormRef.value) return

  await loginFormRef.value.validate(async (valid: boolean) => {
    if (!valid) return

    loading.value = true
    try {
      const response = await service.post('/users/login', {
        username: loginForm.username,
        password: loginForm.password
      })

      if (response.token && response.user) {
        store.dispatch('login', {
          token: response.token,
          user: response.user
        })
        ElMessage.success('Login successful')
        router.push('/dashboard')
      } else {
        ElMessage.error('Login failed: Invalid response data')
      }
    } catch (error: any) {
      ElMessage.error(error.response?.data?.error || 'Login failed, please check your credentials')
    } finally {
      loading.value = false
    }
  })
}
</script>

<style scoped>
.login-page {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #ffffff;
  position: relative;
  overflow: hidden;
  padding: 20px;
}

.login-page::before {
  content: '';
  position: absolute;
  inset: 0;
  opacity: 0.03;
  background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 100 100' fill='%230F2C59'%3E%3Crect x='40' y='20' width='20' height='60' rx='4'/%3E%3Crect x='20' y='40' width='60' height='20' rx='4'/%3E%3C/svg%3E");
  background-size: 120px 120px;
  pointer-events: none;
}

.login-page::after {
  content: '';
  position: absolute;
  inset: 0;
  background: radial-gradient(ellipse at top, rgba(15, 44, 89, 0.04), transparent 70%);
  pointer-events: none;
}

.login-container {
  width: 100%;
  max-width: 380px;
  position: relative;
  z-index: 1;
}

.login-card {
  background: #ffffff;
  border-radius: 16px;
  padding: 32px 24px;
  box-shadow: 0 2px 16px rgba(15, 44, 89, 0.08);
  border: 1px solid rgba(15, 44, 89, 0.06);
}

.login-header {
  display: flex;
  flex-direction: column;
  align-items: center;
  margin-bottom: 32px;
}

.medical-cross-logo {
  width: 64px;
  height: 64px;
  background: #0F2C59;
  border-radius: 14px;
  position: relative;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 16px;
}

.medical-cross-logo::before,
.medical-cross-logo::after {
  content: '';
  position: absolute;
  background: #ffffff;
  border-radius: 3px;
}

.medical-cross-logo::before {
  width: 32px;
  height: 8px;
}

.medical-cross-logo::after {
  width: 8px;
  height: 32px;
}

.cross-h,
.cross-v {
  display: none;
}

.app-title {
  font-size: 22px;
  font-weight: 600;
  color: #0F2C59;
  text-align: center;
  margin: 0;
  letter-spacing: -0.3px;
}

.login-form {
  width: 100%;
}

.login-form :deep(.el-form-item) {
  margin-bottom: 16px;
}

.login-form :deep(.el-input__wrapper) {
  border-radius: 10px;
  padding: 12px 16px;
  box-shadow: 0 0 0 1px rgba(15, 44, 89, 0.15) inset;
  background: #fafbfc;
  transition: all 0.2s ease;
}

.login-form :deep(.el-input__wrapper.is-focus) {
  box-shadow: 0 0 0 1px #0F2C59 inset;
  background: #ffffff;
}

.login-form :deep(.el-input__inner) {
  color: #0F2C59;
  font-size: 15px;
}

.login-form :deep(.el-input__inner::placeholder) {
  color: #8a9bb5;
}

.login-form :deep(.el-input__prefix) {
  color: #0F2C59;
  margin-right: 8px;
}

.login-button {
  width: 100%;
  height: 48px;
  border: none;
  border-radius: 10px;
  background: #0F2C59;
  color: #ffffff;
  font-size: 16px;
  font-weight: 600;
  letter-spacing: 0.2px;
  margin-top: 8px;
  transition: all 0.2s ease;
}

.login-button:hover {
  background: #1a3d6e;
  transform: translateY(-1px);
}

.login-button:active {
  transform: translateY(0);
}

.forgot-link {
  display: block;
  text-align: center;
  margin-top: 20px;
  color: #0F2C59;
  font-size: 13px;
  text-decoration: none;
  opacity: 0.75;
  transition: opacity 0.2s ease;
}

.forgot-link:hover {
  opacity: 1;
  text-decoration: underline;
}

@media (max-width: 480px) {
  .login-page {
    padding: 16px;
    background: #f5f7fa;
  }

  .login-container {
    max-width: 100%;
  }

  .login-card {
    padding: 28px 20px;
    border-radius: 14px;
    box-shadow: none;
    border: none;
  }

  .medical-cross-logo {
    width: 56px;
    height: 56px;
    border-radius: 12px;
  }

  .app-title {
    font-size: 20px;
  }

  .login-form :deep(.el-input__wrapper) {
    padding: 10px 14px;
  }

  .login-button {
    height: 46px;
    font-size: 15px;
  }
}

@media (max-width: 360px) {
  .login-card {
    padding: 24px 16px;
  }

  .app-title {
    font-size: 18px;
  }
}
</style>
