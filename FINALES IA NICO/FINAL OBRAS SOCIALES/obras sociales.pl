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
			  retractall(obrasocial(_,_,_,_)),
			  consult('C:/Users/Nico/Desktop/FINALES IA NICO/FINAL OBRAS SOCIALES/bd.txt').


opciones(1):- obtenerPersonasMayores(ListaPersonas),
	      writeln('Listado de personas mayores a 65 con cobertura de 10 medicamentos al 100%.'),nl,nl,
              writeln(ListaPersonas),nl,nl.

opciones(2):- obtenerPersonasOS(ListaPersonas2),
              writeln('Personas con mas de una OS:'),
              writeln(ListaPersonas2),nl,nl.

obtenerPersonasMayores([H|T]):- persona(H,_,Edad,OS,Plan),
                                Edad > 65,
                                getObrasSociales,
                                contarMedicamentos(OS,Plan,Cantidad),
                                write('Persona: '),writeln(H),
                                write('Cantidad: '),writeln(Cantidad),
                                write('OS: '),writeln(OS),
                                write('Plan: '),writeln(Plan),nl,nl,
                                Cantidad >= 3,
                                retract(persona(H,_,Edad,OS,Plan)),
                                obtenerPersonasMayores(T).
%%obtenerPersonasMayores([_|T]):-obtenerPersonasMayores(T).
obtenerPersonasMayores([]).



contarMedicamentos(OS,Plan,Cantidad) :- obraSocialAux(OS,Plan,Medicamento,100),
				        retract(obraSocialAux(OS,Plan,Medicamento,100)),
					contarMedicamentos(OS,Plan, CantidadAnt),
					Cantidad is CantidadAnt + 1.
contarMedicamentos(_,_,0).



% Mirar este predicado, porque cuando vas validando y haciendo retract,
% estas eliminando los predicados en memoria. Eso implica que cuando
% valides a una segunda persona con el mismo plan, no tenga hechos en
% memoria y no la considere en el listado.
%
% Para eso usar este predicado que lo usa de auxiliar en cada corrida.
% cada vez que llamamos a la opcion 1, toma la carga de obrasSociales y
% la mete en un predicado auxiliar. Luego de eso , elcontador de
% medicamentos actua en ese predicado con el retract, dejando intacto el
% original para otra persona.
getObrasSociales:-
    retractall(obraSocialAux(_,_,_,_)),
    obraSocial(OS,Plan,Med,Porc),
    assert(obraSocialAux(OS,Plan,Med,Porc)),
    fail.
getObrasSociales.

obtenerPersonasOS([H|T]):- contarOS(H,Cantidad),
                           Cantidad > 1,
                           obtenerPersonasOS(T).
obtenerPersonasOS([]).



contarOS(H, Cantidad):- persona(H,_,_,_,_),
                        retract(persona(H,_,_,_,_)),
                        contarOS(H,CantidadA),
                        Cantidad is CantidadA + 1.
contarOS(_,0).
