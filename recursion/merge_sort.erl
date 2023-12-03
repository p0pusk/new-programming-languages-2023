-module(merge_sort).
-export([merge_sort/1, main/0]).

-record(structure, {key, value}).

% Merge Sort
merge_sort(List) when length(List) =< 1 ->
    List;
merge_sort(List) ->
    {First, Second} = split(List, length(List) div 2),
    merge(merge_sort(First), merge_sort(Second)).

% Split the list into two halves
split(List, N) when N > 0 ->
    {First, Second} = lists:split(N, List),
    {First, Second};
split(_, _) ->
    {[], []}.

% Merge two sorted lists
merge([], List) ->
    List;
merge(List, []) ->
    List;
merge([#structure{key = Key1, value = Value1} | Rest1], 
      [#structure{key = Key2, value = Value2} | Rest2]) when Key1 =< Key2 ->
    [#structure{key = Key1, value = Value1} |
     merge(Rest1, [#structure{key = Key2, value = Value2} | Rest2])];
merge(List1, [#structure{key = Key2, value = Value2} | Rest2]) ->
    [#structure{key = Key2, value =Value2} | merge(List1, Rest2)].

% Example usage
main() ->
    List = [#structure{key=3, value="C"},
            #structure{key=1, value="A"},
            #structure{key=5, value="E"},
            #structure{key=4, value="D"},
            #structure{key=2, value="B"}],
    SortedList = merge_sort(List),
    io:format("Sorted List: ~p~n", [SortedList]).

