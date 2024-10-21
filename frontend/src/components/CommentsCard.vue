<template>
  <div class="comment-card">
    <p class="comment-author">Author: {{ comment.by }}</p>
    <p class="comment-date">Commented on: {{ formatDate(comment.date) }}</p>
    <div class="comment-text" v-html="comment.text"></div>
    <div v-if="comment.comments && comment.comments.length" class="comment-replies">
      <CommentsCard
        v-for="reply in comment.comments"
        :key="reply.id"
        :comment="reply"
      />
    </div>
  </div>
</template>

<script>
export default {
  name: 'CommentsCard',
  props: {
    comment: {
      type: Object,
      required: true
    }
  },
  methods: {
    formatDate (date) {
      return new Date(date).toLocaleString('pt-BR', { dateStyle: 'short', timeStyle: 'short' })
    }
  },
  components: {
    CommentsCard: () => import('@/components/CommentsCard.vue')
  }
}
</script>

<style scoped>
.comment-card {
  border: 1px solid #ddd;
  padding: 10px;
  margin-bottom: 10px;
}

.comment-author,
.comment-date,
.comment-body {
  margin-bottom: 5px;
}

.comment-replies {
  margin-top: 10px;
  padding-left: 20px;
  border-left: 2px solid #ddd;
}
</style>
