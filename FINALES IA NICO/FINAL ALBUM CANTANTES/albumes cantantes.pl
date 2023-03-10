%cantante(nombre_cantante,pais_origen)
%album(nombre_album,nombre_cantante,[lista_temas],fecha_edicion,copias_vendidas)



%1)Ingrese un ?lbum y una lista [] de temas y a partir de esto devolver una lista con aquellos temas de la lista original
%  que correspondan al ?lbum ingresado.
%2)Informar cuantos ?lbumes fueron lanzados en un determinado a?o (dato de entrada) por cantantes de origen sueco.
%3)Ingresar un cantante y devolver una lista con todos los albumes que haya lanzado a lo largo de su carrera y
% cuya cantidad de copias supere el mill?n.


:-dynamic(cantante/2).
:-dynamic(album/5).


menu:-abrir_base,
	  writeln('Menu principal: '),
	  writeln('1. Listar temas correspondientes al album ingresado. Dato entrada: Album y Lista de temas.'),
	  writeln('2. Informar cantidad de albumes lanzados en un determinado a?o por cantantes suecos. Dato entrada: a?o'),
	  writeln('3. Listar albumes de un cantante cuyas cantidad de copias vendidas supere el millon. Dato entrada: Cantante. '),
	  writeln('0. Salir.'),
	  read(Op),Op\=0, opciones(Op),nl,nl,menu.
menu:-writeln('Fin del programa.').


abrir_base:-retractall(cantante(_,_)),
		    retractall(album(_,_,_,_,_)),
			consult('C:/Users/Nico/Desktop/FINALES IA NICO/FINAL ALBUM CANTANTES/bd.txt').



opciones(1):-abrir_base,
             writeln('Ingrese un album: '),
	     read(Album),
	     writeln('Ingrese lista de temas: '),
	     leer(ListaTemas),
	     obtenerListaTemas(Album,ListaTemas,ListaTemasCorrespondientes),
             writeln(ListaTemasCorrespondientes),
             nl,nl.

opciones(2):-abrir_base,
	     writeln('Ingrese anio: '),
	     read(A),
	     obtenerCantidadDeAlbumesSueco(A,Cantidad),
             write(Cantidad),
	     nl,nl.

opciones(3):-abrir_base,
	     writeln('Ingrese cantante: '),
	     read(Cantante),
	     obtenerListaAlbumes(Cantante,ListaAlbumes),
	     writeln(ListaAlbumes).



obtenerListaTemas(Album,[H|T],[H|T1]):- album(Album,_,ListaTemasAlbum,_,_),
					pertenece(H,ListaTemasAlbum),
					obtenerListaTemas(Album,T,T1).
obtenerListaTemas(Album,[_|T],ListaTemasCorrespondientes):-obtenerListaTemas(Album,T,ListaTemasCorrespondientes).
obtenerListaTemas(_,[],[]).



obtenerCantidadDeAlbumesSueco(A,Cantidad):- album(Album, C,_,Fecha,_),
					    cantante(C,'suecia'),
					    sub_atom(Fecha,6,4,_,X),
					    X == A,
					    retract(album(Album,C,_,Fecha,_)),
					    obtenerCantidadDeAlbumesSueco(A,CantidadA),
                                            Cantidad is CantidadA + 1.
obtenerCantidadDeAlbumesSueco(_,0).



obtenerListaAlbumes(Cantante,[H|T]):- album(H,Cantante,_,_,CopiasVendidas),
				      CopiasVendidas>=1000000,
				      retract(album(H,Cantante,_,_,CopiasVendidas)),
                                      obtenerListaAlbumes(Cantante,T).
obtenerListaAlbumes(_,[]).




leer([H|T]):-read(H),H\=[],leer(T).
leer([]).

pertenece(H,[H|_]).
pertenece(X,[_|T]):-pertenece(X,T).








