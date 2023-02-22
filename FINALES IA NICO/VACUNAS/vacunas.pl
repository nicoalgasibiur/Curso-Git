%1. Ingresar el nombre de un niño y según la edad, mostrar una lista con las vacunas que le falta aplicarse.
%2. Ingresar una enfermedad y mostrar la cantidad de vacunas que la curan.

%niño(nombre, edad, [vacunas_aplicadas]).
%vacunas_edad(edad_desde, edad_hasta, vacunas_a_aplicarse).
%vacuna(vacuna, [enfermedades_que_cura]).

:-dynamic(nino/3).
:-dynamic(vacuna_edad/3).
:-dynamic(vacuna/2).


menu :- abrir_base,
		writeln('Ingrese opcion: '),
		writeln('1. Ingrese niño y validar por edad las vacunas que le falta aplicarse.'),
		writeln('2. Ingrese enfermedad y mostrar la cantidad de vacunas que la curan.'),
		writeln('0. Salir.'),nl,
		read(Op),Op \= 0, opciones(Op),nl,nl,menu.


menu :- writeln('Fin del programa.').


abrir_base :- retractall(nino(_,_,_)),
	          retractall(vacunas_edad(_,_,_)),
			  retractall(vacuna(_,_)),
			  consult('C:/Users/Nico/Desktop/FINALES IA NICO/VACUNAS/bd.txt').


opciones(1) :- writeln('Ingrese nombre del niño'),
			   read(Nombre),
			   obtenerVacunasPendientes(Nombre),
			   nl,nl.

opciones(2):-  writeln('Ingrese enfermedad: '),
			   read(Enfermedad),
			   obtenerCantidadVacunasEnfermedad(Enfermedad,Cantidad),
                           writeln('Cantidad de vacunas que curan enfermedad '),write(Enfermedad),writeln(Cantidad),
			   nl,nl.



obtenerVacunasPendientes(Nombre):- nino(Nombre,Edad,ListaVacunasAplicadas),
                                   vacuna_edad(ED,EH,ListaVacunasEdad),
                                   Edad>=ED,
                                   Edad=<EH,
                                   retract(vacuna_edad(ED,EH,ListaVacunasEdad)),
                                   obtenerVacunasPendientes(ListaVacunasAplicadas,ListaVacunasEdad,ListaVacunasPendientes),
                                   writeln(ListaVacunasPendientes),nl.
obtenerVacunasPendientes(_).


% Para saber que vacunas estan pendientes, debemos validar que vacunas
% del listado ListaVacunasEdad NO ESTA en ListaVacunasAplicadas. PREDICADO NOT().
obtenerVacunasPendientes(ListaVacunasAplicadas, [H|T],[H|T1]):- not(pertenece(H,ListaVacunasAplicadas)),
								obtenerVacunasPendientes(ListaVacunasAplicadas, T,T1).
obtenerVacunasPendientes(ListaVacunasAplicadas, [_|T],ListaVacunasPendientes):- obtenerVacunasPendientes(ListaVacunasAplicadas, T, ListaVacunasPendientes).
obtenerVacunasPendientes(_,[],[]).

obtenerCantidadVacunasEnfermedad(Enfermedad, Cantidad):- vacuna(Vacuna,ListaEnfermedades),
                                                         pertenece(Enfermedad,ListaEnfermedades),
                                                         retract(vacuna(Vacuna,ListaEnfermedades)),
                                                         obtenerCantidadVacunasEnfermedad(Enfermedad,CantidadA),
                                                         Cantidad is CantidadA + 1.
obtenerCantidadVacunasEnfermedad(_,0).


pertenece(H,[H|_]).
pertenece(X,[_|T]):-pertenece(X,T).

