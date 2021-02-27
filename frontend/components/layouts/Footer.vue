<template>
  <v-footer app color="primary lighten-1" padless>
    <v-row justify="center" no-gutters>
      <a href="/about">
        <v-btn color="white" text rounded class="my-2">
          About
        </v-btn>
      </a>

      <a href="/contact">
        <v-btn color="white" text rounded class="my-2">
          Contact
        </v-btn>
      </a>

      <a href="http://news.railstutorial.org/">
        <v-btn color="white" text rounded class="my-2">News </v-btn>
      </a>

      <v-col class="primary lighten-2 py-4 text-center white--text" cols="12">
        {{ new Date().getFullYear() }} —
        <strong>
          The <a href="https://railstutorial.jp/">Ruby on Rails Tutorial</a> by
          <a href="http://www.michaelhartl.com/">Michael Hartl</a>
        </strong>
      </v-col>
    </v-row>
  </v-footer>
</template>
