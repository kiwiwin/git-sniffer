require 'active_support/inflector'
require_relative 'commit'
require_relative 'blob'
require_relative 'tree'
require_relative 'tag'
require_relative 'lazy'

module GitSniffer
	class Base
		include Lazy
	
		attr_reader :path
		lazy_reader :sha_objects, :sha_commits, :init => :init_objects
		
		def initialize(git_path)
			@path = git_path
		end

		def exec(command)
			`git --git-dir=#{@path} #{command}`
		end
	
		def object(sha)
			raise "no git object with sha #{sha}" if !sha_objects.has_key?(sha)
			sha_objects[sha] = GitSniffer::Object.create_object(self, sha) if !sha_objects[sha]
			sha_objects[sha]
		end

		def objects
			sha_objects.values
		end

		def commits
			sha_commits.values
		end

		class << self
			def open(git_path)
				Base.new(git_path)
			end
		end

	private
		def init_objects
			init_commits
			@sha_objects = Hash.new.merge(@sha_commits)
			exec("rev-list --all --objects").split("\n").each do |line|
				sha = line[0...40]
				@sha_objects[sha] = nil if !@sha_objects.has_key?(sha)
			end
			@sha_objects			
		end

		def init_commits
			@sha_commits = Hash.new
			exec("log --pretty=format:%H").split("\n").each do |sha|
				@sha_commits[sha] = GitSniffer::Commit.new(self, sha)
			end
			@sha_commits
		end
	end
end
