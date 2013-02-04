%% Copyright
%%
%% @doc desc
%%

-module(enouk_core_application_master_sup).
-behaviour(supervisor).
-export([init/1]).

%% ====================================================================
%% API functions
%% ====================================================================
-export([start_link/0, start_application_sup/1]).

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

start_application_sup(Application) ->
    ApplicationSup = {Application, {enouk_core_application_sup, start_link, [Application]},
    temporary, brutal_kill, supervisor, [enouk_core_application_sup]},

  error_logger:info_msg("Validate Child spec"),
  ok = supervisor:check_childspecs([ApplicationSup]),
  error_logger:info_msg("Start child spec"),
  supervisor:start_child(?MODULE, ApplicationSup).

%% ====================================================================
%% Behavioural functions 
%% ====================================================================

init([]) ->
    {ok, { {one_for_one, 5, 10}, []} }.
