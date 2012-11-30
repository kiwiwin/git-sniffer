require 'git_sniffer'
require 'ruport'

puts "#" * 30
puts "Example: author changed lines"
puts "#" * 30
puts 

##########################FIXTURE#############################
@base = GitSniffer::Base.open(File.dirname(__FILE__) + "/fixture/JSON-java.git")
##############################################################

##########################EXEC################################
GitSniffer::Commit.add_hook(:changed_lines) { |commit| commit.diff_parent[:insert] + commit.diff_parent[:delete] }
author_commits = @base.commits.group_by { |commit| commit.committer }

result = author_commits.inject({}) do |res, author_with_commits|
	res[author_with_commits[0]] = author_with_commits[1].inject(0) { |res, commit| res += commit.hook_changed_lines }
	res
end

##########################RESULT#############################
table = Ruport::Data::Table.new :column_names => ["author", "changed_lines"],
								:data => result.to_a

puts table.to_text
puts
puts "#" * 30
