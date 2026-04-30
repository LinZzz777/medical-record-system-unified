<template>
  <div class="users-container">
    <div class="page-header">
      <div>
        <h1 class="page-title">用户管理</h1>
        <p class="page-subtitle">管理系统用户，分配角色权限</p>
      </div>
      <el-button type="primary" @click="openCreateDialog">
        <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg" style="width:16px;height:16px;margin-right:6px;">
          <path d="M12 5V19M5 12H19" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
        </svg>
        新增用户
      </el-button>
    </div>

    <el-card class="users-card" :body-style="{ padding: '24px' }">
      <!-- Search -->
      <el-form :model="searchForm" :inline="true" class="search-form">
        <el-form-item :label="t.username">
          <el-input v-model="searchForm.username" :placeholder="t.enterUsername" clearable />
        </el-form-item>
        <el-form-item :label="t.name">
          <el-input v-model="searchForm.name" :placeholder="t.enterName" clearable />
        </el-form-item>
        <el-form-item :label="t.department">
          <el-select v-model="searchForm.department" :placeholder="t.enterDepartment" clearable filterable class="users-dept-select">
            <el-option v-for="dept in departmentOptions" :key="dept" :label="dept" :value="dept" />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="loadUsers">刷新</el-button>
        </el-form-item>
      </el-form>

      <!-- Table -->
      <div class="table-scroll-wrapper">
      <el-table :data="filteredUsers" style="width: 100%" border class="data-table">
        <el-table-column prop="id" label="ID" width="70" />
        <el-table-column :label="t.employeeNumber" prop="employeeNumber" width="110" />
        <el-table-column :label="t.username" prop="username" width="130" />
        <el-table-column :label="t.name" prop="name" width="110" />
        <el-table-column :label="t.department" prop="department" min-width="130" />
        <el-table-column :label="t.position" prop="position" min-width="130" />
        <el-table-column :label="t.role" prop="role" width="110">
          <template #default="{ row }">
            <el-tag :type="row.role === 'admin' ? 'danger' : row.role === '主任' ? 'warning' : 'info'" effect="plain" size="small">{{ row.role }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column :label="t.status" width="90">
          <template #default="{ row }">
            <el-tag :type="row.status === 0 ? 'danger' : 'success'" effect="dark" size="small">
              {{ row.status === 0 ? t.disabled : t.enabled }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column :label="t.actions" width="240" fixed="right">
          <template #default="{ row }">
            <div class="action-buttons">
              <el-button type="primary" size="small" @click="editUser(row)">{{ t.edit }}</el-button>
              <el-button :type="row.status === 0 ? 'success' : 'warning'" size="small" @click="toggleUserStatus(row)">
                {{ row.status === 0 ? t.enable : t.disable }}
              </el-button>
              <el-button type="danger" size="small" @click="deleteUser(row)">{{ t.delete }}</el-button>
            </div>
          </template>
        </el-table-column>
      </el-table>
      </div>
    </el-card>

    <!-- Dialog -->
    <el-dialog v-model="dialogVisible" :title="dialogTitle" class="responsive-dialog">
      <el-form :model="userForm" label-width="100px" class="user-form">
        <el-form-item :label="t.employeeNumber">
          <el-input v-model="userForm.employeeNumber" :placeholder="t.enterEmployeeNumber" />
        </el-form-item>
        <el-form-item :label="t.username">
          <el-input v-model="userForm.username" :placeholder="t.enterUsername" />
        </el-form-item>
        <el-form-item :label="isEditing ? t.password : t.initialPassword">
          <el-input v-model="userForm.password" type="password" show-password :placeholder="isEditing ? t.keepPassword : t.enterPassword" />
        </el-form-item>
        <el-form-item :label="t.name">
          <el-input v-model="userForm.name" :placeholder="t.enterName" />
        </el-form-item>
        <el-form-item :label="t.department">
          <el-select v-model="userForm.department" :placeholder="t.enterDepartment" filterable clearable style="width: 100%">
            <el-option v-for="dept in departmentOptions" :key="dept" :label="dept" :value="dept" />
          </el-select>
        </el-form-item>
        <el-form-item :label="t.position">
          <el-input v-model="userForm.position" :placeholder="t.enterPosition" />
        </el-form-item>
        <el-form-item :label="t.role">
          <el-select v-model="userForm.role" :placeholder="t.selectRole" allow-create filterable default-first-option style="width: 100%">
            <el-option v-for="role in roleOptions" :key="role" :label="role" :value="role" />
          </el-select>
        </el-form-item>
        <el-form-item :label="t.status">
          <el-radio-group v-model="userForm.status">
            <el-radio :value="1">{{ t.enabled }}</el-radio>
            <el-radio :value="0">{{ t.disabled }}</el-radio>
          </el-radio-group>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">{{ t.cancel }}</el-button>
        <el-button type="primary" @click="saveUser">{{ t.save }}</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, reactive, ref } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import service from '../api/request'

interface User {
  id?: number
  employeeNumber: string
  username: string
  password?: string
  name: string
  department: string
  position: string
  role: string
  status: number
}

interface RoleItem {
  id: number
  roleName: string
}

const createEmptyUserForm = (): User => ({
  employeeNumber: '', username: '', password: '', name: '', department: '', position: '', role: '', status: 1
})

const searchForm = reactive({ username: '', name: '', department: '' })
const users = ref<User[]>([])
const dialogVisible = ref(false)
const userForm = reactive<User>(createEmptyUserForm())
const roleOptions = ref<string[]>(['admin', 'doctor', 'nurse', 'dept_director'])
const departmentOptions = ['内科', '外科', '妇产科', '儿科', '骨科', '神经内科', '心血管内科', '消化内科', '呼吸内科', '泌尿外科', '眼科', '耳鼻喉科', '皮肤科', '感染科', '肿瘤科', '康复科', '中医科', '内分泌科', '肾内科', '口腔科', '急诊科', '风湿免疫科', '临床科', '护理部', '病案科']

const t = {
  username: '用户名', name: '姓名', department: '科室', position: '职位', role: '角色',
  status: '状态', actions: '操作', employeeNumber: '工号',
  enterUsername: '请输入用户名', enterName: '请输入姓名', enterDepartment: '请输入科室',
  enterPosition: '请输入职位', enterEmployeeNumber: '请输入工号', enterPassword: '请输入密码',
  keepPassword: '不修改可留空', selectRole: '请选择角色',
  enabled: '启用', disabled: '禁用', enable: '启用', disable: '禁用',
  edit: '编辑', delete: '删除', cancel: '取消', save: '保存',
  password: '密码', initialPassword: '初始密码', editUser: '编辑用户', addUser: '新增用户'
}

const isEditing = computed(() => Boolean(userForm.id))
const dialogTitle = computed(() => (isEditing.value ? t.editUser : t.addUser))

const filteredUsers = computed(() =>
  users.value.filter(user => {
    const u = !searchForm.username || user.username?.includes(searchForm.username)
    const n = !searchForm.name || user.name?.includes(searchForm.name)
    const d = !searchForm.department || user.department?.includes(searchForm.department)
    return u && n && d
  })
)

const getErrorMessage = (error: any, fallback: string) => error?.response?.data?.message || error?.message || fallback

const resetUserForm = () => { Object.assign(userForm, createEmptyUserForm()); delete (userForm as any).createdAt }
const openCreateDialog = () => { resetUserForm(); dialogVisible.value = true }

const loadUsers = async () => {
  try {
    const response = await service.get('/users/list')
    users.value = Array.isArray(response) ? response : []
  } catch (error) {
    console.error('Failed to load users:', error)
    ElMessage.error(getErrorMessage(error, '加载用户列表失败'))
  }
}

const loadRoles = async () => {
  try {
    const response = await service.get('/roles/list')
    if (Array.isArray(response)) {
      const roles = response.map((item: RoleItem) => item.roleName).filter((r: string) => Boolean(r))
      if (roles.length > 0) roleOptions.value = Array.from(new Set(roles))
    }
  } catch (error) {
    console.error('Failed to load roles:', error)
  }
}

const editUser = (user: User) => { resetUserForm(); Object.assign(userForm, { ...user, password: '' }); dialogVisible.value = true }

const saveUser = async () => {
  if (!userForm.username || !userForm.name) { ElMessage.warning('请先完善用户名和姓名'); return }
  if (!isEditing.value && !userForm.password) { ElMessage.warning('新增用户时必须填写密码'); return }
  try {
    const payload: Record<string, any> = { ...userForm }
    if (!isEditing.value) { delete payload.createdAt; delete payload.id }
    if (isEditing.value && !payload.password) delete payload.password
    const response = isEditing.value ? await service.put('/users/update', payload) : await service.post('/users/register', payload)
    if (response.success) {
      ElMessage.success(isEditing.value ? '用户更新成功' : '用户新增成功')
      dialogVisible.value = false
      await loadUsers()
      return
    }
    ElMessage.error(response.message || '保存用户失败')
  } catch (error) {
    console.error('Failed to save user:', error)
    ElMessage.error(getErrorMessage(error, '保存用户失败'))
  }
}

const deleteUser = async (user: User) => {
  try {
    await ElMessageBox.confirm(`确定要删除用户 ${user.username} 吗？`, '提示', { type: 'warning', confirmButtonText: '确定', cancelButtonText: '取消' })
    const response = await service.delete(`/users/${user.id}`)
    if (response.success) { ElMessage.success(response.message || '删除成功'); await loadUsers(); return }
    ElMessage.error(response.message || '删除失败')
  } catch (error: any) {
    if (error === 'cancel' || error === 'close' || error?.action === 'cancel') return
    console.error('Failed to delete user:', error)
    ElMessage.error(getErrorMessage(error, '删除用户失败'))
  }
}

const toggleUserStatus = async (user: User) => {
  const nextStatus = user.status === 0 ? 1 : 0
  const actionText = nextStatus === 0 ? '禁用' : '启用'
  try {
    await ElMessageBox.confirm(`确定要${actionText}用户 ${user.username} 吗？`, '提示', { type: 'warning', confirmButtonText: actionText, cancelButtonText: '取消' })
    const response = await service.put(`/users/${user.id}/status`, { status: nextStatus })
    if (response.success) { ElMessage.success(response.message || `${actionText}成功`); await loadUsers(); return }
    ElMessage.error(response.message || `${actionText}失败`)
  } catch (error: any) {
    if (error === 'cancel' || error === 'close' || error?.action === 'cancel') return
    console.error('Failed to update user status:', error)
    ElMessage.error(getErrorMessage(error, '更新用户状态失败'))
  }
}

onMounted(() => { loadUsers(); loadRoles() })
</script>

<style scoped>
.users-container {
  padding: var(--space-lg);
}

.page-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: var(--space-lg);
}

