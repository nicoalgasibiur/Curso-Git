%1- Devolver una lista de códigos de pañal que hayan sido vendidas a clientes menores de 21 años.
 % (Validar que la lista no tenga elementos repetidos)
%2- Ingresar un código de pañal y devolver la edad promedio de clientes que lo compran.
%3- 1- Lista de clientes con más de 20 ventas. La lista no podía contener elementos repetidos.

% pañal(CodPañal, edadDesde, edadHasta)
% venta(CodVenta, dni_cliente, ListaCodPañales)
% cliente(dni, nombre, edad)



:-dynamic (pañal/3).
:-dynamic (venta/3).
:-dynamic (cliente/3).



menu:- abrir_base,
       writeln('Opciones: '),
       writeln('1. Lista de pañeles vendidos a clientes mayores a 21 años. Eliminar elementos repetidos.'),
       writeln('2. Edad promedio de clientes que comprar un pañal. Cod panal es dato entrada.'),
       writeln('3. Variante 1. Lista de clientes con mas de 20 ventas. Eliminar elementos repetidos.'),
       read(Op),Op\=[], opciones(Op),nl,nl,menu.

menu:-writeln('Fin programa.').


abrir_base:- retractall(panal(_,_,_)),
	     retractall(venta(_,_,_)),
             retractall(cliente(_,_,_)),
             consult('C:/Users/Nico/Desktop/FINALES IA NICO/FINAL PAÑALERA/bd.txt').


opciones(1):- abrir_base,
              obtenerPanalesVendidos21(ListaPanales),
              lista(ListaPanales),
              write(ListaPanales),
              nl.

opciones(2):- abrir_base,
              write('Ingrese codigo de panal: '),
              read(CodPanal),
              obtenerEdadPromedio(CodPanal,SumaEdad,Cantidad),
              Promedio is SumaEdad /Cantidad,
              write('Edad promedio: '),
              write(Promedio),nl.

opciones(3):- abrir_base,
              obtenerClientesVentas(ListaClientes),
              writeln('Clientes con mas de 2 ventas son:'),
              write(ListaClientes).



obtenerPanalesVendidos21([H|T]):- venta(_,DNI, H),
                                  cliente(DNI,_,Edad),
                                  Edad >=21,
                                  retract(venta(_,DNI,H)),
                                  obtenerPanalesVendidos21(T).
obtenerPanalesVendidos21([]).






lista([H|T]):-[H],lista(T).
lista([]).


obtenerEdadPromedio(CodPanal,SumaEdad,Cantidad):- cliente(DNI,_,Edad),
                                                  venta(_,DNI,ListaPanales),
                                                  pertenece(CodPanal,ListaPanales),
                                                  retract(cliente(DNI,_,Edad)),
                                                  obtenerEdadPromedio(CodPanal,SumaEdadA,CantidadA),
                                                  SumaEdad is SumaEdadA + Edad,
                                                  Cantidad is CantidadA + 1.
obtenerEdadPromedio(_,0,0).



obtenerClientesVentas([H|T]):-    cliente(H,_,_),
                                  contarVentas(H,Cantidad),
                                  Cantidad>=3,
                                  retract(cliente(H,_,_)),
                                  obtenerClientesVentas(T).
obtenerClientesVentas([]).



contarVentas(H,Cantidad):-venta(_,H,_),
                          retract(venta(_,H,_)),
                          contarVentas(H,CantidadA),
                          Cantidad is CantidadA + 1.
contarVentas(_,0).

pertenece(H,[H|_]).
pertenece(X,[_|T]):-pertenece(X,T).



limpiaRepetido([H|T],B):-pertenece(H,T),limpiaRepetido(T,B).
limpiaRepetido([H|T],[H|T1]):-limpiaRepetido(T,T1).
limpiaRepetido([],[]).

