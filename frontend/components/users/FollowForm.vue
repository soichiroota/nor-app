<template>
  <div>
    <div v-if="currentUser.id !== user.id">
      <div id="follow_form">
        <div v-if="isFollowing">
          <v-btn @click="unfollow">
            Unfollow
          </v-btn>
        </div>
        <div v-else>
          <v-btn color="primary" @click="follow">
            Follow
          </v-btn>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { mapGetters } from "vuex";

export default {
  props: {
    user: Object
  },
  data() {
    return {
      isFollowing: false
    };
  },
  methods: {
    async follow() {
      const endpoint = "api/v1/relationships";
      const payload = {
        followed_id: this.user.id
      };
      await this.$axios.$post(endpoint, payload);
      window.location.reload();
    },
    async unfollow() {
      const passiveRelationships = this.user.passive_relationships.filter(
        relationship => relationship.follower_id === this.currentUser.id
      );
      if (passiveRelationships) {
        const endpoint = `api/v1/relationships/${passiveRelationships[0].id}`;
        await this.$axios.$delete(endpoint, {});
      }
      window.location.reload();
    }
  },
  computed: {
    ...mapGetters({
      currentUser: "auth/currentUser"
    })
  },
  async fetch() {
    const res = await this.$axios.$get("/api/v1/users/" + this.user.id);
    const user = JSON.parse(res.user);
    this.isFollowing =
      user.followers.filter(follower => follower.id === this.currentUser.id)
        .length > 0;
  }
};
</script>
