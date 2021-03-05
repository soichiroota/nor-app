<template>
  <div>
    <Errors :errors="errors" />
    <h1>Reset password</h1>

    <v-row>
      <v-col>
        <form @submit.prevent="submit">
          <v-text-field
            v-model="password"
            :counter="6"
            label="Password"
            required
            :append-icon="showPassword ? 'mdi-eye' : 'mdi-eye-off'"
            :rules="[rules.required, rules.min]"
            :type="showPassword ? 'text' : 'password'"
            name="input-password"
            hint="At least 6 characters"
            @input="$v.password.$touch()"
            @blur="$v.password.$touch()"
            @click:append="showPassword = !showPassword"
          />
          <v-text-field
            v-model="passwordConfirmation"
            :counter="6"
            label="Password Confirmation"
            required
            :append-icon="showPasswordConfirmation ? 'mdi-eye' : 'mdi-eye-off'"
            :rules="[rules.required, rules.min]"
            :type="showPasswordConfirmation ? 'text' : 'password'"
            name="input-password-confirmation"
            hint="At least 6 characters"
            @input="$v.passwordConfirmation.$touch()"
            @blur="$v.passwordConfirmation.$touch()"
            @click:append="showPasswordConfirmation = !showPasswordConfirmation"
          />

          <v-btn class="mr-4" @click="submit">
            Update password
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
import { mapGetters } from "vuex";
import Errors from "@/components/shared/ErrorMessages";
import { validationMixin } from "vuelidate";
import { required } from "vuelidate/lib/validators";

export default {
  mixins: [validationMixin],
  validations: {
    password: { required },
    passwordConfirmation: { required }
  },
  components: {
    Errors
  },
  data() {
    return {
      rules: {
        required: value => !!value || "Required.",
        min: v => v.length >= 6 || "Min 6 characters"
      },
      password: "",
      passwordConfirmation: "",
      showPassword: false,
      showPasswordConfirmation: false
    };
  },
  asyncData() {
    return {
      errors: []
    };
  },
  computed: {
    ...mapGetters({}),
    passwordErrors() {
      const errors = [];
      if (!this.$v.password.$dirty) return errors;
      !this.$v.password.password && errors.push("Must be valid password");
      !this.$v.password.required && errors.push("Password is required");
      return errors;
    },
    passwordConfirmationErrors() {
      const errors = [];
      if (!this.$v.passwordConfirmation.$dirty) return errors;
      !this.$v.passwordConfirmation.passwordConfirmation &&
        errors.push("Must be valid password confirmation");
      !this.$v.Confirmation.required &&
        errors.push("Password confirmation is required");
      return errors;
    }
  },
  methods: {
    async submit() {
      this.$v.$touch();
      const params = {
        user: {
          password: this.password,
          password_confirmation: this.passwordConfirmation,
          email: this.$route.params.email
        }
      };
      await this.resetPassword(params);
    },
    clear() {
      this.$v.$reset();
      this.password = "";
      this.passwordConfirmation = "";
    },
    async resetPassword(params) {
      const endpoint = `/api/v1/password_resets/${this.$route.params.token}`;
      const res = await this.$axios.$put(endpoint, params);
      if (res.errors) {
        this.errors = res.errors;
        if (res.errors.include("Password reset has expired.")) {
          location.replace("/passwordResets/new");
        }
      } else {
        this.$cookies.set("token", res.token);
        const user = res.user;
        this.$store.commit("auth/setCurrentUser", { user });
        this.$toast.success("Password has been reset.");
        location.replace(`/users/${res.user.id}/show`);
      }
    }
  },
  head() {
    return {
      title: "Reset Password"
    };
  }
};
</script>
