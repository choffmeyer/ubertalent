#!/usr/bin/env ruby
# encoding: utf-8

$: << File.expand_path('../', File.dirname(__FILE__))

require 'sinatra'
require 'puma'
require 'gibbon'
require 'yaml'
require './db/mongo.rb'

#### Initialization

configure do
  $stdout.sync = true
  enable :sessions
  set :server,        'puma'
  set :views,         './views'
  set :public_folder, './public'
  set :mailchimp,     YAML.load(ERB.new(File.read './config/mailchimp.yml').result)
end

#### Helpers

helpers do
  def index_page_data
    {
      latest_jobs: Job.where(published: 'true').desc('_id').limit(10).to_a
    }
  end

  def jobs_page_data(title: '')
    if title.empty?
      jobs_paged = Job.where(published: 'true').desc('_id').to_a.each_slice(20).to_a
    else
      jobs_paged = Job.where(published: 'true').where(job_title: /#{title}/i).desc('_id').to_a.each_slice(20).to_a
    end
    {
      jobs_paged: jobs_paged
    }
  end

  def job_page_data(id: nil)
    {
      job: Job.where(id: id).to_a.first
    }
  end

  def campaign_page_data
    {
      jobs: Job.where(published: 'true').desc('_id')[0..9]
    }
  end

  def add_page_to_fullpath(page_number, fullpath)
    fullpath = fullpath + '?' unless fullpath.include? '?'
    fullpath = fullpath.sub(/&page=\d+/, '') + "&page=#{page_number}"
  end

  def add_subscriber(email, fname, lname, summary)
    Gibbon::Request.new(api_key: settings.mailchimp[:api_key]).lists(settings.mailchimp[:list_id]).members.create(body: {email_address: email, status: "subscribed", merge_fields: {FNAME: fname, LNAME: lname, SUMMARY: summary}})
  rescue Gibbon::MailChimpError => e
    {status: e.status_code, details: e.title}
  else
    {status: 200}
  end
end

#### Routes

get '/' do
  @data = index_page_data
  erb :index
end

post '/' do
  response = add_subscriber(params['form-email'], params['form-first-name'], params['form-last-name'], params['form-about-yourself'])
  if response[:status] == 200
    redirect "/thank_you"
  else
    session[:mailchimp_response] = response
    redirect "/error"
  end
end

get '/error' do
  @mailchimp_response = session[:mailchimp_response]
  erb :error
end

get '/thank_you' do
  erb 'thank_you'.to_sym
end

get '/jobs' do
  @query        = params[:query].to_s
  @data         = jobs_page_data(title: @query)
  @current_page = (params[:page] ? params[:page] : 1).to_i
  @total_pages  = @data[:jobs_paged].size
  pass if @current_page < 1
  pass if @current_page > @total_pages
  erb :jobs
end

get '/job' do
  id = params[:id].to_s
  pass if id.empty?
  @data = job_page_data(id: id)
  erb :job
end

get '/campaign' do
  @data = campaign_page_data
  erb :campaign, :layout => false
end

not_found do
  erb '404'.to_sym
end
