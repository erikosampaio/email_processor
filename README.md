# Email Processor - Teste Técnico Ruby on Rails

Sistema de processamento de arquivos `.eml` (e-mails) desenvolvido em Ruby on Rails para extrair informações estruturadas e salvar em banco de dados.

## 🚀 Tecnologias Utilizadas

- **Ruby on Rails 8.0.3**
- **PostgreSQL** (banco de dados)
- **Redis + Sidekiq** (background jobs)
- **Docker + Docker Compose** (containerização)
- **RSpec** (testes unitários)
- **Bootstrap** (interface web)

## 📋 Funcionalidades

- Upload de arquivos `.eml` via interface web
- Processamento assíncrono com Sidekiq
- Extração automática de dados do cliente (nome, email, telefone, código do produto, assunto)
- Suporte a múltiplos formatos de email (Fornecedor A e Parceiro B)
- Logs persistentes de sucessos e falhas
- Interface web para visualização de resultados

## 🏗️ Arquitetura

O sistema implementa uma arquitetura limpa com 4 classes principais:

1. **Services::EmailProcessor** - Classe de processamento principal
2. **Parsers::BaseParser** - Classe base para parsers
3. **Parsers::SupplierAParser** - Parser para loja@fornecedorA.com
4. **Parsers::PartnerBParser** - Parser para contato@parceiroB.com

## 🐳 Como Rodar o Projeto (via Docker)

### Pré-requisitos

- Docker
- Docker Compose

### 1. Clone o repositório

```bash
git clone <url-do-repositorio>
cd email_processor
```

### 2. Configure o ambiente

```bash
# Copie o arquivo de exemplo (se necessário)
cp .env.example .env
```

### 3. Suba os serviços com Docker Compose

```bash
# Suba PostgreSQL e Redis
docker-compose up -d

# Aguarde os serviços estarem prontos
docker-compose ps
```

### 4. Configure o banco de dados

```bash
# Instale as dependências
bundle install

# Crie e configure o banco
rails db:create
rails db:migrate
```

### 5. Inicie os serviços

```bash
# Terminal 1: Rails server
rails server -p 3000 -b 0.0.0.0

# Terminal 2: Sidekiq worker
bundle exec sidekiq
```

### 6. Acesse a aplicação

- **Aplicação Rails**: `http://localhost:3000`
- **Sidekiq Web UI**: `http://localhost:3000/sidekiq` (para monitorar jobs em background)

## 🔧 Como Subir o Ambiente (Redis, Sidekiq, Rails)

### Opção 1: Com Docker Compose (Recomendado)

```bash
# Suba todos os serviços
docker-compose up -d

# Verifique se estão rodando
docker-compose ps
```

### Opção 2: Manual

```bash
# 1. Instale e inicie Redis
redis-server

# 2. Configure o banco de dados
rails db:create db:migrate

# 3. Inicie o Rails server
rails server

# 4. Em outro terminal, inicie o Sidekiq
bundle exec sidekiq
```

## 📧 Como Enviar um E-mail .eml para Processamento

### 1. Acesse a interface web

Navegue para `http://localhost:3000`

### 2. Faça upload do arquivo

1. Clique em "Escolher arquivo"
2. Selecione um arquivo `.eml` válido
3. Clique em "Enviar para Processamento"

### 3. Aguarde o processamento

O arquivo será processado em background pelo Sidekiq. Você verá uma mensagem de confirmação.

### 4. Formatos suportados

**Fornecedor A (loja@fornecedorA.com):**
```
Nome: João Silva
Email: joao@example.com
Telefone: (11) 99999-9999
Código do Produto: ABC123
Assunto: Pedido de orçamento
```

**Parceiro B (contato@parceiroB.com):**
```
Cliente: Ana Costa
Email: ana@example.com
Telefone: (21) 98765-4321
Produto: PROD-456
Assunto: Consulta de produto
```

## 📊 Como Visualizar os Resultados (Customers + Logs)

### 1. Visualizar Customers

