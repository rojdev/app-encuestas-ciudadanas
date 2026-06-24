# App Encuestas Ciudadanas

Frontend web interactivo para el sistema de recolección de información y encuestas ciudadanas de la Alcaldía. Desarrollado con **Vue 3** utilizando el framework **Quasar** (con Vite) y **Pinia** para la gestión de estados.

---

## 🛠️ Configuración y Despliegue con Docker Compose

El proyecto está dockerizado para facilitar su desarrollo y ejecución:

### 1. Requisitos Previos
*   Tener instalado [Docker](https://docs.docker.com/get-docker/) y [Docker Compose](https://docs.docker.com/compose/install/).

### 2. Levantar el Servidor de Desarrollo en Docker
Ejecuta el siguiente comando para compilar y arrancar la aplicación:
```bash
docker compose up -d
```
La aplicación web estará disponible de inmediato en: [http://localhost:9000](http://localhost:9000)

---

## 💻 Desarrollo Local

Si prefieres ejecutar el servidor Quasar directamente en tu máquina:

1.  Instalar dependencias:
    ```bash
    npm install
    ```
2.  Iniciar el servidor de desarrollo local:
    ```bash
    npm run dev
    ```
3.  Compilar la versión estática de producción:
    ```bash
    npm run build
    ```
