%jardin(CodigoJardin, nombre_jardin, [Tipos de Sala])
%salas(CodigoJardin, nombre_sala, tipo_de_sala, [Dni Asistentes])

%1.Dada una Lista [] de Dni, y un Codigo de Jardin Devolver una Lista [] con aquellos Dni que asisten realmente al Jardin.
%2.Dada una Lista [] de Jardines, y una Lista [] de Tipos de Sala, devolver una Lista [] con los Jardines que tengan todos
%  los tipos de sala.

:-dynamic(jardin/3).
:-dynamic(sala/4).


menu:- abrir_base,
	   writeln('Ingrese opcion: '),
       writeln('1. Listado de alumnos asistentes a un jardin'),
       writeln('2. Listado de jardines con los tipos de salas indicados'),
       writeln('0. Salir'),
	   read(Op), Op\= 0, opciones(Op), menu.

menu:-writeln('Fin del programa.').


abrir_base:- retractall(jardin(_,_,_)),
	     retractall(sala(_,_,_,_)),
	     consult('C:/Users/Nico/Desktop/FINALES IA NICO/FINAL JARDIN/bd.txt').



opciones(1):- abrir_base,
			  writeln('Ingrese una lista de asistentes (DNI): '),
			  leer(ListaAsistentes),
			  writeln('Ingrese un codigo de jardin:'),
			  read(CodigoJardin),
			  obtenerAsistentesReales(ListaAsistentes,CodigoJardin, ListaAsistentesReales),
			  writeln('Asistentes que realmente van al jardin: '),
			  writeln(ListaAsistentesReales),nl,nl.

opciones(2):- abrir_base,
		      writeln('Ingrese un listado de jardines: '),
			  leer(ListaJardines),
			  writeln('Ingrese una lista de tipos de sala: '),
			  leer(ListaTipoSala),
			  obtenerJardinesSala(ListaJardines,ListaTipoSala, ListaJardinesSala),
			  writeln(ListaJardinesSala),nl,nl.


obtenerAsistentesReales([H|T],CodigoJardin,[H|T1]):- salas(CodigoJardin,_,_,ListaAsistentes),
											         pertenece(H,ListaAsistentes),
                                                     obtenerAsistentesReales(T,CodigoJardin,T1).
obtenerAsistentesReales([_|T],CodigoJardin,ListaAsistentes):-obtenerAsistentesReales(T,CodigoJardin,ListaAsistentes).
obtenerAsistentesReales([],_,[]).



obtenerJardinesSala([H|T],ListaTipoSala, [H|T1]):- jardin(H,_,ListadoTipoSala),
												   validarTiposSala(ListaTipoSala,ListadoTipoSala),
												   obtenerJardinesSala(T,ListaTipoSala,T1).
obtenerJardinesSala([_|T],ListaTipoSala,ListaJardinesSala):- obtenerJardinesSala(T,ListaTipoSala,ListaJardinesSala).
obtenerJardinesSala([],_,[]).	



validarTiposSala([H|T],ListadoTipoSala):- pertenece(H,ListadoTipoSala),
										  validarTiposSala(T,ListadoTipoSala).
validarTiposSala([],_).




pertenece(H,[H|_]).
pertenece(X,[_|T]):-pertenece(X,T).

leer([H|T]):-read(H),H\=[],leer(T).
leer([]).

