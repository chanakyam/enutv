-module(home_page_handler).
-author("chanakyam@koderoom.com").

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
	Url = "http://api.contentapi.ws/videos?channel=world_news&limit=1&skip=0&format=long",
	% io:format("movies url: ~p~n",[Url]),
	{ok, "200", _, Response_mlb} = ibrowse:send_req(Url,[],get,[],[]),
	ResponseParams_mlb = jsx:decode(list_to_binary(Response_mlb)),	
	[Params] = proplists:get_value(<<"articles">>, ResponseParams_mlb),

	World_News_Url = "http://api.contentapi.ws/news?channel=us_world&limit=5&skip=0&format=short",
	{ok, "200", _, Response_World_News} = ibrowse:send_req(World_News_Url,[],get,[],[]),
	ResponseParams_World_News = jsx:decode(list_to_binary(Response_World_News)),	
	WorldNewsParams = proplists:get_value(<<"articles">>, ResponseParams_World_News),

	US_News_Url = "http://api.contentapi.ws/news?channel=us_domestic&limit=5&skip=0&format=short",
	{ok, "200", _, Response_US_News} = ibrowse:send_req(US_News_Url,[],get,[],[]),
	ResponseParams_US_News = jsx:decode(list_to_binary(Response_US_News)),	
	USNewsParams = proplists:get_value(<<"articles">>, ResponseParams_US_News),

	Politics_News_Url = "http://api.contentapi.ws/news?channel=us_politics&limit=3&skip=0&format=short",
	{ok, "200", _, Response_Politics_News} = ibrowse:send_req(Politics_News_Url,[],get,[],[]),
	ResponseParams_Politics_News = jsx:decode(list_to_binary(Response_Politics_News)),	
	PoliticsNewsParams = proplists:get_value(<<"articles">>, ResponseParams_Politics_News),

	Entertainment_News_Url = "http://api.contentapi.ws/news?channel=us_entertainment&limit=5&skip=0&format=short",
	{ok, "200", _, Response_Entertainment_News} = ibrowse:send_req(Entertainment_News_Url,[],get,[],[]),
	ResponseParams_Entertainment_News = jsx:decode(list_to_binary(Response_Entertainment_News)),	
	EntertainmentNewsParams = proplists:get_value(<<"articles">>, ResponseParams_Entertainment_News),

	Market_News_Url = "http://api.contentapi.ws/news?channel=us_markets&limit=5&skip=0&format=short",
	{ok, "200", _, Response_Market_News} = ibrowse:send_req(Market_News_Url,[],get,[],[]),
	ResponseParams_Market_News = jsx:decode(list_to_binary(Response_Market_News)),	
	MarketNewsParams = proplists:get_value(<<"articles">>, ResponseParams_Market_News),

	Money_News_Url = "http://api.contentapi.ws/news?channel=us_money&limit=5&skip=0&format=short",
	{ok, "200", _, Response_Money_News} = ibrowse:send_req(Money_News_Url,[],get,[],[]),
	ResponseParams_Money_News = jsx:decode(list_to_binary(Response_Money_News)),	
	MoneyNewsParams = proplists:get_value(<<"articles">>, ResponseParams_Money_News),

	Trending_Videos_Url = "http://api.contentapi.ws/videos?channel=world_news&limit=4&skip=1&format=short",
	{ok, "200", _, Response_Trending_Videos} = ibrowse:send_req(Trending_Videos_Url,[],get,[],[]),
	ResponseParams_Trending_Videos = jsx:decode(list_to_binary(Response_Trending_Videos)),	
	TrendingVideosParams = proplists:get_value(<<"articles">>, ResponseParams_Trending_Videos),

	Latest_Videos_Url = "http://api.contentapi.ws/videos?channel=world_news&limit=3&skip=10&format=short",
	{ok, "200", _, Response_Latest_Videos} = ibrowse:send_req(Latest_Videos_Url,[],get,[],[]),
	ResponseParams_Latest_Videos = jsx:decode(list_to_binary(Response_Latest_Videos)),	
	LatestVideosParams = proplists:get_value(<<"articles">>, ResponseParams_Latest_Videos),

	{ok, Body} = index_dtl:render([{<<"videoParam">>,Params},{<<"worldnews">>,WorldNewsParams},{<<"usnews">>,USNewsParams},{<<"politicsnews">>,PoliticsNewsParams},{<<"entertainmentnews">>,EntertainmentNewsParams},{<<"marketnews">>,MarketNewsParams},{<<"moneynews">>,MoneyNewsParams},{<<"trendingvideos">>,TrendingVideosParams},{<<"latestvideos">>,LatestVideosParams}]),
    {Body, Req, State}.
