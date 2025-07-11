---Criasção do Banco

-- Criação do banco de dados
CREATE DATABASE IF NOT EXISTS sistema_vendas;
USE sistema_vendas;

-- Tabela Categoria
CREATE TABLE IF NOT EXISTS Categoria (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL,
    Descricao TEXT,
    DataCriacao DATETIME DEFAULT CURRENT_TIMESTAMP,
    DataAtualizacao DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UsuarioAtualizacao INT,
    Ativo TINYINT(1) DEFAULT 1
);

-- Tabela FormaPagamento
CREATE TABLE IF NOT EXISTS FormaPagamento (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL,
    Descricao TEXT,
    DataCriacao DATETIME DEFAULT CURRENT_TIMESTAMP,
    DataAtualizacao DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UsuarioAtualizacao INT,
    Ativo TINYINT(1) DEFAULT 1
);

-- Tabela Produto
CREATE TABLE IF NOT EXISTS Produto (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL,
    Descricao TEXT,
    Preco DECIMAL(10,2) NOT NULL,
    CategoriaID INT,
    DataCriacao DATETIME DEFAULT CURRENT_TIMESTAMP,
    DataAtualizacao DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UsuarioAtualizacao INT,
    Ativo TINYINT(1) DEFAULT 1,
    INDEX idx_nome (Nome),
    CONSTRAINT fk_produto_categoria FOREIGN KEY (CategoriaID) REFERENCES Categoria(Id) ON DELETE SET NULL
);

-- Tabela Cliente
CREATE TABLE IF NOT EXISTS Cliente (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    Telefone VARCHAR(20),
    DataCriacao DATETIME DEFAULT CURRENT_TIMESTAMP,
    DataAtualizacao DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UsuarioAtualizacao INT,
    Ativo TINYINT(1) DEFAULT 1,
    INDEX idx_nome (Nome)
);

-- Tabela Pedido
CREATE TABLE IF NOT EXISTS Pedido (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    ClienteID INT,
    DataPedido DATETIME NOT NULL,
    FormaPagamentoId INT,
    Status VARCHAR(50) NOT NULL,
    DataCriacao DATETIME DEFAULT CURRENT_TIMESTAMP,
    DataAtualizacao DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UsuarioAtualizacao INT,
    Ativo TINYINT(1) DEFAULT 1,
    FOREIGN KEY (ClienteID) REFERENCES Cliente(Id),
    FOREIGN KEY (FormaPagamentoId) REFERENCES FormaPagamento(Id)
);

-- Tabela ItemPedido
CREATE TABLE IF NOT EXISTS ItemPedido (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    PedidoId INT NOT NULL,
    ProdutoId INT,
    Quantidade INT NOT NULL,
    PrecoUnitario DECIMAL(10,2) NOT NULL, -- Boa prática para guardar o preço no momento da compra
    DataCriacao DATETIME DEFAULT CURRENT_TIMESTAMP,
    DataAtualizacao DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UsuarioAtualizacao INT,
    FOREIGN KEY (ProdutoId) REFERENCES Produto(Id) ON DELETE SET NULL,
    -- A MUDANÇA PRINCIPAL ESTÁ AQUI: ON DELETE CASCADE
    FOREIGN KEY (PedidoId) REFERENCES Pedido(Id) ON DELETE CASCADE
);

-- Tabela GrupoUsuario
CREATE TABLE IF NOT EXISTS GrupoUsuario (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL,
    Descricao TEXT,
    DataCriacao DATETIME DEFAULT CURRENT_TIMESTAMP,
    DataAtualizacao DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UsuarioAtualizacao INT,
    Ativo TINYINT(1) DEFAULT 1
);

-- Tabela Permissao
CREATE TABLE IF NOT EXISTS Permissao (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL,
    Descricao TEXT,
    DataCriacao DATETIME DEFAULT CURRENT_TIMESTAMP,
    DataAtualizacao DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UsuarioAtualizacao INT,
    Ativo TINYINT(1) DEFAULT 1
);

-- Tabela PermissaoGrupo (Tabela de Ligação)
CREATE TABLE IF NOT EXISTS PermissaoGrupo (
    PermissaoID INT,
    GrupoUsuarioID INT,
    PRIMARY KEY (PermissaoID, GrupoUsuarioID),
    FOREIGN KEY (PermissaoID) REFERENCES Permissao(Id) ON DELETE CASCADE,
    FOREIGN KEY (GrupoUsuarioID) REFERENCES GrupoUsuario(Id) ON DELETE CASCADE
);

