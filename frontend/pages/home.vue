<template>
  <div>
    <div v-if="currentUser">
      <v-row>
        <v-col>
          <section class="user_info">
            <UserInfo :user="currentUser" :micropostsLength="feedItemsLength" />
          </section>
          <section class="stats">
            <Stats :user="currentUser" />
          </section>
          <section class="micropost_form">
            <Errors :errors="errors" />
            <form @submit.prevent="submit">
              <v-textarea
                outlined
                clearable
                counter
                v-model="content"
                name="content"
                hint="Compose new micropost..."
              ></v-textarea>

              <v-btn class="mr-4" @click="post">
                Post
              </v-btn>
              <span class="picture">
                <v-file-input
                  accept="image/*"
                  label="File input"
                  v-model="picture"
                ></v-file-input>
              </span>
            </form>
          </section>
        </v-col>
        <v-col>
          <h3>Micropost Feed</h3>
          <Feed :user="currentUser" :pages="pages" />
        </v-col>
      </v-row>
    </div>
    <div v-else>
      <h1>Sample App</h1>
      <p>
        This is the home page for the
        <a href="https://railstutorial.jp/">Ruby on Rails Tutorial</a>
        sample application.
      </p>
      <a href="/signup">
        <v-btn large color="primary">Sign up now!</v-btn>
      </a>
      <a href="http://rubyonrails.org/">
        <img src="~/assets/rails.png" alt="Rails logo" />
      </a>
    </div>
    <!--<img src="~/assets/kitten.jpg" alt="Kitten"/>-->
  </div>
</template>

<script>
import { mapGetters } from "vuex";
import UserInfo from "@/components/shared/UserInfo";
import Stats from "@/components/shared/Stats";
import Feed from "@/components/shared/Feed";
import Errors from "@/components/shared/ErrorMessages";

export default {
  components: {
    UserInfo,
    Feed,
    Errors,
    Stats
  },
  head() {
    return {
      title: "Home"
    };
  },
  data() {
    return {
      pages: 1,
      feedItemsLength: 0,
      content: "",
      picture: null
    };
  },
  asyncData() {
    return {
      errors: []
    };
  },
  methods: {
    async getFeedItems() {
      return await this.$axios.$get("/api/v1/static_pages/home");
    },
    async post() {
      const formData = new FormData();
      formData.append("micropost[picture]", this.picture);
      formData.append("micropost[content]", this.content);
      const endpoint = "api/v1/microposts";
      try {
        const res = await this.$axios.$post(endpoint, formData);
        if (res.micropost) {
          this.$toast.success("Micropost created!");
          location.replace("/home");
        }
      } catch (e) {
        this.errors = [];
        if (e.response) {
          this.errors.push(...e.response.data.messages);
        }
      }
    }
  },
  computed: {
    ...mapGetters({
      user: "users/user",
      currentUser: "auth/currentUser"
    })
  },
  async fetch() {
    const response = await this.getFeedItems(this.page);
    this.feedItemsLength = response.total_feeds;
    this.pages = response.pages;
  }
};
</script>

<style></style>
