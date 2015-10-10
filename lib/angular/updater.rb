require 'nokogiri'
require 'open-uri'
require 'versionomy'
require 'pathname'
require 'tempfile'
require 'highline/import'
require 'pry'

# Run with `ruby -r "./tasks/angular-rails/updater.rb" -e "AngularJS::Rails::Updater.new.build_js('1.2.28')"`
module Angular
  BASE_URL = 'https://code.angularjs.org'

  class Updater
    ROOT_PATH = Pathname.new('vendor/assets/javascripts/angular')
    I18N_PATH = Pathname.new('vendor/assets/javascripts/angular/i18n')

    def self.bump(beta: nil)
      version = Versionomy.parse(Angular::Rails::VERSION)
      beta = version.release_type != :final if beta.nil?

      list = if beta
        Angular.upstream_versions
      else
        Angular.stable_versions
      end

      index = list.find_index(version)
      bump = list.at(index + 1)

      self.new(version: bump.to_s, beta: beta)
    end

    def initialize(version: nil, beta: nil)
      @beta = Updater.to_bool(beta)
      check_version(version, @beta)
    end

    def check_version(version=nil, beta=nil)
      version = !version.to_s.strip.split(//).empty? ? version : Angular.latest_version(beta)

      @version = case Updater.to_bool(beta)
      when true
        find_version version, Angular.beta_versions
      when false
        find_version version, Angular.stable_versions
      when nil
        find_version version, Angular.upstream_versions
      end
      puts @version
    end

    def find_version(version, list)
      match = list.find { |v| v.to_s == version.to_s }

      unless match
        matches = list.select do |v|
          v.to_s =~ /#{version.to_s}/
        end

        choose do |menu|
          menu.prompt = "Which one did you mean? "
          matches.each do |match|
            menu.choice(match) { return match }
          end
          menu.choice(:abort) { exit }
        end unless matches.empty?

        puts "Sorry, couldn't find any matches."
        exit
      end

      return match
    end

    def build
      Updater.clean
      download_files
      write_gem_version
    end

    def version_constant_name
      "VERSION"
    end

    def self.clean
      Dir.glob("#{ROOT_PATH}/**/*").each do |f|
        File.delete(f) if File.file?(f)
      end
    end

    private

    def self.to_bool(s)
      return nil unless s.class == String
      return true if s =~ /^(true|t|yes|y|1)$/i
      return false if s.empty? || s =~ /^(false|f|no|n|0)$/i
      return nil
    end

    def write_gem_version
      # /(\d(?:\.\d){0,2})(.*)/
      version_file = Pathname.new('lib/angular/rails/version.rb')
      content = version_file.read
      version_line = content.lines.find { |l| l =~ /^\s+#{version_constant_name}/ }
      new_version_line = version_line.gsub(/'[^']*'/, %Q{'#{@version}'})
      version_file.open('w+') do |f|
        f.write content.gsub(version_line, new_version_line)
      end
    end

    def download_files
      download_base_files
      download_i18n_files
    end

    def download_base_files
      url = BASE_URL + "/" + @version.to_s
      puts "Fetching #{url}"
      Nokogiri::HTML.parse(open(url)).css('a').tap do |body|
        body.map{|a| a[:href] =~ /[^.]*\.js/ ? a : nil }.compact.each do |a|
          full_url = url + "/" + a[:href]
          file = a[:href].gsub(/angular/, 'core').
            gsub(/(?:\-?(\d+)\.)?(?:(\d+)\.)?(\*|\d+)?/, '').
            gsub(/core-/, '')
          full_path = ROOT_PATH.join(file)
          download_file(full_path, full_url)
        end
      end
    end

    def download_i18n_files
      url = BASE_URL + "/" + @version.to_s + "/i18n"
      puts "Fetching #{url}"
      Nokogiri::HTML.parse(open(url)).css('a').tap do |body|
        body.map{|a| a[:href] =~ /angular-locale_[^.]*\.js/ ? a : nil }.compact.each do |a|
          full_url = url + "/" + a[:href]
          full_path = I18N_PATH.join(a[:href].gsub('angular-locale_', ''))
          download_file(full_path, full_url)
        end
      end
    rescue OpenURI::HTTPError => e
      []
    end

    def download_file(file, url)
      puts "Downloading #{file} from #{url}"
      file.open('w+') do |f|
        f.write open(url).read
      end
    end
  end


  def self.latest_version(beta=false)
    if (@beta || beta)
      Angular.beta_versions.last
    else
      Angular.stable_versions.last
    end
  end

  def self.beta_versions
    @beta_versions ||= upstream_versions.select { |v| v.to_s =~ /[\-]/ }
  end

  def self.stable_versions
    @stable_versions ||= upstream_versions.select { |v| v.to_s !~ /[\-]/ }
  end

  def self.upstream_versions
    @upstream_versions ||= Nokogiri::HTML.parse(open(BASE_URL)).
      css('a').map { |e| Versionomy.parse e.text[0..-2] rescue nil }.compact.sort
  end

end
