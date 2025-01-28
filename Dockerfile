FROM node:23-alpine3.20 AS builder
WORKDIR /user/build
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

FROM node:23-alpine3.20 AS runner
WORKDIR /app
COPY --from=builder /user/build/node_modules ./
COPY --from=builder /user/build/package*.json ./
COPY --from=builder /user/build/src ./src
CMD [ "npm" , "start" ]