<template>
  <v-container>
    <div>
      <h1>
        <img :src="gravatarUrl" :alt="userName" class="gravatar" />
        {{ userName }}
      </h1>
    </div>
  </v-container>
</template>

<script>
import { mapGetters } from "vuex";

export default {
  data() {
    return {
      gravatarUrlSize: 80
    };
  },
  methods: {},
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
  async fetch() {
    await this.$store.dispatch("users/fetchUser", this.$route.params.id);
  }
};
</script>

<style></style>
