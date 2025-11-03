% Реализация предиката получения длины списка:
my_length([], 0).
my_length([_|X], N) :- my_length(X, N1), N is N1 + 1.

% Реализация предиката проверки принадлежности списоку:
my_member(A, [A|_]).
my_member(A, [_|Z]) :- my_member(A, Z).

% Реализация предиката конкатенации двух списков:
my_append([], X, X).
my_append([A|X], Y, [A|Z]) :- my_append(X, Y, Z).

% Реализация предиката удаления элемента из списка:
my_remove(X, [X|T], T).
my_remove(X, [Y|T], [Y|T1]) :- my_remove(X, T, T1).

% Реализация предиката получения всех перестановок элементов списка:
my_permute([], []).
my_permute(L, [X|T]) :- my_remove(X, L, R), my_permute(R, T).

% Реализация предиката проверки включения подсписка списка:
my_sublist(S, L) :- my_append(_, L1, L), my_append(S, _, L1).

% Реализация удаления последнего элемента:
my_last([X], X).

my_last([_|Tail], Last) :-
    my_last(Tail, Last).

% Реализация скалярного произведения
dot_product([], _, 0).
dot_product(_, [], 0).

dot_product([X1|T1], [X2|T2], Result) :-
    dot_product(T1, T2, PartialResult),
    Result is X1 * X2 + PartialResult.