FROM node:16 as builder
WORKDIR /workspace
RUN git clone --branch v3.3.0 https://github.com/janoside/btc-rpc-explorer.git .
RUN npm install

FROM node:16-alpine
WORKDIR /workspace
COPY --from=builder /workspace .
RUN apk --update add git
CMD npm start
EXPOSE 3002