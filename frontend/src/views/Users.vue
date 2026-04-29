<template>
  <div class="users-container">
    <el-card class="users-card">
      <template #header>
        <div class="card-header">
          <span>&#29992;&#25143;&#31649;&#29702;</span>
          <el-button type="primary" @click="openCreateDialog">&#26032;&#22686;&#29992;&#25143;</el-button>
        </div>
      </template>

      <el-form :model="searchForm" :inline="true" class="search-form">
        <el-form-item :label="t.username">
          <el-input v-model="searchForm.username" :placeholder="t.enterUsername" clearable />
        </el-form-item>
        <el-form-item :label="t.name">
          <el-input v-model="searchForm.name" :placeholder="t.enterName" clearable />
        </el-form-item>
        <el-form-item :label="t.department">
          <el-select v-model="searchForm.department" :placeholder="t.enterDepartment" clearable filterable style="width: 180px">
            <el-option v-for="dept in departmentOptions" :key="dept" :label="dept" :value="dept" />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="loadUsers">&#21047;&#26032;</el-button>
        </el-form-item>
      </el-form>

      <el-table :data="filteredUsers" style="width: 100%" border>
        <el-table-column prop="id" label="ID" width="80" />
        <el-table-column :label="t.employeeNumber" prop="employeeNumber" width="120" />
        <el-table-column :label="t.username" prop="username" width="140" />
        <el-table-column :label="t.name" prop="name" width="120" />
        <el-table-column :label="t.department" prop="department" min-width="140" />
        <el-table-column :label="t.position" prop="position" min-width="140" />
        <el-table-column :label="t.role" prop="role" width="120" />
        <el-table-column :label="t.status" width="100">
          <template #default="{ row }">
            <el-tag :type="row.status === 0 ? 'danger' : 'success'">
              {{ row.status === 0 ? t.disabled : t.enabled }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column :label="t.actions" width="250" fixed="right">
          <template #default="{ row }">
            <el-button type="primary" size="small" @click="editUser(row)">{{ t.edit }}</el-button>
            <el-button
              :type="row.status === 0 ? 'success' : 'warning'"
              size="small"
              @click="toggleUserStatus(row)"
            >
              {{ row.status === 0 ? t.enable : t.disable }}
            </el-button>
            <el-button type="danger" size="small" @click="deleteUser(row)">{{ t.delete }}</el-button>
          </template>
        </el-table-column>
      </el-table>

      <el-dialog v-model="dialogVisible" :title="dialogTitle" width="520px">
        <el-form :model="userForm" label-width="100px">
          <el-form-item :label="t.employeeNumber">
            <el-input v-model="userForm.employeeNumber" :placeholder="t.enterEmployeeNumber" />
          </el-form-item>
          <el-form-item :label="t.username">
            <el-input v-model="userForm.username" :placeholder="t.enterUsername" />
          </el-form-item>
          <el-form-item :label="isEditing ? t.password : t.initialPassword">
            <el-input
              v-model="userForm.password"
              type="password"
              show-password
              :placeholder="isEditing ? t.keepPassword : t.enterPassword"
            />
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
            <el-select
              v-model="userForm.role"
              :placeholder="t.selectRole"
              allow-create
              filterable
              default-first-option
            >
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
          <span class="dialog-footer">
            <el-button @click="dialogVisible = false">{{ t.cancel }}</el-button>
            <el-button type="primary" @click="saveUser">{{ t.save }}</el-button>
          </span>
        </template>
      </el-dialog>
    </el-card>
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
  employeeNumber: '',
  username: '',
  password: '',
  name: '',
  department: '',
  position: '',
  role: '',
  status: 1
})

const searchForm = reactive({
  username: '',
  name: '',
  department: ''
})

