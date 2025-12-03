CREATE DATABASE Projeto_Individual;
USE Projeto_Individual;

CREATE TABLE usuario (
  idUsuario INT PRIMARY KEY AUTO_INCREMENT,
  nome VARCHAR(80) NOT NULL,
  email VARCHAR(120) NOT NULL UNIQUE,
  senha VARCHAR(255) NOT NULL
);

CREATE TABLE partida (
  idPartida INT PRIMARY KEY AUTO_INCREMENT,
  dtHora DATETIME DEFAULT CURRENT_TIMESTAMP,
  descricao VARCHAR(45)
);

CREATE TABLE resultado (
  idUsuarioPartida INT PRIMARY KEY AUTO_INCREMENT,
  fkUsuario INT NOT NULL,
  fkPartida INT NOT NULL,
  acertos INT NOT NULL DEFAULT 0,
  jogadas INT NOT NULL DEFAULT 0,
  tempo INT NOT NULL DEFAULT 0,
  dataRegistro DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (fkUsuario) REFERENCES usuario(idUsuario) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (fkPartida) REFERENCES partida(idPartida) ON DELETE CASCADE ON UPDATE CASCADE,
  UNIQUE KEY uq_usuario_partida (fkUsuario, fkPartida)
);

INSERT INTO usuario (nome, email, senha) VALUES
('Sabrina', 'sabrina@example.com', 'senha123'),
('Leandro', 'leandro@gmail.com', 'sabrinalinda123');

INSERT INTO partida (descricao) VALUES
('Jogo da Memoria - rodada A'),
('Jogo da Memoria - rodada B');

INSERT INTO resultado (fkUsuario, fkPartida, acertos, jogadas, tempo)
VALUES
(1, 1, 18, 30, 120),
(2, 1, 16, 28, 95),
(1, 2, 20, 36, 180);

SELECT
  u.idUsuario,
  u.nome AS jogador,
  COUNT(r.fkPartida) AS total_partidas,
  SUM(r.acertos) AS total_acertos,
  SUM(r.jogadas) AS total_jogadas,
  ROUND( (SUM(r.acertos) / NULLIF(SUM(r.jogadas),0)) * 100, 1) AS taxa_acertos_percent,
  CONCAT( ROUND( (SUM(r.acertos) / NULLIF(SUM(r.jogadas),0)) * 100, 1), '%' ) AS taxa_texto,
  CASE
    WHEN SUM(r.acertos) / NULLIF(SUM(r.jogadas),0) >= 0.8 THEN 'Excelente'
    WHEN SUM(r.acertos) / NULLIF(SUM(r.jogadas),0) >= 0.5 THEN 'Bom'
    ELSE 'Precisa melhorar'
  END AS classificacao,
  CONCAT('Usuário ', u.nome, ' jogou ', COUNT(r.fkPartida), ' partidas e marcou ', COALESCE(SUM(r.acertos),0), ' acertos.') AS resumo
FROM usuario u
LEFT JOIN resultado r ON r.fkUsuario = u.idUsuario
GROUP BY u.idUsuario;

CREATE VIEW vw_dashboard_usuario AS
SELECT
  u.idUsuario,
  u.nome,
  COUNT(r.fkPartida) AS partidas,
  COALESCE(SUM(r.acertos),0) AS acertos_totais,
  COALESCE(SUM(r.jogadas),0) AS jogadas_totais,
  ROUND( (COALESCE(SUM(r.acertos),0) / NULLIF(COALESCE(SUM(r.jogadas),0),0)) * 100, 1) AS aproveitamento_percent,
  IF( (COALESCE(SUM(r.acertos),0) / NULLIF(COALESCE(SUM(r.jogadas),0),0)) >= 0.7, 'Acima da média', 'Abaixo da média') AS desempenho
FROM usuario u
LEFT JOIN resultado r ON r.fkUsuario = u.idUsuario
GROUP BY u.idUsuario;

SELECT * FROM vw_dashboard_usuario;