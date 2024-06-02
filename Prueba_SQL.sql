-- Active: 1717368519417@@127.0.0.1@5432@prueba_nicole_villarreal_1407
CREATE DATABASE prueba_nicole_villarreal_1407

-- 1 Crea el modelo (revisa bien cual es el tipo de relacion antes de crear), respeta las claves primarias , foraneas y tipos de datos.
CREATE TABLE peliculas (
id SERIAL PRIMARY KEY,
nombre VARCHAR(255),
anno INTEGER);

CREATE TABLE tags (
id SERIAL PRIMARY KEY,
tag VARCHAR(32));

CREATE TABLE peliculas_tags (
id SERIAL PRIMARY KEY,
id_pelicula INTEGER REFERENCES peliculas(id),
id_tag INTEGER REFERENCES tags(id));

--  2 Insertar 5 peliculas y 5 tags, la primera pelicula tiene que tener 3 tag asociados, la segunda pelicula debe tener dos tags asociados.
INSERT INTO peliculas (nombre, anno) VALUES
('Piratas del Caribe', 2003),
('Hotel Transilvania', 1984),
('Harry Potter', 2001),
('Mi Villano Favorito', 2010),
('Jurassic Park', 1993);

INSERT INTO tags (tag) VALUES
('Aventura'),
('Comedia'),
('Fantasía'),
('Comedia'),
('Aventura');

INSERT INTO peliculas_tags (id_pelicula, id_tag) VALUES
(1, 1),
(1, 2),
(1, 4),
(2, 1),
(2, 2);

select * from peliculas

select * from tags

select * from peliculas_tags

-- 3 Cuenta la cantidad de tags que tiene cada pelicula. Si una pelicula no tiene tags debe mostrar 0.
SELECT p.id, p.nombre, COUNT(t.id_tag) as cantidad_tags
FROM peliculas as p
LEFT JOIN peliculas_tags as t ON p.id = t.id_pelicula
GROUP BY p.id, p.nombre
ORDER BY cantidad_tags desc;

-- 4 Crea las tablas respetando los nombres, tipos, clave primarias, foraneas y tipos de datos.
CREATE TABLE preguntas (
id SERIAL PRIMARY KEY,
pregunta VARCHAR(255),
respuesta_correcta VARCHAR
);

CREATE TABLE usuarios (
id SERIAL PRIMARY KEY,
nombre VARCHAR(255),
edad INTEGER
);

CREATE TABLE respuestas (
id SERIAL PRIMARY KEY,
respuesta VARCHAR(255),
usuario_id INTEGER REFERENCES usuarios(id) ,
pregunta_id INTEGER REFERENCES preguntas(id));

-- 5 Agrega datos, 5  usuarios y 5 preguntas.
-- La primera pregunta debe estar contestada dos veces correctamente por distintos usuarios. 
-- La pregunta 3 debe estar contestada correctamente solo por un usuario. 
-- Las otras 2 respuestas deben estar incorrectas. 

INSERT INTO preguntas (id, pregunta, respuesta_correcta) VALUES
(1, '¿Cómo se llama el pirata principal?', 'Jack Sparrow'),
(2, '¿Cuál es el nombre de la hija del personaje principal?', 'Mavis Dracula'),
(3, '¿Cómo se llama el guardabosques?', 'Rubeus Hagrid'),
(4, '¿Cómo se llama el enemigo de Gru?', 'Vector'),
(5, '¿Cómo se llama el dueño del Jurassic Park?', 'John Hammond');

INSERT INTO usuarios (nombre, edad) VALUES
('Nicole', 28),
('Estela', 39),
('Gustavo', 41),
('Pia', 31),
('Cristopher', 34);

-- la primera pregunta debe estar contestada dos veces correctamente por distintos usuarios: 
INSERT INTO respuestas (respuesta, usuario_id, pregunta_id) VALUES
('Jack Sparrow', 1, 1),
('Jack Sparrow', 2, 1);
-- la pregunta 2 debe estar contestada dos veces correctamente por distintos usuarios: 
INSERT INTO respuestas (respuesta, usuario_id, pregunta_id) VALUES
 ('Mavis Dracula', 3, 2);

 -- las otras 2 respuestas deben estar incorrectas. 
 INSERT INTO respuestas (respuesta, usuario_id, pregunta_id) VALUES
('Rubeus Hagrid', 4, 3),
('Vector', 5, 4);

-- 6 Cuenta la cantidad de respuestas correctas totales por usuario (independeinte de la preguntas).
SELECT u.nombre, COUNT(r.respuesta) as respuestas_correctas
FROM usuarios as u
inner JOIN respuestas as r ON u.id = r.usuario_id
inner JOIN preguntas as p ON r.pregunta_id = p.id
WHERE r.respuesta=p.respuesta_correcta
GROUP BY u.nombre
ORDER BY respuestas_correctas DESC , u.nombre DESC;

-- 7 Por cada pregunta, es la tabla preguntas, cuanta cuantos usuarios tuvieron la respuesta correcta. 
SELECT p.id AS pregunta_id, p.pregunta, p.respuesta_correcta, COUNT(r.usuario_id) as usuarios_correctos
FROM preguntas AS p
LEFT JOIN respuestas AS r  ON p.id = r.pregunta_id
WHERE r.respuesta = p.respuesta_correcta
GROUP BY p.id, p.pregunta, p.respuesta_correcta;

-- 8 Implementa borrado en cascada de las respuestas al borrar un usario y borrar el primer usuario para probar la implementacion. 
ALTER TABLE respuestas
DROP CONSTRAINT IF EXISTS respuestas_usuario_id_fkey,
ADD CONSTRAINT respuestas_usuario_id_fkey FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE;

-- Eliminar al usuario 1
DELETE FROM usuarios WHERE id = 1;

 -- Busca si el id 1 se borro
 SELECT * FROM usuarios;
 SELECT * FROM respuestas;

 -- 9 Crea una restriccion que impida insertar usuarios menores de 18 años en la base de datos. 
 ALTER TABLE usuarios
DROP CONSTRAINT IF EXISTS ck_edad_minima,
ADD CONSTRAINT ck_edad_minima CHECK (edad >= 18);

-- Error de ingreso por edad
INSERT INTO usuarios (nombre, edad) VALUES
('Ignacio', 13);

-- 10 Altera la tabla existente de usuarios agregando el campo email con la restriccion de unico.
ALTER TABLE usuarios ADD COLUMN email VARCHAR(255);

ALTER TABLE  usuarios
DROP CONSTRAINT IF EXISTS unique_email,
ADD CONSTRAINT unique_email UNIQUE (email);

select * from usuarios;

-- Error de ingreso por email duplicado.
INSERT INTO usuarios (nombre, edad, email) VALUES
('Pedro', 25, 'andres@mail.com'),
('Angel', 21, 'andres@mail.com');

select * from usuarios;