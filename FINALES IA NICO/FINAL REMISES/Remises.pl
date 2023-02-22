
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
              write('Ingrese los autos a buscar: '),
              leer(Lista),
              obtenerViajesCaros1(Lista),nl,nl.


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



obtenerViajesCaros([H|T]):- %Busco el Nro de movil por patente.
                            auto(NroMovil, H),
                            %Busco el Costo asociado al movil.
                            viaje(NroMovil,Costo),
                            %Lo saco de memoria para ir al siguiente hecho en la proxima llamada.
                            retract(viaje(NroMovil,Costo)),
                            % Valido que cumpla la condicion de costo.
                            Costo>300,
                            % Lo informo.
                            write('Patente: '), write(H),nl,
                            write('Costo de viaje: '),write(Costo),nl,
                            % Recursividad.
                            obtenerViajesCaros(T).

obtenerViajesCaros([_|T]):-obtenerViajesCaros(T).
obtenerViajesCaros([]).


obtenerViajesCaros1([H|T]):- %Busco el Nro de movil por patente.
                            auto(NroMovil, H),
                            %Busco el Costo asociado al movil.
                            viaje(NroMovil,Costo),
                            % Valido que cumpla la condicion de costo.
                            Costo>300,
                            %Lo saco de memoria para ir al siguiente hecho en la proxima llamada.
                            retract(viaje(NroMovil,Costo)),
                            % Lo informo.
                            write('Patente: '), write(H),nl,
                            write('Costo de viaje: '),write(Costo),nl,
                            % Recursividad.
                            obtenerViajesCaros1(T).

obtenerViajesCaros1([_|T]):-obtenerViajesCaros1(T).
obtenerViajesCaros1([]).



leer([H|T]):-read(H), H\=[], leer(T).
leer([]).
