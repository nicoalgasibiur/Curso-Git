
%edificio(nombre,direccion,localidad).
%departamento(nombreEdificio,piso,nro,cantidadHabitaciones,precio,estado,[listaCodigoCaracteriscas]).
%caracteristica(codigo,descripcion)

% departamento es NombreEdificio, Piso y Nro.
% Unidad Premium superior a $10.000.000
% Estado : 'Disponible', 'Vendido'.

%1. Listar unidades disponibles (edificio, piso, nro,direccion, precio)
%   con caracteristicas ingresadas y pertenecientes a la localidad. 
% Dato entrada: Lista de caracteristicas y localidad.

%2. Listar unidades premiuim vendidas.

:-dynamic(edificio/3).
:-dynamic(departamento/7).
:-dynamic(caracteristica/2).

menu:- abrir_base,
    writeln("1. Listar unidades disponibles"),
    writeln("2. Listar unidades premium vendidas"),
    read(Op),Op\=0,opcion(Op),nl,nl,menu.
menu.

opcion(1):- writeln("Ingrese localidad: "),
            read(Localidad),
            writeln("Ingrese listado de caracteristicas."),
            leer(ListaCaracteristicas),
            obtenerDepartamentos(Localidad, ListaCaracteristicas),nl,nl.

opcion(2):- writeln('Unidades premium vendidas: '),														obtenerUnidadesPremium,nl,nl.






abrir_base:- retractall(edificio(_,_,_)),
             retractall(departamento(_,_,_,_,_,_,_)),
             retractall(caracteristica(_,_)),
             consult("C:/Users/Nico/Desktop/FINALES IA NICO/FINAL EDIFICIOS/bd.txt").


% Entro por localidad y voy reccorriendo edificio por edificio buscando
% por Nombre,  para invocar obtenerDepartamentos.
obtenerDepartamentos(Localidad, ListaCaracteristicas):-
% edificio(NombreEdificio, Direccion, Localidad),
							retract(edificio(NombreEdificio, Direccion, Localidad)),
							buscar_por_edificio(NombreEdificio, Direccion, ListaCaracteristicas),
							obtenerDepartamentos(Localidad, ListaCaracteristicas).
obtenerDepartamentos(_, _).


% Aca busco el primer departamento "Disp" junto con todos sus datos y su
% LISTA de caracteristicas.
% Valido que las caracterististicas ingresadas al inicio esten dentro de
% la lista de caracteristicas y recien ahi hago RETRACT y lo informo.
buscar_por_edificio(NombreEdificio,Direccion, ListaCaracteristicas):-
							departamento(NombreEdificio, Piso, Nro, Ch, Pr, 'disp', ListaCaracteristicasDpto),
							validarCaracteristicas(ListaCaracteristicas, ListaCaracteristicasDpto),
							retract(departamento(NombreEdificio, Piso, Nro, Ch, Pr, 'disp', ListaCaracteristicasDpto)),	
							write(NombreEdificio), write(" - Dir: "), write(Direccion), write(" - Piso: "),
							write(Piso), write(" - Habit: "), write(Ch), write(" - Pr: "),
							writeln(Pr),buscar_por_edificio(NombreEdificio, Direccion, ListaCaracteristicas).
buscar_por_edificio(_, _, _).




% una unidad es PREMIUM si Cant Hab es >=3 y Pr >= 10.000

obtenerUnidadesPremium():- departamento(NombreEdificio,Piso,Nro,Ch,Pr,'vend',_),
			   Pr>50,
			   Ch>=3,
			   write(NombreEdificio),
			   write(Piso),
			   write(Nro),
			   write(Pr),
			   retract(departamento(NombreEdificio,Piso,Nro,Ch,Pr,'vend',_)),
                           obtenerUnidadesPremium().
obtenerUnidadesPremium(_).


% valida la LISTA de caracteristicas ingresadas contra la lista de
% caracteristicas del dpto.
validarCaracteristicas([H|T], ListaCaracteristicasDpto):-  pertenece(H, ListaCaracteristicasDpto),
						       validarCaracteristicas(T, ListaCaracteristicasDpto).
validarCaracteristicas([], _).

pertenece(H, [H|_]).
pertenece(X, [_|T]):- pertenece(X,T).


leer([H|T]):- read(H), H \= [], leer(T).
leer([]).
