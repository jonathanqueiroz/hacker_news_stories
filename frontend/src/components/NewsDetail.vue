<template>
  <div class="news-detail-container">
    <div class="news-detail-card">
      <h2 class="news-title"><a :href="news.url" target="_blank">{{ news.title }}</a></h2>
      <p class="news-author">Author: {{ news.by }}</p>
      <p class="news-date">Published on: {{ formatDate(news.date) }}</p>
      <p v-if = "comments && comments.length" class="news-comments">Comments:</p>
      <CommentsList :comments="comments" />
    </div>
  </div>
</template>

<script>
import CommentsList from './CommentsList.vue'

export default {
  name: 'NewsDetail',
  components: {
    CommentsList
  },
  data () {
    return {
      news: {},
      comments: []
    }
  },
  created () {
    this.fetchNewsDetail()
    this.fetchComments()
  },
  methods: {
    async fetchNewsDetail () {
      try {
        const newsId = this.$route.params.id
        const response = await this.$http.get(`/stories/${newsId}`)
        this.news = response.data
      } catch (error) {
        console.error('Error fetching news detail:', error)
      }
    },
    async fetchComments () {
      try {
        const newsId = this.$route.params.id
        const response = await this.$http.get(`/stories/${newsId}/comments`)
        this.comments = response.data
      } catch (error) {
        console.error('Error fetching comments:', error)
      }
    },
    formatDate (date) {
      return new Date(date).toLocaleString('pt-BR', { dateStyle: 'short', timeStyle: 'short' })
    }
  }
}
</script>

<style scoped>
.news-detail-container {
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 20px;
}

.news-detail-card {
  background-color: #fff;
  border: 1px solid #ddd;
  border-radius: 8px;
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
  padding: 20px;
  max-width: 800px;
  width: 100%;
}

.news-title {
  font-size: 2em;
  margin-bottom: 10px;
  color: #333;
}

.news-title a {
  color: inherit;
  text-decoration: none;
}

.news-title a:hover {
  text-decoration: underline;
}

.news-author,
.news-date {
  font-size: 1em;
  color: #555;
  margin-bottom: 10px;
}
</style>
