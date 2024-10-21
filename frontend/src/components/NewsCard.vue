<template>
  <div class="news-card">
    <h2 class="news-title">{{ news.title }}</h2>
    <p class="news-author">Author: {{ news.by }}</p>
    <p class="news-date">Published on: {{ formatDate(news.date) }}</p>
    <p class="news-body">{{ news.body }}</p>
  </div>
</template>

<script>
export default {
  name: 'NewsCard',
  props: {
    news: {
      type: Object,
      required: true
    }
  },
  methods: {
    formatDate (date) {
      return new Date(date).toLocaleString('pt-BR', { dateStyle: 'short', timeStyle: 'short' })
    }
  }
}
</script>

<style scoped>
.news-card {
  background-color: #fff;
  border: 1px solid #ddd;
  border-radius: 8px;
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
  padding: 20px;
  transition: transform 0.2s, box-shadow 0.2s;
  cursor: pointer;
}

.news-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
}

.news-title {
  font-size: 1.5em;
  margin-bottom: 10px;
}

.news-author,
.news-date {
  font-size: 0.9em;
  color: #555;
  margin-bottom: 5px;
}

.news-body {
  font-size: 1em;
  color: #333;
}
</style>
