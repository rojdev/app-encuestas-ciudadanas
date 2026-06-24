<template>
  <q-card :class="$q.dark.isActive ? 'bg-dark' : ''">
    <q-card-section class="text-h6">
      {{ titulo }}
    </q-card-section>
    <q-card-section>
      <ECharts
        ref="barchart"
        :option="options"
        autoresize
        style="height: 380px; width: 100%"
      />
      <div style="display: flex; flex-wrap: wrap; gap: 20px">
        <p v-for="item in chartData.nombres" :key="item">
          <span class="negrita">{{ item }}:</span>
          {{ chartData.totales[chartData.nombres.indexOf(item)] }}
        </p>
        <div v-if="id_pregunta < 6">
          <span class="negrita">Encuestados:</span>
          {{ totalEncuestados }}
          <span class="negrita">Promedio (Excelente + Bueno):</span>
          {{ calculateAverage(chartData.totales, 0, 1) }} %
          <span class="negrita">Promedio (Regular + Malo):</span>
          {{ calculateAverage(chartData.totales, 2, 3) }} %
        </div>
        <div v-if="id_pregunta == 7">
          <span class="negrita">Encuestados:</span>
          {{ totalEncuestados }}
          <span class="negrita">Porcentaje de "Si":</span>
          {{ calculateYesPercentage(chartData.totales) }} %
          <span class="negrita">Porcentaje de "No":</span>
          {{ calculateNoPercentage(chartData.totales) }} %
        </div>
      </div>
    </q-card-section>
  </q-card>
</template>

<script>
import * as echarts from "echarts/core";
import { CanvasRenderer } from "echarts/renderers";
import { BarChart } from "echarts/charts";
import {
  TitleComponent,
  TooltipComponent,
  GridComponent,
  LegendComponent,
} from "echarts/components";
import ECharts from "vue-echarts";
import { useQuasar } from "quasar";

echarts.use([
  TitleComponent,
  TooltipComponent,
  GridComponent,
  BarChart,
  CanvasRenderer,
  LegendComponent,
]);

export default {
  name: "BarChart",
  components: { ECharts },
  props: {
    chartData: {
      type: Object,
      required: true,
      default: () => ({ nombres: [], totales: [] }),
    },
    titulo: {
      type: String,
      required: true,
    },
    totalEncuestados: {
      type: Number,
      required: true,
    },
    id_pregunta: {
      type: Number,
      required: true,
    },
  },
  data() {
    return {
      $q: useQuasar(),
      options: {
        tooltip: {
          trigger: "axis",
          axisPointer: {
            type: "shadow",
          },
          formatter: (params) => `${params[0].axisValue}: ${params[0].value}`,
        },
        xAxis: {
          type: "category",
          data: [],
        },
        yAxis: {
          type: "value",
        },
        series: [
          {
            itemStyle: {
              color: (params) =>
                ["#FF5733", "#3498DB", "#2ECC71", "#F1C40F", "#9B59B6"][
                  params.dataIndex % 5
                ],
            },
            data: [],
            type: "bar",
          },
        ],
      },
    };
  },
  watch: {
    chartData: {
      handler(newChartData) {
        this.options.xAxis.data = newChartData.nombres;
        this.options.series[0].data = newChartData.totales;
      },
      deep: true,
    },
  },

  methods: {
    calculateAverage(totales, index1, index2) {
      if (
        !totales ||
        totales.length === 0 ||
        this.totalEncuestados === 0 ||
        index1 < 0 ||
        index2 < 0 ||
        index1 >= totales.length ||
        index2 >= totales.length
      ) {
        return "N/A"; // Handle cases with invalid data or indices
      }

      const value1 = totales[index1] || 0;
      const value2 = totales[index2] || 0;

      const sum = value1 + value2;
      const average = (sum / this.totalEncuestados) * 100;
      return average.toFixed(2);
    },
    calculateYesPercentage(totales) {
      if (!totales || totales.length < 2 || this.totalEncuestados === 0) {
        return "N/A"; // Handle cases with invalid data or indices
      }
      const yesCount = totales[0] || 0; // Assuming "Si" is at index 0
      const percentage = (yesCount / this.totalEncuestados) * 100;
      return percentage.toFixed(2);
    },

    calculateNoPercentage(totales) {
      if (!totales || totales.length < 2 || this.totalEncuestados === 0) {
        return "N/A"; // Handle cases with invalid data or indices
      }
      const noCount = totales[1] || 0; // Assuming "No" is at index 1
      const percentage = (noCount / this.totalEncuestados) * 100;
      return percentage.toFixed(2);
    },
    saveImage() {
      const linkSource = this.$refs.barchart.getDataURL();
      const downloadLink = document.createElement("a");
      document.body.appendChild(downloadLink);
      downloadLink.href = linkSource;
      downloadLink.target = "_self";
      downloadLink.download = "BarChart.png";
      downloadLink.click();
    },
  },
};
</script>

<style scoped></style>
