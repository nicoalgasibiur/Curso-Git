%escuela(Escuela, Descripcion).
%alumno(Legajo,Nombre,Direccion,Escuela,Estatura).

%1. Por cada escuela, promedio de estatura de sus alumnos. Mostrar de la siguiente manera:
%Escuela: XXX
%Promedio de estatura: xxx
%Escuela: YYY
%Promedio de estatura: yyy
%Escuela: ZZZ
%Promedio de estatura: zzz


%2. Ingresar una escuela y devolver una lista con los legajos de los alumnos que midan menos de 165cm.


:-dynamic(escuela/2).
:-dynamic(alumno/5).

menu:- abrir_base,
	   writeln('opciones: '),
	   writeln('1. Promedio de estatura por escuela.'),
	   writeln('2. lista de alumnos que midan menos de 165.' ),
	   read(Op),Op\=0, opciones(Op),nl,nl,menu.

menu:-writeln('Fin del programa').


abrir_base:- retractall(escuela(_,_)),
			 retractall(alumno(_,_,_,_,_)),
			 consult('C:/Users/Nico/Desktop/FINALES IA NICO/FINAL ESCUELA/bd.txt').



opciones(1):- obtenerPromedioEstatura,nl,nl.

opciones(2) :- writeln('Ingrese una escuela: '),
			   read(Escuela),
			   obtenerAlumnosEstatura(Escuela, ListaAlumnos),
			   writeln(ListaAlumnos),nl.


obtenerPromedioEstatura:- escuela(Escuela,_),
			  retract(escuela(Escuela,_)),
			  obtenerPromedioEstatura(Escuela,Suma,Cantidad),
			  Promedio is Suma/Cantidad,
			  write('Escuela: '),writeln(Escuela),
			  write('Promedio estatura: '),writeln(Promedio),
			  obtenerPromedioEstatura.

obtenerPromedioEstatura.



obtenerPromedioEstatura(Escuela,Suma,Cantidad):- alumno(Legajo,_,_,Escuela,Estatura),
						 retract(alumno(Legajo,_,_,Escuela,Estatura)),
						 obtenerPromedioEstatura(Escuela, SumaA,CantidadA),
						 Suma is SumaA + Estatura,
						 Cantidad is CantidadA + 1.
obtenerPromedioEstatura(_,0,0).



obtenerAlumnosEstatura(Escuela, [H|T]):- alumno(H,Nombre,_,Escuela,Estatura),
					 Estatura>165,
					 retract(alumno(H,Nombre,_,_,Estatura)),
					 obtenerAlumnosEstatura(Escuela, T).

obtenerAlumnosEstatura(_,[]).
