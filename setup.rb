#!/usr/bin/env ruby
# frozen_string_literal: true

# Project bootstrap script for Ruby apps.
# - Ensures Bundler is available
# - Creates/updates a Gemfile with common development gems
# - Runs bundle install
# - Initializes RSpec and RuboCop configurations
# - Creates basic .env and .gitignore entries

require 'fileutils'

ROOT = File.expand_path(__dir__)

def say(message)
  puts("==> #{message}")
end

def run!(command)
  say("$ #{command}")
  success = system(command)
  abort("Command failed: #{command}") unless success
  success
end

def write_file_unless_exists(path, content)
  return if File.exist?(path)
  FileUtils.mkdir_p(File.dirname(path))
  File.write(path, content)
  say("created #{relative(path)}")
end

def append_unless_present(path, needle)
  current = File.exist?(path) ? File.read(path) : ""
  return if current.include?(needle)
  FileUtils.mkdir_p(File.dirname(path))
  File.open(path, 'a') { |f| f.write("\n#{needle}\n") }
  say("updated #{relative(path)}")
end

def relative(abs)
  abs.sub(/^#{Regexp.escape(ROOT)}\//, '')
end

def ensure_bundler!
  say('Vérification de Bundler…')
  have_bundler = system('ruby -e "require \"bundler\"" > /dev/null 2>&1')
  return if have_bundler

  say('Installation de Bundler…')
  run!('gem install bundler --no-document')
end

def ensure_ruby_version_file!
  ruby_version = RUBY_VERSION
  write_file_unless_exists(File.join(ROOT, '.ruby-version'), "#{ruby_version}\n")
end

def ensure_gitignore!
  append_unless_present(File.join(ROOT, '.gitignore'), <<~TXT.chomp)
    # Ruby / Bundler
    /.bundle
    /vendor/bundle
    .byebug_history

    # Env files
    .env
    .env.local
  TXT
end

def ensure_gemfile!
  gemfile_path = File.join(ROOT, 'Gemfile')

  if File.exist?(gemfile_path)
    say('Gemfile existant détecté — ajout des gems recommandées si absentes…')
    content = File.read(gemfile_path)
    additions = []

    additions << "gem 'rspec'" unless content.match?(/gem\s+['\"]rspec['\"]/)
    additions << "gem 'dotenv'" unless content.match?(/gem\s+['\"]dotenv['\"]/)
    additions << "gem 'rake'" unless content.match?(/gem\s+['\"]rake['\"]/)
    additions << "gem 'rubocop', require: false" unless content.match?(/gem\s+['\"]rubocop['\"]/)
    additions << "gem 'rubocop-performance', require: false" unless content.match?(/rubocop-performance/)
    additions << "gem 'rubocop-rspec', require: false" unless content.match?(/rubocop-rspec/)

    unless additions.empty?
      File.open(gemfile_path, 'a') do |f|
        f.puts "\n# Gems ajoutées par ruby/setup.rb"
        additions.each { |line| f.puts line }
      end
      say("updated #{relative(gemfile_path)} (added: #{additions.join(', ')})")
    else
      say('Aucun ajout nécessaire au Gemfile.')
    end
  else
    say('Création d\'un Gemfile minimal…')
    ruby_decl = "ruby '#{RUBY_VERSION}'"
    content = <<~GEMFILE
      source 'https://rubygems.org'
      #{ruby_decl}

      gem 'dotenv'
      gem 'rake'
      gem 'rspec'
      gem 'rubocop', require: false
      gem 'rubocop-performance', require: false
      gem 'rubocop-rspec', require: false
      gem 'pry'
    GEMFILE
    File.write(gemfile_path, content)
    say("created #{relative(gemfile_path)}")
  end
end

def bundle_install!
  say('Installation des gems (bundle install)…')
  run!("bundle install")
end

def setup_rspec!
  spec_helper = File.join(ROOT, 'spec', 'spec_helper.rb')
  return if File.exist?(spec_helper)

  say('Initialisation de RSpec…')
  run!('bundle exec rspec --init')
end

def setup_rubocop!
  rubocop_yml = File.join(ROOT, '.rubocop.yml')
  return if File.exist?(rubocop_yml)

  say('Création configuration RuboCop…')
  content = <<~YML
    AllCops:
      NewCops: enable
      TargetRubyVersion: #{RUBY_VERSION.split('.').first(2).join('.')}
      Exclude:
        - 'db/schema.rb'
        - 'bin/*'

    require:
      - rubocop-performance
      - rubocop-rspec

    Layout/LineLength:
      Max: 100
  YML
  File.write(rubocop_yml, content)
  say("created #{relative(rubocop_yml)}")
end

def ensure_env_files!
  write_file_unless_exists(File.join(ROOT, '.env'), "# Variables d'environnement\n")
end

def create_bin_scripts!
  bin_console = File.join(ROOT, 'bin', 'console')
  bin_rubocop = File.join(ROOT, 'bin', 'rubocop')

  write_file_unless_exists(bin_console, <<~BASH)
    #!/usr/bin/env bash
    set -euo pipefail
    bundle exec pry -r ./app.rb
  BASH
  FileUtils.chmod('+x', bin_console) if File.exist?(bin_console)

  write_file_unless_exists(bin_rubocop, <<~BASH)
    #!/usr/bin/env bash
    set -euo pipefail
    bundle exec rubocop "$@"
  BASH
  FileUtils.chmod('+x', bin_rubocop) if File.exist?(bin_rubocop)
end

def main
  Dir.chdir(ROOT) do
    say("Répertoire projet: #{ROOT}")
    ensure_bundler!
    ensure_ruby_version_file!
    ensure_gitignore!
    ensure_gemfile!
    bundle_install!
    setup_rspec!
    setup_rubocop!
    ensure_env_files!
    create_bin_scripts!

    say('Configuration terminée ✅')
    puts
    puts('- Pour lancer les tests: bundle exec rspec')
    puts('- Pour vérifier le style: bundle exec rubocop')
    puts("- Console interactive: bin/console (ou `bundle exec pry`)" )
  end
end

main if __FILE__ == $PROGRAM_NAME