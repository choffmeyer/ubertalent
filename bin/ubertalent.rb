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

  def jobs_page_data(title: '', category: '')
    if title.empty? && category.empty?
      jobs_paged = Job.where(published: 'true').desc('_id').to_a.each_slice(20).to_a
    elsif category.empty?
      jobs_paged = Job.where(published: 'true').where(job_title: /#{title}/i).desc('_id').to_a.each_slice(20).to_a
    elsif title.empty?
      jobs_paged = Job.where(published: 'true').where(category: category).desc('_id').to_a.each_slice(20).to_a
    else
      jobs_paged = Job.where(published: 'true').where(job_title: /#{title}/i, category: category).desc('_id').to_a.each_slice(20).to_a
    end
    {
      jobs_paged: jobs_paged,
      categories: Job.where(published: 'true').distinct(:category).to_a
    }
  end

  def add_page_to_fullpath(page_number, fullpath)
    fullpath = fullpath + '?' unless fullpath.include? '?'
    fullpath = fullpath.sub(/&page=\d+/, '') + "&page=#{page_number}"
  end
end

#### Routes

get '/' do
  @data = index_page_data
  erb :index
end

get '/jobs' do
  @query        = params[:query].to_s
  @category     = params[:category].to_s
  @data         = jobs_page_data(title: @query, category: @category)
  @current_page = (params[:page] ? params[:page] : 1).to_i
  @total_pages  = @data[:jobs_paged].size
  pass if @current_page < 1
  pass if @current_page > @total_pages
  erb :jobs
end

not_found do
  erb 404.to_s.to_sym
end
