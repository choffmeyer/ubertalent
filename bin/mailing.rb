#!/usr/bin/env ruby
# encoding: utf-8

$: << File.expand_path('../', File.dirname(__FILE__))

require 'gibbon'
require 'yaml'
require 'erb'
require './db/mongo.rb'

#### Initialization
mailchimp  = YAML.load(ERB.new(File.read './config/mailchimp.yml').result)
gibbon     = Gibbon::Request.new(api_key: mailchimp[:api_key])

#### Getting subscribers data
total_subs = gibbon.lists(settings.mailchimp[:list_id]).members.retrieve(params: {"status": "subscribed"}).body["total_items"]
