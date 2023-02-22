:-dynamic (docente/6).
:-dynamic (colegio/3).
:-dynamic (colegio_docentes/3).

% docente(dni,nombre,edad,telefono,direccion,ciudad).
% colegio(nombreColegio,direccion,ciudad).
% colegio_docentes(nombreColegio,dni,[listaMaterias]).

% 1. Listar todos los docentes que trabajen en al menos 2 colegios diferentes de la ciudad de Rosario.
% 2. Ingresar una lista de docentes y una lista de colegios y devolver una tercer lista con los docentes
%    que pertenezcan a los colegios ingresados anteriormente.



menu:- abrir_base,
	   writeln('Ingrese opcion: '),
	   writeln('1. Buscar docentes que trabajen en 2 o mas colegios en Rosario.'),
	   writeln('2. Ingresar lista de docentes, lista de colegios y devolver aquellos docentes que pertenezcan a los colegios.'),
	   writeln('0. Salir'),
	   read(Op), Op\= 0, opciones(Op), nl,nl, menu.

menu:- writeln('Fin del programa.'),nl,nl.

abrir_base:- retractall(docente(_,_,_,_,_,_)),
			 retractall(colegio(_,_,_)),
			 retractall(colegio_docentes(_,_,_)),
			 consult('C:/Users/Nico/Desktop/FINALES IA NICO/FINAL DOCENTES/db.txt').


opciones(1):- obtenerDocentes(ListaDocentes),
			  writeln('Docentes que trabajan en 2 o mas colegios de Rosario: '),nl,
			  write(ListaDocentes),nl,nl.


opciones(2):- writeln('Ingrese DNI docentes: '), leer(ListaDocentes),
			  writeln('Ingrese colegios: '),leer(ListaColegios),
			  obtenerDocentesColegios(ListaDocentes, ListaColegios, ListaDocentesColegios),
			  writeln('Listado de docentes que pertenezcan a uno de los colegios ingresados: '),
			  writeln(ListaDocentesColegios),nl,nl.




obtenerDocentes([H|T]):- docente(H,_,_,_,_,_),
						 contarColegios(H,Cantidad),
						 Cantidad>=2,
						 retract(docente(H,_,_,_,_,_)),
						 obtenerDocentes(T).
obtenerDocentes([]).


contarColegios(DNI,Cantidad):- colegio_docentes(Colegio,DNI,_),
                               colegi(Colegio,_,'Rosario'),
							   retract(colegio_docentes(Colegio,DNI,_)),
							   contarColegios(DNI,CantidadA),
							   Cantidad is CantidadA + 1.
contarColegios(_,0).



leer([H|T]):-read(H),H\=[],leer(T).
leer([]).

% Al ser ListaColegios, utilizada para validar si el colegio del docente
% pertenece a ese colegio, no es necesario en terminos de H y T. Si a la
% ListaDocentesColegios.
obtenerDocentesColegios([H|T],ListaColegios,[H|T2]):- colegio_docentes(Colegio,H,_),
                                                      pertenece(Colegio,ListaColegios),
                                                      obtenerDocentesColegios(T,ListaColegios,T2).
obtenerDocentesColegios([_|T],ListaColegios,ListaDocentesColegios):-obtenerDocentesColegios(T,ListaColegios,ListaDocentesColegios).
obtenerDocentesColegios([],_,[]).


pertenece(X,[X|_]).
pertenece(X,[_|T]):-pertenece(X,T).




