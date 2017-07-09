require 'mongoid'

Mongoid.load!('./config/mongoid.yml')

class Job
  include Mongoid::Document

  field :job_title, type: String
  field :job_company, type: String
  field :job_location, type: String
  field :job_url, type: String
  field :job_id, type: String
  field :job_board, type: String
  field :job_board_url, type: String
  field :job_description, type: String
  field :published, type: String
  field :expired, type: String
  field :remote, type: String
  field :tags, type: String
  field :source, type: String

  validates_uniqueness_of :job_id
end
