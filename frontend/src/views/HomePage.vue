<template>
  <div>
    <h1>Top Stories</h1>
    <NewsList />
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
