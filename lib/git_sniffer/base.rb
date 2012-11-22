require 'active_support/inflector'
require_relative 'commit'
require_relative 'blob'
require_relative 'tree'
require_relative 'lazy'

module GitSniffer
	class Base
		include Lazy
	
		attr_reader :path
		lazy_reader :objects

		def commits
			shas = exec("rev-list --all")
			shas.split("\n").collect { |sha| Commit.new(self, sha) }
		end
		
		def initialize(git_path)
			@path = git_path
		end

		def exec(command)
			`git --git-dir=#{@path} #{command}`
		end
	
		def object(sha)
			objects[sha]
		end

		def shas
			objects.keys
		end

		def lazy_objects_source
			res = {}
			Dir.foreach("#{@path}/objects") do |entry|
				if entry =~ /[a-z0-9]{2}/
					Dir.foreach("#{@path}/objects/#{entry}") do |filename|
						res["#{entry}#{filename}"] = create_type_object("#{entry}#{filename}") if filename =~ /[a-z0-9]{38}/
					end
				end
			end
			res
		end

		class << self
			def open(git_path)
				Base.new(git_path)
			end
		end

		def object_type(sha)
			exec("cat-file -t #{sha}").chomp
		end

	private
		def create_type_object(sha)
			eval("GitSniffer::#{object_type(sha).capitalize}").new(self, sha)
		end

		def method_missing(method_id, *args, &block)
			types = ["blobs", "commits"]
			return type_objects(method_id.to_s.singularize) if types.include? method_id.to_s
			super
		end

		def type_objects(type)
			objects.inject([]) do |res, object|
				res << object[1] if object_type(object[0]) == type; res
			end
		end
	end
end
