-module(enouk_core).

-export([start/0, stop/0, start_application/1, start_instance/1, join_instance/2, get_all_instances/1]).

start() ->
  application:start(enouk_core, permanent).

stop() ->
  application:stop(enouk_core).

start_application(ApplicationName) ->
  case enouk_core_application_master_sup:start_application_sup(ApplicationName) of
    {error, Msg} -> {error, Msg};
    _ ->
      application:start(ApplicationName),
      true = gproc:reg({c, l, ApplicationName}, 0)
  end.

start_instance(ApplicationName) ->
  Id = gproc:update_counter({c, l, ApplicationName}, 1),
  enouk_core_application_sup:start_instance(ApplicationName, Id).

join_instance(InstanceId, UserId) ->
  enouk_core_application:join(InstanceId, UserId).

get_all_instances(ApplicationName) ->
  enouk_core_application:get_all_instances(ApplicationName).

get_instance_info(InstanceId) ->
  ok.

