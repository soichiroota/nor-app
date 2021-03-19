<template>
  <div>
    <NuxtLink :to="`/users/${user.id}/show`">
      <img :src="getGravatarUrl(user)" :alt="user.name" class="gravatar" />
    </NuxtLink>
    <h1>{{ user.name }}</h1>
    <span><a :href="`/users/${user.id}/show`">view my profile</a></span>
    <span>{{ pluralize("micropost", micropostsLength) }}</span>
  </div>
</template>

<script>
export default {
  props: {
    user: Object,
    micropostsLength: Number
  },
  data() {
    return {
      gravatarUrlSize: 80
    };
  },
  methods: {
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
    },
    pluralize(str, count) {
      const pluralize = require("pluralize");
      return pluralize(str, count, true);
    }
  }
};
</script>
