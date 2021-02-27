<template>
  <v-app-bar fixed app color="primary" class="white--text">
    <v-app-bar-nav-icon class="white--text" />

    <v-toolbar-title>SAMPLE APP</v-toolbar-title>

    <v-spacer />
    <a href="/home">
      <v-btn icon>
        <v-icon>mdi-home</v-icon>
      </v-btn>
    </a>

    <a href="/help">
      <v-btn icon>
        <v-icon>mdi-help</v-icon>
      </v-btn>
    </a>

    <div v-if="currentUser">
      <a href="/users">
        <v-btn icon>
          <v-icon>mdi-account-group</v-icon>
        </v-btn>
      </a>
      <v-menu left bottom>
        <template v-slot:activator="{ on, attrs }">
          <v-btn icon v-bind="attrs" v-on="on">
            <v-icon>mdi-dots-vertical</v-icon>
          </v-btn>
        </template>

        <v-list>
          <v-list-item @click="clickProfile">
            <v-list-item-title>
              Profile
            </v-list-item-title>
          </v-list-item>
          <v-list-item @click="clickSettings">
            <v-list-item-title>
              Settings
            </v-list-item-title>
          </v-list-item>
          <v-divider />
          <v-list-item @click="logout">
            <v-list-item-title>
              Log out
            </v-list-item-title>
          </v-list-item>
        </v-list>
      </v-menu>
    </div>
    <div v-else>
      <a href="/sessions/new">
        <v-btn icon>
          <v-icon>mdi-login</v-icon>
        </v-btn>
      </a>
    </div>
  </v-app-bar>
</template>

<script>
import { mapGetters } from "vuex";
export default {
  computed: {
    ...mapGetters({
      currentUser: "auth/currentUser"
    }),
    hasCookiesToken: function() {
      return !!this.$cookies.get("token") && !!this.currentUser;
    }
  },
  methods: {
    clickProfile() {
      this.$router.push(`/users/${this.currentUser.id}/show`);
    },
    clickSettings() {
      this.$router.push(`/users/${this.currentUser.id}/edit`);
    },
    async logout() {
      try {
        this.$cookies.remove("token");
        // this.$router.push('/')だとlayout/default.vueのmethodsが実行されず
        // logoutボタンがsign inページでも残るのでlocation.replaceを使っています
        location.replace("/sessions/new");
      } catch (e) {
        console.log(e);
      }
    }
  }
};
</script>
