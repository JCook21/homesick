# frozen_string_literal: true

require_relative 'lib/homesick/version'

Gem::Specification.new do |s|
  s.name        = 'homesick'
  s.version     = Homesick::Version::STRING
  s.authors     = ['Joshua Nichols', 'Yusuke Murata']
  s.email       = ['josh@technicalpickles.com', 'info@muratayusuke.com']
  s.homepage    = 'http://github.com/technicalpickles/homesick'
  s.summary     = "Your home directory is your castle. Don't leave your dotfiles behind."
  s.description = 'Homesick is sorta like rip, but for dotfiles. It uses git to clone a ' \
                  'repository containing dotfiles, and saves them in ~/.homesick. It then ' \
                  'allows you to symlink all the dotfiles into place with a single command.'
  s.license     = 'MIT'
  s.metadata    = { 'rubygems_mfa_required' => 'true' }

  s.required_ruby_version = '>= 3.2'

  s.files         = `git ls-files`.split("\n")
  s.executables   = ['homesick']
  s.require_paths = ['lib']

  s.add_dependency 'thor', '>= 0.14.0'
end
