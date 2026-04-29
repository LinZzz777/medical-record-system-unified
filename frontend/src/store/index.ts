import { createStore } from 'vuex'

interface User {
  id: number
  employeeNumber: string
  username: string
  name: string
  role: string
  department: string
  phone: string
  email: string
  address: string
  position: string
}

interface RootState {
  user: User | null
  token: string | null
  loading: boolean
  error: string | null
}

export default createStore<RootState>({
  state: {
    user: JSON.parse(localStorage.getItem('user') || 'null'),
    token: localStorage.getItem('token'),
    loading: false,
    error: null
  },
  getters: {
    isAuthenticated: (state) => !!state.token,
    isAdmin: (state) => state.user?.role === 'admin',
    isDirector: (state) => state.user?.role === '主任',
    isAdminOrDirector: (state) => state.user?.role === 'admin' || state.user?.role === '主任',
    isDeptDirector: (state) => state.user?.role === 'dept_director',
    isMedRecordsDirector: (state) => state.user?.role === 'dept_director' && state.user?.department === '病案科',
    userDepartment: (state) => state.user?.department || '',
    currentUser: (state) => state.user
  },
  mutations: {
    setUser(state, user: User) {
      state.user = user
      localStorage.setItem('user', JSON.stringify(user))
    },
    setToken(state, token: string) {
      state.token = token
      localStorage.setItem('token', token)
    },
    setLoading(state, loading: boolean) {
      state.loading = loading
    },
    setError(state, error: string | null) {
      state.error = error
    },
    logout(state) {
      state.user = null
      state.token = null
      localStorage.removeItem('user')
      localStorage.removeItem('token')
    }
  },
  actions: {
    login({ commit }, { token, user }) {
      commit('setToken', token)
      commit('setUser', user)
      commit('setError', null)
    },
    logout({ commit }) {
      commit('logout')
    }
  }
})