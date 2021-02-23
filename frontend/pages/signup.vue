<template>
  <v-container>
    <div>
      <h1>Sign up</h1>
      <p>This will be a signup page for new users.</p>
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
      title: 'Sign up'
    }
  }
}
</script>

<style>
</style>