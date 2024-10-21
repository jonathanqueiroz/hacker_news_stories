<template>
  <div class="comments-container">
    <div class="comments-grid">
      <CommentsCard
        v-for="comment in commentsList"
        :key="comment.id"
        :comment="comment"
      />
    </div>
  </div>
</template>

<script>
import CommentsCard from '@/components/CommentsCard.vue'

export default {
  name: 'CommentsList',
  components: {
    CommentsCard
  },
  data () {
    return {
      commentsList: []
    }
  },
  created () {
    this.fetchComments()
  },
  methods: {
    async fetchComments () {
      try {
        const storyId = this.$route.params.id
        const response = await this.$http.get(`/stories/${storyId}/comments`)
        this.commentsList = response.data
      } catch (error) {
        console.error('Error fetching comments:', error)
      }
    }
  }
}
</script>

<style scoped>
.comments-container {
  padding: 20px;
}

.comments-grid {
  display: flex;
  flex-direction: column;
  gap: 10px;
}
</style>
