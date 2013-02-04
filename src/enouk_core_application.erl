-module(enouk_core_application).

-behaviour(gen_server).

%% behaviour
-export([behaviour_info/1]).

%% API
-export([start_link/3, join/2]).

%% gen_server callbacks
-export([init/1,
  handle_call/3,
  handle_cast/2,
  handle_info/2,
  terminate/2,
  code_change/3]).

-record(state, {application, id, module}).

%%%===================================================================
%%% behaviour API
%%%===================================================================
-spec behaviour_info(atom()) -> 'undefined' | [{atom(), arity()}].
behaviour_info(callbacks) ->
  [{init, 1},
    {handle_join, 1},
    {handle_command, 2}];
behaviour_info(_Other) ->
  undefined.

%%%===================================================================
%%% API
%%%===================================================================

start_link(ApplicationName, Id, ApplicationModule) ->
  gen_server:start_link(?MODULE, [ApplicationName, Id, ApplicationModule], []).

join(InstanceId, UserId) ->
  %% Fetch the pid of the instance
  Pid = gproc:lookup_pid({instance_id, InstanceId}),
  %% Call the application for join
  Response = gen_server:call(Pid, {join, UserId}),
  %% Register for updates on this instance
  gproc:reg({p, l, {subscribe, InstanceId}}),
  Response.

get_all_instances(ApplicationName) ->
  MatchHead = [{'application', ApplicationName}, '_'],
  Guard = [],
  Result = ['$$'],
  gproc:select(names, [{MatchHead, Guard, Result}]).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

init([ApplicationName, InstanceId, ApplicationModule]) ->
  gproc:reg({n, l, [{application, ApplicationName},{instance_id, InstanceId}]}, InstanceId),
  {ok, #state{application = ApplicationName, id = InstanceId, module = ApplicationModule}}.

handle_call(_Request, _From, State) ->
  Reply = ok,
  {reply, Reply, State}.


handle_cast(_Msg, State) ->
  {noreply, State}.


handle_info(_Info, State) ->
  {noreply, State}.


terminate(_Reason, _State) ->
  ok.


code_change(_OldVsn, State, _Extra) ->
  {ok, State}.
