<template>
  <v-container>
    <div>
      <h1>
        Update your profile
        <img :src="gravatarUrl" :alt="user.name" class="gravatar"/>
        {{ user.name }}
      </h1>
<v-row>
      <v-col>
          <form @submit.prevent="submit">
              <v-text-field
              v-model="name"
              :counter="4"
              label="Name"
              required
              @input="$v.name.$touch()"
              @blur="$v.name.$touch()"
              ></v-text-field>
              <v-text-field
              v-model="email"
              label="E-mail"
              required
              @input="$v.email.$touch()"
              @blur="$v.email.$touch()"
              ></v-text-field>
              <v-text-field
              v-model="password"
              :counter="6"
              label="Password"
              required
              @input="$v.password.$touch()"
              @blur="$v.password.$touch()"
              :append-icon="showPassword ? 'mdi-eye' : 'mdi-eye-off'"
              :rules="[rules.required, rules.min]"
              :type="showPassword ? 'text' : 'password'"
              name="input-password"
              hint="At least 6 characters"
              @click:append="showPassword = !showPassword"
              ></v-text-field>
              <v-text-field
              v-model="passwordConfirmation"
              :counter="6"
              label="Password Confirmation"
              required
              @input="$v.passwordConfirmation.$touch()"
              @blur="$v.passwordConfirmation.$touch()"
              :append-icon="showPasswordConfirmation ? 'mdi-eye' : 'mdi-eye-off'"
              :rules="[rules.required, rules.min]"
              :type="showPasswordConfirmation ? 'text' : 'password'"
              name="input-password-confirmation"
              hint="At least 6 characters"
              @click:append="showPasswordConfirmation = !showPasswordConfirmation"
              ></v-text-field>

              <v-btn
              class="mr-4"
              @click="submit"
              >
              Save changes
              </v-btn>
              <v-btn @click="clear">
              clear
              </v-btn>
          </form>
      </v-col>
  </v-row>

    <div class="gravatar_edit">
      <img :src="gravatarUrl" :alt="user.name" class="gravatar"/>
      <a href="http://gravatar.com/emails" target="_blank">change</a>
    </div>
  </div>
  </v-container>
</template>

<script>
import { mapGetters } from 'vuex'

export default {
  data() {
    return {
      gravatarUrlSize: 80,
    }
  },
  methods: {
    gravatarUrl: function () {
      if (this.user.email) {
        const crypto = require('crypto')
        const gravatarId = crypto.createHash('md5').update(this.user.email.toLowerCase()).digest('hex')
        return `https://secure.gravatar.com/avatar/${gravatarId}?s=${this.gravatarUrlSize}`
      } else {
        ''
      }
    }
  },
  head() {
    return {
      title: "Edit user"
    }
  },
  computed: {
    ...mapGetters({
      user: 'users/user',
      currentUser: 'auth/currentUser'
    }),
  },
  async fetch() {
    await this.$store.dispatch('users/fetchUser', this.$route.params.id)
  },
  mounted() {
  },
}
</script>

<style>
</style>