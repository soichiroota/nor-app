<template>
  <div>
    <div v-if="feedItems">
      <ul class="microposts" v-for="micropost in feedItems" :key="micropost.id">
        <Micropost :micropost="micropost" :user="micropost.user" />
      </ul>
      <div class="text-center">
        <v-pagination
          v-model="page"
          :length="pages"
          :total-visible="7"
          @click="getFeedItems"
        />
      </div>
    </div>
  </div>
</template>

<script>
import Micropost from "@/components/microposts/Micropost";

export default {
  components: {
    Micropost
  },
  props: {
    user: Object,
    pages: Number
  },
  data() {
    return {
      page: 1,
      feedItems: []
    };
  },
  watch: {
    async page() {
      if (this.user) {
        const response = await this.getFeedItems(this.page);
        this.feedItems = JSON.parse(response.feed_items);
      }
    }
  },
  async fetch() {
    if (this.user) {
      const response = await this.getFeedItems(this.page);
      this.feedItems = JSON.parse(response.feed_items);
    }
  },
  methods: {
    async getFeedItems(page) {
      return await this.$axios.$get(`/api/v1/static_pages/home?page=${page}`);
    }
  }
};
</script>

<style></style>
