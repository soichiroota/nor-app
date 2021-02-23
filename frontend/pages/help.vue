<template>
  <v-container>
    <div>
      <h1>Help</h1>
      <p>
        Get help on the Ruby on Rails Tutorial at the
        <a href="https://railstutorial.jp/help">Rails Tutorial help page</a>.
        To get help on this sample app, see the
        <a href="https://railstutorial.jp/#ebook"><em>Ruby on Rails Tutorial</em>
        book</a>.
      </p>
    </div>
  </v-container>
</template>

<script>
export default {
  data() {
    return {
      subTitle: 'Zenn is good service!!',
      tasks: [],
    }
  },
  methods: {
    async getSomething() {
      const response = await this.$axios.$get('/api/v1/tasks')
      this.tasks = JSON.parse(response.tasks)
    }
  },
  head() {
    return {
      title: 'Help'
    }
  }
}
</script>

<style>
.container {
  margin: 0 auto;
  min-height: 100vh;
  display: flex;
  justify-content: center;
  align-items: center;
  text-align: center;
}

.title {
  font-family: 'Quicksand', 'Source Sans Pro', -apple-system, BlinkMacSystemFont,
    'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
  display: block;
  font-weight: 300;
  font-size: 100px;
  color: #35495e;
  letter-spacing: 1px;
}

.subtitle {
  font-weight: 300;
  font-size: 42px;
  color: #526488;
  word-spacing: 5px;
  padding-bottom: 15px;
}

.links {
  padding-top: 15px;
}
</style>
