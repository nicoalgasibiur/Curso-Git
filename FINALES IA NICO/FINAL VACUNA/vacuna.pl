%vacuna(ID, Nombre, Cadena de frio)
%vacunas_segun_edad(Vacuna, Edad a la que se recomienda tener aplicada)
%persona(nombre, edad, [ListaVacunasAplicadas])

%1. Devuelva una lista de personas a las que se aplicó más de 2 vacunas que necesiten cadena de frío
%2. Dada una edad y una vacuna, devolver la cantidad de veces que fue aplicada a persona menores de esas edad


:-dynamic(vacuna/3).
:-dynamic(vacunas_segun_edad/2).
:-dynamic(persona/3).


menu:-  abrir_base,
	writeln('Menu principal: '),
	writeln('1. Listado de personas que se aplicaron mas de 2 vacunas con cadena de frio. '),
	writeln('2. Cantidad de aplicaciones de una vacuna a una edad. Ingresar vacuna y edad.'),
	writeln('0. Salir.'),
	read(Op),Op\=0,opciones(Op),nl,nl,menu.

menu:-writeln('Fin de programa.').


abrir_base:-retractall(vacuna(_,_,_)),
	    retractall(vacunas_segun_edad(_,_)),
            retractall(personas(_,_,_)),
            consult('C:/Users/Nico/Desktop/FINALES IA NICO/FINAL VACUNA/bd.txt').


opciones(1):- abrir_base,
              obtenerPersonasVacunadasFrio(ListaPersonas),
	      writeln('Listado de personas con mas de 2 vacunas que tienen cadena de frio: '),nl,
              write(ListaPersonas),
              nl,nl.

opciones(2):- abrir_base,
              writeln('Ingrese Vacuna: '),
              read(Vacuna),
              writeln('Ingrese edad: '),
              read(Edad),
              contarAplicaciones(Vacuna,Edad,Cantidad),
              write('Aplicaciones de la vacuna a la edad de: '),writeln(Cantidad),nl,nl.



obtenerPersonasVacunadasFrio([H|T]):- persona(H,_, ListaVacunasAplicadas),
                                      contarVacunasFrio(ListaVacunasAplicadas, Cantidad),
				      Cantidad >=2,
                                      retract(persona(H,_,ListaVacunasAplicadas)),
                                      obtenerPersonasVacunadasFrio(T).
obtenerPersonasVacunadasFrio([]).


contarVacunasFrio([H|T],Cantidad):-	vacuna(H,_,si),
%%					retract(vacuna(H,_,si)),
					contarVacunasFrio(T,CantidadA),
					Cantidad is CantidadA + 1.
contarVacunasFrio([_|T],Cantidad):-contarVacunasFrio(T, Cantidad).
contarVacunasFrio([],0).




contarAplicaciones(Vacuna,Edad,Cantidad):- vacuna_segun_edad(Vacuna,Edad),
					   persona(P,E,ListaVacunasAplicadas),
					   E<Edad,
					   pertenece(Vacuna,ListaVacunasAplicadas),
					   retract(persona(P,E,ListaVacunasAplicadas)),
                                           contarAplicaciones(Vacuna,Edad,CantidadA),
                                           Cantidad is CantidadA + 1.
contarAplicaciones(_,_,0).



pertenece(H,[H|_]).
pertenece(X,[_|T]):-pertenece(X,T).

