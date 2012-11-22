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

		def create_type_object(sha)
			eval("GitSniffer::#{object_type(sha).capitalize}").new(self, sha)
		end

		def object_type(sha)
			exec("cat-file -t #{sha}").chomp
		end

		def method_missing(method_id, *args, &block)
			types = ["blobs", "commits", "trees"]
			return type_objects(method_id.to_s.singularize, args[0]) if types.include? method_id.to_s
			super
		end

		def type_objects(type, opts)
			res = objects.inject([]) do |res, object|
				res << object if object.type == type; res
			end
			res = res.sort_by { |object| object.send opts[:sort_by] } if opts && opts[:sort_by]
			res
		end
	end
end
