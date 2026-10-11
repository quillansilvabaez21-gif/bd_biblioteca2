CREATE DATABASE bd_biblioteca2;
USE bd_biblioteca2;

-- Tabla Editorial
CREATE TABLE Editorial (
    ID_editorial INT not null AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL,
    pais VARCHAR(50) NOT NULL,
    PRIMARY KEY (ID_editorial)
);


-- Tabla Bibliotecario
CREATE TABLE bibliotecario (
    ID_bibliotecario INT not null AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    DNI VARCHAR(50) NOT NULL,
    PRIMARY KEY (ID_bibliotecario)
);


-- Tabla Autor
CREATE TABLE autor (
    ID_autor INT not null AUTO_INCREMENT,
    nombre VARCHAR(50),
    apellido VARCHAR(50),
    nacionalidad VARCHAR(50),
    PRIMARY KEY (ID_autor)
);


-- Tabla Género
CREATE TABLE Genero (
    ID_genero INT not null AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL,
    PRIMARY KEY (ID_genero)
);


-- Tabla Socio
CREATE TABLE socio (
    ID_socio INT not null AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    telefono VARCHAR(50) NOT NULL,
    DNI VARCHAR(50) NOT NULL,
    PRIMARY KEY (ID_socio)
);


-- Tabla Libro
CREATE TABLE libro (
    ID_libro INT not null AUTO_INCREMENT,
    titulo VARCHAR(50) NOT NULL,
    año_pub VARCHAR(50) NOT NULL,
    FK_editorial INT NOT NULL,
    FK_genero INT NOT NULL,
    FOREIGN KEY (FK_editorial) REFERENCES Editorial(ID_editorial),
    FOREIGN KEY (FK_genero) REFERENCES Genero(ID_genero),
    PRIMARY KEY (ID_libro)
);


-- Tabla Ejemplar
CREATE TABLE ejemplar (
    ID_ejemplar INT not null AUTO_INCREMENT,
    estado VARCHAR(50),
    ubicacion VARCHAR(50),
    FK_libro INT NOT NULL,
    FOREIGN KEY (FK_libro) REFERENCES libro(ID_libro),
    PRIMARY KEY (ID_ejemplar)
);


-- Tabla Relacional Libro_autor (Clave compuesta, no lleva IDENTITY)
CREATE TABLE Libro_autor (
    FK_libro INT NOT NULL,
    FK_autor INT NOT NULL,
    PRIMARY KEY (FK_libro, FK_autor),
    FOREIGN KEY (FK_libro) REFERENCES libro(ID_libro),
    FOREIGN KEY (FK_autor) REFERENCES autor(ID_autor)
);


-- Tabla Préstamo
CREATE TABLE prestamo (
    ID_prestamo INT not null AUTO_INCREMENT,
    fecha_prestamo DATETIME NOT NULL,
    fecha_devolucion DATETIME NOT NULL,
    FK_socio INT NOT NULL,
    FK_ejemplar INT NOT NULL,
    FK_bibliotecario INT NOT NULL,
    FOREIGN KEY (FK_socio) REFERENCES socio(ID_socio),
    FOREIGN KEY (FK_ejemplar) REFERENCES ejemplar(ID_ejemplar),
    FOREIGN KEY (FK_bibliotecario) REFERENCES bibliotecario(ID_bibliotecario),
    PRIMARY KEY (ID_prestamo)
);

-- 1. Listado de socios: Mostrar el listado completo de todos los socios registrados en la biblioteca, ordenados alfabéticamente por apellido y nombre.
SELECT 
    ID_socio,
    apellido,
    nombre,
    telefono,
    DNI
FROM socio
ORDER BY apellido DESC, nombre DESC;

-- 2. Libros por editorial: Listar todos los libros publicados por una editorial específica (por ejemplo, "Editorial Planeta"), mostrando su título y año de publicación.
SELECT 
    l.titulo,
    l.año_pub,
    e.nombre AS editorial,
    e.pais AS pais_editorial
FROM libro l
INNER JOIN Editorial e ON l.FK_editorial = e.ID_editorial
WHERE e.nombre = 'Alfaguara'
ORDER BY l.titulo ASC;

-- 3. Ejemplares por estado: Listar todos los ejemplares de la biblioteca que se encuentren actualmente en un estado determinado (por ejemplo, buscar los que estén en estado "Dañado" o "En reparación").
SELECT 
    e.ID_ejemplar,
    e.estado,
    e.ubicacion,
    l.titulo AS libro
FROM ejemplar e
INNER JOIN libro l ON e.FK_libro = l.ID_libro
WHERE e.estado = 'Dañado';

-- 4. Libros por género y autor: Consultar los libros pertenecientes a un género literario específico (por ejemplo, "Ciencia Ficción"), mostrando el título del libro junto con el nombre y apellido de su autor.
SELECT 
    l.titulo,
    g.nombre AS genero,
    a.nombre AS nombre_autor,
    a.apellido AS apellido_autor
FROM libro l
INNER JOIN Genero g ON l.FK_genero = g.ID_genero
INNER JOIN Libro_autor la ON l.ID_libro = la.FK_libro
INNER JOIN autor a ON la.FK_autor = a.ID_autor
WHERE g.nombre = 'romance';


-- 5. Búsqueda por DNI de socio: Buscar y mostrar la información personal de un socio específico utilizando su número de DNI.
SELECT 
    ID_socio,
    nombre,
    apellido,
    telefono,
    DNI
FROM socio
WHERE DNI = '87654321';


-- 6. Préstamos activos (pendientes de devolución): Listar todos los préstamos que aún no han sido devueltos, mostrando el nombre del socio, el título del libro, el ejemplar y la fecha de devolución prevista.
SELECT 
    p.ID_prestamo,
    s.nombre + ' ' + s.apellido AS socio,
    l.titulo,
    e.ID_ejemplar,
    p.fecha_prestamo,
    p.fecha_devolucion
