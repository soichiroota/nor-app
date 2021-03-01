<template>
  <div />
</template>

<script>
export default {
  data() {
    return {
      response: null
    };
  },
  async fetch() {
    const endpoint = `/api/v1/account_activations/${this.$route.params.token}/edit?email=${this.$route.params.email}`;
    const response = await this.$axios.$get(endpoint);
    this.response = response;
  },
  mounted() {
    if (this.response.token) {
      this.$cookies.set("token", this.response.token);
      const user = this.response.user;
      this.$store.commit("auth/setCurrentUser", { user });
      this.$toast.success("Account activated!");
      location.replace(`/users/${this.response.user.id}/show`);
    } else {
      this.$toast.error("Invalid activation link");
      location.replace("/home");
    }
  },
  methods: {},
  head() {
    return {
      title: "Account activation"
    };
  }
};
</script>
