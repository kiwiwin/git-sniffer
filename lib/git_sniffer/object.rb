require_relative 'lazy'

module GitSniffer
	class Object
		include Lazy

		attr_reader :sha
		lazy_reader :type

		def initialize(base, sha)
			@base = base
			@sha = sha
		end

		def lazy_type_source
			@base.exec("cat-file -t #{@sha}").chomp
		end

		def hash
			@sha.hash
		end

		def eql?(other)
			self.class.equal?(other.class) && @sha == other.sha
		end

		def content
			@base.exec("cat-file -p #{@sha}")
		end
	end
end
