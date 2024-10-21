# Hacker News Stories: Explore as últimas notícias da Hacker News

**Uma aplicação Vue.js e Rails para explorar as últimas notícias da Hacker News**

Este projeto permite que você navegue pelas notícias mais populares da Hacker News de forma rápida e eficiente. Você pode explorar os detalhes de cada notícia, ler os comentários e filtrar as notícias por um termo específico. Além disso existe uma conexão de WebSocket para trazer as notícias mais recentes.

## Tecnologias
* **Frontend:** Vue.js
* **Backend:** Rails e Redis
* **API:** Hacker News API
* **Deployment:** Docker e Docker Compose

## Funcionalidades
* Visualização de notícias e comentários
* Busca por termos específicos
* Cache
* Paralelismo
* WebSockets
* **[Adicione outras funcionalidades aqui]**

## Instalação
1. **Clone o repositório:**
   ```bash
   git clone https://github.com/jonathanqueiroz/hacker_news_stories
   cd hacker_news_stories

2. **Rode o projeto Docker:**
   ```bash
   docker-compose up --build
