<template>
  <img src="/images/encuestaslogo.png" alt="" class="logo">
  <div v-if="!encuestaIniciada">
    <div class="inicio-encuesta">
      <q-btn @click="iniciarEncuesta" label="Iniciar" class="iniciar-encuesta" />
      <p class="text-bienvenida">Presione <strong>INICIAR</strong> la encuesta para ayudarnos a recolectar datos sobre
        la aceptación y
        valoración de la gestión municipal.</p>
    </div>
  </div>
  <q-card class="Main-Form" v-else>

    <div>
      <div class="datos-encuestado" v-if="currentQuestion === 0">
        <br />
        <label for="sexo">Sexo:</label>
        <q-option-group id="sexo" class="respuesta-sexo" :options="[
          { label: 'M', value: 'Masculino' },
          { label: 'F', value: 'Femenino' },
        ]" v-model="sexo" type="radio" />
        <label for="edad" class="edad">Edad:</label>
        <input id="edad" class="respuesta-edad" filled v-model="edad" type="text" placeholder="Edad" />
      </div>
      <div v-for="(pregunta, index) in preguntas" :key="pregunta.id_pregunta">
        <div class="pregunta" v-if="currentQuestion === index + 1">
          <br />
          <p class="tit-pregunta">{{ pregunta.enunciado }}</p>
          <q-option-group class="respuesta"
            :options="Object.entries(JSON.parse(pregunta.cantidad_items)[0]).map(([value, label]) => ({ label, value: parseInt(value) }))"
            v-model="respuestas[pregunta.id_pregunta]" type="radio" />
        </div>
      </div>

      <div class="btn-controles">
        <q-btn @click="previousQuestion" :disabled="currentQuestion === 0" label="Anterior" color="primary"
          class="q-mr-sm" />
        <q-btn v-if="currentQuestion < preguntas.length" @click="nextQuestion" label="Siguiente" color="primary" />
        <q-btn v-if="currentQuestion === preguntas.length" push color="white" text-color="primary"
          label="Enviar Encuesta" @click="mostrarMensajeFinal" class="q-ml-sm" />
      </div>
    </div>
  </q-card>

  <div v-if="encuestaEnviada">
    <div class="mensaje-final">
      <p>Su encuesta ha sido enviada. ¡Gracias por participar!</p>
      <q-btn @click="salir" label="Salir" color="primary" class="q-mt-sm" />
    </div>
  </div>

  <footer class="footer"><strong>@2025 Sistema para recolección de información Ver 1.0</strong></footer>
</template>

<script>
import { ref, onMounted } from 'vue'
import axios from 'axios'

export default {
  setup() {
    const sexo = ref(null)
    const edad = ref(null)
    const preguntas = ref([])
    const respuestas = ref({})
    const currentQuestion = ref(0)
    const encuestaIniciada = ref(false)
    const encuestaEnviada = ref(false)

    onMounted(async () => {
      try {
        const response = await axios.get('http://192.168.0.113:7012/encuesta/obtenerpreguntas')
        preguntas.value = response.data
        preguntas.value.forEach(pregunta => {
          respuestas.value[pregunta.id_pregunta] = null
        })
      } catch (error) {
        console.error('Error al obtener las preguntas:', error)
      }
    })

    const iniciarEncuesta = () => {  // Función para iniciar la encuesta
      encuestaIniciada.value = true
    }

    const nextQuestion = () => {
      currentQuestion.value++
    }

    const previousQuestion = () => {
      currentQuestion.value--
    }

    const enviarEncuesta = async () => {
      try {
        const response = await axios.post('http://192.168.0.113:7012/encuesta/guardarEncuesta', {
          sexo: sexo.value,
          edad: edad.value,
          ...Object.keys(respuestas.value).reduce((acc, key) => {
            acc[`pregunta_${key}`] = respuestas.value[key]
            return acc
          }, {}),
        })
        window.location.reload()
      } catch (error) {
        console.error('Error al enviar la encuesta:', error)
      }
    }


    const mostrarMensajeFinal = async () => {
      try {
        const response = await axios.post('http://192.168.0.113:7012/encuesta/guardarEncuesta', {
          sexo: sexo.value,
          edad: edad.value,
          ...Object.keys(respuestas.value).reduce((acc, key) => {
            acc[`pregunta_${key}`] = respuestas.value[key]
            return acc
          }, {}),
        })
        encuestaEnviada.value = true // Mostrar mensaje final
      } catch (error) {
        console.error('Error al enviar la encuesta:', error)
      }
    }

    const salir = () => {
      window.location.href = '/' // Redirigir a la página principal
    }

    return {
      sexo,
      edad,
      preguntas,
      respuestas,
      currentQuestion,
      nextQuestion,
      previousQuestion,
      enviarEncuesta,
      iniciarEncuesta,
      encuestaIniciada,
      mostrarMensajeFinal,
      encuestaEnviada,
      salir,
    }
  },
}
</script>
<style>
.Main-Form {
  width: 80%;
  border-radius: 2rem;
}

