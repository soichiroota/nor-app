<template>
    <v-app-bar
      fixed
      app
      color="primary"
      class="white--text"
    >
      <v-app-bar-nav-icon class="white--text"></v-app-bar-nav-icon>

      <v-toolbar-title>SAMPLE APP</v-toolbar-title>

      <v-spacer></v-spacer>
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

      <a href="#">
        <v-btn icon>
          <v-icon>mdi-login</v-icon>
        </v-btn>
      </a>

      <v-menu
        left
        bottom
      >
        <template v-slot:activator="{ on, attrs }">
          <v-btn
            icon
            v-bind="attrs"
            v-on="on"
          >
            <v-icon>mdi-dots-vertical</v-icon>
          </v-btn>
        </template>

        <v-list>
          <v-list-item
            v-for="n in 5"
            :key="n"
            @click="() => {}"
          >
            <v-list-item-title>Option {{ n }}</v-list-item-title>
          </v-list-item>
        </v-list>
      </v-menu>
    </v-app-bar>
</template>