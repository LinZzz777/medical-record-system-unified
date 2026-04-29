<template>
  <div class="login-page">
    <div class="medical-grid" aria-hidden="true"></div>
    <div class="login-layout">
      <section class="login-brand">
        <div class="brand-top">
          <span class="hospital-emblem" aria-hidden="true">
            <i></i>
            <i></i>
          </span>
          <div>
            <div class="brand-tag">HOSPITAL ARCHIVE SYSTEM</div>
            <h1>病案借阅管理系统</h1>
          </div>
        </div>
        <p class="brand-summary">
          统一管理病案借阅申请、审批流转、归还跟踪与操作留痕，
          为医院日常病案流转提供规范、清晰、可追踪的工作入口。
        </p>

        <div class="brand-metrics">
          <div class="metric-item">
            <strong>24h</strong>
            <span>审批状态可追踪</span>
          </div>
          <div class="metric-item">
            <strong>3级</strong>
            <span>角色权限管理</span>
          </div>
          <div class="metric-item">
            <strong>100%</strong>
            <span>关键操作留痕</span>
          </div>
        </div>

        <div class="brand-notes">
          <div class="note-item">
            <span class="note-icon" aria-hidden="true"></span>
            <div>
              <strong>借阅流程在线化</strong>
              <p>申请、审批、取件、归还状态清晰可见</p>
            </div>
          </div>
          <div class="note-item">
            <span class="note-icon" aria-hidden="true"></span>
            <div>
              <strong>角色权限区分明确</strong>
              <p>管理员与普通用户根据职责进入不同视图</p>
            </div>
          </div>
          <div class="note-item">
            <span class="note-icon" aria-hidden="true"></span>
            <div>
              <strong>关键操作全程留痕</strong>
              <p>便于日常管理、复核审查与责任追踪</p>
            </div>
          </div>
        </div>
      </section>

      <section class="login-panel">
        <div class="login-card">
          <div class="panel-watermark" aria-hidden="true">
            <span><i></i><i></i></span>
          </div>
          <div class="login-card-header">
            <div class="header-mark"></div>
            <div>
              <div class="login-caption">用户登录</div>
              <h2>进入系统工作台</h2>
            </div>
          </div>

          <p class="login-description">请输入账号信息，继续处理病案借阅与审批业务。</p>
          <div class="login-safe-tip">院内统一身份认证 · 数据加密传输</div>

          <el-form
            ref="loginFormRef"
            :model="loginForm"
            :rules="rules"
            label-position="top"
            class="login-form"
            @keyup.enter="handleLogin"
          >
            <el-form-item label="用户名" prop="username">
              <el-input
                v-model="loginForm.username"
                placeholder="请输入用户名"
                size="large"
              />
            </el-form-item>

            <el-form-item label="密码" prop="password">
              <el-input
                v-model="loginForm.password"
                type="password"
                show-password
                placeholder="请输入密码"
                size="large"
              />
            </el-form-item>

            <el-form-item class="submit-row">
              <el-button
                type="primary"
                :loading="loading"
                class="login-button"
                @click="handleLogin"
              >
                登录系统
              </el-button>
            </el-form-item>
          </el-form>

          <div class="login-footer">
            <span>安全登录</span>
            <span class="divider"></span>
            <span>病案借阅全流程可追踪</span>
          </div>
        </div>
      </section>
    </div>
  </div>
</template>

<script setup lang="ts">
import { reactive, ref } from 'vue'
import { ElMessage } from 'element-plus'
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
  username: [{ required: true, message: '请输入用户名', trigger: 'blur' }],
  password: [{ required: true, message: '请输入密码', trigger: 'blur' }]
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
        ElMessage.success('登录成功')
        router.push('/dashboard')
      } else if (response.error) {
        ElMessage.error(response.error)
      } else {
        ElMessage.error('登录失败：返回数据格式错误')
      }
    } catch (error: any) {
      ElMessage.error(error.response?.data?.error || '登录失败，请检查用户名和密码')
    } finally {
      loading.value = false
    }
  })
}
</script>