-- Tabela Usuario
CREATE TABLE IF NOT EXISTS Usuario (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    NomeUsuario VARCHAR(50) NOT NULL UNIQUE,
    Senha VARCHAR(255) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    GrupoUsuarioID INT,
    Ativo TINYINT(1) DEFAULT 1,
    Token VARCHAR(255) DEFAULT NULL,
    DataCriacao DATETIME DEFAULT CURRENT_TIMESTAMP,
    DataAtualizacao DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UsuarioAtualizacao INT,
    FOREIGN KEY (GrupoUsuarioID) REFERENCES GrupoUsuario(Id)
);

-- Criação do banco de dados
CREATE DATABASE IF NOT EXISTS sistema_vendas;
USE sistema_vendas;

-- Tabela categoria
CREATE TABLE IF NOT EXISTS categoria (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    data_criacao DATETIME DEFAULT CURRENT_TIMESTAMP,
    data_atualizacao DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    usuario_atualizacao INT,
    ativo TINYINT(1) DEFAULT 1
);

-- Tabela forma_pagamento
CREATE TABLE IF NOT EXISTS forma_pagamento (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    data_criacao DATETIME DEFAULT CURRENT_TIMESTAMP,
    data_atualizacao DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    usuario_atualizacao INT,
    ativo TINYINT(1) DEFAULT 1
);

-- Tabela produto
CREATE TABLE IF NOT EXISTS produto (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    preco DECIMAL(10,2) NOT NULL,
    categoria_id INT,
    data_criacao DATETIME DEFAULT CURRENT_TIMESTAMP,
    data_atualizacao DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    usuario_atualizacao INT,
    ativo TINYINT(1) DEFAULT 1,
    INDEX idx_nome (nome),
    CONSTRAINT fk_produto_categoria FOREIGN KEY (categoria_id) REFERENCES categoria(id) ON DELETE SET NULL
);

-- Tabela usuario (unifica clientes e administradores)
CREATE TABLE IF NOT EXISTS usuario (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome_completo VARCHAR(150) NOT NULL, -- Campo para o nome real do cliente/admin
    nome_usuario VARCHAR(50) NOT NULL UNIQUE, -- Campo para login
    senha VARCHAR(255) NOT NULL,
    email VARCHAR(100) UNIQUE,
    telefone VARCHAR(20),
    cpf VARCHAR(14) UNIQUE,
    is_admin TINYINT(1) DEFAULT 0, -- Simplificação do sistema de permissão
    ativo TINYINT(1) DEFAULT 1,
    token VARCHAR(255),
    data_criacao DATETIME DEFAULT CURRENT_TIMESTAMP,
    data_atualizacao DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    usuario_atualizacao INT
);

-- Tabela pedido
CREATE TABLE IF NOT EXISTS pedido (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT, -- Refere-se a um 'usuario'
    data_pedido DATETIME NOT NULL,
    forma_pagamento_id INT,
    status VARCHAR(50) NOT NULL, -- Ex: 'Pendente', 'Pago', 'Enviado', 'Cancelado'
    data_criacao DATETIME DEFAULT CURRENT_TIMESTAMP,
    data_atualizacao DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    usuario_atualizacao INT,
    ativo TINYINT(1) DEFAULT 1,
    FOREIGN KEY (cliente_id) REFERENCES usuario(id) ON DELETE SET NULL,
    FOREIGN KEY (forma_pagamento_id) REFERENCES forma_pagamento(id) ON DELETE SET NULL
);

-- Tabela item_pedido
CREATE TABLE IF NOT EXISTS item_pedido (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pedido_id INT NOT NULL,
    produto_id INT,
    quantidade INT NOT NULL,
    preco_unitario DECIMAL(10,2) NOT NULL,
    data_criacao DATETIME DEFAULT CURRENT_TIMESTAMP,
    data_atualizacao DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    usuario_atualizacao INT,
    FOREIGN KEY (produto_id) REFERENCES produto(id) ON DELETE SET NULL,
    FOREIGN KEY (pedido_id) REFERENCES pedido(id) ON DELETE CASCADE
);