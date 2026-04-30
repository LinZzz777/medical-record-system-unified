import { createRouter, createWebHistory, RouteRecordRaw } from 'vue-router'
import Login from '../views/Login.vue'
import Layout from '../components/Layout/index.vue'
import store from '../store'

const routes: Array<RouteRecordRaw> = [
  {
    path: '/',
    redirect: '/dashboard'
  },
  {
    path: '/login',
    name: 'Login',
    component: Login
  },
  {
    path: '',
    component: Layout,
    meta: { requiresAuth: true },
    children: [
      {
        path: '/dashboard',
        name: 'Dashboard',
        component: () => import('../views/Dashboard.vue')
      },
      {
        path: '/borrow',
        name: 'Borrow',
        component: () => import('../views/Borrow/index.vue')
      },
      {
        path: '/borrow-history',
        name: 'BorrowHistory',
        component: () => import('../views/BorrowHistory.vue')
      },
      {
        path: '/users',
        name: 'UserManagement',
        component: () => import('../views/Users.vue'),
        meta: { requiresAdmin: true }
      },
      {
        path: '/review',
        name: 'Review',
        component: () => import('../views/Review.vue'),
        meta: { requiresAdmin: true }
      },
      {
        path: '/audit',
        name: 'AuditLogs',
        component: () => import('../views/AuditLogs.vue'),
        meta: { requiresAdmin: true }
      }
    ]
  }
]

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes
})

// 路由守卫
router.beforeEach((to, from, next) => {
  const token = store.state.token
  
  if (to.matched.some(record => record.meta.requiresAuth)) {
    if (!token) {
      next({ name: 'Login' })
    } else {
      // 检查是否需要管理员权限
      if (to.matched.some(record => record.meta.requiresAdmin)) {
        const user = store.state.user
        if (user?.role === 'admin' || user?.role === '主任') {
          next()
        } else if (user?.role === 'dept_director' && to.path === '/review') {
          next()
        } else {
          next({ name: 'Dashboard' })
        }
      } else {
        next()
      }
    }
  } else {
    next()
  }
})

export default router