const users = ref<User[]>([])
const dialogVisible = ref(false)
const userForm = reactive<User>(createEmptyUserForm())
const roleOptions = ref<string[]>(['admin', 'doctor', 'nurse', 'dept_director'])
const departmentOptions = ['内科', '外科', '妇产科', '儿科', '骨科', '神经内科', '心血管内科', '消化内科', '呼吸内科', '泌尿外科', '眼科', '耳鼻喉科', '皮肤科', '感染科', '肿瘤科', '康复科', '中医科', '内分泌科', '肾内科', '口腔科', '急诊科', '风湿免疫科', '临床科', '护理部', '病案科']
const t = {
  username: '\u7528\u6237\u540d',
  name: '\u59d3\u540d',
  department: '\u79d1\u5ba4',
  position: '\u804c\u4f4d',
  role: '\u89d2\u8272',
  status: '\u72b6\u6001',
  actions: '\u64cd\u4f5c',
  employeeNumber: '\u5de5\u53f7',
  enterUsername: '\u8bf7\u8f93\u5165\u7528\u6237\u540d',
  enterName: '\u8bf7\u8f93\u5165\u59d3\u540d',
  enterDepartment: '\u8bf7\u8f93\u5165\u79d1\u5ba4',
  enterPosition: '\u8bf7\u8f93\u5165\u804c\u4f4d',
  enterEmployeeNumber: '\u8bf7\u8f93\u5165\u5de5\u53f7',
  enterPassword: '\u8bf7\u8f93\u5165\u5bc6\u7801',
  keepPassword: '\u4e0d\u4fee\u6539\u53ef\u7559\u7a7a',
  selectRole: '\u8bf7\u9009\u62e9\u89d2\u8272',
  enabled: '\u542f\u7528',
  disabled: '\u7981\u7528',
  enable: '\u542f\u7528',
  disable: '\u7981\u7528',
  edit: '\u7f16\u8f91',
  delete: '\u5220\u9664',
  cancel: '\u53d6\u6d88',
  save: '\u4fdd\u5b58',
  password: '\u5bc6\u7801',
  initialPassword: '\u521d\u59cb\u5bc6\u7801',
  editUser: '\u7f16\u8f91\u7528\u6237',
  addUser: '\u65b0\u589e\u7528\u6237'
}

const isEditing = computed(() => Boolean(userForm.id))
const dialogTitle = computed(() => (isEditing.value ? t.editUser : t.addUser))

const filteredUsers = computed(() =>
  users.value.filter((user) => {
    const usernameMatched = !searchForm.username || user.username?.includes(searchForm.username)
    const nameMatched = !searchForm.name || user.name?.includes(searchForm.name)
    const departmentMatched =
      !searchForm.department || user.department?.includes(searchForm.department)

    return usernameMatched && nameMatched && departmentMatched
  })
)

const getErrorMessage = (error: any, fallback: string) =>
  error?.response?.data?.message || error?.message || fallback

const resetUserForm = () => {
  Object.assign(userForm, createEmptyUserForm())
  delete (userForm as any).createdAt
}

const openCreateDialog = () => {
  resetUserForm()
  dialogVisible.value = true
}

const loadUsers = async () => {
  try {
    const response = await service.get('/users/list')
    users.value = Array.isArray(response) ? response : []
  } catch (error) {
    console.error('Failed to load users:', error)
    ElMessage.error(getErrorMessage(error, '\u52a0\u8f7d\u7528\u6237\u5217\u8868\u5931\u8d25'))
  }
}

const loadRoles = async () => {
  try {
    const response = await service.get('/roles/list')
    if (Array.isArray(response)) {
      const roles = response
        .map((item: RoleItem) => item.roleName)
        .filter((roleName: string) => Boolean(roleName))
      if (roles.length > 0) {
        roleOptions.value = Array.from(new Set(roles))
      }
    }
  } catch (error) {
    console.error('Failed to load roles:', error)
  }
}

const editUser = (user: User) => {
  resetUserForm()
  Object.assign(userForm, {
    ...user,
    password: ''
  })
  dialogVisible.value = true
}

