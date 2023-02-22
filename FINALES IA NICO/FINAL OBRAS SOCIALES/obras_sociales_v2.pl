%persona(Dni,Nombre,Edad,ObraSocial,Plan).
%obraSocial(Obra,Plan, Medicamento, Porcentaje_Cobertura).

%1- devolver una lista con los DNI de las personas que tengan más de 65 años y cuyo plan cubra al menos 10 medicamentos al 100%.
%2- devolver los datos de aquellas personas que tengan más de una obra social.


:-dynamic (persona/5).
:-dynamic (obraSocial/4).
:-dynamic (obraSocialAux/4).

% Menu principal.
menu:- abrir_base,
	   writeln('Ingrese una opcion: '),
	   writeln('1 - Personas mayores de 65 anios con cobertura de al menos 10 medicamentos al 100%'),
	   writeln('2 - Personas con mas de una obra social'),
	   writeln('0 - Salir'),
	   read(Op),Op\=0, opciones(Op),menu.

menu:- writeln('Fin del programa.').

abrir_base :- retractall(persona(_,_,_,_,_)),
			  retractall(obraSocial(_,_,_,_)),
			  consult('C:/Users/Nico/Desktop/FINALES IA NICO/FINAL OBRAS SOCIALES/bd.txt').

abrir_base_obra_Social:- retractall(obraSocial(_,_,_,_)),
						 consult('C:/Users/Nico/Desktop/FINALES IA NICO/FINAL OBRAS SOCIALES/bd_obra_social.txt').
opciones(1):- abrir_base,
			  obtenerPersonasMayores(ListaPersonas),
	          writeln('Listado de personas mayores a 65 con cobertura de 10 medicamentos al 100%.'),nl,nl,
              writeln(ListaPersonas),nl,nl.

opciones(2):- abrir_base,
			  obtenerPersonasOS(ListaPersonas2),
              writeln('Personas con mas de una OS:'),
              writeln(ListaPersonas2),nl,nl.




obtenerPersonasMayores([H|T]):- persona(H,_,Edad,OS,Plan),
                                Edad > 65,
								abrir_base_obra_Social,
                                contarMedicamentos(OS,Plan,Cantidad),
                                Cantidad >= 3,
                                retract(persona(H,_,Edad,OS,Plan)),
                                obtenerPersonasMayores(T).
obtenerPersonasMayores([]).



contarMedicamentos(OS,Plan,Cantidad) :- obraSocial(OS,Plan,Medicamento,Porc),
										Porc == 100,
										retract(obraSocial(OS,Plan,Medicamento,Porc)),
										contarMedicamentos(OS,Plan, CantidadA),
										Cantidad is CantidadA + 1.
contarMedicamentos(_,_,0).



obtenerPersonasOS([H|T]):- contarOS(H,Cantidad),
                           Cantidad > 1,
                           obtenerPersonasOS(T).
obtenerPersonasOS([]).


contarOS(H, Cantidad):- persona(H,_,_,_,_),
                        retract(persona(H,_,_,_,_)),
                        contarOS(H,CantidadA),
                        Cantidad is CantidadA + 1.
contarOS(_,0).


pertenece(H,[H|_]).
pertenece(X,[_|T]):-pertenece(X,T).


