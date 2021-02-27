<template>
  <div>
    <li style="text-align: left;">
      <img :src="getGravatarUrl(user)" :alt="user.name" class="gravatar" />
      <NuxtLink :to="`/users/${user.id}/show`">
        {{ user.name }}
      </NuxtLink>
      <div v-if="currentUser.admin && currentUser.id !== user.id">
        |
        <v-dialog v-model="dialog" width="500">
          <template v-slot:activator="{ on, attrs }">
            <v-btn color="red lighten-2" dark small v-bind="attrs" v-on="on">
              delete
            </v-btn>
          </template>

          <v-card>
            <v-card-title class="headline grey lighten-2">
              You sure?
            </v-card-title>

            <v-divider />

            <v-card-actions>
              <v-spacer />
              <v-btn color="primary" text @click="deleteUser">
                Yes
              </v-btn>
            </v-card-actions>
          </v-card>
        </v-dialog>
      </div>
    </li>
  </div>
</template>

<script>
export default {
  props: {
    user: Object,
    currentUser: Object
  },
  data() {
    return {
      gravatarUrlSize: 50,
      dialog: false
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
    async deleteUser() {
      this.dialog = false;
      const response = await this.$axios.$delete(
        `/api/v1/users/${this.user.id}`
      );
      this.$toast.success("User deleted");
      window.location.reload();
    }
  }
};
</script>

<style></style>
