namespace :deploy do
  def self.heroku_remotes #:nodoc:
    `git remote -v | grep git@heroku.com | awk '{print $1}'`.split("\n")
  end

  desc "Creates a 'stable' branch"
  task :setup do
    `git branch stable &>/dev/null`
    `git push origin stable:stable &>/dev/null`
  end

  heroku_remotes.each do |environment|
    desc "Deploy GIT_REF (origin/stable by default) to #{environment}."
    task environment do
      branch = ENV["GIT_REF"] || "origin/stable"

      `git fetch origin &>/dev/null`
      system "git push -f #{environment} #{branch}:master"
    end
  end
end
