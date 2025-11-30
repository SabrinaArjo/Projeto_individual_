CREATE DATABASE Projeto_Individual;

USE Projeto_Individual;

CREATE TABLE usuario (
  idUsuario INT PRIMARY KEY AUTO_INCREMENT,
  nome VARCHAR(80) NOT NULL,
  email VARCHAR(120) NOT NULL UNIQUE,
  senha VARCHAR(50) NOT NULL
);

CREATE TABLE personagem (
  idPersonagem INT PRIMARY KEY AUTO_INCREMENT,
  nome VARCHAR(80) NOT NULL,
  imagem VARCHAR(255)
);

CREATE TABLE usuario_personagem (
  fkUsuario INT,
  fkPersonagem INT,
  PRIMARY KEY (fkUsuario, fkPersonagem),
  FOREIGN KEY (fkUsuario) REFERENCES usuario(idUsuario),
  FOREIGN KEY (fkPersonagem) REFERENCES personagem(idPersonagem)
);

CREATE TABLE partida (
  idPartida INT PRIMARY KEY AUTO_INCREMENT,
  fkUsuario INT,
  acertos INT,
  jogadas INT,
  tempo INT,
  dataPartida DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (fkUsuario) REFERENCES usuario(idUsuario)
);

INSERT INTO usuario (nome, email, senha) values
('leandro', 'leandro@gmail.com', 'sabrinalinda123');

INSERT INTO personagem (nome, imagem) VALUES
('Tanjiro Kamado', 'tanjiro_kamado_card.jpeg'),
('Nezuko Kamado', 'nezuko.jpeg'),
('Zenitsu Agatsuma', 'ZENITSU.jpeg'),
('Inosuke Hashibira', 'Inosuke.jpeg'),
('Rengoku Kyojuro', 'rengoku.jpeg'),
('Shinobu Kocho', 'tomioka.jpg');

INSERT INTO partida (fkUsuario, acertos, erros) VALUES
(1, 20, 16),
(1, 25, 11),
(2, 18, 18),
(3, 30, 6),
(3, 27, 9);

SELECT 
    u.idUsuario,
    u.nome AS jogador,
    
    COUNT(p.idPartida) AS total_partidas,

    SUM(p.acertos) AS total_acertos,
    SUM(p.erros) AS total_erros,

    CONCAT(
        ROUND((SUM(p.acertos) / (SUM(p.acertos) + SUM(p.erros))) * 100, 1),
        '%'
    ) AS aproveitamento_geral,

    CASE
        WHEN (SUM(p.acertos) / (SUM(p.acertos) + SUM(p.erros))) >= 0.8
            THEN 'Excelente'
        WHEN (SUM(p.acertos) / (SUM(p.acertos) + SUM(p.erros))) >= 0.5
            THEN 'Bom'
        ELSE
            'Precisa melhorar'
    END AS classificacao,

    CONCAT('Jogador ', u.nome, ' jogou ', COUNT(p.idPartida), ' partidas.') AS mensagem
FROM usuario u
JOIN partida p ON p.fkUsuario = u.idUsuario
GROUP BY u.idUsuario;

CREATE VIEW vw_estatisticas_usuarios AS
SELECT 
    u.idUsuario,
    u.nome,
    COUNT(p.idPartida) AS partidas,
    SUM(p.acertos) AS acertos_totais,
    SUM(p.erros) AS erros_totais,
    ROUND((SUM(p.acertos) / (SUM(p.acertos) + SUM(p.erros))) * 100, 1) AS aproveitamento,
    
    IF(
        (SUM(p.acertos) / (SUM(p.acertos) + SUM(p.erros))) >= 0.7,
        'Acima da média',
        'Abaixo da média'
    ) AS desempenho
FROM usuario u
JOIN partida p ON p.fkUsuario = u.idUsuario
GROUP BY u.idUsuario;