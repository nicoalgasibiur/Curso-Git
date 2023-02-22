
%orden(nro_orden, fecha, cliente).
%producto(codigo, descripcion, cant_en_stock).
%orden_producto(nro_orden, codigo, cantidad_solicitada).

%1.Ingresar una lista [] de codigos de producto y determinar a través de una nueva lista [], a todos ellos que
%  no tienen suficiente stock para cubrir los pedidos presentes en las órdenes.
%2. Mostrar en una lista de todos aquellos productos que hayan sido solicitado en 5 o más órdenes.
%3. Para un cliente (dato de entrada), determinar si posee dos o más órdenes en un mismo mes y año.


:-dynamic (orden/3).
:-dynamic (producto/3).
:-dynamic (orden_producto/3).

menu:-abrir_base,
	  writeln('Menu principal: '),
	  writeln('1. Listar productos con falta de stock para ordenes. Dato entrada: Lista de productos.'),
	  writeln('2. Listar produtos que esten en 5 o mas ordenes. '),
	  writeln('3. Determinar si cliente posee 2 o mas ordenes.'),
	  read(Op),Op\=0,opciones(Op),nl,nl,menu.
menu:-writeln('Fin del programa').

abrir_base:-retractall(orden(_,_,_)),
			retractall(producto(_,_,_)),
			retractall(orden_producto(_,_,_)),
			consult('C:/Users/Nico/Desktop/FINALES IA NICO/FINAL ORDEN PRODUCTO/bd.txt').


opciones(1):- abri_base,
			  writeln('Ingrese lista de productos: '),
			  leer(ListaProductos),
			  obtenerListaProductosSinStock(ListaProductos,ListaProductosSinStock),
			  writeln('Productos sin stock para satisfacer ordenes: '),
			  write(ListaProductosSinStock),nl,nl.
			  
opciones(2):- abrir_base,
			  obtenerProductosOrdenes(ListaProductos),
			  writeln('Productos en mas de 5 ordenes:'),
			  writeln(ListaProductos),nl,nl.			  
			  


opciones(4):- abrir_base,
			  convertirProductosLista(ListaProductos),
			  convertirOrdenesProductoLista(ListaOrdenesProducto),
			  abrir_base,
			  obtenerProductosOrdenes1(ListaProductos, ListaOrdenesProducto, ListaFinal),
			  writeln('Productos en mas de 5 ordenes:'),
			  writeln(ListaFinal),nl,nl.


opciones(3):-abrir_base,
			 writeln('Ingrese cliente: '),
			 read(Cliente),
			 validarOrdenCliente(Cliente,Cantidad),
			 Cantidad>=2,
			 writeln('Cliente posee 2 o mas ordenes.').

obtenerListaProductosSinStock([H|T],[H|T1]):-producto(H,_,Stock),
											 sumaCantidadOrdenada(H,Cantidad),
											 Cantidad>Stock,
											 obtenerListaProductosSinStock(T,T1).
obtenerListaProductosSinStock([_|T],ListaProductosSinStock):-obtenerListaProductosSinStock(T,ListaProductosSinStock).
obtenerListaProductosSinStock([],[]).


sumaCantidadOrdenada(Codigo,Cantidad):-orden_producto(ID,Codigo,Cant_solicitada),
									   retract(orden_producto(ID,Codigo,Cant_solicitada)),
									   sumaCantidadOrdenada(Codigo,CantidadA),
									   Cantidad is CantidadA + Cant_solicitada.
sumaCantidadOrdenada(_,0).






obtenerProductosOrdenes([H|T]):-producto(H,_,_),
								contarOcurrencias(H,Cantidad),
								Cantidad >= 2,
								retract(producto(H,_,_)),
								obtenerProductosOrdenes(T).
obtenerProductosOrdenes([]).



contarOcurrencias(H,Cantidad):- orden_producto(O,H,_),
								retract(orden_producto(O,H,_)),
								contarOcurrencias(H,CantidadA),
								Cantidad is CantidadA + 1.
contarOcurrencias(_,0).




obtenerProductosOrdenes1([H|T], ListaOrdenesProducto, [H|T1]):-contar(H,ListaOrdenesProducto,Cantidad),
															  Cantidad >= 2,
															  obtenerProductosOrdenes1(T,ListaOrdenesProducto,T1).
obtenerProductosOrdenes1([_|T],ListaOrdenesProducto,ListaFinal):-obtenerProductosOrdenes1(T,ListaOrdenesProducto,ListaFinal).
obtenerProductosOrdenes1([],_,[]).



contar(Producto,[H|T],Cantidad):- orden_producto(H,Producto,_),
								  contar(Producto,T,CantidadT),
								  Cantidad is CantidadT + 1.
contar(Producto,[_|T],Cantidad):-contar(Producto,T,Cantidad).
contar(_,[],0).



convertirProductosLista([H|T]):-producto(H,_,_),retract(producto(H,_,_)),convertirProductosLista(T).
convertirProductosLista([]).

convertirOrdenesProductoLista([H|T]):-orden_producto(H,_,_),retract(orden_producto(H,_,_)),convertirOrdenesProductoLista(T).
convertirOrdenesProductoLista([]).


leer([H|T]):-read(H),H\=[],leer(T).
leer([]).
