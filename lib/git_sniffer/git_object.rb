require_relative 'lazy'

module GitSniffer
	class GitObject
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
	end
end
