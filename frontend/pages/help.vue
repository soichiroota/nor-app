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
</style>
