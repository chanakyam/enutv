-module(news_get_all_by_category_handler).
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
	lager:info("List of Popular videos requested"),
	{Category, _} = cowboy_req:qs_val(<<"c">>, Req),
	{Skip, _ } = cowboy_req:qs_val(<<"skip">>, Req),
	{Limit, _ } = cowboy_req:qs_val(<<"perpage">>, Req),
	Url = case binary_to_list(Category) of 
		"World" ->
			%Category = "US",
			enutv_util:news_by_category_limit_skip("text_us_world","by_id_title_desc_thumb_date", binary_to_list(Skip), binary_to_list(Limit));
		"US" ->
			%Category = "US",
			enutv_util:news_by_category_limit_skip("text_us_domestic","by_id_title_desc_thumb_date", binary_to_list(Skip), binary_to_list(Limit));
			
		"Politics" ->
			%Category = "Politics",
			enutv_util:news_by_category_limit_skip("text_us_politics","by_id_title_desc_thumb_date", binary_to_list(Skip), binary_to_list(Limit));
			
		"Entertainment" ->
			%Category = "Entertainment",
			enutv_util:news_by_category_limit_skip("text_us_entertainment","by_id_title_desc_thumb_date", binary_to_list(Skip), binary_to_list(Limit));
		
		"Markets" ->
			%Category = "Entertainment",
			enutv_util:news_by_category_limit_skip("text_us_markets","by_id_title_desc_thumb_date", binary_to_list(Skip), binary_to_list(Limit));

		"Money" ->
			%Category = "Entertainment",
			enutv_util:news_by_category_limit_skip("text_us_money","by_id_title_desc_thumb_date", binary_to_list(Skip), binary_to_list(Limit));
		_ ->

			%Category = "None",
			lager:info("#########################None")

	end,
	{ok, "200", _, Response} = ibrowse:send_req(Url,[],get,[],[]),
	Res = string:sub_string(Response, 1, string:len(Response) -1 ),
	Body = list_to_binary(Res),
	{Body, Req, State}.


