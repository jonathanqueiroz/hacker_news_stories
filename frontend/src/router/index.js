import { createRouter, createWebHistory } from 'vue-router'
import HomePage from '../views/HomePage.vue'
import NewStories from '../views/NewStories.vue'
import NewsDetail from '../components/NewsDetail.vue'

const routes = [
  {
    path: '/',
    name: 'HomePage',
    component: HomePage
  },
  {
    path: '/news',
    name: 'News',
    component: NewStories
  },
  {
    path: '/news/:id',
    name: 'NewsDetail',
    component: NewsDetail
  }
]

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes
})

export default router