FROM prestamo p
INNER JOIN socio s ON p.FK_socio = s.ID_socio
INNER JOIN ejemplar e ON p.FK_ejemplar = e.ID_ejemplar
INNER JOIN libro l ON e.FK_libro = l.ID_libro
WHERE p.fecha_devolucion >= GETDATE()
ORDER BY p.fecha_devolucion ASC;

-- 7. Historial de préstamos por socio: Obtener el historial completo de préstamos realizados por un socio específico (buscado por su DNI o ID), detallando las fechas de préstamo y los títulos de los libros solicitados.
SELECT 
    p.ID_prestamo,
    l.titulo,
    e.ID_ejemplar,
    p.fecha_prestamo,
    p.fecha_devolucion,
    b.nombre + ' ' + b.apellido AS bibliotecario_responsable
FROM prestamo p
INNER JOIN socio s ON p.FK_socio = s.ID_socio
INNER JOIN ejemplar e ON p.FK_ejemplar = e.ID_ejemplar
INNER JOIN libro l ON e.FK_libro = l.ID_libro
INNER JOIN bibliotecario b ON p.FK_bibliotecario = b.ID_bibliotecario
WHERE s.DNI = '12345678'
ORDER BY p.fecha_prestamo DESC;

-- 8. Productividad de bibliotecarios: Listar a los bibliotecarios junto con la cantidad total de préstamos que han registrado en el sistema, ordenados de mayor a menor actividad.
SELECT 
    b.ID_bibliotecario,
    b.nombre + ' ' + b.apellido AS bibliotecario,
    COUNT(p.ID_prestamo) AS total_prestamos_realizados
FROM bibliotecario b
LEFT JOIN prestamo p ON b.ID_bibliotecario = p.FK_bibliotecario
GROUP BY b.ID_bibliotecario, b.nombre, b.apellido
ORDER BY total_prestamos_realizados DESC;

-- 9. Top 5 libros más prestados (Avanzada): Obtener el ranking de los 5 libros más solicitados de la biblioteca, mostrando el título del libro y la cantidad total de veces que ha sido prestado.
SELECT TOP 5
    l.ID_libro,
    l.titulo,
    COUNT(p.ID_prestamo) AS total_veces_prestado
FROM libro l
INNER JOIN ejemplar e ON l.ID_libro = e.FK_libro
INNER JOIN prestamo p ON e.ID_ejemplar = p.FK_ejemplar
GROUP BY l.ID_libro, l.titulo
ORDER BY total_veces_prestado DESC;

-- 10. Top 5 socios más activos (Avanzada): Identificar a los 5 socios que más préstamos de libros han realizado durante el último año, incluyendo el total acumulado de préstamos.
SELECT TOP 5
    s.ID_socio,
    s.nombre + ' ' + s.apellido AS socio,
    s.DNI,
    COUNT(p.ID_prestamo) AS total_prestamos
FROM socio s
INNER JOIN prestamo p ON s.ID_socio = p.FK_socio
WHERE p.fecha_prestamo >= DATEADD(year, -1, GETDATE())
GROUP BY s.ID_socio, s.nombre, s.apellido, s.DNI
ORDER BY total_prestamos DESC;

-- 1. Insertar editoriales
INSERT INTO Editorial (nombre, pais) VALUES ('Editorial Planeta', 'España');
INSERT INTO Editorial (nombre, pais) VALUES ('Alfaguara', 'Argentina');

-- 2. Insertar géneros
INSERT INTO Genero (nombre) VALUES ('Ciencia Ficción');
INSERT INTO Genero (nombre) VALUES ('romance');

-- 3. Insertar autores
INSERT INTO autor (nombre, apellido, nacionalidad) VALUES ('Isaac', 'Asimov', 'Estadounidense');
INSERT INTO autor (nombre, apellido, nacionalidad) VALUES ('Julio', 'Cortázar', 'Argentino');

-- 4. Insertar libros
INSERT INTO libro (titulo, año_pub, FK_editorial, FK_genero) VALUES ('Fundación', '1951', 1, 1);
INSERT INTO libro (titulo, año_pub, FK_editorial, FK_genero) VALUES ('Rayuela', '1963', 2, 2);

-- 5. Relacionar libros y autores
INSERT INTO Libro_autor (FK_libro, FK_autor) VALUES (1, 1);
INSERT INTO Libro_autor (FK_libro, FK_autor) VALUES (2, 2);

-- 6. Insertar bibliotecarios
INSERT INTO bibliotecario (nombre, apellido, DNI) VALUES ('Ana', 'Gómez', '33444555');
insert into bibliotecario (nombre, apellido, DNI) values ('Quillan','silva','48721512');

-- 7. Insertar socios
INSERT INTO socio (nombre, apellido, telefono, DNI) VALUES ('Carlos', 'Pérez', '3511234567', '12345678');
INSERT INTO socio (nombre, apellido, telefono, DNI) VALUES ('Lucía', 'Martínez', '3519876543', '87654321');

-- 8. Insertar ejemplares físicos
INSERT INTO ejemplar (estado, ubicacion, FK_libro) VALUES ('Disponible', 'Estante A-1', 1);
INSERT INTO ejemplar (estado, ubicacion, FK_libro) VALUES ('Dañado', 'Estante B-3', 2);

-- 9. Insertar un préstamo de prueba
INSERT INTO prestamo (fecha_prestamo, fecha_devolucion, FK_socio, FK_ejemplar, FK_bibliotecario) 
VALUES (GETDATE(), DATEADD(day, 7, GETDATE()), 1, 1, 1);