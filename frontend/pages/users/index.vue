<template>
    <div>
<h1>All users</h1>

  <div class="text-center">
    <v-pagination
      v-model="page"
      :length="pages"
      :total-visible="7"
      @click="getUsers"
    ></v-pagination>
  </div>

    <ul v-for="user in users" :key="user.id">
        <User :user="user" :currentUser="currentUser"/>
    </ul>

  <div class="text-center">
    <v-pagination
      v-model="page"
      :length="pages"
      :total-visible="7"
    ></v-pagination>
  </div>

    </div>
</template>

<script>
import { mapGetters } from 'vuex'
import User from '@/components/users/User'

export default {
  components: {
    User
  },
  head() {
    return {
      title: 'All users'
    }
  },

    data() {
    return {
      page: 1,
      pages: 1,
      users: [],
    }
  },
  asyncData() {
    return { 
    }
    },
  methods: {
    async getUsers (page) {
      return await this.$axios.$get(`/api/v1/users?page=${page}`)
    }
  },
  async fetch() {
    const response = await this.getUsers(this.page)
    this.users = JSON.parse(response.users)
    this.pages = response.pages
  },
    computed: {
      ...mapGetters({
          currentUser: 'auth/currentUser'
      }),
    },
    watch: {
      async page () {
        const response = await this.getUsers(this.page)
        this.users = JSON.parse(response.users)
      }
    }
}
</script>

<style>
</style>