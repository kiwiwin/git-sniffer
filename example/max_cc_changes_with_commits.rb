require 'git_sniffer'
require 'ruport'

puts "#" * 30
puts "Example: max cyclomatic complexity with commits"
puts "#" * 30
puts 

##########################FIXTURE#############################
@base = GitSniffer::Base.open(File.dirname(__FILE__) + "/fixture/JSON-java.git")
##############################################################

GitSniffer::Blob.add_hook(:max_cc) { |blob| GitSniffer::SingleFileMetric.max_cc(blob) }

GitSniffer::Commit.add_hook(:max_cc) do |commit| 
	commit.blobs.inject(0) do |max_cc, blob|
		if blob.name =~ /^.*.java$/
			max_cc = [max_cc, blob.hook_max_cc].max
		end
		max_cc
	end
end

rows = @base.commits.collect do |commit| 
	max_cc = 0
	begin
		max_cc = commit.hook_max_cc		
	rescue GitSniffer::SingleFileCheckError => error
		puts error.file_name
		puts error.message
	end

	[commit.commit_date, max_cc] 
end

table = Ruport::Data::Table.new :column_names => ["commit date", "max cyclomatic complexity"],
								:data => rows

puts table.to_text
puts
puts "#" * 30