- Acesse `http://localhost:3000/customers`
- Veja todos os clientes processados com sucesso
- Clique em "Ver Detalhes" para informações completas

### 2. Visualizar Logs

- Acesse `http://localhost:3000/email_logs`
- Veja estatísticas: Sucessos, Falhas, Total
- Clique em "Ver Detalhes" para logs específicos
- Filtre por status (sucesso/falha)

### 3. Estrutura dos Dados

**Customer (Cliente):**
- Nome
- Email
- Telefone
- Código do Produto
- Assunto
- Data de cadastro

**EmailLog (Log de Processamento):**
- Nome do arquivo
- Status (sucesso/falha)
- Dados extraídos (JSON)
- Mensagem de erro (se falha)
- Data de processamento

## 🧪 Executando os Testes

```bash
# Execute todos os testes
bundle exec rspec

# Execute com detalhes
bundle exec rspec --format documentation

# Execute testes específicos
bundle exec rspec spec/services/
```

## 📁 Estrutura do Projeto

```
app/
├── controllers/          # Controllers da aplicação
├── jobs/                # Background jobs (Sidekiq)
├── models/              # Models (Customer, EmailLog, EmailFile)
├── services/            # Lógica de negócio
│   ├── parsers/         # Parsers para diferentes formatos
│   └── email_processor.rb
└── views/               # Views da interface web

spec/                    # Testes RSpec
├── factories/           # Factories para testes
├── services/            # Testes dos services
└── models/              # Testes dos models

config/
├── database.yml         # Configuração do banco
├── initializers/        # Configurações (Sidekiq, etc.)
└── routes.rb            # Rotas da aplicação

docker-compose.yml       # Configuração Docker
```

## 🔍 Exemplos de Uso

### Arquivo .eml de Exemplo (Fornecedor A)

```eml
From: loja@fornecedorA.com
To: vendas@suaempresa.com
Subject: Pedido de orçamento

Nome: Maria Santos
Email: maria@example.com
Telefone: (11) 98765-4321
Código do Produto: XYZ789
Assunto: Solicitação de preço
```

### Arquivo .eml de Exemplo (Parceiro B)

```eml
From: contato@parceiroB.com
To: vendas@suaempresa.com
Subject: Consulta de produto

Cliente: Ana Costa
Email: ana@example.com
Telefone: (21) 98765-4321
Produto: PROD-456
Assunto: Dúvidas sobre produto
```

## 🛠️ Desenvolvimento

### Adicionando Novos Parsers

1. Crie uma nova classe em `app/services/parsers/`
2. Herde de `Parsers::BaseParser`
3. Implemente os métodos abstratos
4. Adicione o caso no `EmailProcessor#select_parser`

Exemplo:
```ruby
class Parsers::NewSupplierParser < BaseParser
  private

  def extract_name
    # Sua lógica aqui
  end

  # Implemente os outros métodos...
end
```

### Configurações

- **Banco de dados**: PostgreSQL na porta 5433
- **Redis**: Porta 6379
- **Rails**: Porta 3000
- **Sidekiq**: Processa jobs em background

## 📝 Logs e Monitoramento

- Logs de processamento salvos em `EmailLog`
- Logs do Rails em `log/development.log`
- Logs do Sidekiq no terminal
- Interface web para visualização de resultados

## 🚨 Solução de Problemas

### Erro de conexão com banco
```bash
# Verifique se o PostgreSQL está rodando
docker-compose ps

# Reinicie os serviços
docker-compose restart
```

### Erro de conexão com Redis
```bash
# Verifique se o Redis está rodando
redis-cli ping

# Deve retornar PONG
```

### Jobs não processando
```bash
# Verifique se o Sidekiq está rodando
ps aux | grep sidekiq

# Reinicie o Sidekiq
bundle exec sidekiq
```

## 📄 Licença

Este projeto foi desenvolvido como parte de um teste técnico.

---

**Desenvolvido com ❤️ em Ruby on Rails**
