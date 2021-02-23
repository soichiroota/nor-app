<template>
  <v-container>
    <div>
      <h1>
        <img :src="gravatarUrl" :alt="user.name" class="gravatar"/>
        {{ user.name }}
      </h1>
    </div>
  </v-container>
</template>

<script>
import { mapGetters } from 'vuex'

export default {
  data() {
    return {
      subTitle: 'Zenn is good service!!',
      tasks: [],
      gravatarUrl: ''
    }
  },
  methods: {
    async getSomething() {
      const response = await this.$axios.$get('/api/v1/tasks')
      this.tasks = JSON.parse(response.tasks)
    },
    getGravatarUrl(size=80) {
      const crypto = require('crypto')
      const gravatarId = crypto.createHash('md5').update(this.user.email.toLowerCase()).digest('hex')
      this.gravatarUrl = `https://secure.gravatar.com/avatar/${gravatarId}?s=${size}`
    },
  },
  head() {
    return {
      title: this.user.name
    }
  },
  computed: {
    ...mapGetters({
      user: 'users/user',
    })
  },
  async fetch({ store, params, redirect }) {
    await store.dispatch('users/fetchUser', params.id)
    this.getGravatarUrl()
  },
  mounted() {
  },
}
</script>

<style>
</style>