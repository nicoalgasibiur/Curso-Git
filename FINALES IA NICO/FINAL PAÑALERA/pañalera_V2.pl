%1- Devolver una lista de códigos de pañal que hayan sido vendidas a clientes mayores de 21 años.
 % (Validar que la lista no tenga elementos repetidos)
%2- Ingresar un código de pañal y devolver la edad promedio de clientes que lo compran.
%3- 1- Lista de clientes con más de 20 ventas. La lista no podía contener elementos repetidos.

% pañal(CodPañal, edadDesde, edadHasta)
% venta(CodVenta, dni_cliente, ListaCodPañales)
% cliente(dni, nombre, edad)



:-dynamic (panal/3).
:-dynamic (venta/3).
:-dynamic (cliente/3).



menu:- abrir_base,
       writeln('Opciones: '),
       writeln('1. Lista de pañeles vendidos a clientes mayores a 21 años. Eliminar elementos repetidos.'),
       writeln('2. Edad promedio de clientes que comprar un pañal. Cod panal es dato entrada.'),
       writeln('3. Variante 1. Lista de clientes con mas de 20 ventas. Eliminar elementos repetidos.'),
       read(Op),Op\=0, opciones(Op),nl,nl,menu.

menu:-writeln('Fin programa.').


abrir_base:- retractall(panal(_,_,_)),
			 retractall(venta(_,_,_)),
             retractall(cliente(_,_,_)),
             consult('C:/Users/Nico/Desktop/FINALES IA NICO/FINAL PAÑALERA/bd.txt').


opciones(1):- abrir_base,
			  obtenerListaVentas(ListaVentas),
			  abrir_base,
              obtenerPanalesVendidos21(ListaPanales,ListaVentas),
              write(ListaPanales),
              nl.

opciones(4):- abrir_base,
			  obtenerPanales(ListaPanales1),
			  writeln('Lista panales vendidos:'),
			  writeln(ListaPanales1),nl,nl.
			

opciones(2):- abrir_base,
              write('Ingrese codigo de panal: '),
              read(CodPanal),
              obtenerEdadPromedio(CodPanal,SumaEdad,Cantidad),
			  Cantidad > 0,
              Promedio is SumaEdad / Cantidad,
              write('Edad promedio: '),
              write(Promedio),nl.
opciones(2):- writeln('Error, no hay pañales vendidos con ese codigo, elija otro'),nl,nl,menu.
			  

opciones(3):- abrir_base,
              obtenerClientesVentas(ListaClientes),
              writeln('Clientes con mas de 2 ventas son:'),
              write(ListaClientes).



%Ejercicio 1.
% La clave es hacer una lista de ventas, para no utilizar RETRACT en Ventas.
% EXPLICACION: Una venta tiene varios pañales, si uso retract me cuenta uno solo pañal bien y al resto lo elimine de memoria.
% Recorres pañal por panal, contando la cantidad de ventas de ese pañal, vas a cliente y validas su edad, si cumple contas.



obtenerListaVentas([H|T]):-venta(H,_,_),
						   retract(venta(H,_,_)),
						   obtenerListaVentas(T).
obtenerListaVentas([]).



obtenerPanalesVendidos21([H|T],ListaVentas):- panal(H,_,_),
											  contarVentasPanal(H,Cantidad,ListaVentas),
											  Cantidad >=3,
											  retract(panal(H,_,_)),
											  obtenerPanalesVendidos21(T,ListaVentas).
obtenerPanalesVendidos21([],_).


contarVentasPanal(Panal,Cantidad,[H|T]):-   venta(H, DNI, ListaPanales),
											pertenece(Panal, ListaPanales),
											cliente(DNI,_,Edad),
											Edad >= 21,
											contarVentasPanal(Panal, CantidadA,T),
											Cantidad is CantidadA + 1.
contarVentasPanal(Panal,Cantidad,[_|T]):-contarVentasPanal(Panal,Cantidad,T).											
contarVentasPanal(_,0,[]).


%Ejercicio 1.B. 
% La opcion 4 es la que funciona bien. Dejo las otras para comparar.

 obtenerPanales([H|T]):- panal(H,_,_),
						 venta(_,DNI,ListaPanales),
						 cliente(DNI,_,Edad),
						 Edad > 21,
						 pertenece(H,ListaPanales),
						 retract(panal(H,_,_)),
						 obtenerPanales(T).
obtenerPanales([]).




%Ejercicio 2.
% Agarro el primer cliente, me fijo tiene al menos una venta y si tiene lo saco y lo sumo y cuento.


obtenerEdadPromedio(CodPanal,SumaEdad,Cantidad):- cliente(DNI,_,Edad),
                                                  venta(_,DNI,ListaPanales),
                                                  pertenece(CodPanal,ListaPanales),
                                                  retract(cliente(DNI,_,Edad)),
                                                  obtenerEdadPromedio(CodPanal,SumaEdadA,CantidadA),
                                                  SumaEdad is SumaEdadA + Edad,
                                                  Cantidad is CantidadA + 1.
obtenerEdadPromedio(_,0,0).




% Ejercicio 3.


obtenerClientesVentas([H|T]):- cliente(H,_,_),
							   contarVentas(H,Cantidad),
							   Cantidad >= 3,
							   retract(cliente(H,_,_)),
							   obtenerClientesVentas(T).
obtenerClientesVentas([]).


contarVentas(H,Cantidad):- venta(ID,H,_),
						   retract(venta(ID,H,_)),
						   contarVentas(H,CantidadA),
						   Cantidad is CantidadA +1.
contarVentas(_,0).



pertenece(H,[H|_]).
pertenece(X,[_|T]):-pertenece(X,T).


limpiaRepetido([H|T],B):-pertenece(H,T),
						 limpiaRepetido(T,B).
limpiaRepetido([H|T],[H|T1]):-limpiaRepetido(T,T1).
limpiaRepetido([],[]).

