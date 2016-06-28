require 'pathname'
require 'bundler'

Bundler.require(:default, ENV['RACK_ENV'] || :production)
ROOT = Pathname.new(File.expand_path('../..', __FILE__))
Grape::ActiveRecord.configure_from_file! ROOT.join('config', 'database.yml')
Dir.glob(ROOT.join('app', 'models', '*.rb')).each { |file| require file }
Dir.glob(ROOT.join('app', 'helpers', '*.rb')).each { |file| require file }
Dir.glob(ROOT.join('app', '*.rb')).each { |file| require file }