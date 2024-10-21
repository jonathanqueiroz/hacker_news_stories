<template>
  <div id="app">
    <nav>
      <router-link to="/"><b>Home</b></router-link> |
      <router-link to="/news"><b>News</b></router-link>
    </nav>
    <router-view></router-view>
  </div>
</template>

<script>
export default {
  name: 'App'
}
</script>

<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}

nav {
  margin-bottom: 20px;
}

nav a {
  margin: 0 10px;
  text-decoration: none;
  color: black;
}

nav input {
  margin-left: 20px;
  padding: 5px;
}
</style>
