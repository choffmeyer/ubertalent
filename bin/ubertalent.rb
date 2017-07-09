#!/usr/bin/env ruby
# encoding: utf-8

$: << File.expand_path('../', File.dirname(__FILE__))

require 'sinatra'
require 'puma'
require './db/mongo.rb'

#### Initialization

configure do
  $stdout.sync = true
  set :server,        'puma'
  set :views,         './views'
  set :public_folder, './public'
end

#### Helpers

helpers do
  def index_page_data
    {
      latest_jobs: Job.where(published: 'true').desc('_id').limit(10).to_a
    }
  end

  def jobs_page_data
    {
      latest_jobs_paged: Job.where(published: 'true').desc('_id').to_a.each_slice(20).to_a
    }
  end
end

#### Routes

get '/' do
  @data = index_page_data
  erb :index
end

get '/jobs' do
  @page_n = (params[:page] ? params[:page] : 1).to_i
  @query  = params[:query]
  @data   = jobs_page_data
  pass if @page_n < 1
  pass if @page_n > @data[:latest_jobs_paged].size
  erb :jobs
end
