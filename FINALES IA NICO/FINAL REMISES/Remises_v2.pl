
%auto(nro_movil, patente).
%viaje(nro_movil, costo).

%1. Monto total acumulado por cada auto
%2. Dada una lista de autos devolver de esa lista cuales tenian al menos un viaje con costo mayor a 300.

:-dynamic (auto/2).
:-dynamic (viaje/2).


menu:- abrir_base,
		write('Elija una opcion: '),nl,
		write('1. Monto total acumulado por auto.'),nl,
		write('2. Ingresar lista de autos y determinar cuales tuvieron un costo mayor a 300.'),nl,
		write('0. Salir.'),nl,
		read(Op),Op \=0, opciones(Op),
		menu.
menu:- writeln('Fin del programa.').


abrir_base :- retractall(auto(_,_)),
			  retractall(viaje(_,_)),
			  consult('C:/Users/Nico/desktop/FINALES IA NICO/FINAL REMISES/bd.txt').

opciones(1):- abrir_base,
			  calcularMonto,nl,nl.

opciones(2):- abrir_base,
              write('Ingrese lista de los autos a buscar: '),
              leer(ListaAutos),
              obtenerViajesCaros3(ListaAutos,ListaAutosCaros),
			  writeln(ListaAutosCaros),
			  nl,nl.


calcularMonto:- auto(NroMovil,Patente),
				retract(auto(NroMovil,Patente)),
				sumaViajesMovil(NroMovil,Total),
				write('Patente: '),write(Patente),nl,
				write('Monto: '),write(Total),nl,nl,
				calcularMonto.
calcularMonto.


sumaViajesMovil(NroMovil, Total):- viaje(NroMovil,Costo),
								   retract(viaje(NroMovil,Costo)),
								   sumaViajesMovil(NroMovil,CostoA),
								   Total is CostoA + Costo.


sumaViajesMovil(_,0).


obtenerViajesCaros3([H|T],[H|T1]):- auto(H,_),
								    contarViajesCaros(H,Cantidad),
								    Cantidad >= 1,
								    obtenerViajesCaros3(T,T1).
obtenerViajesCaros3([_|T],ListaAutos):-obtenerViajesCaros3(T,ListaAutos).
obtenerViajesCaros3([],[]).



contarViajesCaros(NroMovil,Cantidad):- viaje(NroMovil,Costo),
									   Costo>= 100,
									   retract(viaje(NroMovil,Costo)),
									   contarViajesCaros(NroMovil,CantidadA),
									   Cantidad is CantidadA + 1.
contarViajesCaros(_,0).

leer([H|T]):-read(H), H\=[], leer(T).
leer([]).
