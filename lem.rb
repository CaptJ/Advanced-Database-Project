require 'sinatra'
require 'sinatra/session'
require 'pg'
require 'json'
require 'rack-flash'
require 'sinatra/redirect_with_flash'

#require_relative 'dbaccess'
#conn = PGconn.connect(
#    :host => "localhost",   :port => 5432,      :dbname => "DSConnect",
#    :user => "lem",         :password => "s"
#    )

class PGresult
    def to_h(key_field='id')
        the_h = Hash.new

        self.each do |row|
            the_h[row[key_field]] = row
        end

        the_h
     end

     def to_a
        the_a = Array.new

        self.each do |row|
            the_a << row
        end

        the_a
     end

     def to_json(*a)
        self.to_a.to_json(*a)
     end
end

enable :sessions
set :session_secret, 'KniGht0fFlow3r$'
use Rack::Flash, :sweep => true



get '/' do 
    session!
    erb :"page/home"
end

get '/login' do
    if session?
        redirect '/'
    else
        erb :"page/login"
    end
end

post '/login' do
    if params[:username]
        #res = conn.exec("SELECT entity.login('#{params[:username]}','#{params[:password]}')")
        if params[:username] != 'lemonkoala' or params[:password] != 'w2e5'
            flash[:error] = 'Username or password invalid'
            redirect '/login'
        else
            session_start!
            session[:user_id] = 7
            session[:user_name] = 'Lem'
            redirect '/'
        end
    else
        redirect '/login'
    end
end

get '/logout' do
    session_end!
    redirect '/'
end

get '/protected' do
    session!
    protected!
    "Welcome, authenticated client"
end

get '/events.json' do
    [{
        :title   =>     "This is the revenge.",
        :thedate => { :month => 8, :day => 16, :year => 2011},
        :isWholeDay => true,
        :otherData => {},
        :displayDetails => { :backgroundColor => "#456789", :foregroundColor => "#123456" }
    },
    {
        :title      =>  "Indiana Jones and the Last Crusade",
        :thedate    =>  { :month => 8, :day => 24, :year => 2011},
        :isWholeDay =>  false,
        :otherData  =>  { :fname => "Indiana", :lname => "Jones", :artifact => "Holy Grail" },
        :displayDetails =>  { :backgroundColor => "#FF0000", :foregroundColor => "#FFFFFF"}
    }].to_json
end

not_found do
    status 404
    "Dunno whatcha talking about"
end

helpers do
    include Rack::Utils
    
    alias_method :h, :escape_html

    def partial (template, locals = {} )
        erb template, :layout => false, :locals => locals
    end

    def protected!
        unless authorized?
            throw :halt, [401, "You are denied access."]
        end
    end

    def authorized?
        session[:username] == 'lem'    
    end
end

