<template>
  <v-container class="d-flex align-center flex-column text-center mt-10 pb-10">
    <h1 class="text-h3 mb-2">Pomagacze</h1>
    <h2 class="text-h6">Aplikacja Pomagacze zachęca do pomagania, bycia wolontariuszem <br>i zmieniania swojego otoczenia
      na lepsze.</h2>
    <v-btn class="mt-4" color="primary" rounded="xl" size="x-large" to="/install">POBIERZ
      <v-icon class="ml-2">mdi-download</v-icon>
    </v-btn>

    <v-carousel v-model="index" hide-delimiter-background style="width: 410px; height: 630px" class="my-7" continuous cycle interval="4000">
      <v-carousel-item
          v-for="(url, i) in Array.from({length: 8}).map((x, i) => `screenshots/screenshot${i+1}.png`)"
          :key="url"
      >
        <img :src="url" height="590" />
      </v-carousel-item>
    </v-carousel>

    <h2 class="mt-15 mb-8">Do czego służy aplikacja?</h2>

    <div class="text-left mb-10 w-66">
      <h3>Poszukiwanie wolontariuszy</h3>
      <ul>
        <li>dodawanie akcji społecznych</li>
        <li>przygotowywanie ogłoszenia wraz z opisem akcji oraz wymagań wiekowych wolontariuszy</li>
        <li>zbieranie chętnych do akcji – zbieranie zapisów wolontariuszy</li>
        <li>promocja akcji – wysyłka powiadomień do znajomych możliwość udostępnienia wydarzenia w innych serwisach społecznościowych
          typu Facebook
        </li>
        <li>potwierdzanie udziału w akcji przez poszczególnych wolontariuszy (dzięki zastosowaniu
          technologii NFC oraz Nearby Connections)
        </li>
      </ul>
      <h3 class="mt-3">Uczestnictwo w wydarzeniach</h3>
      <ul>
        <li>wyszukiwanie akcji społecznych według lokalizacji oraz rodzaju wydarzenia</li>
        <li>informacja o znajomych, którzy również dołączyli do tych akcji</li>
        <li>aktualności na temat wydarzeń</li>
        <li>otrzymywanie punktów za udział</li>
        <li>sprawdzanie rankingów najlepszych wolontariuszy</li>
      </ul>
    </div>
  </v-container>
</template>

<script setup lang="ts">
import { ref } from 'vue';

const index = ref(0);
</script>

<style scoped>
</style>