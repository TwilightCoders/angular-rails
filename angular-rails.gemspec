# -*- encoding: utf-8 -*-
require File.expand_path('../lib/angular/rails/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = 'angular-rails'
  s.version     = Angular::Rails::VERSION
  s.date        =  Time.new.strftime('%Y-%m-%d')
  s.summary     = 'Angular.js on Rails'
  s.description = 'The angular.js JavaScript library ready to play with the Rails Asset Pipeline'
  s.authors     = ['Dale Stevens']
  s.email       = 'dale@twilightcoders.net'
  s.files       = Dir['{lib,vendor}/**/*'] + ['MIT-LICENSE', 'README.md']
  s.homepage    = 'https://github.com/twilightcoders/angular-rails/'
  s.license     = 'MIT'

  s.add_development_dependency  'rake'
  s.add_development_dependency  'versionomy'
  s.add_development_dependency  'nokogiri'
  s.add_development_dependency  'highline'
end
