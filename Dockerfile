## Install dependencies only when needed
#FROM node:15-alpine AS deps
## Check https://github.com/nodejs/docker-node/tree/b4117f9333da4138b03a546ec926ef50a31506c3#nodealpine to understand why libc6-compat might be needed.
#RUN apk add --no-cache libc6-compat
#WORKDIR /app
#COPY package.json package-lock.json ./
#RUN npm ci
#
## Rebuild the source code only when needed
#FROM node:15-alpine AS builder
#WORKDIR /app
#COPY ./src/ ./src/
#COPY package.json tsconfig.json ./
#COPY --from=deps /app/node_modules ./node_modules
#RUN npm run build

FROM epaypool/chia-blockchain:latest

EXPOSE 55400

#RUN apt-get install -y nodejs

#COPY --from=builder /app/dist/ ./app/dist/
#COPY --from=builder /app/node_modules ./app/node_modules

ENV LOG_LEVEL=WARN
VOLUME /root/.chia

# epaypool testnet and mainnet ca certificates
ADD ./ca ./ca
ADD ./entrypoint.sh ./entrypoint.sh

ENTRYPOINT ["bash", "./entrypoint.sh"]
