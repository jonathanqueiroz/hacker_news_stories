# Dockerfile
FROM ruby:3.3.5

# Instala dependências do sistema
RUN apt-get update -qq && apt-get install -y nodejs

# Define o diretório de trabalho
WORKDIR /app

# Copia o Gemfile e Gemfile.lock para o diretório de trabalho
COPY Gemfile* /app/

# Instala as gems
RUN bundle install

# Copia o restante do código da aplicação
COPY . /app

# Exponha a porta que o Rails usará
EXPOSE 3000

# Comando para iniciar o servidor Rails
CMD ["rails", "server", "-b", "0.0.0.0"]
