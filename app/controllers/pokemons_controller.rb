class PokemonsController < ApplicationController

  def show
    require 'net/http'
    require 'uri'

    # クライアントを用意
    uri = URI.parse('https://pokeapi.co/api/v2/') #URI.parseは、URIオブジェクトを生成するメソッド。
    http = Net::HTTP.new(uri.host, uri.port) # HTTPクライアントを生成し、引数にホスト名とポート番号を指定している。
    http.use_ssl = true # httpsで通信をする場合はuse_sslをtrueにする

    # paramsの取得
    @birthdayS = params[:id].to_s
    @birthdayI = params[:id].to_i
    @birthM = @birthdayS[0,2]
    @birthD = @birthdayS[2,2]

    # リクエストの内容
    if date? == false
        redirect_to root_path, alert:"月日を正確に入力してください"
    elsif @birthdayS.length == 4 #マイナス値や3桁,5桁の数字を送られたときに弾く
      #レスポンスの設定
      get_request = Net::HTTP::Get.new("https://pokeapi.co/api/v2/pokemon/#{@birthdayI}", 'content-Type' => 'application/json') #JSON指定
      response = http.request(get_request) #http_clientオブジェクトを使用してget_requestを実行

      ###JP name###
      get_jp_request = Net::HTTP::Get.new("https://pokeapi.co/api/v2/pokemon-species/#{@birthdayI}", 'content-Type' => 'application/json') #JSON指定
      jp_response = http.request(get_jp_request) #http_clientオブジェクトを使用してget_requestを実行
      ### ####
      begin
        @jpdata = JSON.parse(jp_response.body) #jp-nameを含んだdataの抽出
        @data = JSON.parse(response.body) #pokemon-data(engのみ)の抽出
      rescue JSON::ParserError
        # redirect_to pokemons_noindex_path, id: params[:id]
        redirect_to controller: :pokemons,action: :noindex , id: params[:id]
      end
    else
        redirect_to root_path, alert:"4桁の半角数字で入力してください"
    end
  end

  def create
    @birthdayI = params[:birthday].to_i
    redirect_to controller: :pokemons ,action: :show, id: params[:birthday]
  end

  def noindex
    @birthdayS = params[:id].to_s
    @birthM = @birthdayS[0,2]
    @birthD = @birthdayS[2,2]

    require 'net/http'
    require 'uri'
    # クライアントを用意
    uri = URI.parse('https://pokeapi.co/api/v2/') #URI.parseは、URIオブジェクトを生成するメソッド。
    http = Net::HTTP.new(uri.host, uri.port) # HTTPクライアントを生成し、引数にホスト名とポート番号を指定している。
    http.use_ssl = true # httpsで通信をする場合はuse_sslをtrueにする
    #リクエストを登録
    get_item_request = Net::HTTP::Get.new("https://pokeapi.co/api/v2/item/4", 'content-Type' => 'application/json') #JSON指定
    item_response = http.request(get_item_request) #http_clientオブジェクトを使用してget_requestを実行
    @item = JSON.parse(item_response.body)
  end

private
  def date?
    case @birthM.to_i
      when 1,3,5,7,8,10,12 then @birthD.to_i.between?(1,31)
      when 4,6,9,11 then @birthD.to_i.between?(1,30)
      when 2 then @birthD.to_i.between?(1,29)
      else false
    end
  end

end
