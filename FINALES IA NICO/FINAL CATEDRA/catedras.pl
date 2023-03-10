% catedra(catedra, nombre_catedra).
% comision(catedra,comision,ciclo,[legajos de inscriptos]).
% alumno(legajo,nombre).

% 1. Devolver lista [] de las catedras del ciclo 2017 que tengan m�s de 100 inscriptos en sus comisiones.
% 2. Mostrar las catedras en las que se encuentra inscripto un alumno (ingresando el legajo) tambien en el ciclo 2017.



:-dynamic(catedra/2).
:-dynamic(comision/4).
:-dynamic(alumno/2).

menu:- abrir_base,
	   writeln('Opciones: '),
	   writeln('1. Listado de catedras del ciclo 2017 con mas de 100 inscriptos en comisiones'),
	   writeln('2. Catedras que se encuentra inscripto un alumno (ingresando legajo), en el año 2017'),
	   writeln('0. Salir'),
	   read(Op), Op \= 0, opciones(Op), nl, menu.

menu:-writeln('Fin del programa').


abrir_base:-retractall(catedra(_,_)),
	    retractall(comision(_,_,_,_)),
            retractall(alumno(_,_)),
            consult('C:/Users/Nico/Desktop/FINALES IA NICO/FINAL CATEDRA/bd.txt').


opciones(1):- abrir_base,
	      obtenerCatedras(ListaCatedras),
              writeln('Catedras ciclo lectivo 2017 con +100: '),
              write(ListaCatedras),
              nl.

opciones(2):- abrir_base,
              writeln('Ingrese legajo del alumno: '),
              read(Legajo),
              obtenerCatedrasAlumno(Legajo,ListaCatedras),
              write('Catedras del alumno '),write(Legajo),nl,
              listarCatedras(ListaCatedras),nl,nl.






obtenerCatedras([H|T]):-comision(H,_,2017, ListaInscriptos),
			contarInscriptos(ListaInscriptos, Cantidad),
			Cantidad > 2,
			retract(comision(H,_,2017, ListaInscriptos)),
			obtenerCatedras(T).
obtenerCatedras([]).


contarInscriptos([_|T],Cantidad):- contarInscriptos(T, CantA),
				   Cantidad is CantA + 1.
contarInscriptos([],0).



obtenerCatedrasAlumno(Legajo, [H|T]):- comision(H,_,2017,ListaInscriptos),
                                       pertenece(Legajo, ListaInscriptos),
                                       retract(comision(H,_,2017,ListaInscriptos)),
                                       obtenerCatedrasAlumno(Legajo,T).

obtenerCatedrasAlumno(_,[]).


pertenece(H,[H|_]).
pertenece(X,[_|T]):-pertenece(X,T).

listarCatedras([H|T]):- catedra(H,Desc),write(H), write('-'), write(Desc),nl, listarCatedras(T).
listarCatedras([]).
