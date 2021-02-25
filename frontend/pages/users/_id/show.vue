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
      gravatarUrlSize: 80,
    }
  },
  methods: {
    gravatarUrl: function () {
      if (this.user.email) {
        const crypto = require('crypto')
        const gravatarId = crypto.createHash('md5').update(this.user.email.toLowerCase()).digest('hex')
        return `https://secure.gravatar.com/avatar/${gravatarId}?s=${this.gravatarUrlSize}`
      } else {
        ''
      }
    }
  },
  head() {
    return {
      title: this.user.name
    }
  },
  computed: {
    ...mapGetters({
      user: 'users/user',
      currentUser: 'auth/currentUser'
    }),
  },
  async fetch() {
    await this.$store.dispatch('users/fetchUser', this.$route.params.id)
  },
  mounted() {
  },
}
</script>

<style>
</style>