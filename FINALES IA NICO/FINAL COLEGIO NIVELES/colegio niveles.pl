%colegio(Cod_colegio,Direccion,Telefono,Ciudad,1[nivel]n).
%niveles(Cod_colegio,Nivel,Curso,Turno,1[DniAlumnos]n).


%1) Ingresar un nivel y devolver un listado con todos los colegios que sean de Rosario, que ofrezcan el nivel ingresado
% y que tengan hasta 90 alumnos.
%2) Dado un listado de Dni de alumnos ingresado, un Colegio y un Turno,
% devolver otro listado de los alumnos que verdaderamente pertenezcan a ese colegio y asistan a ese turno (de la lista de ingresada).

:-dynamic (colegio/5).
:-dynamic (niveles/5).

menu:- abrir_base,
       writeln('1. Listado de colegios de rosario de un nivel. Dato entrada: nivel.'),
       writeln('Menu de opciones: '),
       writeln('2. Listado de alumnos que pertenecen a un colegio y turno. Dato entrada: Lista de dni, colegio y turno.'),
       writeln('0. Salir.'),
       read(Op),Op\=0, opciones(Op),nl,nl,menu.

menu:-writeln('Fin del programa.').

abrir_base:- retractall(colegio(_,_,_,_,_)),
             retractall(niveles(_,_,_,_,_)),
			 consult('C:/Users/Nico/Desktop/FINALES IA NICO/FINAL COLEGIO NIVELES/bd.txt').

opciones(1):- abrir_base,
			  writeln('Ingrese un nivel: '),
              read(Nivel),
              obtenerColegiosNivel(Nivel,ListaColegios),
              write('Listado de colegios con nivel '),write(Nivel),write(' :'),
              writeln(ListaColegios),nl,nl.

opciones(2):- abrir_base,
             writeln('Ingrese dni de alumnos'),
             leer(ListaAlumnos),
             writeln('Ingrese colegio: '),
             read(Colegio),
             writeln('Ingrese turno: '),
             read(Turno),
             obtenerListado(ListaAlumnos,Colegio,Turno, ListaAlumnosReales),
             writeln(ListaAlumnosReales),nl,nl.


obtenerColegiosNivel(Nivel,[H|T]):- colegio(H,_,_,'Rosario',ListaNiveles),
									pertenece(Nivel, ListaNiveles),
                                    niveles(H,Nivel,_,_,ListaAlumnos),
                                    contarAlumnos(ListaAlumnos,Cantidad),
                                    Cantidad >= 1,
                                    retract(colegio(H,_,_,'Rosario',ListaNiveles)),
                                    obtenerColegiosNivel(Nivel,T).
obtenerColegiosNivel(_,[]).


/*

Intentar hacer el pertenece y no pertenece con esta parte y poner predicado
 
 obtenerListado3([H|T],Colegio,turno,ListaPertenece,ListaNoPertenece)..
 
 
opciones(3.):- abrir_base,
             leer(ListaAlumnos),
             writeln('Ingrese dni de alumnos'),
             writeln('Ingrese colegio: '),
             read(Colegio),
             writeln('Ingrese turno: '),
             read(Turno),
             obtenerListado(ListaAlumnos,Colegio,Turno, ListaAlumnosReales),
             writeln(ListaAlumnosReales),nl,nl.*/
			 
			 
			 
obtenerListado([H|T],Colegio,Turno,[H|T1]):- niveles(Colegio,_,_,Turno,LAlumnos),
											 pertenece(H,LAlumnos),
											 obtenerListado(T,Colegio,Turno,T1).
obtenerListado([_|T],Colegio,Turno,ListaAlumnosReales):- obtenerListado(T,Colegio,Turno,ListaAlumnosReales).
obtenerListado([],_,_,[]).




leer([H|T]):-read(H),H\=[],leer(T).
leer([]).

pertenece(H,[H|_]).
pertenece(X,[_|T]):-pertenece(X,T).


contarAlumnos([_|T],Cantidad):-contarAlumnos(T,CantidadT),
                               Cantidad is CantidadT + 1.
contarAlumnos([],0).

