# Dockerfile
FROM node:14.13.1-alpine3.12 as build-stage

WORKDIR /app

# Install dependencies
COPY package.json ./
COPY yarn.lock ./
RUN yarn

# Build with env.production
COPY . .
RUN yarn build

# Production stage
FROM nginx:1.19.0-alpine as production-stage
COPY --from=build-stage /app/dist /app/app-a
COPY nginx.conf /etc/nginx/nginx.conf
EXPOSE 80
ENTRYPOINT ["nginx", "-g", "daemon off;"]