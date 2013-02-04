%% Copyright
%%
%% @doc desc
%%

-module(enouk_core_application_sup).
-behaviour(supervisor).
-export([init/1]).

%% ====================================================================
%% API functions
%% ====================================================================
-export([start_link/1, start_instance/2]).

start_link(Application) when is_atom(Application) ->
  supervisor:start_link({local, Application}, ?MODULE, []).

start_instance(Application, Id) when is_atom(Application) ->
  case application:get_env(Application, enouk_core) of
    {ok, ApplicationModule} ->
      case supervisor:start_child(Application, [Application, Id, ApplicationModule]) of
        {ok, _Pid} -> ok;
        Error -> Error
      end;
    _ -> {error, application_module_not_specified}
  end.


%% ====================================================================
%% Behavioural functions 
%% ====================================================================

init([]) ->
  Spec = {enouk_core_application, {enouk_core_application, start_link, []},temporary, brutal_kill, worker, [enouk_core_application]},
  {ok, {{simple_one_for_one, 5, 10}, [Spec]}}.

%% ====================================================================
%% Internal functions
%% ====================================================================