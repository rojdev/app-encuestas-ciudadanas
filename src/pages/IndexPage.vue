<template>
  <q-page class="">
    <div class="graficas">
      <div class="">
        <div class="grafica" v-for="pregunta in preguntas" :key="pregunta.id_pregunta">
          <BarChart :chart-data="chartData[pregunta.id_pregunta]" :titulo="pregunta.enunciado"
            :totalEncuestados="totalEncuestados" :id_pregunta="pregunta.id_pregunta" />
        </div>
      </div>
    </div>

    <q-inner-loading :showing="isLoading">
      <img class="loader" src="/public/images/loader.png" alt="Cargando..." width="200px" />
    </q-inner-loading>
  </q-page>
</template>

<script>
import { ref, onMounted } from "vue";
import axios from "axios";
import BarChart from "components/BarChart.vue";

export default {
  name: "IndexPage",
  components: {
    BarChart,
  },
  setup() {
    const isLoading = ref(true);
    const preguntas = ref([]);
    const chartData = ref({});
    const totalEncuestados = ref(null);

    const fetchPreguntas = async () => {
      try {
        const response = await axios.get(
          "http://192.168.0.113:7012/encuesta/obtenerpreguntas"
        );
        const totalEncuestadosResponse = await axios.get("http://192.168.0.113:7012/encuesta/allEncuestados");

        preguntas.value = response.data;
        totalEncuestados.value = totalEncuestadosResponse.data; // Directly assign the count
      } catch (error) {
        console.error("Error fetching data:", error);
        // Handle the error appropriately, e.g., display an error message to the user.
        isLoading.value = false; // Hide the loader even if there's an error.
      }
    };

    const fetchEstadisticas = async (id_pregunta) => {
      try {
        const response = await axios.get(
          "http://192.168.0.113:7012/encuesta/obtenerEstadisticas",
          {
            params: {
              id_pregunta: id_pregunta,
            },
          }
        );
        chartData.value[id_pregunta] = processChartData(response.data);
      } catch (error) {
        console.error(
          `Error fetching estadísticas for pregunta ${id_pregunta}:`,
          error
        );
      }
    };

    const processChartData = (data) => {
      // Ensure data is an array and has at least one element
      if (Array.isArray(data) && data.length > 0) {
        const nombres = Object.keys(data[0]);
        const totales = Object.values(data[0]);
        return { nombres, totales };
      } else {
        console.warn("Invalid data format for chart:", data);
        return { nombres: [], totales: [] };
      }
    };

    onMounted(async () => {
      isLoading.value = true;
      await fetchPreguntas();

      // Fetch estadísticas for each pregunta
      for (const pregunta of preguntas.value) {
        await fetchEstadisticas(pregunta.id_pregunta);
      }

      isLoading.value = false;
    });

    return {
      isLoading,
      preguntas,
      chartData,
      totalEncuestados,
    };
  },
};
</script>
<style lang="scss" scoped>
.loader {
  animation: rotate 1s linear infinite;
  /* Aplica la animación "rotate" */
  animation-duration: 2.4s;
  /* Establece la duración máxima de la animación */
  margin-top: -750px;
}

@keyframes rotate {
  0% {
    transform: translateY(-150px);
  }

  25% {
    transform: translateY(0px);
  }

  50% {
    transform: translateY(-15px);
  }

  75% {
    transform: translateY(0px);
  }

  100% {
    transform: translateY(-15px);
  }
}

.filtrado {
  display: flex;
  align-items: center;
  justify-content: right;
  margin-top: 10px;
  gap: 10px;
}

.filtrado button {
  margin-right: 5px;
}

.btn {
  padding: 10px;
  background-color: black;
  color: white;
  border-radius: 10px;
}

.background-image {
  background-image: url("/images/siamobile.jpg");
  background-size: cover;
  background-position: center;
  background-repeat: no-repeat;
}

.graficas {
  display: grid;
  gap: 20px;
}

.grafica {
  grid-area: 2 / 1 / span 2 / span 3;
  margin: 1rem auto 2.5rem auto;
  max-width: 80%;
}

@media (min-width: 768px) {
  .background-image {
    background-image: url("/images/siadesktop.jpg");
    background-size: fill;
    background-position: top;
  }
}
</style>
