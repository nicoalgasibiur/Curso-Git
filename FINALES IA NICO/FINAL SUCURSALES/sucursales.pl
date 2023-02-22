% sucursales(id, nombre)
% producto(id, nombre, necesitaRefrigeracion, fechaVencimiento, idSucursal)
% necesitaRefrigeracion: 'si'/'no'. 
% fechaVencimiento: formato "DD/MM/YYYY"

%1) Dada una lista de sucursales, listado de productos que requieran conservación con refrigeración
%   y listado de los que NO requieran, definiendo y usando una función llamada dividir_por_conservacion/3
%2) Listado de sucursales que tengan al menos 2 productos con fecha_vencimiento en 2024.


:-dynamic(sucursales/2).
:-dynamic(producto/5).

menu:-abrir_base,
      writeln('Opciones:'),
	  writeln('1. Listar productos con conservación y sin conservacion.Entrada: Lista de productos.'),
	  writeln('2. Obtener sucursales con al menos 2 productos con fecha vencimiento 2024.'),
	  writeln('0. Salir.'),
	  read(Op),Op\=0,opciones(Op),nl,nl,menu.

menu:- writeln('Fin del programa').

abrir_base:-retractall(sucursales(_,_)),
			retractall(producto(_,_)),
			consult('C:/Users/Nico/Desktop/FINALES IA NICO/FINAL SUCURSALES/bd.txt').


opciones(1):- abrir_base,
			  writeln('Ingrese lista de productos'),
			  leer(ListaProductos),
			  dividir_por_conservacion(ListaProductos,ListaProductosConservacion,ListaProductosSinConservacion),
			  writeln('Productos con conservacion: '),
			  writeln(ListaProductosConservacion),
			  writeln('Productos sin conservacion'),
			  writeln(ListaProductosSinConservacion),
			  nl,nl.

opciones(3):- abrir_base,
			  writeln('Ingrese lista de sucursales'),
			  leer(ListaSucursales),
			  dividir_por_conservaciones1(ListaSucursales,ListaProductosConFrio,ListasProductosNoFrio),
			  writeln('productos con frio: '),
			  writeln(ListaProductosConFrio),
			  writeln('Productos sin frio: '),
			  writeln(ListasProductosNoFrio),
			  nl,nl.
			  
opciones(2):- abrir_base,
			  obtenerSucursarles(ListaSucursales),
			  writeln(ListaSucursales),nl,nl.
			  


dividir_por_conservacion([H|T],[H|T1],ListaProductosSinConservacion):- producto(H,_,'si',_,_),
																	   dividir_por_conservacion(T,T1,ListaProductosSinConservacion).
dividir_por_conservacion([H|T],ListaProductosConservacion,[H|T1]):- dividir_por_conservacion(T,ListaProductosConservacion,T1).
dividir_por_conservacion([],[],[]).




% Version mejorada.
% Precondicion: El predicado me lo define la profesora: dividir_por_conservaciones1/3.
% TIP: Yo respeto ese y puedo hacer otro predicado que sea con Dividir(Productos, Frio, NoFrio).

%1. Obtengo una lista de productos.
%2. Limpio de la lista los elementos repetidos.
%3. Recien ahi, llamo al predicado

dividir_por_conservaciones1(ListaSucursales,ListaProductosFrio,ListaProductosNoFrio):- obtenerListaProductos(ListaProductos),
																					   abrir_base,
																					   limpiaRepetidos(ListaProductos,ListaProductosSinRepeticiones),
																					   dividirProductos(ListaSucursales, ListaProductosSinRepeticiones,ListaProductosFrio,ListaProductosNoFrio).




% Lista de productos
obtenerListaProductos([H|T]):-producto(H,_,_,_,_),retract(producto(H,_,_,_,_)),obtenerListaProductos(T).
obtenerListaProductos([]).

% Limpiamos repetidos.
limpiaRepetidos([H|T],ListaNoRepetidos):- pertenece(H,T),
										  limpiaRepetidos(T,ListaNoRepetidos).
limpiaRepetidos([H|T],[H|T1]):-limpiaRepetidos(T,T1).
limpiaRepetidos([],[]).


%Divido los productos como ya se dividirlos.
dividirProductos(ListaSucursales, [H|T],[H|T1],ListaProductosNoFrio):-producto(H,_,'si',_,Sucursal),
																	  pertenece(Sucursal,ListaSucursales),
																	  dividirProductos(ListaSucursales,T,T1,ListaProductosNoFrio).
dividirProductos(ListaProductos,[H|T],ListaProductosFrio,[H|T1]):-dividirProductos(ListaProductos,T,ListaProductosFrio,T1).
dividirProductos(_,[],[],[]).																	 







obtenerSucursarles([H|T]):- sucursales(H,_),
							contarProductosVencimiento(H,Cantidad),
							Cantidad >=2,
							retract(sucursales(H,_)),
							obtenerSucursarles(T).
obtenerSucursarles([]).

contarProductosVencimiento(H,Cantidad):- producto(ID, _,_, FechaVencimiento,H),
										 sub_atom(FechaVencimiento,6,_,0,X),
										 X = '2024',
										 retract(producto(ID,_,_,FechaVencimiento,H)),
										 contarProductosVencimiento(H,CantidadA),
										 Cantidad is CantidadA + 1.
contarProductosVencimiento(_,0).



leer([H|T]):- read(H),H\=[],leer(T).
leer([]).

pertenece(H,[H|_]).
pertenece(X,[_|T]):- pertenece(X,T).