require_relative 'lazy'
require_relative 'git_object'

module GitSniffer
	class Blob < GitObject
		include Lazy

		lazy_reader :name		

		def initialize(base, sha)
			super(base, sha)
		end

		def content
			@base.exec("cat-file -p #{@sha}")
		end

		def lazy_name_source
			@base.exec("rev-list --all --objects").split("\n").each do |line|
				return $1 if line =~ /^#{@sha} (.*)/ ;
			end
		end
	end
end
