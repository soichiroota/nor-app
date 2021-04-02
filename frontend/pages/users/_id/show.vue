<template>
  <v-row>
    <v-col>
      <h1>
        <img :src="gravatarUrl" :alt="userName" class="gravatar" />
        {{ userName }}
      </h1>
    </v-col>
    <v-col>
      <div v-if="currentUser">
        <FollowForm :user="user" />
      </div>
      <div v-if="microposts.length">
        <h3>Microposts ({{ microposts.length }})</h3>
        <ul
          class="microposts"
          v-for="micropost in microposts"
          :key="micropost.id"
        >
          <Micropost :micropost="micropost" :user="user" />
        </ul>

        <div class="text-center">
          <v-pagination
            v-model="page"
            :length="pages"
            :total-visible="7"
            @click="getUser"
          />
        </div>
      </div>
    </v-col>
  </v-row>
</template>

<script>
import { mapGetters } from "vuex";
import Micropost from "@/components/microposts/Micropost";
import FollowForm from "@/components/users/FollowForm";

export default {
  components: {
    Micropost,
    FollowForm
  },
  data() {
    return {
      gravatarUrlSize: 80,
      page: 1,
      pages: 1,
      microposts: [],
      timeAgo: null
    };
  },
  methods: {
    async getUser(page) {
      return await this.$axios.$get(
        `/api/v1/users/${this.$route.params.id}?page=${page}`
      );
    }
  },
  head() {
    return {
      title: this.title
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
    },
    title: function() {
      if (this.user) {
        return this.user.name;
      } else {
        return "";
      }
    },
    userName: function() {
      if (this.user) {
        return this.user.name;
      } else {
        return "";
      }
    }
  },
  watch: {
    async page() {
      const response = await this.getUser(this.page);
      this.microposts = JSON.parse(response.microposts);
    }
  },
  async fetch() {
    await this.$store.dispatch("users/fetchUser", this.$route.params.id);
    const response = await this.getUser(this.page);
    this.microposts = JSON.parse(response.microposts);
    this.pages = response.pages;
  }
};
</script>

<style></style>
