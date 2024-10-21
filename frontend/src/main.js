import { createApp } from 'vue'
import App from './App.vue'
import axios from 'axios'
import router from './router'

const app = createApp(App)

const baseURL = process.env.VUE_APP_BASE_URL

app.config.globalProperties.$http = axios.create({
  // eslint-disable-next-line object-shorthand
  baseURL: baseURL
})

app.config.globalProperties.$wsBaseURL = `${baseURL.replace(/^http/, 'ws')}/cable`

app.use(router)
app.mount('#app')
