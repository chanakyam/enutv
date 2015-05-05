-module(news_topnews_handler).
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
		{<<"application/json">>, welcome}	
	], Req, State}.

terminate(_Reason, _Req, _State) ->
	ok.

%% API
welcome(Req, State) ->
	{Count, _ } = cowboy_req:qs_val(<<"n">>, Req),
	{Category, _ } = cowboy_req:qs_val(<<"c">>, Req),
	% lager:info("Top 10 News items requested"),
	Url = case binary_to_list(Category) of 
		"World" ->
			%Category = "US",
			"http://api.contentapi.ws/news?channel=us_world&limit=5&skip=0&format=short";
		"US" ->
			%Category = "US",
			"http://api.contentapi.ws/news?channel=us_domestic&limit=5&skip=0&format=short";
			
		"Politics" ->
			%Category = "Politics",
			"http://api.contentapi.ws/news?channel=us_politics&limit=5&skip=0&format=short";
			
		"Entertainment" ->
			%Category = "Entertainment",
			"http://api.contentapi.ws/news?channel=us_entertainment&limit=5&skip=0&format=short";
		
		"Markets" ->
			%Category = "Entertainment",
			"http://api.contentapi.ws/news?channel=us_markets&limit=5&skip=0&format=short";
		
		"Money" ->
			%Category = "Entertainment",
			"http://api.contentapi.ws/news?channel=us_money&limit=5&skip=0&format=short";
		_ ->
			%Category = "None",
			lager:info("#########################None")

	end,

	{ok, "200", _, Response_mlb} = ibrowse:send_req(Url,[],get,[],[]),
	Body = list_to_binary(Response_mlb),
	{Body, Req, State}.

