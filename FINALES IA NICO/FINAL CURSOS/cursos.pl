%Dada la siguiente BD
%personas(Nombre, Edad, [Profesiones],Ciudad).
%cursos(Profesion, [Cursos]).
%personas_cursos(Nombre,Profesion,[CursosRealizados]).

%1) Ingresar una profesión (dato de entrada), y mostar la edad promedio de dicha profesion en la ciudad de Rosario.
%2) Ingresar una profesión (dato de entrada), y mostrar para cada persona, la lista de cursos que le faltan realizar.
%3) Mostrar la profesión con mayor cantidad de cursos.



:-dynamic(personas/4).
:-dynamic(cursos/2).
:-dynamic(personas_cursos/3).


menu:- abrir_base,
	   writeln('Ingrese opcion: '),
	   writeln('1. Edad promedio de la profesion. Dato entrada: Profesion.'),
	   writeln('2. Mostrar cursos pendientes por persona para la profesion. Dato entrada: Profesion.'),
	   writeln('3. Profesion con mayor cantidad de cursos'),
	   writeln('0. Salir.'),
	   read(Op),Op \=[],opciones(Op),nl,nl,menu.

menu:-write('Fin del programa.').

abrir_base:-retractall(personas(_,_,_,_)),
			retractall(cursos(_,_)),
			retractall(personas_cursos(_,_,_)),
            consult('C:/Users/Nico/Desktop/FINALES IA NICO/FINAL CURSOS/bd.txt').

opciones(1):- abrir_base,
			  writeln('Ingrese profesion: '),
			  read(Profesion),
			  obtenerEdadPromedioProfesion(Profesion,Cantidad,Suma),
			  Cantidad > 0,
			  Prom is Suma / Cantidad,
			  write('Promedio: '),writeln(Prom),
			  nl,nl.
opciones(1):-writeln('Division por cero, elija otra profesion. '),nl,nl,menu.



opciones(2):- abrir_base,
			  writeln('Ingrese profesion: '),
			  read(Profesion),
			  obtenerCursosPendientes(Profesion),
			  nl,nl.

opciones(3):- %%abrir_base,
				profesionMasCursos(_,0),nl,nl.

obtenerEdadPromedioProfesion(Profesion, Cantidad, Suma):- personas(Nombre,Edad,ListaProfesiones,Ciudad),
														  Ciudad = 'Rosario',
														  pertenece(Profesion,ListaProfesiones),
														  retract(personas(Nombre,Edad,ListaProfesiones,Ciudad)),									                  obtenerEdadPromedioProfesion(Profesion,CantidadA,SumaA),
														  Cantidad is CantidadA + 1,
														  Suma is SumaA + Edad.
obtenerEdadPromedioProfesion(_,0,0).




obtenerCursosPendientes(Profesion):- cursos(Profesion,ListaCursosRequeridos),
                                     personas_cursos(Nombre,Profesion,ListaCursosRealizados),
                                     retract(personas_cursos(Nombre,Profesion,ListaCursosRealizados)),
                                     obtenerCursosFaltantes(ListaCursosRequeridos,ListaCursosRealizados,ListaPendientes),
                                     write('Persona: '),write(Nombre),nl,
                                     write('Profesion: '),write(Profesion),nl,
                                     write('Cursos pendientes: '),writeln(ListaPendientes),
                                     obtenerCursosPendientes(Profesion).

obtenerCursosPendientes(_).









profesionMasCursos(Profesion,Cant):-cursos(Profesion,Lista),
                                    retract(cursos(Profesion,Lista)),
                                    contar(Lista,Cantidad),
                                    Cantidad>Cant,
                                    profesionMasCursos(Profesion,Cantidad).

profesionMasCursos(Profesion,_):-write(Profesion).

obtenerCursosFaltantes([H|T],ListaCursosRealizados,[H|T1]):- not(pertenece(H,ListaCursosRealizados)),
															 obtenerCursosFaltantes(T,ListaCursosRealizados,T1).
obtenerCursosFaltantes([_|T],ListaCursosRealizados,T1):-obtenerCursosFaltantes(T,ListaCursosRealizados,T1).
obtenerCursosFaltantes([],_,[]).

contar([_|T],Cantidad):-contar(T,CantidadT), Cantidad is CantidadT + 1.
contar([],0).

pertenece(H,[H|_]).
pertenece(X,[_|T]):-pertenece(X,T).


