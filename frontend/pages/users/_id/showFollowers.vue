<template>
  <div>
    <v-row>
      <v-col>
        <section class="user_info">
          <UserInfo :user="user" :micropostsLength="micropostsCount" />
        </section>
        <section class="stats">
          <Stats :user="user" />
          <div v-if="users">
            <div class="user_avatars">
              <div v-for="follower in users" :key="follower.id">
                <NuxtLink :to="`/users/${follower.id}/show`">
                  <img
                    :src="getGravatarUrl(follower)"
                    :alt="follower.name"
                    class="gravatar"
                  />
                </NuxtLink>
              </div>
            </div>
          </div>
        </section>
      </v-col>
      <v-col>
        <h3>Followers</h3>
        <div v-if="users">
          <ul v-for="follower in users" :key="follower.id">
            <User :user="follower" :currentUser="currentUser" />
          </ul>
          <div class="text-center">
            <v-pagination
              v-model="page"
              :length="pages"
              :total-visible="7"
              @click="getFollowers"
            />
          </div>
        </div>
      </v-col>
    </v-row>
  </div>
</template>

<script>
import { mapGetters } from "vuex";
import UserInfo from "@/components/shared/UserInfo";
import Stats from "@/components/shared/Stats";
import User from "@/components/users/User";

export default {
  components: {
    UserInfo,
    Stats,
    User
  },
  data() {
    return {
      gravatarUrlSize: 30,
      page: 1,
      pages: 1,
      micropostsCount: 0,
      users: []
    };
  },
  methods: {
    async getFollowers(page) {
      return await this.$axios.$get(
        `/api/v1/users/${this.$route.params.id}/followers?page=${page}`
      );
    },
    getGravatarUrl(user) {
      if (user.email) {
        const crypto = require("crypto");
        const gravatarId = crypto
          .createHash("md5")
          .update(user.email.toLowerCase())
          .digest("hex");
        return `https://secure.gravatar.com/avatar/${gravatarId}?s=${this.gravatarUrlSize}`;
      } else {
        return "";
      }
    }
  },
  head() {
    return {
      title: "Followers"
    };
  },
  computed: {
    ...mapGetters({
      user: "users/user",
      currentUser: "auth/currentUser"
    }),
    gravatarUrl: function() {
      if (this.user.email) {
        const crypto = require("crypto");
        const gravatarId = crypto
          .createHash("md5")
          .update(this.user.email.toLowerCase())
          .digest("hex");
        return `https://secure.gravatar.com/avatar/${gravatarId}?s=${this.gravatarUrlSize}`;
      } else {
        return "";
      }
    }
  },
  watch: {
    async page() {
      const response = await this.getFollowers(this.page);
      this.users = JSON.parse(response.users);
      this.micropostsCount = this.user.microposts_count;
    }
  },
  async fetch() {
    await this.$store.dispatch("users/fetchUser", this.$route.params.id);
    const response = await this.getFollowers(this.page);
    this.users = JSON.parse(response.users);
    this.micropostsCount = this.user.microposts_count;
    this.pages = response.pages;
  }
};
</script>

<style></style>
