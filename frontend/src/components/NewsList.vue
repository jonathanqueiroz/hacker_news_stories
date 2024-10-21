<template>
  <div class="news-container">
    <input
      type="text"
      v-model="searchTerm"
      placeholder="Type to search news"
      class="search-bar"
      v-if = "newsType === 'new'"
    />
    <div class="news-grid">
      <NewsCard
        v-for="news in newsList"
        :key="news.id"
        :news="news"
        @click="goToNewsDetail(news.id)"
      />
    </div>
  </div>
</template>

<script>
import NewsCard from '@/components/NewsCard.vue'
import { createConsumer } from '@rails/actioncable'

export default {
  name: 'NewsList',
  components: {
    NewsCard
  },
  props: {
    newsType: {
      type: String,
      default: 'top'
    }
  },
  data () {
    return {
      newsList: [],
      searchTerm: '',
      cable: null,
      subscription: null
    }
  },
  watch: {
    searchTerm (newTerm) {
      this.fetchNewStories(newTerm)
    }
  },
  created () {
    if (this.newsType === 'top') {
      this.fetchTopStories()
    } else {
      this.fetchNewStories(this.searchTerm)
    }

    this.connectWebSocket()
  },
  beforeUnmount () {
    if (this.subscription) {
      this.subscription.unsubscribe()
    }
    if (this.cable) {
      this.cable.disconnect()
    }
  },
  methods: {
    async fetchTopStories () {
      try {
        const response = await this.$http.get('/')
        this.newsList = response.data
      } catch (error) {
        console.error('Error fetching news:', error)
      }
    },
    async fetchNewStories (filterTerm = '') {
      try {
        const response = await this.$http.get('/new_stories', {
          params: { filter_term: filterTerm }
        })

        this.newsList = response.data
      } catch (error) {
        console.error('Error fetching news:', error)
      }
    },
    goToNewsDetail (newsId) {
      this.$router.push({ name: 'NewsDetail', params: { id: newsId } })
    },
    connectWebSocket () {
      this.cable = createConsumer(this.$wsBaseURL)
      this.subscription = this.cable.subscriptions.create('StoriesChannel', {
        received: (data) => {
          if (data.stories) {
            this.newsList = data.stories
          }
        }
      })
    }
  }
}
</script>

<style scoped>
.news-container {
  padding: 20px;
}

.news-grid {
  display: flex;
  flex-wrap: wrap;
  gap: 20px;
}

.search-bar {
  margin-bottom: 20px;
  padding: 10px;
  width: 50%;
  box-sizing: border-box;
}
</style>
