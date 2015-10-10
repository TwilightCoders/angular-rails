# angular-rails <a href="http://badge.fury.io/rb/angular-rails"><img src="https://badge.fury.io/rb/angular-rails@2x.png" alt="Gem Version" height="18"></a>

angular-rails wraps the [Angular.js](http://angularjs.org) library for use in Rails 3.1 and above. Assets will minify automatically during production.

## Usage

Add the following to your Gemfile:

    gem 'angular-rails'

Add the following directive to your JavaScript manifest file (application.js):

    //= require angular/core

If you desire to require (optional) Angular files, you may include them as well in your JavaScript manifest file (application.js). For example:

    //= require angular/animate
    //= require angular/resource

To use the any internationalization/localization (i18n), you may include them as well in your JavaScript manifest file (application.js):

    //= require angular/i18n/en-us
    // ...
    //= require angular/i18n/ga

## Versioning

Every attempt is made to mirror the currently shipping Angular.js version number wherever possible.

The major, minor, and patch version numbers will always represent the Angular.js version.

## IMPORTANT: Requesting upgrades for new Angular.js versions

I've heavily adapted an auto-updater originally created by [Nick Clark](https://github.com/NickClark) that will upgrade the package to the latest version. To request that the latest version of Angular.JS be pushed as a gem to RubyGems, you're welcome to fork, run the updater, and then open a pull request, or you can open an issue.
