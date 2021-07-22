<template>
  <v-container>
    <div>
      <h1>Sample App</h1>
      <p>
        This is the home page for the
        <a href="https://railstutorial.jp/">Ruby on Rails Tutorial</a>
        sample application.
      </p>
      <a href="/signup">
        <v-btn large color="primary">Sign up now!</v-btn>
      </a>
    </div>
    <a href="http://rubyonrails.org/">
      <img src="~/assets/rails.png" alt="Rails logo" />
    </a>
    <!--<img src="~/assets/kitten.jpg" alt="Kitten"/>-->
  </v-container>
</template>

<script>
export default {
  head() {
    return {
      title: "Home"
    };
  }
};
</script>

<style></style>
