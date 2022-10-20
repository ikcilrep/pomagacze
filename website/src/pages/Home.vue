<template>
  <v-container class="d-flex align-center flex-column text-center mt-8 pb-10">
    <h1 class="text-h3 mb-2">Pomagacze</h1>
    <h2 class="text-h6">Aplikacja Pomagacze zachęca do pomagania, bycia wolontariuszem,<br>zmieniania swojego otoczenia na lepsze</h2>
    <img :src="imgUrl" width="300"/>
    <v-btn class="mt-3" color="primary" rounded="xl" size="x-large" to="/install">POBIERZ
      <v-icon class="ml-2">mdi-download</v-icon>
    </v-btn>
  </v-container>
</template>

<script setup lang="ts">
import imgUrl from '../assets/screenshot.png';</script>

<style scoped lang="scss">

</style>