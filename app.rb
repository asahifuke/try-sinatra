# frozen_string_literal: true

require_relative './memo'
require 'pg'
require 'sinatra'
require 'sinatra/reloader'
require 'erb'

Object.include ERB::Util

CONN ||= PG.connect(dbname: 'db_usage')
unless CONN.exec('SELECT * FROM information_schema.tables WHERE table_name = $1;', ['memos'])
  CONN.exec('create table memos (id serial, title text, body text, primary key(id));')
end

get '/' do
  @memos = Memo.all
  erb :index
end

get '/memos/new' do
  erb :new
end

post '/memos' do
  @memo = Memo.new(title: params[:title], body: params[:body])
  @memo.save
  redirect '/'
end

get '/memos/:id' do
  @memo = Memo.find(params[:id])
  erb :show
end

get '/memos/:id/edit' do
  @memo = Memo.find(params[:id])
  erb :edit
end

patch '/memos/:id' do
  @memo = Memo.find(params[:id])
  @memo.title = params[:title]
  @memo.body = params[:body]
  @memo.save
  redirect "/memos/#{@memo.id}"
end

delete '/memos/:id' do
  @memo = Memo.find(params[:id])
  @memo.destory
  redirect '/'
end
