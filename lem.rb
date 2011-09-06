require 'sinatra'
require 'sinatra/session'
require 'pg'
require 'json'


enable :sessions
set :session_fail, '/login'
set :session_secret, 'KniGht0fFlow3r$'


conn = PGconn.connect(
    :host => "localhost",   :port => 5432,      :dbname => "DSConnect",
    :user => "lem",         :password => "s"
    )

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
        session_start!
        session[:username] = params[:username]
        redirect '/'
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

helpers do
    include Rack::Utils
    
    alias_method :h, :escape_html

    def protected!
        unless authorized?
            throw :halt, [401, "You are denied access."]
        end
    end

    def authorized?
        session[:username] == 'lem'    
    end
end
