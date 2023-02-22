%vehiculo(CodVehiculo,[Lista de caracteristicas(color, AC, Puertas, Año)]).
%ventas(IDVenta, Codvehiculo, Año).


%1)Ingresar una caracteristica y devolver una lista con códigos de los autos que tengan esa caracteristica.
%2)Ingresar una lista de código de vehiculos y un año y devolver una lista con los autos que se hayan
  %vendido mas de 10 veces en ese año.*/

%declaramos predicados dinamicos para usar retract y assert.
:-dynamic (vehiculo/2).
:-dynamic (ventas/3).


menu:-abrir_base,
	  writeln('Ingrese una opcion: '),
	  writeln('1. Listar vehiculos por caracteristica ingresada. '),
	  writeln('2. Listar ventas de vehiculos vendidos mas de 10 veces en el año (Debe ingresar vehiculo y año).'),
	  writeln('0. Salir'),nl,
	  read(Op), Op\=0, opciones(Op),nl,nl, menu.


menu:-writeln('Fin del programa.'),nl,nl.




abrir_base:- retractall(vehiculo(_,_)),
	     retractall(ventas(_,_,_)),
             consult('C:/Users/Nico/Desktop/FINALES IA NICO/FINAL VEHICULO/bd.txt').


opciones(1):- abrir_base,
			  write('Ingrese caracteristica: '),read(Caract),
			  obtenerVehiculosCaracteristica(ListadoVehiculos,Caract),
			  write('Vehiculos con la caracteristica "'), write(Caract),writeln('": '),nl,
			  write(ListadoVehiculos),nl,nl.

opciones(2):- abrir_base,
			  write('Ingrese codigos de vehiculo: '),leer(ListaVehiculos),
			  write('Ingrese anio: '),read(A),
			  obtenerVehiculosMasVendidos(ListaVehiculos,A,ListaVehiculosVendidos),
			  writeln('Vehiculos mas vendidos son: '),
			  write(ListaVehiculosVendidos),nl,nl.

opciones(3):- abrir_base,
			  write('Ingrese codigos de vehiculo: '),leer(ListaVehiculos),
			  write('Ingrese anio: '),read(A),
			  obtenerVehiculosMasVendidos1(ListaVehiculos,A,ListaVehiculosVendidos),
			  writeln('Vehiculos mas vendidos son: '),
			  write(ListaVehiculosVendidos),nl,nl.




obtenerVehiculosCaracteristica([H|T],Caract):- vehiculo(H,ListaCaracteristicas),
					       pertenece(Caract,ListaCaracteristicas),
					       retract(vehiculo(H,ListaCaracteristicas)),
                                               obtenerVehiculosCaracteristica(T,Caract).
obtenerVehiculosCaracteristica([],_).


pertenece(X,[X|_]).
pertenece(X,[_|T]):-pertenece(X,T).




obtenerVehiculosMasVendidos([H|T],A,[H|T1]):-  contarVentas(H,A,Cantidad),
	                                        Cantidad > 2,
						obtenerVehiculosMasVendidos(T,A,T1).
% Importante este predicado, valida en la cola para volver a invocar en la recursividad.
% Si el contarVentas falla, hace fallar el primer predicado ObtenerVehiculosMasVendidos, para que entre en bucle sin sentido,
% Este predicado lo manda a la cola de la lista para sacar la nueva cabeza y generar una nueva.
obtenerVehiculosMasVendidos([_|T],A,ListaVehiculosVendidos):-obtenerVehiculosMasVendidos(T,A,ListaVehiculosVendidos).
obtenerVehiculosMasVendidos([],_,[]).






obtenerVehiculosMasVendidos1([H|T],A,[H|T1]):-  vehiculo(H,_),
												contarVentas(H,A,Cantidad),
												Cantidad > 2,
												obtenerVehiculosMasVendidos1(T,A,T1).
% Importante este predicado, valida en la cola para volver a invocar en la recursividad.
% Si el contarVentas falla, hace fallar el primer predicado ObtenerVehiculosMasVendidos, para que entre en bucle sin sentido,
% Este predicado lo manda a la cola de la lista para sacar la nueva cabeza y generar una nueva.
obtenerVehiculosMasVendidos1([_|T],A,ListaVehiculosVendidos):-obtenerVehiculosMasVendidos1(T,A,ListaVehiculosVendidos).
obtenerVehiculosMasVendidos1([],_,[]).


contarVentas(H,A,Cantidad):- ventas(_,H,A),
							 retract(ventas(_,H,A)),
							 contarVentas(H,A,CantidadA),
							 Cantidad is CantidadA + 1.
contarVentas(_,_,0).





leer([H|T]):-read(H),H\=[],leer(T).
leer([]).
