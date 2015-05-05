-module(news_categories_handler).
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
	{[{Name,Value}], Req2} = cowboy_req:bindings(Req),
	{Page, PageNumber} = cowboy_req:qs_val(<<"page">>, Req),
	SkipItems = (list_to_integer(binary_to_list(Page))-1) * 15,
	Url = case binary_to_list(Value) of 
		"World" ->
			%Category = "US",
			string:concat("http://api.contentapi.ws/news?channel=us_world&limit=30&format=short&skip=",integer_to_list(SkipItems));
		
		"US" ->
			%Category = "US",
			string:concat("http://api.contentapi.ws/news?channel=us_domestic&limit=30&format=short&skip=",integer_to_list(SkipItems));
		
		"Politics" ->
			%Category = "Politics",
			string:concat("http://api.contentapi.ws/news?channel=us_politics&limit=30&format=short&skip=",integer_to_list(SkipItems));
		
		"Entertainment" ->
			%Category = "Entertainment",
			string:concat("http://api.contentapi.ws/news?channel=us_entertainment&limit=30&format=short&skip=",integer_to_list(SkipItems));
		
		"Markets" ->
			%Category = "Entertainment",
			string:concat("http://api.contentapi.ws/news?channel=us_markets&limit=30&format=short&skip=",integer_to_list(SkipItems));
		
		"Money" ->
			%Category = "Entertainment",
			string:concat("http://api.contentapi.ws/news?channel=us_money&limit=30&format=short&skip=",integer_to_list(SkipItems));
		_ ->

			%Category = "None",
			lager:info("#########################None")

	end,

	% for videos

	Video_Url = case binary_to_list(Value) of 
		"World" ->
			%Category = "US",
			"http://api.contentapi.ws/videos?channel=world_news&limit=1&skip=1&format=long";
		"US" ->
			%Category = "US",
			"http://api.contentapi.ws/videos?channel=world_news&limit=1&skip=2&format=long";
			
		"Politics" ->
			%Category = "Politics",
			"http://api.contentapi.ws/videos?channel=world_news&limit=1&skip=3&format=long";
			
		"Entertainment" ->
			%Category = "Entertainment",
			"http://api.contentapi.ws/videos?channel=world_news&limit=1&skip=4&format=long";
		
		"Markets" ->
			%Category = "Entertainment",
			"http://api.contentapi.ws/videos?channel=world_news&limit=1&skip=5&format=long";
		
		"Money" ->
			%Category = "Entertainment",
			"http://api.contentapi.ws/videos?channel=world_news&limit=1&skip=6&format=long";
		_ ->

			%Category = "None",
			lager:info("#########################None")

	end,
	{ok, "200", _, Response} = ibrowse:send_req(Url,[],get,[],[]),
	ResponseParams = jsx:decode(list_to_binary(Response)),	
	ParamsAllNews = proplists:get_value(<<"articles">>, ResponseParams),

	% Video_Url = "http://api.contentapi.ws/videos?channel=world_news&limit=1&skip=0&format=long",
	% io:format("movies url: ~p~n",[Url]),
	{ok, "200", _, Response_Video} = ibrowse:send_req(Video_Url,[],get,[],[]),
	ResponseParams_Video = jsx:decode(list_to_binary(Response_Video)),	
	[Params] = proplists:get_value(<<"articles">>, ResponseParams_Video),

	Politics_News_Url = "http://api.contentapi.ws/news?channel=us_politics&limit=5&skip=0&format=short",
	{ok, "200", _, Response_Politics_News} = ibrowse:send_req(Politics_News_Url,[],get,[],[]),
	ResponseParams_Politics_News = jsx:decode(list_to_binary(Response_Politics_News)),	
	PoliticsNewsParams = proplists:get_value(<<"articles">>, ResponseParams_Politics_News),

	Latest_Videos_Url = "http://api.contentapi.ws/videos?channel=world_news&limit=5&skip=10&format=short",
	{ok, "200", _, Response_Latest_Videos} = ibrowse:send_req(Latest_Videos_Url,[],get,[],[]),
	ResponseParams_Latest_Videos = jsx:decode(list_to_binary(Response_Latest_Videos)),	
	LatestVideosParams = proplists:get_value(<<"articles">>, ResponseParams_Latest_Videos),
	
	{ok, Body} = news_categories_page_dtl:render([{<<"videoParam">>,Params},{<<"titles">>, ParamsAllNews}, {<<"category">>, binary_to_list(Value) },{<<"politicsnews">>,PoliticsNewsParams},{<<"latestvideos">>,LatestVideosParams}]),
    {Body, Req2, State}.
    