<style scoped>
.login-page {
  position: relative;
  overflow: hidden;
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 32px 24px;
  background:
    radial-gradient(circle at 8% 14%, rgba(30, 134, 186, 0.14), transparent 30%),
    radial-gradient(circle at 90% 82%, rgba(48, 110, 173, 0.12), transparent 26%),
    linear-gradient(145deg, #f4f9ff 0%, #eef6fd 45%, #eaf2fb 100%);
}

.medical-grid {
  position: absolute;
  inset: 0;
  pointer-events: none;
  opacity: 0.35;
  background-image:
    linear-gradient(to right, rgba(77, 133, 180, 0.12) 1px, transparent 1px),
    linear-gradient(to bottom, rgba(77, 133, 180, 0.12) 1px, transparent 1px);
  background-size: 44px 44px;
  mask-image: radial-gradient(circle at center, rgba(0, 0, 0, 0.82), transparent 86%);
}

.login-layout {
  position: relative;
  z-index: 1;
  width: min(1120px, 100%);
  display: grid;
  grid-template-columns: minmax(0, 1fr) 430px;
  gap: 56px;
  align-items: center;
}

.login-brand {
  max-width: 520px;
}

.brand-top {
  display: flex;
  align-items: center;
  gap: 14px;
}

.hospital-emblem {
  flex-shrink: 0;
  width: 56px;
  height: 56px;
  border-radius: 16px;
  background: linear-gradient(165deg, #0f7fc0, #1fa2dd);
  box-shadow: 0 12px 20px rgba(18, 122, 182, 0.22);
  position: relative;
}

.hospital-emblem i {
  position: absolute;
  border-radius: 999px;
  background: rgba(255, 255, 255, 0.95);
}

.hospital-emblem i:first-child {
  top: 24px;
  left: 14px;
  width: 28px;
  height: 8px;
}

.hospital-emblem i:last-child {
  top: 14px;
  left: 24px;
  width: 8px;
  height: 28px;
}

.brand-tag {
  display: inline-flex;
  align-items: center;
  padding: 7px 14px;
  border-radius: 999px;
  background: rgba(18, 120, 178, 0.1);
  color: #216383;
  font-size: 11px;
  font-weight: 700;
  letter-spacing: 0.14em;
}

.login-brand h1 {
  margin: 16px 0 18px;
  color: #0f3653;
  font-size: 44px;
  line-height: 1.18;
}

.brand-summary {
  margin: 0 0 28px;
  color: #4f6f83;
  font-size: 16px;
  line-height: 1.95;
}

.brand-metrics {
  display: flex;
  flex-wrap: wrap;
  gap: 12px;
  margin-bottom: 22px;
}

.metric-item {
  padding: 12px 14px;
  border-radius: 14px;
  background: rgba(255, 255, 255, 0.82);
  border: 1px solid rgba(53, 120, 164, 0.18);
  box-shadow: 0 10px 20px rgba(38, 88, 126, 0.06);
}

.metric-item strong {
  display: block;
  margin-bottom: 3px;
  color: #155278;
  font-size: 18px;
  line-height: 1.2;
}

.metric-item span {
  color: #577286;
  font-size: 13px;
}

.brand-notes {
  display: grid;
  gap: 14px;
}

.note-item {
  display: grid;
  grid-template-columns: 26px 1fr;
  gap: 14px;
  padding: 16px 18px 16px 14px;
  border-radius: 16px;
  background: rgba(255, 255, 255, 0.8);
  border: 1px solid rgba(53, 120, 164, 0.14);
  box-shadow: 0 12px 22px rgba(27, 60, 75, 0.06);
}

.note-icon {
  width: 22px;
  height: 22px;
  margin-top: 2px;
  border-radius: 50%;
  background: linear-gradient(140deg, #2197d2, #2f76b5);
  position: relative;
}

.note-icon::before,
.note-icon::after {
  content: '';
  position: absolute;
  border-radius: 999px;
  background: #fff;
}

.note-icon::before {
  top: 10px;
  left: 6px;
  width: 10px;
  height: 2px;
}

.note-icon::after {
  top: 6px;
  left: 10px;
  width: 2px;
  height: 10px;
}

.note-item strong {
  display: block;
  margin-bottom: 6px;
  color: #0e3f61;
  font-size: 17px;
}

.note-item p {
  margin: 0;
  color: #567387;
  line-height: 1.7;
}

.login-panel {
  display: flex;
  justify-content: center;
}

.login-card {
  position: relative;
  overflow: hidden;
  width: 100%;
  padding: 34px 32px 26px;
  border-radius: 24px;
  background: rgba(255, 255, 255, 0.93);
  border: 1px solid rgba(34, 113, 168, 0.18);
  box-shadow: 0 24px 52px rgba(25, 77, 120, 0.16);
  backdrop-filter: blur(6px);
}

.panel-watermark {
  position: absolute;
  top: -30px;
  right: -14px;
  width: 120px;
  height: 120px;
  border-radius: 999px;
  background: radial-gradient(circle, rgba(54, 147, 198, 0.14), rgba(31, 130, 184, 0));
}

.panel-watermark span {
  position: absolute;
  top: 38px;
  right: 34px;
  width: 36px;
  height: 36px;
}

.panel-watermark i {
  position: absolute;
  border-radius: 999px;
  background: rgba(32, 124, 177, 0.28);
}

.panel-watermark i:first-child {
  top: 15px;
  left: 0;
  width: 36px;
  height: 6px;
}

.panel-watermark i:last-child {
  top: 0;
  left: 15px;
  width: 6px;
  height: 36px;
}

.login-card-header {
  position: relative;
  z-index: 1;
  display: flex;
  align-items: center;
  gap: 14px;
  margin-bottom: 10px;
}

.header-mark {
  width: 10px;
  height: 46px;
  border-radius: 999px;
  background: linear-gradient(180deg, #0f87cb 0%, #4a78cc 100%);
}

.login-caption {
  margin-bottom: 4px;
  color: #33759f;
  font-size: 13px;
  font-weight: 700;
  letter-spacing: 0.08em;
}

.login-card-header h2 {
  margin: 0;
  color: #0d3b5d;
  font-size: 28px;
}

.login-description {
  position: relative;
  z-index: 1;
  margin: 0 0 24px;
  color: #5a7689;
  line-height: 1.75;
}

.login-safe-tip {
  position: relative;
  z-index: 1;
  margin-bottom: 18px;
  padding: 10px 12px;
  border-radius: 12px;
  color: #286587;
  font-size: 13px;
  background: rgba(50, 132, 180, 0.08);
  border: 1px dashed rgba(43, 120, 167, 0.34);
}

.login-form :deep(.el-form-item) {
  margin-bottom: 20px;
}

.login-form :deep(.el-form-item__label) {
  padding-bottom: 8px;
  color: #124667;
  font-weight: 600;
}

.login-form :deep(.el-input__wrapper) {
  min-height: 48px;
  border-radius: 14px;
  background: #fafdff;
  box-shadow: inset 0 0 0 1px rgba(37, 120, 172, 0.18);
  transition: box-shadow 0.2s ease, background-color 0.2s ease;
}

.login-form :deep(.el-input__wrapper.is-focus) {
  background: #fff;
  box-shadow:
    inset 0 0 0 1px rgba(22, 109, 163, 0.56),
    0 0 0 4px rgba(71, 152, 204, 0.14);
}

.login-form :deep(.el-input__inner) {
  color: #103f61;
}

.login-form :deep(.el-input__inner::placeholder) {
  color: #87a3b4;
}

.submit-row {
  margin-top: 8px;
  margin-bottom: 2px;
}

.login-button {
  width: 100%;
  height: 48px;
  border: none;
  border-radius: 14px;
  background: linear-gradient(135deg, #0f87cb 0%, #1f7db8 52%, #456ec6 100%);
  box-shadow: 0 12px 24px rgba(27, 99, 153, 0.24);
  font-size: 16px;
  font-weight: 700;
  letter-spacing: 0.03em;
}

.login-button:hover {
  filter: brightness(1.02);
}

.login-footer {
  margin-top: 22px;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 12px;
  color: #5b788b;
  font-size: 13px;
}

.divider {
  width: 1px;
  height: 12px;
  background: rgba(23, 98, 143, 0.22);
}

@media (max-width: 980px) {
  .login-layout {
    grid-template-columns: 1fr;
    gap: 28px;
  }

  .login-brand {
    max-width: none;
  }

  .login-brand h1 {
    font-size: 36px;
  }

  .login-panel {
    justify-content: stretch;
  }

  .login-card {
    max-width: 540px;
  }
}

@media (max-width: 640px) {
  .login-page {
    padding: 18px 14px;
  }

  .login-layout {
    gap: 22px;
  }

  .login-brand h1 {
    font-size: 30px;
  }

  .hospital-emblem {
    width: 48px;
    height: 48px;
  }

  .hospital-emblem i:first-child {
    top: 20px;
    left: 12px;
    width: 24px;
  }

  .hospital-emblem i:last-child {
    top: 12px;
    left: 20px;
    height: 24px;
  }

  .brand-summary {
    font-size: 15px;
  }

  .brand-metrics {
    gap: 8px;
  }

  .metric-item {
    flex: 1 1 calc(50% - 8px);
    min-width: 132px;
  }

  .login-card {
    padding: 28px 20px 22px;
    border-radius: 20px;
  }

  .login-card-header h2 {
    font-size: 24px;
  }
}
</style>
