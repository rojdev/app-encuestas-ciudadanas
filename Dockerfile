FROM node:20-slim

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

EXPOSE 9000

CMD ["npx", "quasar", "dev", "--host", "0.0.0.0"]
