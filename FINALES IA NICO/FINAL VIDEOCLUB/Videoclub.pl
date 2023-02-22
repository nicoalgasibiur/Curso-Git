%persona(Nombre,[ListaPeliculasVieron])
%peliculas(IDPelicula,Nombre,Duracion)

% Una persona tenia diferente membresia segun la cantida de minutos visto en una pelicula.
% Membresia Gold: +100 Minutos vistos de peliculas.

%1. Listar todas las personas con memebresia GOLD.
%2. Listar todas las peliculas que fueron vistas al menos una vez.


:-dynamic(persona/2).
:-dynamic(pelicula/3).

menu:- abrir_base,
	   writeln('Menu:'),
	   writeln('1. Listar personas que son membresia GOLD'),
	   writeln('2. Listar peliculas vistas al menos una vez'),
	   writeln('0. Salir'),
	   read(Op),Op\=0,opciones(Op),nl,nl,menu.

menu:- writeln('Fin del programa.').

abrir_base:- retractall(persona(_,_)),
			 retractall(pelicula(_,_,_)),
			 consult('C:/Users/Nico/Desktop/FINALES IA NICO/FINAL VIDEOCLUB/bd.txt').

abrir_base_peliculas:-retractall(pelicula(_,_,_)),
					  consult('C:/Users/Nico/Desktop/FINALES IA NICO/FINAL VIDEOCLUB/bd_pelicula.txt').
					  
opciones(1):- abrir_base,
			  obtenerListaPeliculas(ListaPeliculas),
			  abrir_base,
			  obtenerPersonasGold(ListaPeliculas, ListadoPersonas),
			  writeln(ListadoPersonas),nl,nl.
opciones(3):- abrir_base,
			  obtenerPersonasGold1(ListadoPersonas),
			  writeln(ListadoPersonas),nl,nl.
			  
opciones(4):- abrir_base,
			  obtenerPersonasGold2(ListaPersonasGOLD),
			  writeln(ListaPersonasGOLD),
			  nl,nl.
			  

opciones(2):- abrir_base,
			  obtenerListaPersonas(ListaPersonas),
			  abrir_base,
			  obtenerPeliculasVistas(ListaPersonas, ListaPeliculas),
			  writeln(ListaPeliculas),nl,nl.
			  


%Obtengo lista de TODAS las peliculsa de la BD.
obtenerListaPeliculas([H|T]):- pelicula(H,_,_),
							   retract(pelicula(H,_,_)),
							   obtenerListaPeliculas(T).
obtenerListaPeliculas([]).


%Obtengo lista de TODAS las personas de la BD.
obtenerListaPersonas([H|T]):- persona(H,_),
							  retract(persona(H,_)),
							  obtenerListaPersonas(T).
obtenerListaPersonas([]).


%Punto 1.
obtenerPersonasGold(ListaPeliculas,[H|T]):- persona(H,ListaPeliculasVio),
											contarMinutos(ListaPeliculas,ListaPeliculasVio,Suma),
											Suma > 100,
											retract(persona(H,ListaPeliculasVio)),
											obtenerPersonasGold(ListaPeliculas, T).
obtenerPersonasGold(_,[]).



contarMinutos([H|T],ListaPeliculasVio,Suma):- pelicula(H,_,Duracion),
											  pertenece(H,ListaPeliculasVio),
											  contarMinutos(T,ListaPeliculasVio,SumaT),
											  Suma is SumaT + Duracion.
contarMinutos([_|T],ListaPeliculasVio,Suma):- contarMinutos(T,ListaPeliculasVio,Suma).
contarMinutos([],_,0).


% Variante del punto 1 con abrir_base_peliculas y sin lista general de peliculas.

obtenerPersonasGold1([H|T]):-    persona(H,ListaPeliculasVio),

								 abrir_base_peliculas,
								 contarMinutos1(ListaPeliculasVio,Suma),
								 Suma > 100,
								 retract(persona(H,ListaPeliculasVio)),
								 obtenerPersonasGold1(T).
obtenerPersonasGold1([]).


contarMinutos1([H|T],Cantidad):- pelicula(H,_,Duracion),
								 retract(pelicula(H,_,Duracion)),
								 contarMinutos1(T,CantidadT),
								 Cantidad is CantidadT + Duracion.
contarMinutos1([],0).


%Variante del punto 1 con lista para sumar duracion.

obtenerPersonasGold2([H|T]):- persona(H,ListaPeliculas),
							  contarMinutos2(ListaPeliculas,Minutos),
							  Minutos > 100,
							  retract(persona(H,ListaPeliculas)),
							  obtenerPersonasGold2(T).
obtenerPersonasGold2([]).

contarMinutos2([H|T],Minutos):- pelicula(H,_,Duracion),
								contarMinutos2(T,MinutosT),
								Minutos is MinutosT + Duracion.

contarMinutos2([],0).
							  



% Punto 2.

obtenerPeliculasVistas(ListaPersonas, [H|T]):-  pelicula(H,_,_),
												contarVecesVista(ListaPersonas, H,Cantidad),
												Cantidad >=3,
												retract(pelicula(H,_,_)),
												obtenerPeliculasVistas(ListaPersonas, T).
obtenerPeliculasVistas(_,[]).


contarVecesVista([H|T], P,Cantidad):-  persona(H,ListaPeliculas),
									   pertenece(P,ListaPeliculas),
									   contarVecesVista(T,P,CantidadA),
									   Cantidad is CantidadA + 1.
contarVecesVista([_|T],P,Cantidad):- contarVecesVista(T,P,Cantidad).  
contarVecesVista([],_,0).




pertenece(H,[H|_]).
pertenece(X,[_|T]):-pertenece(X,T).