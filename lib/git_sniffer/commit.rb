require 'date'
require_relative 'object'
require_relative 'blob'

module GitSniffer
	class Commit < GitSniffer::Object
		lazy_reader :message
		lazy_reader :commit_date, :committer, :committer_email, :init => :get_committer_info
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
			content =~ /committer (.+) <(.+)> (\d+) ([+-])(\d{2})(\d{2})/
			@committer = $1
			@committer_email = $2
			@commit_date = DateTime.parse(Time.at($3.to_i + 3600 * ($4 + $5).to_i + 60 * ($4 + $6).to_i)
				.utc.to_s.gsub("UTC", "#{$4}#{$5}#{$6}")) 
		end

		def lazy_parents_source
			parent_shas = content.scan(/parent ([a-z0-9]{40})/)
			@parents = parent_shas.collect { |sha| @base.object(sha[0]) }
		end
	end
end
