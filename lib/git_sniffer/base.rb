require 'active_support/inflector'
require_relative 'commit'
require_relative 'blob'
require_relative 'lazy'

module GitSniffer
	class Base
		include Lazy
	
		attr_reader :path
		lazy_reader :objects
		
		def initialize(git_path)
			@path = git_path
		end

		def exec(command)
			`git --git-dir=#{@path} #{command}`
		end

		def lazy_objects_source
			res = []
			Dir.foreach("#{@path}/objects") do |entry|
				if entry =~ /[a-z0-9]{2}/
					Dir.foreach("#{@path}/objects/#{entry}") do |filename|
						res << "#{entry}#{filename}" if filename =~ /[a-z0-9]{38}/
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

	private
		def object_type(sha)
			exec("cat-file -t #{sha}").chomp
		end

		def method_missing(method_id, *args, &block)
			types = ["blobs", "commits"]
			return type_objects(method_id.to_s.singularize) if types.include? method_id.to_s
			super
		end

		def type_objects(type)
			objects.inject([]) do |res, sha|
				res << eval("GitSniffer::#{type.capitalize}").new(self, sha) if object_type(sha) == type; res
			end
		end
	end
end
