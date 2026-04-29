import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

// https://vitejs.dev/config/
export default defineConfig(({ command }) => ({
  base: command === 'build' ? '/api/' : '/',
  plugins: [vue()],
  server: {
    port: 3000,
    proxy: {
      '/api': {
        target: 'http://localhost:8080',
        changeOrigin: true
      }
    }
  },
  build: {
    outDir: '../backend/src/main/resources/static',
    emptyOutDir: true,
    rollupOptions: {
      output: {
        manualChunks(id) {
          if (!id.includes('node_modules')) {
            return
          }

          if (id.includes('echarts')) {
            return 'vendor-echarts'
          }

          if (id.includes('element-plus') || id.includes('@element-plus') || id.includes('@floating-ui')) {
            return 'vendor-element-plus'
          }

          if (id.includes('vue-router')) {
            return 'vendor-router'
          }

          if (id.includes('vuex')) {
            return 'vendor-store'
          }

          if (id.includes('axios') || id.includes('dayjs')) {
            return 'vendor-utils'
          }

          if (
            id.includes('/vue/') ||
            id.includes('@vue/') ||
            id.includes('vue/dist') ||
            id.includes('vue-runtime')
          ) {
            return 'vendor-vue'
          }

          return 'vendor-misc'
        }
      }
    }
  }
}))
