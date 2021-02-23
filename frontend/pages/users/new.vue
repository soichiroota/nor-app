<template>
<div>
  <Errors :errors="errors"/>
  <h1>Sign up</h1>
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
              hint="At least 8 characters"
              @click:append="showPasswordConfirmation = !showPasswordConfirmation"
              ></v-text-field>

              <v-btn
              class="mr-4"
              @click="submit"
              >
              Create my account
              </v-btn>
              <v-btn @click="clear">
              clear
              </v-btn>
          </form>
      </v-col>
  </v-row>
</div>
</template>

<script>
  import { mapGetters } from 'vuex'
  import Errors from '@/components/shared/ErrorMessages'
  import { validationMixin } from 'vuelidate'
  import { required, maxLength, email } from 'vuelidate/lib/validators'


  export default {
    mixins: [validationMixin],
    validations: {
      name: { required, maxLength: maxLength(50) },
      email: { required, email },
      password: { required },
      passwordConfirmation: { required },
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
          min: v => v.length >= 8 || 'Min 8 characters',
        },
        name: '',
        email: '',
        password: '',
        passwordConfirmation: '',
        showPassword: false,
        showPasswordConfirmation: false,
      }
    },
    computed: {
      ...mapGetters({
      }),
      nameErrors () {
        const errors = []
        if (!this.$v.name.$dirty) return errors
        !this.$v.name.maxLength && errors.push('Name must be at most 10 characters long')
        !this.$v.name.required && errors.push('Name is required.')
        return errors
      },
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
      passwordConfirmationErrors () {
        const errors = []
        if (!this.$v.passwordConfirmation.$dirty) return errors
        !this.$v.passwordConfirmation.passwordConfirmation && errors.push('Must be valid password confirmation')
        !this.$v.Confirmation.required && errors.push('Password confirmation is required')
        return errors
      },
    },
    methods: {
      async submit() {
        this.$v.$touch()
        const params = {
          user: {
            name: this.name,
            email: this.email,
            password: this.password,
            password_confirmation: this.passwordConfirmation
          }
        }
        await this.createUser(params)
      },
      clear () {
        this.$v.$reset()
        this.name = ''
        this.email = ''
        this.password = ''
        this.passwordConfirmation = ''
      },
      async createUser(params) {
        const endpoint = '/api/v1/signup'
        const res = await this.$axios.$post(endpoint, params)

        if (res.errors) {
          this.errors = res.errors
        } else {
          this.$router.push(`/users/${res.id}/show`)
          this.$toast.success('Welcome to the Sample App!')
        }
      }
    },
    head() {
        return {
            title: 'Sign up'
        }
    }
  }
</script>
