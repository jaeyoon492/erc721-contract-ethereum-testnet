FROM node:16-alpine

WORKDIR /usr/src/node

COPY package.json ./
COPY yarn.lock ./

RUN yarn

COPY . .

RUN npx hardhat compile

EXPOSE 8545

CMD ["npx", "hardhat", "node"]