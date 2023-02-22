% catedra(nombre_catedra,descripcion).
% comision(nombre_catedra,comision,ciclo,[legajo de inscriptos]).
% alumno(legajo,nombre,apellido,edad).

% 1. Devolver una lista de catedras del ciclo 2022 que tengan mas de 100 inscriptos en sus comisiones.
% 2. Mostrar las catedras en las cuales se encuentra inscripto un alumno.

:- dynamic (catedra/2).
:- dynamic (comision/4).
:- dynamic (alumno/4).


menu:- abrir_base, writeln('Ingrese opciones: '),nl,
	  write('1. Listado de catedras del ciclo lectivo 2022 con mas de 100 inscriptos.'),nl,
	  write('2. Catedras inscriptas de un alumno.'),nl,
	  write('0. Salir. '),nl,
	  read(Op),Op \=0, opciones(Op),
	  menu.

menu:- write('Fin del programa.').

abrir_base:- retractall(catedra(_,_)),
			 retractall(comision(_,_,_,_)),
			 retractall(alumno(_,_,_,_)),
			 consult('C:/Users/Nico/Desktop/FINALES IA NICO/FINAL COMISIONES/bd.txt').


opciones(1):-abrir_base,
			 obtener_catedras(ListaCatedras),
			 listar(ListaCatedras),
			 nl,nl.

opciones(2):- abrir_base,
			  write('Ingrese legajo del alumno a buscar: '),
			  read(Legajo),
			  obtener_catedras_alumno(Legajo,ListaCatedras),
			  writeln('Catedras inscripto del alumno para ciclo lectivo 2022: '),
			  listar(ListaCatedras),
			  nl,nl.




obtener_catedras([H|T]):-comision(H,_,2022,ListaIncriptos),
				  contarInscriptos(H,CantidadInscriptos),
				  CantidadInscriptos > 2,
				  retract(comision(H,_,2022,ListaIncriptos)),
				  obtener_catedras(T).

obtener_catedras([]).


contarInscriptos(Catedra,CantidadInscriptos):- comision(Catedra,_,_,ListaInscriptos),
											   contarElementos(ListaInscriptos,CantidadInscriptos).


contarElementos([],0).
contarElementos([_|T],CantidadInscriptos):-contarElementos(T,CantidadInscriptosCola),
										   CantidadInscriptos is CantidadInscriptosCola + 1.

listar([H|T]):-write(H),obtenerDescripcion(H,Descripcion),write(' - '), writeln(Descripcion),listar(T).
listar([]).

obtenerDescripcion(H,Descripcion):-catedra(H,Descripcion).


obtener_catedras_alumno(L,[H|T]):- comision(H,_,2022,ListaIncriptos),
								   pertenece(L,ListaIncriptos),
								   retract(comision(H,_,2022,ListaIncriptos)),
								   obtener_catedras_alumno(L,T).

obtener_catedras_alumno(_,[]).


pertenece(H,[H|_]).
pertenece(X, [_|T]):-pertenece(X,T).


