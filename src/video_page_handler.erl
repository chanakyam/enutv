-module(video_page_handler).
-author("shree@ybrantdigital.com").

-export([init/3]).

-export([content_types_provided/2]).
-export([welcome/2]).
-export([terminate/3]).

%% Init
init(_Transport, _Req, []) ->
	{upgrade, protocol, cowboy_rest}.

%% Callbacks
content_types_provided(Req, State) ->
	{[		
		{<<"text/html">>, welcome}	
	], Req, State}.

terminate(_Reason, _Req, _State) ->
	ok.

%% API
welcome(Req, State) ->
	{[{Id,VideoId}], Req2} = cowboy_req:bindings(Req),

	Url = string:concat("http://api.contentapi.ws/v?id=",binary_to_list(VideoId) ),
	{ok, "200", _, Response} = ibrowse:send_req(Url,[],get,[],[]),
	Res = string:sub_string(Response, 1, string:len(Response) -1 ),
	Params = jsx:decode(list_to_binary(Res)),

	Politics_News_Url = "http://api.contentapi.ws/news?channel=us_politics&limit=5&skip=0&format=short",
	{ok, "200", _, Response_Politics_News} = ibrowse:send_req(Politics_News_Url,[],get,[],[]),
	ResponseParams_Politics_News = jsx:decode(list_to_binary(Response_Politics_News)),	
	PoliticsNewsParams = proplists:get_value(<<"articles">>, ResponseParams_Politics_News),
	
	% {ok, Body} = video_page_dtl:render(Params),
	{ok, Body} = video_page_dtl:render([{<<"news">>, Params}, {<<"politicsnews">>,PoliticsNewsParams}]),
    {Body, Req2, State}.


 