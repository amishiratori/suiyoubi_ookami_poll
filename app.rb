require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require 'dotenv'
require 'securerandom'
require 'sinatra/cookies'
require './models.rb'

helpers Sinatra::Cookies

helpers do
  Dotenv.load
  def protect!
    unless authorized?
      response['WWW-Authenticate'] = %(Basic realm="Restricted Area")
      throw(:halt, [401, "Not authorized\n"])
    end
  end
  def authorized?
    @auth ||=  Rack::Auth::Basic::Request.new(request.env)
    username = ENV['BASIC_AUTH_USERNAME']
    password = ENV['BASIC_AUTH_PASSWORD']
    @auth.provided? && @auth.basic? && @auth.credentials && @auth.credentials == [username, password]
  end
end

before do
  unless cookies[:uuid]
    cookies[:uuid] = SecureRandom.uuid
  end
end

get '/' do
  @mentors = Mentor.all
  erb :index
end

post '/vote/:id' do
  uuid = cookies[:uuid]
  mentor = Mentor.find(params[:id])
  vote = mentor.mentors_uuids.find_by(uuid: uuid)
  if vote
    if Time.now - vote.created_at > 3600
      vote.destroy
      mentor.mentors_uuids.create(uuid: uuid)
      mentor.update_column(:votes, mentor.votes + 1)
      return 'success'
    else
      return 'failed'
    end
  else
    mentor.mentors_uuids.create(uuid: uuid)
    mentor.update_column(:votes, mentor.votes + 1)
    return 'success'
  end
end

get '/admin' do
  protect!
  @mentors = Mentor.all
  erb :index
end