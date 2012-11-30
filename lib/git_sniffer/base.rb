require 'active_support/inflector'
require_relative 'commit'
require_relative 'blob'
require_relative 'tree'
require_relative 'lazy'

module GitSniffer
	class Base
		include Lazy
	
		attr_reader :path
		lazy_reader :sha_objects
		
		def initialize(git_path)
			@path = git_path
		end

		def exec(command)
			`git --git-dir=#{@path} #{command}`
		end
	
		def object(sha)
			sha_objects[sha]
		end

		def shas
			sha_objects.keys
		end

		def objects
			sha_objects.values
		end

		class << self
			def open(git_path)
				Base.new(git_path)
			end
		end

	private
		def lazy_sha_objects_source
			exec("rev-list --all --objects").split("\n").inject({}) do |res, line|
				sha = line[0...40]
				res[sha] = GitSniffer::Object.create_object(self, sha)
				res
			end
		end

		def method_missing(method_id, *args, &block)
			types = ["blobs", "commits", "trees"]
			return type_objects(method_id.to_s.singularize, args[0]) if types.include? method_id.to_s
			super
		end

		def type_objects(type, opts)
			objects.select { |object| object.type == type }
		end
	end
end
