
%edificio(nombre,direccion,localidad).
%departamento(nombreEdificio,piso,nro,cantidadHabitaciones,precio,estado,[listaCodigoCaracteriscas]).
%caracteristica(codigo,descripcion)

% departamento es NombreEdificio, Piso y Nro.
% Unidad Premium superior a $10.000.000 y habitaciones >=3.
% Estado : 'Disponible', 'Vendido'.

%1. Listar unidades disponibles (edificio, piso, nro,direccion, precio)
%   con caracteristicas ingresadas y pertenecientes a la localidad. 
% Dato entrada: Lista de caracteristicas y localidad.

%2. Listar unidades premium vendidas.

:-dynamic(edificio/3).
:-dynamic(departamento/7).
:-dynamic(caracteristica/2).

menu:- abrir_base,
	   writeln("1. Listar unidades disponibles"),
       writeln("2. Listar unidades premium vendidas"),
       read(Op),Op\=0,opcion(Op),nl,nl,menu.
menu.

opcion(1):- writeln("Ingrese una localidad: "),
            read(Localidad),
            writeln("Ingrese listado de caracteristicas."),
            leer(ListaCaracteristicas),
            obtenerDepartamentos(Localidad, ListaCaracteristicas),
			nl,nl.

opcion(2):- writeln('Unidades premium vendidas: '),
			obtenerUnidadesPremium(),
			nl,nl.




abrir_base:- retractall(edificio(_,_,_)),
             retractall(departamento(_,_,_,_,_,_,_)),
             retractall(caracteristica(_,_)),
             consult("C:/Users/Nico/Desktop/FINALES IA NICO/FINAL EDIFICIOS/bd.txt").


% Utilizo como argumento la Localidad para buscar el Edficio.
% Obtengo un DPTO asociado a ese edificio y sus caracteristica. 
% Valido con un predicado que TODAS las caracteristicas pertenezcan a la lista de caracteristicas ingresadas.
% Muestro y realizo RETRACT, para luego poder llamar recursivamente al predicado.
obtenerDepartamentos(Localidad,ListaCaracteristicas):- 
								edificio(Edificio,Direccion,Localidad),
								departamento(Edificio,Piso,Nro,_,_,'disp',ListaCaracteristicasDpto),
								validarCaracteristicas(ListaCaracteristicas,ListaCaracteristicasDpto),
								write('Edificio:'),writeln(Edificio),
								write('Piso:'),writeln(Piso),
								write('Nro:'),writeln(Nro),
								write('Direccion:'),writeln(Direccion),
								nl,nl,
								retract(departamento(Edificio,Piso,Nro,_,_,'disp',ListaCaracteristicasDpto)),
								obtenerDepartamentos(Localidad,ListaCaracteristicas).
obtenerDepartamentos(_,_).


% Valido que la lista de caracteristicas ingresada pertenezca a la otra lista obtenida del DPTO de la BD.
validarCaracteristicas([H|T],ListaCaracteristicasDpto):- pertenece(H,ListaCaracteristicasDpto),
													     validarCaracteristicas(T,ListaCaracteristicasDpto).
validarCaracteristicas([],_).






% una unidad es PREMIUM si Cant Hab es >=3 y Pr >= 10.000

obtenerUnidadesPremium():- departamento(NombreEdificio,Piso,Nro,Ch,Pr,'vend',_),
						   Pr>=50,
						   Ch>=3,
						   retract(departamento(NombreEdificio,Piso,Nro,Ch,Pr,'vend',_)),
						   
						   write('Edificio:'), writeln(NombreEdificio),
						   write('Piso:'),writeln(Piso),
						   write('Nro:'),writeln(Nro),
						   write('Precio: $' ),writeln(Pr),nl,nl,
						   
                           obtenerUnidadesPremium().
obtenerUnidadesPremium(_).

pertenece(H, [H|_]).
pertenece(X, [_|T]):- pertenece(X,T).

leer([H|T]):- read(H), H \= [], leer(T).
leer([]).