.page-title {
  font-size: var(--font-size-3xl);
  font-weight: var(--font-weight-bold);
  color: var(--color-text-primary);
  margin: 0;
}

.page-subtitle {
  color: var(--color-text-secondary);
  font-size: var(--font-size-base);
  margin: 4px 0 0;
}

.users-card {
  margin-bottom: var(--space-lg);
}

.search-form {
  margin-bottom: var(--space-lg);
  flex-wrap: wrap;
  gap: 8px;
}

.search-form .el-form-item {
  margin-bottom: 12px;
}

.data-table {
  border-radius: var(--radius-md);
  overflow: hidden;
}

.action-buttons {
  display: flex;
  gap: 6px;
}

.user-form {
  padding: 8px 0;
}

/* Responsive */
.users-dept-select {
  width: 180px;
  max-width: 100%;
}

.responsive-dialog {
  max-width: 520px;
}

.table-scroll-wrapper {
  overflow-x: auto;
  -webkit-overflow-scrolling: touch;
}

@media (max-width: 768px) {
  .users-container {
    padding: var(--space-md);
  }

  .page-header {
    flex-direction: column;
    align-items: flex-start;
    gap: 12px;
  }

  .page-title {
    font-size: var(--font-size-2xl);
  }

  .search-form {
    flex-direction: column;
    align-items: stretch;
  }

  .search-form .el-form-item {
    margin-right: 0;
  }

  .users-dept-select {
    width: 100%;
  }

  .action-buttons {
    flex-direction: column;
    gap: 4px;
  }

  .action-buttons .el-button {
    width: 100%;
  }

  .table-scroll-wrapper {
    margin: 0 -24px;
    padding: 0 24px;
  }
}

@media (max-width: 480px) {
  .users-container {
    padding: var(--space-sm);
  }

  .responsive-dialog {
    width: 96vw !important;
    max-width: none;
  }

  .table-scroll-wrapper {
    margin: 0 -16px;
    padding: 0 16px;
  }
}
</style>
