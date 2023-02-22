
%habitacion(Numero,descripcion,[ListaCaracteristicas],PrecioPorDia, Estado).
%caracteristicas(Codigo,Descripcion)
%1. Listado de habitaciones disponibles, según una lista de características.
% Mostrar: Descripción y Precio por día.

:-dynamic(habitacion/5).
:-dynamic(caracteristica/2).

menu:-  abrir_base,
		writeln('Opciones:'),
        writeln('1. Mostrar habitaciones "Disponibles" segun caracteristicas ingresadas.'),
		writeln('0. Salir'),
		read(Op),
        Op \= 0, opcion(Op), nl,nl, menu.

menu:- writeln('Fin programa.').


abrir_base:-retractall(habitacion(_,_,_,_,_)),
			retractall(caracteristica(_,_)),
            consult('C:/Users/Nico/Desktop/FINALES IA NICO/FINAL HABITACIONES/bd.txt').

opcion(1):- abrir_base,
			write('Ingrese caracteristicas: '),
            leer(ListaCaracteristicas),
            obtenerHabitaciones(ListaCaracteristicas),nl,nl.



obtenerHabitaciones(ListaCaracteristicas):- habitacion(Numero,Descripcion,ListaCaracteristicasHabitacion,PrecioPorDia,'disponible'),
											validarCaracteristicas(ListaCaracteristicas,ListaCaracteristicasHabitacion),
                                            retract(habitacion(Numero,Descripcion,ListaCaracteristicasHabitacion,PrecioPorDia,'disponible')),
                                            write('ID: '),writeln(Numero),
                                            write('Descripcion: '),writeln(Descripcion),
                                            write('Precio por dia: '),writeln(PrecioPorDia),
                                            obtenerHabitaciones(ListaCaracteristicas).
obtenerHabitaciones(_).


validarCaracteristicas([H|T],ListaCaracteristicasHabitacion):- pertenece(H,ListaCaracteristicasHabitacion),
															   validarCaracteristicas(T,ListaCaracteristicasHabitacion).
validarCaracteristicas([_|T],ListaCaracteristicasHabitacion):- validarCaracteristicas(T,ListaCaracteristicasHabitacion).
validarCaracteristicas([],_).


pertenece(H,[H|_]).
pertenece(X,[_|T]):-pertenece(X,T).

leer([H|T]):- read(H),H\=[],leer(T).
leer([]).
