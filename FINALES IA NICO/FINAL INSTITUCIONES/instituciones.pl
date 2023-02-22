
%institutoSalud(IDInstitucion,Nombre,Direccion,Telefono,Sector,[Obras Sociales]).
%medico(Matricula, Nombre, Especialidad, [IDInstituciones]).


%1. Dada una lista de códigos de institutos y una obra social,
%   indicar el nombre de los institutos que atiendan por esa os.
%2. Contar los médicos que atienden en institutos del sector publico.

% Variante:
%1. Devolver una lista [] con los c�digos de instituciones que coincidan con la obra social
%   y con el sector. Dato entrada: Lista instituciones y sector.
%2. Devolver una lista [] con los c�digos de instituciones en las que  atiende un m�dico
%   y seg�n una obra social,tambien estos dos datos se ingresaban como dato.

:-dynamic(institutoSalud/6).
:-dynamic(medico/4).


menu:- abrir_base,
writeln('Opciones: '),
	  writeln('1. Listado de institutos que atienden con Obra Social. Dato entrada: lista cod institutos y OS. '),
	  writeln('2. Cantidad de medicos sector publico.'),
      writeln('3. 1. Variante. Ingresar OS y sector. Devolver lista de instituciones.'),
      writeln('4. 2. Variante. Lista de instituciones que atiende un medico. Ingresar Medico y OS'),
	  writeln('5. Variante del punto 4 optimizada'),
      writeln('0. Salir.'),
	  read(Op), Op \= 0, opciones(Op),nl,menu.

menu.


abrir_base:- retractall(institutoSalud(_,_,_,_,_,_)),
			 retractall(medico(_,_,_,_)),
			 consult('C:/Users/Nico/Desktop/FINALES IA NICO/FINAL INSTITUCIONES/bd.txt').

abrir_base_instituciones:- retractall(institutoSalud(_,_,_,_,_,_)),
						   consult('C:/Users/Nico/Desktop/FINALES IA NICO/FINAL INSTITUCIONES/bd_institutoSalud.txt')

opciones(1):- abrir_base, writeln('Ingrese una obra social: '),
			  read(OS),
			  writeln('Ingrese instituciones: '),
			  leer(ListaInstituciones),
			  obtenerInstitucionesCompatibles(ListaInstituciones,OS,ListaInstitucionesCompatibles),
			  writeln('Instituciones compatibles: '),
			  write(ListaInstitucionesCompatibles),nl.


opciones(2):- abrir_base,
			  writeln('Medicos que atienden en sector publico: '),
			  obtenerCantidadMedicos(Cantidad),
			  write(Cantidad),nl.


opciones(3):- abrir_base,
			  writeln('Ingrese OS: '),
              read(OS),
              writeln('Ingrese sector: '),
              read(Sector),
              obtenerInstitucionesCompatibles2(OS,Sector,ListaInstituciones),
              writeln('Instituciones compatibles son: '),
              write(ListaInstituciones),nl.

opciones(4):- abrir_base,
              writeln('Ingrese matricula de medico: '),
              read(Matricula),
              writeln('Ingrese OS: '),
              read(OS),
              obtenerInstitucionesCompatibles3(Matricula,OS,ListaInstituciones),
              write('Medico: '),writeln(Matricula),
              write('OS: '),writeln(OS),
              writeln('Listado instituciones donde atiende: '),
              write(ListaInstituciones),nl.
			  
			  
opciones(5):- abrir_base,
              writeln('Ingrese matricula de medico: '),
              read(Matricula),
              writeln('Ingrese OS: '),
              read(OS),
              obtenerInstitucionesCompatibles4(Matricula,OS,ListaInstituciones),
              write('Medico: '),writeln(Matricula),
              write('OS: '),writeln(OS),
              writeln('Listado instituciones donde atiende: '),
              write(ListaInstituciones),nl.



%% Ejercicio 1.
obtenerInstitucionesCompatibles([H|T],OS,[H|T2]):- institutoSalud(H,_,_,_,_,ListaObrasSociales),
                                                   pertenece(OS,ListaObrasSociales),
						  % retract(institutoSalud(H,_,_,_,_,ListaObrasSociales)),
                                                   obtenerInstitucionesCompatibles(T,OS,T2).
obtenerInstitucionesCompatibles([_|T],OS,T2):- obtenerInstitucionesCompatibles(T,OS,T2).
obtenerInstitucionesCompatibles([],_,[]).


%% Ejercicio 2.

obtenerCantidadMedicos(Cantidad):- medico(Matricula,_,_,ListaInstituciones),
								   contarInstitucionesPublicas(ListaInstituciones,Cant),
                                   Cant >=1,
                                   retract( medico(Matricula,_,_,ListaInstituciones)),
								   obtenerCantidadMedicos(CantidadA),
                                   Cantidad is CantidadA + 1.
obtenerCantidadMedicos(0).


contarInstitucionesPublicas([H|T],Cant):- institutoSalud(H,_,_,_,Sector,_),
										  Sector == 'publico',
										  %retract(institutoSalud(H,_,_,_,Sector,_)),
										  contarInstitucionesPublicas(T,CantA),
										  Cant is CantA + 1.
contarInstitucionesPublicas([_|T],Cant):-contarInstitucionesPublicas(T,Cant).
contarInstitucionesPublicas([],0).





obtenerInstitucionesCompatibles2(OS,Sector,[H|T]):- institutoSalud(H,_,_,_,Sector,ListaObrasSociales),
                                                    pertenece(OS,ListaObrasSociales),
                                                    retract(institutoSalud(H,_,_,_,Sector,ListaObrasSociales)),
                                                    obtenerInstitucionesCompatibles2(OS,Sector,T).
% obtenerInstitucionesCompatibles2(OS,Sector,[_|T]):-
% obtenerInstitucionesCompatibles2(OS,Sector,T).
obtenerInstitucionesCompatibles2(_,_,[]).




obtenerInstitucionesCompatibles3(Matricula, OS,ListaInstitucionesCompatibles):-
									medico(Matricula, _,_,ListaInstituciones),
									validarInstitucion(OS,ListaInstituciones,ListaInstitucionesCompatibles).

validarInstitucion(OS,[H|T],[H|T2]):- institutoSalud(H,_,_,_,_,ListaObraSociales),
                                      pertenece(OS,ListaObraSociales),
                                      validarInstitucion(OS,T,T2).
validarInstitucion(OS,[_|T],T2):- validarInstitucion(OS,T,T2).
validarInstitucion(_,[],[]).




obtenerInstitucionesCompatibles4(Matricula,OS,[H|T]):-  institutoSalud(H,_,_,_,_,ListaOS),
														pertenece(OS,ListaOS),
														medico(Matricula,_,_,ListaInstituciones),
														pertenece(H,ListaInstituciones),
														retract(institutoSalud(H,_,_,_,_,ListaOS)),
														obtenerInstitucionesCompatibles4(Matricula,OS,T).
obtenerInstitucionesCompatibles4(_,_,[]).



leer([H|T]):- read(H),H\=[],leer(T).
leer([]).

pertenece(H,[H|_]).
pertenece(X,[_|T]):- pertenece(X,T).
