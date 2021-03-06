require_relative 'lazy'
require_relative 'hook'

module GitSniffer
	class Object
		include Hook
		include Lazy

		attr_reader :sha
		lazy_reader :type
		lazy_reader :content

		def initialize(base, sha)
			@base = base
			@sha = sha
		end

		def lazy_type_source
			@base.exec("cat-file -t #{@sha}").chomp
		end

		def lazy_content_source
			@base.exec("cat-file -p #{@sha}")
		end

		def hash
			@sha.hash
		end

		def eql?(other)
			self.class.equal?(other.class) && @sha == other.sha
		end

		class << self
			def create_object(base, sha)
				eval("GitSniffer::#{object_type(base, sha)}").new(base, sha)		
			end

			def object_type(base, sha)
				base.exec("cat-file -t #{sha}").chomp.capitalize
			end
		end
	end
end
