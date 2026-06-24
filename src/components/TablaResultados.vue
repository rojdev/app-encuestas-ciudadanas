<template>
  <q-card class="datos-encuesta">
    <q-card-section>
      <div class="text-h6">Resultados de la Encuesta de Satisfacción</div>
    </q-card-section>

    <q-card-section class="q-pt-none">
      <div class="text-h6">Resultados de la Pregunta 1</div>
      <br />
      <ul class="resultados-lista">
        <li>
          <strong>Total de encuestados:</strong> {{ datosEncuesta.encuestados }}
        </li>
        <li>
          <strong>Promedio "Malo":</strong>
          {{ datosEncuesta.promediomalo1.toFixed(2) }}
        </li>
        <li>
          <strong>Promedio "Regular":</strong>
          {{ datosEncuesta.promedioregular1.toFixed(2) }}
        </li>
        <li>
          <strong>Promedio "Regular" + "Malo":</strong>
          {{ datosEncuesta.promedioregularmalo.toFixed(2) }}
        </li>
        <li>
          <strong>Promedio "Bueno":</strong>
          {{ datosEncuesta.promediobueno1.toFixed(2) }}
        </li>
        <li>
          <strong>Promedio "Excelente":</strong>
          {{ datosEncuesta.promedioexcelente1.toFixed(2) }}
        </li>
        <li>
          <strong>Promedio "Bueno" + "Excelente":</strong>
          {{ datosEncuesta.respuestabuenoexecente.toFixed(2) }}
        </li>
      </ul>
      <div class="text-h6">Resultados de la Pregunta 2</div>
      <br />
      <ul class="resultados-lista">
        <li>
          <strong>Promedio "Malo":</strong>
          {{ datosEncuesta.promediomalo2.toFixed(2) }}
        </li>
        <li>
          <strong>Promedio "Regular":</strong>
          {{ datosEncuesta.promedioregular2.toFixed(2) }}
        </li>
        <li>
          <strong>Promedio "Regular" + "Malo":</strong>
          {{ datosEncuesta.promedioregularmalo2.toFixed(2) }}
        </li>
        <li>
          <strong>Promedio "Bueno":</strong>
          {{ datosEncuesta.promediobueno2.toFixed(2) }}
        </li>
        <li>
          <strong>Promedio "Excelente":</strong>
          {{ datosEncuesta.promedioexcelente2.toFixed(2) }}
        </li>
        <li>
          <strong>Promedio "Bueno" + "Excelente":</strong>
          {{ datosEncuesta.respuestabuenoexecente2.toFixed(2) }}
        </li>
      </ul>
    </q-card-section>
  </q-card>
</template>

<script>
import { ref, onMounted } from "vue";
import axios from "axios";

export default {
  setup() {
    const datosEncuesta = ref({
      encuestados: 0,
      promediomalo1: 0,
      promedioregular1: 0,
      promedioregularmalo: 0,
      promediobueno1: 0,
      promedioexcelente1: 0,
      respuestabuenoexecente: 0,
      promediomalo2: 0,
      promedioregular2: 0,
      promedioregularmalo2: 0,
      promediobueno2: 0,
      promedioexcelente2: 0,
      respuestabuenoexecente2: 0,
    });

    onMounted(async () => {
      try {
        const response = await axios.get(
          "http://192.168.0.113:7012/encuesta/obtenerencuesta"
        );
        datosEncuesta.value = response.data;
      } catch (error) {
        console.error("Error al obtener los datos de la encuesta:", error);
      }
    });

    return {
      datosEncuesta,
    };
  },
};
</script>

<style scoped>
.datos-encuesta {
  width: 60%; /* Ajustamos el ancho de la tarjeta */
  margin: 20px auto;
}

.resultados-lista {
  list-style: none; /* Quitamos los puntos de la lista */
  padding: 0;
}

.resultados-lista li {
  margin-bottom: 10px; /* Espacio entre elementos de la lista */
}

.resultados-lista strong {
  font-weight: bold;
}
</style>
