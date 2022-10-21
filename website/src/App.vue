<template>
  <v-app>
    <v-main>
      <v-app-bar>
        <v-app-bar-title>
          <router-link to="/" class="text-black text-decoration-none">Pomagacze</router-link>
        </v-app-bar-title>
        <v-spacer />
        <v-btn icon="mdi-github" href="https://github.com/ikcilrep/pomagacze"></v-btn>
      </v-app-bar>
      <router-view />
    </v-main>
    <v-footer class="d-flex justify-center py-5">
      Aplikacja zrobiona przez zespół "hhhhhhhhhhhhhhhh".
    </v-footer>
  </v-app>
</template>

<script>

</script>
