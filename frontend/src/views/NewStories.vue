<template>
  <div>
    <h1>New Stories</h1>
    <NewsList
      :newsType="'new'"
    />
  </div>
</template>

<script>
import NewsList from '../components/NewsList.vue'

export default {
  name: 'HomePage',
  components: {
    NewsList
  }
}
</script>
