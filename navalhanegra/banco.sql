-- ============================================================
-- NAVALHA NEGRA - banco de dados (MySQL)
--
-- NÃO é obrigatório rodar este script: quando o servidor liga, o Spring
-- cria o banco barbearia_db e executa o schema.sql (CREATE TABLE IF NOT EXISTS),
-- e o usuário admin é criado automaticamente com a senha em BCrypt.
-- Se preferir criar tudo à mão no Workbench, rode este arquivo.
-- ============================================================
CREATE DATABASE IF NOT EXISTS barbearia_db;
USE barbearia_db;

-- Entidade 1: usuários do login (senha SEMPRE em hash BCrypt)
CREATE TABLE IF NOT EXISTS usuarios (
    id         INT AUTO_INCREMENT PRIMARY KEY,
    email      VARCHAR(150) NOT NULL UNIQUE,
    senha_hash VARCHAR(255) NOT NULL,
    perfil     VARCHAR(20)  NOT NULL DEFAULT 'CLIENTE'   -- ADMIN ou CLIENTE
) ENGINE=InnoDB;

-- Entidade 2: cadastros de clientes (6 campos obrigatórios + extras do desafio 3)
CREATE TABLE IF NOT EXISTS cadastros (
    id           INT AUTO_INCREMENT PRIMARY KEY,
    nome         VARCHAR(150) NOT NULL,
    email        VARCHAR(150) NULL,                      -- liga o cadastro ao login
    endereco     VARCHAR(200) NOT NULL,
    cep          VARCHAR(9)   NOT NULL,
    numero       VARCHAR(10)  NOT NULL,
    telefone     VARCHAR(20)  NOT NULL,
    observacao   TEXT,
    data_criacao DATETIME     NOT NULL,
    ativo        TINYINT(1)   NOT NULL DEFAULT 1
) ENGINE=InnoDB;

-- ============================================================
-- AUDITORIA (passo 6 do roteiro): mostre ao professor que a senha está criptografada
-- ============================================================
-- SELECT id, email, perfil, senha_hash FROM usuarios;
--   -> senha_hash aparece como $2a$10$.... (BCrypt) para TODOS (admin e clientes)
--
-- SELECT * FROM cadastros;
--
-- Ver cada cliente junto com o login dele:
-- SELECT c.id, c.nome, c.email, u.perfil, u.senha_hash
--   FROM cadastros c JOIN usuarios u ON u.email = c.email;
