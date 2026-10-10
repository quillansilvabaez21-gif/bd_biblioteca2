# bd_biblioteca2
trabajo practico N°9

parte 1
1. Requisitos Funcionales (Orientados a los Datos)
   
Gestión de Socios: El sistema debe permitir registrar, actualizar y dar de alta a nuevos socios de la biblioteca, almacenando obligatoriamente su nombre, apellido, teléfono y DNI único.

Registro de Catálogo Literario: El sistema debe permitir registrar libros indicando su título, año de publicación, editorial correspondiente y género literario, vinculándolos a uno o más autores.

Control de Ejemplares Físicos: El sistema debe permitir gestionar copias físicas (ejemplar) de cada libro, especificando su estado actual (ej. Disponible, Prestado, Dañado) y su ubicación física dentro de la biblioteca.

Registro de Préstamos: El sistema debe permitir registrar un préstamo de libros asociando un ejemplar disponible a un socio, registrando la fecha de préstamo, la fecha de devolución acordada y el bibliotecario responsable de la transacción.

Control de Personal: El sistema debe permitir administrar los datos de los bibliotecarios (nombre, apellido, DNI) que operan en el sistema y realizan las gestiones de atención a los socios.

2. Listado Descriptivo de Consultas Principales
   
Consultas Simples (Búsquedas y Listados Básicos)
Listado de socios: Mostrar el listado completo de todos los socios registrados en la biblioteca, ordenados alfabéticamente por apellido y nombre.

Libros por editorial: Listar todos los libros publicados por una editorial específica (por ejemplo, "Editorial Planeta"), mostrando su título y año de publicación.

Ejemplares por estado: Listar todos los ejemplares de la biblioteca que se encuentren actualmente en un estado determinado (por ejemplo, buscar los que estén en estado "Dañado" o "En reparación").

Libros por género y autor: Consultar los libros pertenecientes a un género literario específico (por ejemplo, "Ciencia Ficción"), mostrando el título del libro junto con el nombre y apellido de su autor.

Búsqueda por DNI de socio: Buscar y mostrar la información personal de un socio específico utilizando su número de DNI.

Consultas Intermedias y Avanzadas (Reportes y Estadísticas)
Préstamos activos (pendientes de devolución): Listar todos los préstamos que aún no han sido devueltos, mostrando el nombre del socio, el título del libro, el ejemplar y la fecha de devolución prevista.

Historial de préstamos por socio: Obtener el historial completo de préstamos realizados por un socio específico (buscado por su DNI o ID), detallando las fechas de préstamo y los títulos de los libros solicitados.

Productividad de bibliotecarios: Listar a los bibliotecarios junto con la cantidad total de préstamos que han registrado en el sistema, ordenados de mayor a menor actividad.

Top 5 libros más prestados (Avanzada): Obtener el ranking de los 5 libros más solicitados de la biblioteca, mostrando el título del libro y la cantidad total de veces que ha sido prestado.

Top 5 socios más activos (Avanzada): Identificar a los 5 socios que más préstamos de libros han realizado durante el último año, incluyendo el total acumulado de préstamos.
