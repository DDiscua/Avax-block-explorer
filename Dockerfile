# develop stage
FROM node:14.19-alpine3.14 as develop-stage

WORKDIR /app
COPY package*.json ./
COPY yarn.lock ./
RUN yarn install
COPY . .

# build stage
FROM develop-stage as build-stage
RUN yarn build
# production stage
FROM nginx:1.15.7-alpine as production-stage
COPY --from=build-stage /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