.btn-enviar {
  width: 60%;
  margin: 1rem auto 0px auto;
}

.pregunta {
  margin: 1rem auto 0rem auto;
}

.sexo {
  margin-bottom: -1rem;
}

.respuesta {
  width: 60%;
  margin: 0px auto 0px auto;
}

.respuesta-sexo {
  width: 60%;
  display: flex;
  justify-content: center;
  padding-left: 9rem;
}

.respuesta-edad {
  background-color: #f0f0f0;
  border-color: white;
  border-radius: 0.5rem;
}

.tit-pregunta {
  font-weight: bold;
  text-align: center;
  font-size: 18px;
}

.datos-encuestado {
  text-align: center;
  margin-top: 20px;
  font-size: 24px;
}

.btn-controles {
  display: flex;
  justify-content: center;
  padding-bottom: 1rem;
  padding-top: 1rem;
}

.inicio-encuesta {
  display: flex;
  flex-direction: column;
  align-items: center;
  position: fixed;
  top: 50%;
}

.iniciar-encuesta {
  width: 200px;
  height: 35px;
  border-radius: 60px;
  font-size: 20px;
  color: black;
  background: rgb(27, 124, 182);
  background: linear-gradient(90deg, rgba(27, 124, 182, 1) 5%, rgba(0, 212, 255, 1) 100%);
  margin-bottom: 6rem;
}

.text-bienvenida {
  background-color: white;
  border: 2px solid #00d4ff;
  border-style: dotted;
  border-radius: 20px;
  max-width: 80%;
  margin: 0 auto 0 auto;
  padding: 0.5rem;
  font-size: 12px;
  text-align: justify;
}

.mensaje-final {
  position: fixed;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  text-align: center;
  background-color: white;
  padding: 20px;
  border-radius: 10px;
  box-shadow: 0 0 10px rgba(0, 0, 0, 0.2);
}

.logo {
  animation: fade-in 1s ease-in-out forwards;
  /* Ajusta la duración (1s) y la función de tiempo (ease-in-out) según prefieras */
  opacity: 0;
  /* Inicialmente invisible */
  transform: scale(0.5);
  /* Escala inicial (puedes ajustarla) */
}

.footer {
  position: fixed;
  bottom: 0;
  left: 0;
  width: 100%;
  padding: 10px;
  text-align: center;
  font-size: 12px;
}

@keyframes fade-in {
  from {
    opacity: 0;
    transform: scale(0.5);
  }

  to {
    opacity: 1;
    transform: scale(1);
  }
}

@media only screen and (max-width: 768px) {
  * {
    font-weight: bold;
  }

  .Main-Form {
    position: fixed;
    bottom: 10%;
    left: 0;
    width: 100%;
  }
}

@media only screen and (min-width: 768px) {
  .logo {
    max-height: 768px;
    position: fixed;
    top: 10%;
    left: 10%;
  }

  .btn-enviar {
    margin: 0px auto 0px auto;
  }

  .btn-enviar-btn {
    display: flex;
    margin: 15px auto 0px auto;
    align-items: flex-end;
  }

  .inicio-encuesta {
    position: fixed;
    right: 10%;
  }

  .Main-Form {
    width: 30%;
    position: fixed;
    top: 50%;
    left: 50%;
    transform: translate(30%, -30%);
  }
}
</style>
