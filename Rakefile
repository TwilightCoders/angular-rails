#!/usr/bin/env rake
require 'bundler/gem_tasks'

require_relative 'lib/angular/updater'

desc 'Build/Upgrade Angular JS assets at specific version'
task :upgrade, [:version, :beta] do |_t, args|
  version = args[:version]
  beta = args[:beta]
  updater = Angular::Updater.new(version: version, beta: beta)
  updater.build
end

task :upgrade_stable, [:version, :beta] do |_t, args|
  version = args[:version]
  beta = args[:beta] || false
  updater = Angular::Updater.new(version: version, beta: beta)
  updater.build
end

task :bump, [:beta] do |_t, args|
  beta = args[:beta] || false
  updater = Angular::Updater.bump(beta: beta)
  updater.build
end

task :bulk do
  while updater = Angular::Updater.bump do
    version = updater.version
    `git checkout -B #{version.major}.#{version.minor}.x`
    updater.build
    `git add vendor/`
    `git add lib/angular/rails/version.rb`
    `git commit -m "Version #{version}"`
  end
end

desc 'Clean Angular JS assets'
task :clean do
  Angular::Updater.clean
end
