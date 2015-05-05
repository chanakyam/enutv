-module(tnc_page_handler).

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
	
	Video_Url = "http://api.contentapi.ws/videos?channel=world_news&limit=1&skip=8&format=long",
	% io:format("movies url: ~p~n",[Url]),
	{ok, "200", _, Response_Video} = ibrowse:send_req(Video_Url,[],get,[],[]),
	ResponseParams_Video = jsx:decode(list_to_binary(Response_Video)),	
	[VideoParams] = proplists:get_value(<<"articles">>, ResponseParams_Video),

	Trending_Videos_Url = "http://api.contentapi.ws/videos?channel=world_news&limit=5&skip=1&format=short",
	{ok, "200", _, Response_Trending_Videos} = ibrowse:send_req(Trending_Videos_Url,[],get,[],[]),
	ResponseParams_Trending_Videos = jsx:decode(list_to_binary(Response_Trending_Videos)),	
	TrendingVideosParams = proplists:get_value(<<"articles">>, ResponseParams_Trending_Videos),
	
	Politics_News_Url = "http://api.contentapi.ws/news?channel=us_politics&limit=5&skip=0&format=short",
	{ok, "200", _, Response_Politics_News} = ibrowse:send_req(Politics_News_Url,[],get,[],[]),
	ResponseParams_Politics_News = jsx:decode(list_to_binary(Response_Politics_News)),	
	PoliticsNewsParams = proplists:get_value(<<"articles">>, ResponseParams_Politics_News),

	% {ok, Body} = news_page_dtl:render(Params),
	{ok, Body} = tnc_dtl:render([{<<"videoParam">>,VideoParams}, {<<"trendingvideos">>,TrendingVideosParams}, {<<"politicsnews">>,PoliticsNewsParams}]),
    {Body, Req, State}.
	% {ok, Body} = tnc_dtl:render(),
    