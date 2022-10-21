<template>
  <v-app>
    <v-main style="min-height: 90vh">
      <v-app-bar>
        <router-link to="/" class="text-black text-decoration-none d-flex w-66 align-center ml-3">
          <v-img
              class="mx-3"
              src="/icon.png"
              max-height="35"
              max-width="35"
              contain
          ></v-img>
          <v-toolbar-title to="/">
            Pomagacze
          </v-toolbar-title>
        </router-link>
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
