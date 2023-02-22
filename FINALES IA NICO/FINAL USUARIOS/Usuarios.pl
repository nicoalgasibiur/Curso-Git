/*

usuario(id, estado, edad, ciudad, [ids usuarios amigos]).
provincia(id, nombre, [ids ciudades]).
pais(id, nombre, [ids provincias]).

El estado de un usuario puede ser activo o inactivo.
   1)Mostrar la cantidad de usuarios activos que vivan en países que tengan más de 20 provincias.
   2)Ingresar los datos de un usuario (id, estado, edad, ciudad, [ids usuarios amigos]) y guardarlo en la base de datos
     sólo si es argentino y mayor de 18 años.
*/

% Se declaran para poder alterarlos en tiempo de ejecucion. (agregar o eliminar hechos).
:- dynamic (usuario/5).
:- dynamic (provincia/3).
:- dynamic (pais/3).

% Menu recursivo.
menu :- abrirBase,
		writeln('Ingrese una opcion: '),
		writeln('1. Mostrar usuarios "Activos" de paises de mas de 20 provicias.'),
		writeln('2. Alta de usuario si es mayor a 18 años.'),
		writeln('0. Salir.'),
		read(Op),Op\=0,opciones(Op),
		menu.

% Este menu es para cuando la opcion es distinta de 1 y 2. Debe dar true el predicado menu.
menu:-writeln('Fin del programa.').

% Elimina todos los predicados en memoria con retractall y luego levanta la BD del archivo a memoria.
abrirBase:- retractall(usuario(_,_,_,_,_)),
			retractall(provincia(_,_,_)),
			retractall(pais(_,_,_)),
			consult('C:/Users/Nico/Desktop/FINALES IA NICO/FINAL USUARIOS/bd.txt').


% Opcion 1.
opciones(1):- abrirBase,
			  % Predicado que genera una lista de usuarios.
			  buscarUsuarios(Lista),
			  writeln('Los usuarios son: '),
			  writeln(Lista).
% Si no encuentra usuarios, debe dar true de todas formas, por lo que le informamos este msj.
opciones(1):- write('No se encontraron usuarios. ').


opciones(2):- abrirBase, alta_usuario.


buscarUsuarios([H|T]):- % Busco el primero hecho que coincida ser un usuario activo y me traigo su ciudad.
						usuario(H,'activo',_,Ciudad,_),
						% Buscamos la provincia a la cual pertenece esa ciudad.
						buscarProvincia(Ciudad,Provincia),
						% Buscamos el pais al cual pertenece esa provincia.
						buscarPais(Pais,Provincia),
						% Contamos la cantidad de pcias que tiene ese pais.
						contarProvincias(Pais,CantidadProvincias),
						% Validamos el contador.
						CantidadProvincias >= 2,
						% Lo sacamos de la memoria y llamamos a la recursividad.
						retract(usuario(H,'activo',_,Ciudad,_)),
						buscarUsuarios(T).
% Para inicializar una lista, la condicion de lista vacia va al final. Es similar a Leer la lista.
buscarUsuarios([]).


% Buscamos la provincia validando si la ciudad encontrada es un elemento dentro de la lista de ciudades de cada provincia.
buscarProvincia(Ciudad,Provincia):-% busco provincia a provincia su lista de ciudades.
								   provincia(Provincia,_,ListaCiudades),
								   % uso predicado pertenece.
								   pertenece(Ciudad,ListaCiudades).

% Buscamos el pais, validando si la provincia enontrada es un elemento dentro de la lista de provincias de cada pais.
buscarPais(Pais,Provincia):- % busco pais a pais su lista de provincias.
							 pais(Pais,_,ListaProvincias),
							 % uso predicado pertenece.
							 pertenece(Provincia, ListaProvincias).


% Usamos el predicado pertenece SIN MOSTRAR INFORMACION ( 2 predicados y no 3).
% Este predicado puede devolver FALSE.

% Verificamos que pertenezca a la cabeza.
pertenece(H,[H|_]).
% Verificamos que esten en la cola.
pertenece(H,[_|T]):- pertenece(H,T).

% Contamos la cantidad de pronvicias del pais obtenido.
contarProvincias(Pais,CantidadProvincias):- % Busco pais a pais la lista de pronvicas.
											pais(Pais,_,ListaProvincias),
											% Cuento la cantidad de pronvincias de ese pais.
											contarElementos(ListaProvincias, CantidadProvincias).

% Contador de elementos de la lista de pronvincias.
contarElementos([],0).
contarElementos([_|T],CantidadProvincias):-contarElementos(T,CantidadProvinciasCola),CantidadProvincias is CantidadProvinciasCola +1.

leer([H|T]):-read(H),H\=[],leer(T).
leer([]).


% Alta usuario

alta_usuario :- abrirBase,
		write('Ingrese ID :'),read(ID),
		write('Ingrese estado:'),read(Estado),
		write('Ingrese edad:'),read(Edad),
		write('Ingrese ciudad:'),read(Ciudad),
		write('Ingrese amigos:'),leer(Lista),
		Edad>=18,
		buscarProvincia(Ciudad,Provincia),
		buscarPais(Provincia,Pais),
		Pais = 1,
		assert(usuario(ID,Estado,Edad,Ciudad,Lista)),
		guardar.
alta_usuario :- write('El usuario no es mayor de edad o no es argentino'),nl,nl.

guardar:-tell('C:/Users/Nico/Desktop/FINALES IA NICO/FINAL USUARIOS/bd.txt'),
	 listing(usuario),
	 listing(provincia),
	 listing(pais),
	 told.
