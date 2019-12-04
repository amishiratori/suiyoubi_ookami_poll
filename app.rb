require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require 'securerandom'
require 'sinatra/cookies'
require './models.rb'

helpers Sinatra::Cookies

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
  @mentors = Mentor.all
  erb :index
end