const saveUser = async () => {
  if (!userForm.username || !userForm.name) {
    ElMessage.warning('\u8bf7\u5148\u5b8c\u5584\u7528\u6237\u540d\u548c\u59d3\u540d')
    return
  }

  if (!isEditing.value && !userForm.password) {
    ElMessage.warning('\u65b0\u589e\u7528\u6237\u65f6\u5fc5\u987b\u586b\u5199\u5bc6\u7801')
    return
  }

  try {
    const payload: Record<string, any> = { ...userForm }
    if (!isEditing.value) {
      delete payload.createdAt
      delete payload.id
    }
    if (isEditing.value && !payload.password) {
      delete payload.password
    }

    const response = isEditing.value
      ? await service.put('/users/update', payload)
      : await service.post('/users/register', payload)

    if (response.success) {
      ElMessage.success(
        isEditing.value ? '\u7528\u6237\u66f4\u65b0\u6210\u529f' : '\u7528\u6237\u65b0\u589e\u6210\u529f'
      )
      dialogVisible.value = false
      await loadUsers()
      return
    }

    ElMessage.error(response.message || '\u4fdd\u5b58\u7528\u6237\u5931\u8d25')
  } catch (error) {
    console.error('Failed to save user:', error)
    ElMessage.error(getErrorMessage(error, '\u4fdd\u5b58\u7528\u6237\u5931\u8d25'))
  }
}

const deleteUser = async (user: User) => {
  try {
    await ElMessageBox.confirm(`\u786e\u5b9a\u8981\u5220\u9664\u7528\u6237 ${user.username} \u5417\uff1f`, '\u63d0\u793a', {
      type: 'warning',
      confirmButtonText: '\u786e\u5b9a',
      cancelButtonText: '\u53d6\u6d88'
    })

    const response = await service.delete(`/users/${user.id}`)
    if (response.success) {
      ElMessage.success(response.message || '\u5220\u9664\u6210\u529f')
      await loadUsers()
      return
    }

    ElMessage.error(response.message || '\u5220\u9664\u5931\u8d25')
  } catch (error: any) {
    if (error === 'cancel' || error === 'close' || error?.action === 'cancel') {
      return
    }
    console.error('Failed to delete user:', error)
    ElMessage.error(getErrorMessage(error, '\u5220\u9664\u7528\u6237\u5931\u8d25'))
  }
}

const toggleUserStatus = async (user: User) => {
  const nextStatus = user.status === 0 ? 1 : 0
  const actionText = nextStatus === 0 ? '\u7981\u7528' : '\u542f\u7528'

  try {
    await ElMessageBox.confirm(`\u786e\u5b9a\u8981${actionText}\u7528\u6237 ${user.username} \u5417\uff1f`, '\u63d0\u793a', {
      type: 'warning',
      confirmButtonText: actionText,
      cancelButtonText: '\u53d6\u6d88'
    })

    const response = await service.put(`/users/${user.id}/status`, { status: nextStatus })
    if (response.success) {
      ElMessage.success(response.message || `${actionText}\u6210\u529f`)
      await loadUsers()
      return
    }

    ElMessage.error(response.message || `${actionText}\u5931\u8d25`)
  } catch (error: any) {
    if (error === 'cancel' || error === 'close' || error?.action === 'cancel') {
      return
    }
    console.error('Failed to update user status:', error)
    ElMessage.error(getErrorMessage(error, '\u66f4\u65b0\u7528\u6237\u72b6\u6001\u5931\u8d25'))
  }
}

onMounted(() => {
  loadUsers()
  loadRoles()
})
</script>

<style scoped>
.users-container {
  padding: 20px;
}

.users-card {
  margin-bottom: 20px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.search-form {
  margin-bottom: 20px;
}

.dialog-footer {
  text-align: right;
}
</style>
