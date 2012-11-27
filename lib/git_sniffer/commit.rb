require 'date'
require_relative 'object'
require_relative 'blob'

module GitSniffer
	class Commit < GitSniffer::Object
		lazy_reader :message
		lazy_reader :commit_date
		lazy_reader :committer
		lazy_reader :committer_email
		lazy_reader :parents

		def initialize(base, sha)
			super(base, sha)
		end

		def blobs
			result = @base.exec("ls-tree -r #{@sha}")
			result.scan(/\d+ \w+ ([a-z\d]{40})\t.+\n/).collect do |line|
				@base.object(line[0])
			end
		end

		def diff_parent
			return Hash.new(0) if parents.size == 0
			self.class.diff_shortstat(@base, parents[0], self)
		end

		class << self
			def diff_shortstat(base, to, from)
				result = Hash.new(0)
				output = base.exec("diff --shortstat #{to.sha} #{from.sha}")
				result[:file] = $1.to_i if output =~ /(\d+) files? changed/
				result[:insert] = $1.to_i if output =~ /(\d+) insertions?\(\+\)/
				result[:delete] = $1.to_i if output =~ /(\d+) deletions?\(-\)/
				result
			end
		end

		private
		def lazy_message_source
			content.split("\n")[-1]
		end

		def get_committer_info
			content =~ /committer (.+) <(.+)> (\d+) [+-]\d{4}/
			@committer = $1
			@committer_email = $2
			@commit_date = Time.at($3.to_i).to_datetime
		end

		def lazy_commit_date_source
			get_committer_info
			@commit_date
		end

		def lazy_committer_source
			get_committer_info
			@committer
		end

		def lazy_committer_email_source
			get_committer_info
			@committer_email
		end

		def lazy_parents_source
			parent_shas = content.scan(/parent ([a-z0-9]{40})/)
			@parents = parent_shas.collect { |sha| @base.object(sha[0]) }
		end
	end
end
