<template>
<div>
  <Errors :errors="errors"/>
  <h1>Log in</h1>
  <v-row>
      <v-col>
          <form @submit.prevent="login">
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

              <v-btn
              class="mr-4"
              @click="login"
              >
              Log in
              </v-btn>
              <v-btn @click="clear">
              clear
              </v-btn>
          </form>
      </v-col>
  </v-row>
  <p>New user? <a href="/users/new">Sign up now!</a></p>
</div>
</template>

<script>
  import Errors from '@/components/shared/ErrorMessages'
  import { validationMixin } from 'vuelidate'
  import { required, email } from 'vuelidate/lib/validators'


  export default {
    mixins: [validationMixin],
    validations: {
      email: { required, email },
      password: { required },
    },
    components: {
      Errors
    },
    asyncData() {
      return {
        errors: [],
      }
    },
    data () {
      return {
        rules: {
          required: value => !!value || 'Required.',
          min: v => v.length >= 6 || 'Min 6 characters',
        },
        email: '',
        password: '',
        showPassword: false,
        idSaving: true
      }
    },
    computed: {
      emailErrors () {
        const errors = []
        if (!this.$v.email.$dirty) return errors
        !this.$v.email.email && errors.push('Must be valid e-mail')
        !this.$v.email.required && errors.push('E-mail is required')
        return errors
      },
      passwordErrors () {
        const errors = []
        if (!this.$v.password.$dirty) return errors
        !this.$v.password.password && errors.push('Must be valid password')
        !this.$v.password.required && errors.push('Password is required')
        return errors
      },
    },
    methods: {
      clear () {
        this.$v.$reset()
        this.email = ''
        this.password = ''
      },
      getSignInIds() {
        this.email = localStorage.email
      },
      setSignInIds() {
        if (this.idSaving) {
          localStorage.setItem('email', this.email)
        }
      },
      clearStrageId() {
        if (!this.idSaving) {
          localStorage.removeItem('email')
        }
      },
      async login() {
        this.setSignInIds()
        try {
            const params = {
                email: this.email,
                password: this.password,
            }
          const res = await this.$store.dispatch('auth/signIn', { ...params })
          // this.$router.push('/dashboard/')だとlayout/default.vueのmethodsが実行されず
          // sign_inボタンがsign in後のページでも残るのでlocation.replaceを使っています
          location.replace(`/users/${res.user.id}/show`)
        } catch (e) {
          this.errors = []
          if (e.response && e.response.status === 401) {
            this.errors.push(...e.response.data.messages)
          }
        }
      }
    },
    head() {
        return {
            title: 'Log in'
        }
    },
    mounted() {
      this.getSignInIds()
    },
  }
</script>