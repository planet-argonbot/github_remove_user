# Remove a user from all of our Github repositories
require 'github_api'
require 'io/console'

if ARGV.empty?
  puts "Usage: remove_user <username>"
  exit -1
end

username = ARGV.first

owner = STDIN.gets("Github Username: ")
password = STDIN.getpass("Password: ")

github = Github.new basic_auth: "#{owner}:#{password}"
github_repos = github.repos.list per_page: 200

github_repos.each do |repo|
  # if it belongs to Planet Argon
  if repo['owner']['login'] == owner
    puts "Repository: #{repo['name']}"
    # is the user a collaborator?
    if github.repos.collaborators.collaborator?(owner, repo['name'], username)
      # remove them from the repository
      if github.repos.collaborators.remove(owner, repo['name'], username)
        puts "#{username} has been successfully removed from #{repo['name']}"
      else
        puts "WARNING: Unable to remove #{username} from #{repo['name']}"
      end
    end
  end
end
