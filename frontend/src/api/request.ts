import axios, { AxiosInstance, AxiosRequestConfig, AxiosResponse } from 'axios'
import store from '../store'

interface ApiService extends Omit<AxiosInstance, 'request' | 'get' | 'delete' | 'head' | 'options' | 'post' | 'put' | 'patch'> {
  request<T = any>(config: AxiosRequestConfig): Promise<T>
  get<T = any>(url: string, config?: AxiosRequestConfig): Promise<T>
  delete<T = any>(url: string, config?: AxiosRequestConfig): Promise<T>
  head<T = any>(url: string, config?: AxiosRequestConfig): Promise<T>
  options<T = any>(url: string, config?: AxiosRequestConfig): Promise<T>
  post<T = any>(url: string, data?: any, config?: AxiosRequestConfig): Promise<T>
  put<T = any>(url: string, data?: any, config?: AxiosRequestConfig): Promise<T>
  patch<T = any>(url: string, data?: any, config?: AxiosRequestConfig): Promise<T>
}

const service = axios.create({
  baseURL: '/api',
  timeout: 10000
}) as ApiService

const loginPath = `${import.meta.env.BASE_URL}login`

// 请求拦截器
service.interceptors.request.use(
  (config) => {
    const token = store.state.token
    if (token) {
      config.headers.Authorization = `Bearer ${token}`
    }
    const user = store.state.user
    if (user && user.username) {
      config.headers['X-User'] = user.username
    }
    return config
  },
  (error) => {
    return Promise.reject(error)
  }
)

// 响应拦截器
service.interceptors.response.use(
  (response: AxiosResponse) => {
    return response.data
  },
  (error) => {
    if (error.response) {
      const status = error.response.status
      if (status === 401) {
        // 未授权，清除token并跳转到登录页
        store.dispatch('logout')
        window.location.href = loginPath
      }
    }
    return Promise.reject(error)
  }
)

export default service
