<template>
  <v-container class="d-flex align-center flex-column text-center mt-10 pb-16">
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
          eager
      >
        <img :src="url" height="590" />
      </v-carousel-item>
    </v-carousel>

    <h2 class="mt-15 mb-8">Do czego służy aplikacja?</h2>

    <div class="text-left mb-10" style="width: 800px; max-width: 90vw;">
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

    <h2 class="mt-15 mb-8">Wygodny sposób potwierdzania uczestnictwa</h2>

    <div style="width: 700px; max-width: 90vw;" class="mb-8">
      <div style="padding:56.25% 0 0 0;position:relative;">
        <iframe class="rounded-lg" src="https://player.vimeo.com/video/762995817?h=79c66b2416&amp;badge=0&amp;autopause=0&amp;player_id=0&amp;app_id=58479" frameborder="0" allow="autoplay; fullscreen; picture-in-picture" allowfullscreen style="position:absolute;top:0;left:0;width:100%;height:100%;" title="Decorporation"></iframe>
      </div>
      <div style="padding:56.25% 0 0 0;position:relative;" class="mt-5">
        <iframe class="rounded-lg" src="https://player.vimeo.com/video/762995817?h=79c66b2416&amp;badge=0&amp;autopause=0&amp;player_id=0&amp;app_id=58479" frameborder="0" allow="autoplay; fullscreen; picture-in-picture" allowfullscreen style="position:absolute;top:0;left:0;width:100%;height:100%;" title="Decorporation"></iframe>
      </div>
    </div>
    <component :is='"script"' src="https://player.vimeo.com/api/player.js"></component>
  </v-container>
</template>

<script setup lang="ts">
import { ref } from 'vue';

const index = ref(0);
</script>

<style scoped>
ul {
  margin-left: 30px;
}
</style>