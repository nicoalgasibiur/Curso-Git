

%camion(cod_camion, marca, modelo, tipo_mma, peso_vacio, tipo1, tipo2, tipo3).
%viaje(cod_conductor, cod_camion, peso_carga_kg, ciudad_origen, fecha_partida,ciudad_destino, fecha_llegada).
%conductor(cod_conductor, apellido_nombre, edad, ciudad_natal, [cod_camion]).


%1. Dada una lista [ ] de c?digos de camiones y un c?digo de conductor (datos de entrada), devolver
%una nueva lista [ ] con aquellos camiones de la lista ingresada que dicho conductor est? habilitado a conducir.

%2. Dada una lista [ ] de c?digos de conductores y un c?digo de camion (datos de entrada) devolver
%una nueva lista [ ] con el apellido/nombre de los conductores (de la lista de entrada) que realizaron al
%menos un viaje con dicho cami?n en Abril 2020 (para el mes y a?o considerar fecha_partida).


:-dynamic(camion/8).
:-dynamic(viaje/7).
:-dynamic(conductor/5).


menu:- abrir_base,
	   writeln('Menu principal: '),
	   writeln('1. Listado de camiones de un conductor habilitado. INGRESAR: Lista de camiones y codigo de conductor.'),
	   writeln('2. Listado de conductores (con apellido y nombre) que realizaron un viaje con en abril 2020. INGRESAR: Lista de conductores
			    y codigo de camion. Fecha considerar Fecha_partida.'),
	   writeln('0. Salir.'),
	   read(Op), Op \= 0, opciones(Op), nl, menu.

menu:- writeln('Fin del programa.'),nl,nl.

abrir_base:- retractall(camion(_,_,_,_,_,_,_,_)),
		     retractall(viaje(_,_,_,_,_,_,_)),
			 retractall(conductor(_,_,_,_,_)),
			 consult('C:/Users/Nico/Desktop/FINALES IA NICO/FINAL CAMIONES/bd.txt').


opciones(1):- abrir_base,
			  writeln('Ingrese camiones: '),
			  leer(ListaCamiones),
			  writeln('Ingrese codigo de conductor: '),
			  read(Conductor),
			  obtenerCamionesHabilitados(ListaCamiones,Conductor,ListaCamionesHabilitado),
			  writeln('Los camiones habilitados para el conductor son: '),
			  write(ListaCamionesHabilitado),nl,nl.

opciones(2):- abrir_base, 
			  writeln('Ingrese conductores: '),
			  leer(ListaConductores),
			  writeln('Ingrese codigo de camion: '),
			  read(Camion),
			  obtenerConductoresAbril(ListaConductores,Camion,ListaConductoresViajes),
			  writeln('Conductores que realizaron viaje en abril 2020: '),
			  listarConductores(ListaConductoresViajes),nl,nl.


obtenerCamionesHabilitados([H|T1],Conductor,[H|T2]):- conductor(Conductor,_,_,_, ListaCamiones),
													  pertenece(H,ListaCamiones),
													  obtenerCamionesHabilitados(T1,Conductor,T2).
obtenerCamionesHabilitados([_|T1],Conductor,ListaCamionesHabilitados):-obtenerCamionesHabilitados(T1,Conductor,ListaCamionesHabilitados).
obtenerCamionesHabilitados([],_,[]).






obtenerConductoresAbril([H|T1],Camion,[H|T2]):- viaje(H,Camion,_,_,FechaPartida,_,_),
                                                %0123456789
                                                %01/01/2020.
                                                sub_atom(FechaPartida,3,7,_,X),
                                                X == '04/2020',
												obtenerConductoresAbril(T1,Camion,T2).
obtenerConductoresAbril([_|T1],Camion,ListaConductoresViajes):-obtenerConductoresAbril(T1,Camion,ListaConductoresViajes).
obtenerConductoresAbril([],_,[]).




pertenece(H,[H|_]).
pertenece(X,[_|T]):-pertenece(X,T).


leer([H|T]):- read(H),H\=[],leer(T).
leer([]).

listarConductores([H|T]):- conductor(H,AN,_,_,_), write(AN),nl,listarConductores(T).
listarConductores([]).





