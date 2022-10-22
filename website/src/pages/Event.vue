<template>
  <v-container class="pt-8">
    <div v-if="loading" class="d-flex justify-center align-center" style="min-height: 90vh">
      <v-progress-circular indeterminate color="primary"/>
    </div>
    <div v-else-if="error">
      <h1>Błąd: {{ error?.message || error }}</h1>
    </div>
    <div v-else>
      <h1 class="mb-2">{{ event.title }}</h1>
      <div class="d-flex flex-row flex-wrap mb-4">
        <v-btn class="ma-1" color="primary" rounded="xl" :href="`com.pomagacze.pomagacze://event/${event.id}`"
        >Otwórz w aplikacji
          <v-icon class="ml-1">mdi-open-in-app</v-icon>
        </v-btn>
        <v-btn class="ma-1" color="primary" rounded="xl" to="/install">Pobierz aplikację
          <v-icon class="ml-1">mdi-download</v-icon>
        </v-btn>
      </div>
      <div class="d-flex flex-wrap mb-1">
        <v-chip class="ma-1">
          <v-icon class="mr-1">mdi-calendar</v-icon>
          {{
            new Date(event.date_start).toLocaleString([], {
              year: 'numeric',
              month: 'short',
              day: 'numeric',
              hour: '2-digit',
              minute: '2-digit'
            })
          }}
          <v-icon class="mx-1">mdi-arrow-right</v-icon>
          {{
            new Date(event.date_end).toLocaleString([], {
              year: 'numeric',
              month: 'short',
              day: 'numeric',
              hour: '2-digit',
              minute: '2-digit'
            })
          }}
        </v-chip>
        <v-chip class="ma-1">
          <v-icon class="mr-1 text-error">mdi-heart</v-icon>
          +{{ event.points }}
        </v-chip>
        <v-chip class="ma-1">
          <v-icon class="mr-1">mdi-account-multiple</v-icon>
          {{ event.volunteer_count }}/{{ event.maximal_number_of_volunteers }}
        </v-chip>
      </div>
      <v-chip class="ma-1">
        <v-icon class="mr-1">mdi-map-marker</v-icon>
        {{ event.address_full }}
      </v-chip>
      <div class="mt-8 mb-5 ml-1">
        {{ event.description }}
        <br><br>
        <b>Organizator:</b> {{ event.author.name }}
        <br>
        <b>Kontakt do organizatora:</b> {{ event.email || 'Brak' }}
      </div>
      <img v-if="event.image_url" :src="event.image_url" class="rounded-lg" height="400">
    </div>
  </v-container>
</template>

<script setup lang="ts">
import { supabase } from '../supabase.js';
import { onMounted, ref } from 'vue';
import { useRoute } from 'vue-router';

const event = ref(null);
const loading = ref(true);
const error = ref(null);

const route = useRoute();

onMounted(async () => {
  loading.value = true;
  const res = await supabase.from('events_extended').select('*, author:author_id(*), volunteers(*, profile:user_id(id, name))').eq('id', route.params.id).single();
  loading.value = false;
  if (res.error) {
    error.value = res.error;
    return;
  }
  event.value = res.data;
});
</script>

<style scoped lang="scss">

</style>