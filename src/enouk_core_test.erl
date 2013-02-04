-module(enouk_core_test).

-include_lib("eunit/include/eunit.hrl").

simple_test() ->
  enouk_core:start(),
	ok = enouk_core:load_application(test_app),
	{ok, InstanceId} = enouk_core:new_application_instance(test_app),

	{ok, AdamSessionId} = enouk_core:join_instance(InstanceId, <<"Adam">>),
	{ok, EvaSessionId} = enouk_core:join_instance(InstanceId, <<"Eva">>),

	{ok, Info} = enouk_core:get_instance_info(InstanceId),

	enouk_core:send_command(AdamSessionId, <<"Sten">>),
	enouk_core:send_command(EvaSessionId, <<"Sax">>),

	{ok, Events} = enouk_core:get_instance_info(InstanceId).

