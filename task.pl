solution :-
    People = [ [kondratev, Pk], [davydov, Pd], [fedorov, Pf] ],

    permutation([stolyar, malyar, vodoprovodchik], [Pk, Pd, Pf]),

    member([WhoStol, stolyar], People),
    member([WhoVod, vodoprovodchik], People),

    WhoStol \= WhoVod,

    member([WhoMalyar, malyar], People),

    WhoMalyar \= WhoStol,
    WhoMalyar \= WhoVod,

    % Условие: Фёдоров никогда не слышал о Давыдове.
    %если взять условие, что маляр знаком со столяром, и столяр живёт в доме водопроводчика, то маляр что-то слышал о каждом,
    %а следовательно Фёдоров не может быть маляром, так как не слышал о Давыдове 
    WhoMalyar \= fedorov,

    %Условие: столяр работает в доме водопроводчика.
    %если взять это условие, то получается, столяр и водопроводчик что-то о друг-друге слышали, а значит, если столяр Фёдоров,
    %то Давыдов не водопроводчик, и наоборот
    ( WhoStol == fedorov ->
        WhoVod \= davydov
    ; true ),
    ( WhoStol == davydov ->
        WhoVod \= fedorov
    ; true ),

    %если взять то же условие, то если Фёдоров столяр, то Давыдов не может быть Маляром,
    %так как иначе Фёдоров должен быть знаком с ним
    ( WhoStol == fedorov ->
        WhoMalyar \= davydov
    ; true ),

    write('kondratev - '), write(Pk), nl,
    write('davydov - '), write(Pd), nl,
    write('fedorov - '), write(Pf), nl.

:- initialization(solution).