<template>
  <v-container>
    <div>
      <h1>Sample App</h1>
      <p>
        This is the home page for the
        <a href="https://railstutorial.jp/">Ruby on Rails Tutorial</a>
        sample application.
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
      title: 'Home'
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
