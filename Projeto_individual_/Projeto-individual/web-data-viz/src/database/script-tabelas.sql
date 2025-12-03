CREATE DATABASE Projeto_Individual;
USE Projeto_Individual;

CREATE TABLE usuario (
  idUsuario INT PRIMARY KEY AUTO_INCREMENT,
  nome VARCHAR(80) NOT NULL,
  email VARCHAR(120) NOT NULL UNIQUE,
  senha VARCHAR(50) NOT NULL
);

CREATE TABLE partida (
  idPartida INT PRIMARY KEY AUTO_INCREMENT,
  tempo INT NOT NULL,
  dataPartida DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE resultado (
  fkUsuario INT,
  fkPartida INT,
  acertos INT NOT NULL,
  jogadas INT NOT NULL,

  PRIMARY KEY (fkUsuario, fkPartida),

  FOREIGN KEY (fkUsuario) REFERENCES usuario(idUsuario),
  FOREIGN KEY (fkPartida) REFERENCES partida(idPartida)
);

INSERT INTO usuario (nome, email, senha) VALUES
('Sabrina', 'sabrina@gmail.com', 'senha123'),
('Leandro', 'leandro@gmail.com', 'sabrinalinda123');

INSERT INTO partida (tempo) VALUES
(45), (60), (38), (79);

INSERT INTO resultado (fkUsuario, fkPartida, acertos, jogadas) VALUES
(1, 1, 18, 26),
(1, 2, 20, 30),
(2, 3, 22, 24),
(2, 4, 25, 33);

CREATE VIEW vw_estatisticas_usuario AS
SELECT 
    u.idUsuario,
    u.nome,
    
    COUNT(r.fkPartida) AS total_partidas,
    SUM(r.acertos) AS acertos_totais,
    SUM(r.jogadas) AS jogadas_totais,
    ROUND(AVG(p.tempo), 1) AS tempo_medio,
    
    ROUND((SUM(r.acertos) / SUM(r.jogadas)) * 100, 1) AS taxa_acerto
FROM usuario u
JOIN resultado r ON r.fkUsuario = u.idUsuario
JOIN partida p ON p.idPartida = r.fkPartida
GROUP BY u.idUsuario;