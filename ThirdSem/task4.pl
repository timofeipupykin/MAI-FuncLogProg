init_state([st, s1, sh, s2, e, kr]).

goal_states([[st, s1, kr, s2, e, sh], [st, s2, kr, s1, e, sh]]).

is_goal(State) :-
    goal_states(Goals),
    member(State, Goals).

%1 2 3
%4 5 6

neighbors(1, [2,4]).
neighbors(2, [1,3,5]).
neighbors(3, [2,6]).
neighbors(4, [1,5]).
neighbors(5, [2,4,6]).
neighbors(6, [3,5]).

replace([_|T], 1, X, [X|T]).
replace([H|T], I, X, [H|R]) :-
    I > 1,
    I1 is I - 1,
    replace(T, I1, X, R).

find_index([H|_], H, 1) :- !.
find_index([_|T], Elem, I) :-
    find_index(T, Elem, I1),
    I is I1 + 1.

swap_positions(List, I, J, Result) :-
    nth1(I, List, AI),
    nth1(J, List, AJ),
    replace(List, I, AJ, Tmp),
    replace(Tmp, J, AI, Result).

move(State, NewState) :-
    find_index(State, e, Epos),
    neighbors(Epos, Neigh),
    member(P, Neigh),
    swap_positions(State, Epos, P, NewState).

show_board(State) :-
    State = [A,B,C,D,E,F],
    format('| ~w | ~w | ~w |~n', [A,B,C]),
    format('| ~w | ~w | ~w |~n', [D,E,F]).


dfs(State, _, _, [State]) :-
    is_goal(State).

dfs(State, GoalList, Visited, [State | Path]) :-
    move(State, Next),
    \+ member(Next, Visited),
    dfs(Next, GoalList, [Next | Visited], Path).

dfs_solve(State, Goals, Path) :-
    dfs(State, Goals, [State], Path).



iddfs(State, _, _, _, [State]) :-
    is_goal(State).

iddfs(State, GoalList, Visited, Limit, [State | Path]) :-
    Limit > 0,
    move(State, Next),
    \+ member(Next, Visited),
    Limit1 is Limit - 1,
    iddfs(Next, GoalList, [Next | Visited], Limit1, Path).

iddfs_solve(Start, Goals, Path) :-
    between(0, 1000, Limit),
    iddfs(Start, Goals, [Start], Limit, Path),
    !.


bfs([[State|RestPath] | _], _, [State|RestPath]) :-
    is_goal(State).

bfs([[State|RestPath] | OtherPaths], Visited, Solution) :-
    findall([Next,State|RestPath],
            ( move(State, Next),
              \+ member(Next, Visited)
            ),
            NewPaths),
    findall(Next, member([Next|_], NewPaths), NewStates),
    append(Visited, NewStates, Visited2),
    append(OtherPaths, NewPaths, Queue2),
    bfs(Queue2, Visited2, Solution).

bfs_solve(Start, Path) :-
    bfs([[Start]], [Start], Path).


write_path(Path) :-
    writeln('--- Solution (states from start to goal) ---'),
    forall(member(State, Path), (show_board(State), writeln(''))).


run :-
    init_state(Start),
    goal_states(Goals),
    format('Start:~n'), show_board(Start), nl,
    format('Goal1:~n'), show_board([st, s1, kr, s2, e, sh]), nl,
    format('Goal2:~n'), show_board([st, s2, kr, s1, e, sh]), nl,
    (   bfs_solve(Start, PathBFS) ->
        length(PathBFS, L1),
        format('BFS found path length=~w~n', [L1]),
        write_path(PathBFS);
        writeln('BFS: no solution')
    ),
    nl,
    (   iddfs_solve(Start, Goals, PathID) ->
        length(PathID, L2),
        format('IDDFS found path length=~w~n', [L2]),
        write_path(PathID);
        writeln('IDDFS: no solution')
    ),
    nl,
    (   dfs_solve(Start, Goals, PathDFS) ->
        length(PathDFS, L3),
        format('DFS returned path length=~w~n', [L3]),
        write_path(PathDFS);
        writeln('DFS: no solution within limit')
    ).

:- initialization(run).