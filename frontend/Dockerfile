FROM node:14

# Definir diretório de trabalho
WORKDIR /app

# Copiar package.json e yarn.lock
COPY package.json yarn.lock ./

# Instalar dependências
RUN yarn install

# Copiar o restante do código
COPY . .

# Compilar a aplicação
RUN yarn build

# Expor a porta da aplicação
EXPOSE 8080

# Comando para iniciar o servidor
CMD ["yarn", "serve"]
