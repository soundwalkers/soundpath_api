#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

SoundpathApi::Application.load_tasks

RDoc::Task.new :rdoc do |rdoc|
  rdoc.main = "README.rdoc"

  rdoc.rdoc_files.include("README.rdoc", "doc/*.rdoc", "app/**/*.rb", "lib/*.rb", "config/**/*.rb")

  rdoc.title = "App Documentation"
  rdoc.rdoc_dir = 'public/html'
  rdoc.options << "--all" 
end
