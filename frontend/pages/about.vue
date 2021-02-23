<template>
  <v-container>
    <div>
      <h1>About</h1>
      <p>
        <a href="https://railstutorial.jp/">Ruby on Rails Tutorial</a>
        is a <a href="https://railstutorial.jp/#ebook">book</a> and
        <a href="https://railstutorial.jp/#screencast">screencast</a>
        to teach web development with
        <a href="http://rubyonrails.org/">Ruby on Rails</a>.
        This is the sample application for the tutorial.
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
      title: 'About'
    }
  }
}
</script>

<style>
</style>
