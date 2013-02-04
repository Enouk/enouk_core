%% Copyright
-module(gproc_test).
-author("marcus").

-include_lib("eunit/include/eunit.hrl").

%% @doc hello
simple_test() ->
  simple_test(),
  simple_test(),

  A = fun()->ok end,
  erlang:now(),
  ?assert(gproc:reg({c,l,c1}, 3) =:= true),
  ?assert(gproc:get_value({c,l,c1}) =:= 3).
