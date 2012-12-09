require_relative 'lazy'
require_relative 'hook'

module GitSniffer
	class Object
		include Hook
		include Lazy

		attr_reader :sha
		lazy_reader :type
		lazy_reader :content

		def initialize(base, sha, *fields)
			@base = base
			@sha = sha
			if fields[0].is_a?(Hash)
				fields.each_pair { |key, value| define_singleton_method("#{@key}") { value } }
			end
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
				GitSniffer.const_get("#{object_type(base, sha)}").new(base, sha)
			end

			def object_type(base, sha)
				base.exec("cat-file -t #{sha}").chomp.capitalize
			end
		end
	end
end
