<template>
  <div>
    <Errors :errors="errors" />
    <h1>Forgot password</h1>
    <v-row>
      <v-col>
        <form @submit.prevent="submit">
          <v-text-field
            v-model="email"
            label="E-mail"
            required
            @input="$v.email.$touch()"
            @blur="$v.email.$touch()"
          />

          <v-btn class="mr-4" @click="submit">
            Submit
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
import Errors from "@/components/shared/ErrorMessages";
import { validationMixin } from "vuelidate";
import { required, email } from "vuelidate/lib/validators";

export default {
  components: {
    Errors
  },
  mixins: [validationMixin],
  validations: {
    email: { required, email }
  },
  data() {
    return {
      rules: {
        required: value => !!value || "Required.",
        min: v => v.length >= 6 || "Min 6 characters"
      },
      email: ""
    };
  },
  computed: {
    emailErrors() {
      const errors = [];
      if (!this.$v.email.$dirty) return errors;
      !this.$v.email.email && errors.push("Must be valid e-mail");
      !this.$v.email.required && errors.push("E-mail is required");
      return errors;
    }
  },
  asyncData() {
    return {
      errors: []
    };
  },
  methods: {
    clear() {
      this.$v.$reset();
      this.email = "";
    },
    async submit() {
      const params = {
        mail: this.email,
        url: window.location.origin
      };
      try {
        const res = await this.$store.dispatch("auth/createPasswordReset", {
          ...params
        });
        if (res.user === null) {
          this.$toast.error("Email address not found");
        } else {
          this.$toast.info("Email sent with password reset instructions");
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
  head() {
    return {
      title: "Forgot password"
    };
  }
};
</script>
