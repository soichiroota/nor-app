<template>
  <div>
    <li>
      <NuxtLink :to="`/users/${user.id}/show`">
        <img :src="getGravatarUrl(user)" :alt="user.name" class="gravatar" />
      </NuxtLink>
      <span class="user">
        <NuxtLink :to="`/users/${user.id}/show`">
          {{ user.name }}
        </NuxtLink>
      </span>
      <br />
      <span class="content">
        {{ micropost.content }}
        <div v-if="micropost.picture.url">
          <img :src="`${$axios.defaults.baseURL}${micropost.picture.url}`" />
        </div>
      </span>
      <br />
      <span class="timestamp">
        Posted <timeago :datetime="micropost.created_at"></timeago>.
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
              <v-btn color="primary" text @click="deleteMicropost">
                Yes
              </v-btn>
            </v-card-actions>
          </v-card>
        </v-dialog>
      </span>
    </li>
  </div>
</template>

<script>
export default {
  props: {
    micropost: Object,
    user: Object
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
    async deleteMicropost() {
      this.dialog = false;
      const response = await this.$axios.$delete(
        `/api/v1/microposts/${this.micropost.id}`
      );
      this.$toast.success("Micropost deleted");
      window.location.reload();
    }
  }
};
</script>

<style></style>
