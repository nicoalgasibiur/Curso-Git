%cancion(IdCancion,Nombre,Artista,Duración,Genero)
%invitados(Nombre, [IdCanciones que gusta]) Tenía un atributo mas que no me acuerdo pero no se usaba
%1- Listar las canciones que le gusta a mas del 80% de los invitados.
%2- Listar las canciones de género "vals" que duren mas de 15 minutos.


:-dynamic(cancion/4).
:-dynamic(invitados/2).

menu:-    abrir_base_general,
	  writeln('Menu de opciones: '),
	  writeln('1. Listar canciones que le gustan a mas del 80% de los invitados.'),
	  writeln('2. Listar canciones de genero X que duren mas de Y minutos.'),
	  writeln('0. Salis.'),
	  read(Op),Op\=0,opciones(Op),nl,nl,menu.

menu:-writeln('Fin del programa.').

abrir_base_general:-retractall(cancion(_,_,_,_)),
		    retractall(invitados(_,_)),
		    consult('C:/Users/Nico/Desktop/FINALES IA NICO/FINAL CANCIONES/bd_canciones.txt'),
		    consult('C:/Users/Nico/Desktop/FINALES IA NICO/FINAL CANCIONES/bd_invitados.txt').

abrir_base_invitados:-retractall(invitados(_,_)),
		      consult('C:/Users/Nico/Desktop/FINALES IA NICO/FINAL CANCIONES/bd_invitados.txt').



opciones(1):-abrir_base_general,
             % Genero una lista de TODOS los hechos invitados. Esto para evitar usar retract y aprovechar el backtracking y recursividad de la lista
             obtenerInvitadosLista(ListaInvitados),
             abrir_base_invitados,
             % Cuento el total de hechos de Invitados para tener el denominador para calcular el porcentaje.
             contarInvitados(ListaInvitados,Total),
             % Obtengo la lista de canciones por medio del Total y de la lista de invitados.
             obtenerCanciones(Total,ListaInvitados,ListaCanciones),
             write(ListaCanciones).

opciones(2):-writeln('Ingrese genero: '),
	     read(Genero),
             obtenerCancionesGenero(Genero,ListaCanciones),
             writeln(ListaCanciones).


opciones(9):-abrir_base_general,
	     contarTotalInvitados(Cantidad),
             abrir_base_invitados,
             obtenerCanciones80(Cantidad, ListaCanciones),
             write('Listado de canciones: '),writeln(ListaCanciones),nl,nl.

% Descompongo el 3er argumento que es donde guardamos la lista de
% canciones que cumplen la condicion.
%
% La clave es buscar la cancion y validarla por TODOS los invitados, por
% ende pasamos la ListaInvitados para evitar usar RETRACT y poder
% tenerla para la proxima cancion.
%
% Tomamos una cancion, contamola cantidad de veces que gusta esa cancion
% , calculamos promedio y solo si es mayor a 0.8 usamos RETRACT de
% cancion.
obtenerCanciones(Total,ListaInvitados,[H|T]):- cancion(H,_,_,_,_),
                                               contarVecesQueGusta(H,ListaInvitados,Cantidad),
                                               Prom is Cantidad/Total,
                                               Prom >= 0.8,
                                               retract(cancion(H,_,_,_,_)),
                                               obtenerCanciones(Total,ListaInvitados,T).
obtenerCanciones(_,_,[]).



% Genero la lista de invitados.
obtenerInvitadosLista([H|T]):-invitados(H,_),
                              retract(invitados(H,_)),
                              obtenerInvitadosLista(T).
obtenerInvitadosLista([]).


% Contamos la lista para obtener el TOTAL.
contarInvitados([_|T],Cantidad):-contarInvitados(T,CantidadT),
                                 Cantidad is CantidadT + 1.
contarInvitados([],0).


% Tenemos el ID de la canccion y la lista de invitados expresada en
% terminos de H y T.
% Recorremos los invitados por medio de la H y T, validando si el ID
% pertenece a la lista de cada invitado.
%
% Si falla, automaticamente pasamos al otro invitado por medio del 2do
% predicado evitando usar RETRACT(invitados(H,Lista). No podemos usar
% RETRACT ya que la proxima cancion necesita ir por TODOS los invitados
% tambien y si usamos retract solo valida la primera bien.
contarVecesQueGusta(ID,[H|T],Cantidad):- invitados(H,ListaCanciones),
                                         pertenece(ID,ListaCanciones),
                                         contarVecesQueGusta(ID,T,CantidadA),
                                         Cantidad is CantidadA +1.
contarVecesQueGusta(ID,[_|T],Cantidad):-contarVecesQueGusta(ID,T,Cantidad).
contarVecesQueGusta(_,[],0).




obtenerCancionesGenero(Genero,[H|T]):-cancion(H,_,_,Duracion,Genero),
                                      Duracion >4,
				      retract(cancion(H,_,_,Duracion,Genero)),
				      obtenerCancionesGenero(Genero,T).
obtenerCancionesGenero(_,[]).








contarTotalInvitados(Cantidad):- invitados(H,_),
								 retract(invitados(H,_)),
								 contarTotalInvitados(CantidadA),
								 Cantidad is CantidadA + 1.
contarTotalInvitados(0).

obtenerCanciones80(Cantidad, [H|T]):- cancion(H,_,_,_,_),
									  abrir_base_invitados,
									  contarCancion(H,Cant),
									  Prom is Cant / Cantidad,
									  Prom >=0.8,
									  retract(cancion(H,_,_,_,_)),
									  obtenerCanciones80(Cantidad,T).
obtenerCanciones80(_,[]).


contarCancion(H,Cant):- invitados(N,ListaCanciones),
						 pertenece(H,ListaCanciones),
						 retract(invitados(N,ListaCanciones)),
						 contarCancion(H,CantA),
						 Cant is CantA + 1.
contarCancion(_,0).
									  
	
	
	
pertenece(H,[H|_]).
pertenece(X,[_|T]):-pertenece(X,T).

