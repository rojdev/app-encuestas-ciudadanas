<template>
  <q-layout view="lHh Lpr lFf" class="background-image">
    <q-header elevated>
      <q-toolbar>
        <q-btn flat dense round icon="menu" aria-label="Menu" @click="toggleLeftDrawer" />
        <q-toolbar-title>
          Sistema para recolección de información
        </q-toolbar-title>
      </q-toolbar>
    </q-header>

    <q-drawer v-model="leftDrawerOpen" side="left" show-if-above :width="250" :breakpoint="700">
      <q-scroll-area style="height: calc(100% - 150px); ">
        <q-list padding>
          <q-item clickable v-ripple :to="{ name: 'dashboard' }">
            <q-item-section avatar>
              <q-icon name="dashboard" />
            </q-item-section>
            <q-item-section>
              Ver Estadísticas
            </q-item-section>
          </q-item>
          <q-item clickable v-ripple :to="{ name: 'encuesta' }">
            <q-item-section avatar>
              <q-icon name="encuesta" />
            </q-item-section>
            <q-item-section>
              Ver Encuesta
            </q-item-section>
          </q-item>
          <!-- <q-item clickable v-ripple :to="{ name: 'dashboard' }">
            <q-item-section avatar>
              <q-icon name="dashboard" />
            </q-item-section>
            <q-item-section>
              Ver Estadísticas
            </q-item-section>
          </q-item>

          <q-item clickable v-ripple :to="{ name: 'consulta' }">
            <q-item-section avatar>
              <q-icon name="search" />
            </q-item-section>
            <q-item-section>
              Consultar Solicitud
            </q-item-section>
          </q-item>

          <q-item clickable v-ripple :to="{ name: 'listado' }">
            <q-item-section avatar>
              <q-icon name="list" />
            </q-item-section>
            <q-item-section>
              Listar Solicitudes
            </q-item-section>
          </q-item>

          <q-item clickable v-ripple :to="{ name: 'buscarcomunas' }">
            <q-item-section avatar>
              <q-icon name="location_city" />
            </q-item-section>
            <q-item-section>
              Reporte Comunas Atendidas
            </q-item-section>
          </q-item> -->

          <q-item clickable v-ripple @click="logout">
            <q-item-section avatar>
              <q-icon name="logout" />
            </q-item-section>
            <q-item-section>
              Cerrar Sesión
            </q-item-section>
          </q-item>
        </q-list>
      </q-scroll-area>
    </q-drawer>

    <q-page-container>
      <router-view />
    </q-page-container>
  </q-layout>
</template>

<script setup>
import { ref } from 'vue';
import { useRouter } from 'vue-router';

const router = useRouter();
const leftDrawerOpen = ref(false);

function logout() {
  localStorage.removeItem('token');
  router.push('/login');
}

function toggleLeftDrawer() {
  leftDrawerOpen.value = !leftDrawerOpen.value;
}
</script>

<style>
.background-image {
  background-image: url("/images/siamobile.jpg");
  background-size: cover;
  background-position: center;
  background-repeat: no-repeat;
}

.q-toolbar {
  background: rgb(27, 124, 182);
  background: linear-gradient(90deg, rgba(27, 124, 182, 1) 5%, rgba(0, 212, 255, 1) 100%);
}

@media (min-width: 768px) {
  .background-image {
    background-image: url("/images/siadesktop.jpg");
    background-size: fill;
    background-position: top;
  }
}
</style>
