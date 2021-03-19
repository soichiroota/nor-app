<template>
  <v-main>
    <v-container>
      <div>
        <h1 class="title">
          NoR-app
        </h1>
        <h2 class="subtitle">
          {{ subTitle }}
        </h2>
        <button @click="getSomething">
          タスク取得
        </button>
        <ul v-for="task in tasks"
:key="task.id">
          <li style="text-align: left;">
            {{ task.title }}
          </li>
        </ul>
      </div>
    </v-container>
  </v-main>
</template>

<script>
export default {
  data() {
    return {
      subTitle: "Zenn is good service!!",
      tasks: []
    };
  },
  methods: {
    async getSomething() {
      const response = await this.$axios.$get("/api/v1/tasks");
      this.tasks = JSON.parse(response.tasks);
    }
  },
  head() {
    return {
      title: 'Ruby on Rails Tutorial Sample App',
      titleTemplate: ''
    }
  }
}
</script>
