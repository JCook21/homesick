module Homesick
  module Actions
    # Git-related helper methods for Homesick
    module GitActions
      # Information on the minimum git version required for Homesick
      MIN_VERSION = {
        major: 1,
        minor: 8,
        patch: 0
      }.freeze
      STRING = MIN_VERSION.values.join('.')

      def git_version_correct?
        current_version = `git --version`[/(\d+\.\d+\.\d+)/, 1]
        Gem::Version.new(current_version) >= Gem::Version.new(STRING)
      end

      def git_clone(repo, config = {})
        config ||= {}
        destination = config[:destination] || File.basename(repo, '.git')
        destination = Pathname.new(destination) unless destination.is_a?(Pathname)

        empty_directory(destination.dirname, verbose: false)
        return say_status :exist, destination.expand_path, :blue if destination.directory?

        say_status 'git clone',
                   "#{repo} to #{destination.expand_path}",
                   :green
        run "git clone -q --config push.default=upstream --recursive #{repo} #{destination}"
      end

      def git_init(path = '.')
        path = Pathname.new(path)

        inside path do
          return say_status 'git init', 'already initialized', :blue if path.join('.git').exist?

          say_status 'git init', ''
          run 'git init >/dev/null'
        end
      end

      def git_remote_add(name, url)
        existing_remote = `git config remote.#{name}.url`.chomp
        existing_remote = nil if existing_remote == ''
        return say_status 'git remote', "#{name} already exists", :blue if existing_remote

        say_status 'git remote', "add #{name} #{url}"
        run "git remote add #{name} #{url}"
      end

      def git_submodule_init
        say_status 'git submodule', 'init', :green
        run 'git submodule --quiet init'
      end

      def git_submodule_update
        say_status 'git submodule', 'update', :green
        run 'git submodule --quiet update --init --recursive >/dev/null 2>&1'
      end

      def git_pull
        say_status 'git pull', '', :green
        run 'git pull --quiet'
      end

      def git_push
        say_status 'git push', '', :green
        run 'git push'
      end

      def git_commit_all(config = {})
        say_status 'git commit all', '', :green
        return run %(git commit -a -m "#{config[:message]}") if config[:message]

        run 'git commit -v -a'
      end

      def git_add(file)
        say_status 'git add file', '', :green
        run "git add '#{file}'"
      end

      def git_status
        say_status 'git status', '', :green
        run 'git status'
      end

      def git_diff
        say_status 'git diff', '', :green
        run 'git diff'
      end
    end
  end
end
