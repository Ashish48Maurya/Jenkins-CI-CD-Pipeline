FROM node:23-alpine3.20 As builder
WORKDIR /build
COPY package*.json ./
RUN npm install
COPY . .

FROM node:23-alpine3.20 As runner
WORKDIR /app
COPY --from=builder /build/node_modules ./node_modules
COPY --from=builder /build/package*.json ./
COPY --from=builder /build/src ./src
RUN rm -rf /build
CMD [ "npm" , "start" ]