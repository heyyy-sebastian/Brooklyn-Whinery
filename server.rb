module Sinatra
  require 'bcrypt'

  class Server < Sinatra::Base

    enable :sessions
    set :method_override, true

    ####################################
    #### INITIALIZE MARKDOWN PARSER ####
    ####################################

    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)

    ###############################
    #### LANDING PG & PROD ENV ####
    ###############################

    get "/" do
      erb :index
    end

    if ENV["RACK_ENV"] == 'production'
      conn = PG.connect(
        dbname: ENV["POSTGRES_DB"],
        host: ENV["POSTGRES_HOST"],
        password: ENV["POSTGRES_PASS"],
        user: ENV["POSTGRES_USER"]
      )
    else
      conn = PG.connect({dbname: "bk_whinery"})
    end

    #######################
    #### LOGIN METHODS ####
    #######################

    def logged_in?
      @author = session[:user_id]
    end

    def current_user
      @current_user ||= conn.exec("SELECT * FROM users WHERE id=#{session[:user_id]}").first
    end

    get "/login" do
      if logged_in?
        erb :allmenus
      else
        erb :login
      end
    end

    post "/login" do
      @email = params[:email]
      @password = params[:password]

      @user = conn.exec_params(
        "SELECT * FROM users WHERE email=$1 LIMIT 1",
        [@email]
      ).first

      if @user && BCrypt::Password::new(@user["password_digest"]) == params[:password]
        session[:user_id] = @user["id"]
        redirect "/allmenus"
      else
        "Incorrect email or password!"
      end
    end

    #Figure out a better signout method?
    #get "/signout" do
     # logged_in? = false
     #redirect "/"
    #end

    ########################
    #### SIGNUP METHODS ####
    ########################

    get "/signup" do
      erb :signup
    end

    post "/signup" do
      @name = params[:name]
      @email = params[:email]
      @password_digest = BCrypt::Password::create(params[:password])

      conn.exec_params(
        "INSERT INTO users (name, email, password_digest) VALUES ($1, $2, $3)",
        [@name, @email, @password_digest]
      )

      @created = true
      erb :signup
    end

    ###############################
    #### LIST-ALL-MENUS METHOD ####
    ###############################

    get "/allmenus" do
      if logged_in?
        @menus = conn.exec("SELECT * FROM menus")
        @menus_likes = conn.exec("SELECT * FROM menus ORDER BY vote ASC LIMIT 6")
        @menus_comments = conn.exec("SELECT * FROM menus ORDER BY num_comments ASC LIMIT 6")
        erb :allmenus
      else
        erb :login
      end
    end

    #########################
    #### MAKE A NEW MENU ####
    #########################

    get "/makemenu" do
      erb :makemenu
    end

    post "/makemenu" do
      @title = params[:title]
      @mood = params[:mood]
      @color = params[:color]

      if @color == "both"
        @newmenu = conn.exec_params("SELECT * FROM wines WHERE mood=$1 ORDER BY RANDOM() LIMIT 3", [@mood])
        @winearray = @newmenu.map do |wine|
          wine["id"]
        end
        conn.exec_params("INSERT INTO menus(author_id, title, wine_a, wine_b, wine_c) VALUES('#{logged_in?}',$1, '#{@winearray[0]}', '#{@winearray[1]}', '#{@winearray[2]}' )", [@title])
        @add_menu = conn.exec_params("SELECT id FROM menus WHERE title='#{@title}'")
        @created = true
      elsif
        @newmenu = conn.exec_params("SELECT * FROM wines WHERE mood=$1 AND color=$2 ORDER BY RANDOM() LIMIT 3", [@mood, @color])
        @winearray = @newmenu.map do |wine|
          wine["id"]
        end
        conn.exec_params("INSERT INTO menus(author_id, title, wine_a, wine_b, wine_c) VALUES('#{logged_in?}',$1, '#{@winearray[0]}', '#{@winearray[1]}', '#{@winearray[2]}' )", [@title])
        @add_menu = conn.exec_params("SELECT id FROM menus WHERE title='#{@title}'")
        @created = true
      end

      if @created
      @id = @add_menu[0]["id"].to_i
      redirect "/allmenus/#{@id}"
    else
      redirect "/makemenu"
    end

    end

    ###############################
    #### VIEW INDIVIDUAL MENUS ####
    ###############################

    get "/allmenus/:id" do
      @menu = conn.exec_params("SELECT * FROM menus WHERE id=$1", [params[:id]]).first
      @wine_a = conn.exec("SELECT * FROM wines WHERE id=#{@menu["wine_a"]}")
      @wine_b = conn.exec("SELECT * FROM wines WHERE id=#{@menu["wine_b"]}")
      @wine_c = conn.exec("SELECT * FROM wines WHERE id=#{@menu["wine_c"]}")
      ## THIS BECOMES AN ARRAY where each hash is the wine object from the wines table
      @comments = conn.exec_params("SELECT * FROM comments WHERE menu_id=$1", [@menu["id"]])
      @comments_md = @comments.map{ |comments|
        markdown.render(comments["description"])
      }
      erb :menu
    end

    #######################
    #### VOTE ON MENUS ####
    #######################

    put '/upvote' do
      menu_id = params['menu_id']
      @vote = params['vote']

      if @vote == "Cheers"
      conn.exec_params("UPDATE menus SET vote = vote + 1 WHERE id = $1", [menu_id])
      end

      redirect "/allmenus/#{menu_id}"
    end

    ###############################
    #### ADD & UPDATE COMMENTS ####
    ###############################

    post '/addcomment' do

      author_id = logged_in?
      description = params['description']
      menu_id = params['menu_id']

      @comment = conn.exec_params("INSERT INTO comments (menu_id, author_id, description) VALUES ($1, $2, $3)",[menu_id, author_id, description])
      conn.exec_params("UPDATE menus SET num_comments = num_comments +1 WHERE id = $1", [menu_id])

      redirect "/allmenus/#{menu_id}"
    end

 ##Don't move these two end statements
  end
end
