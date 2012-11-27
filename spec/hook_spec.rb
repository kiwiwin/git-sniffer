require_relative 'spec_helper'

describe GitSniffer::Hook do
		context(:simple_java) do
	    before(:each) do
				@base = GitSniffer::Base.open(fixture_path(:simple_java))
			end	

			it "get all blobs size" do
				GitSniffer::Commit.add_hook(:blobs) { |commit| commit.blobs.size }
				@base.object("c025dce424130b546754eb391a13eb601c4a243c").hook_blobs.should == 3 
				@base.object("00cb610e642d0fac84ad4dac479b98ef447099cd").hook_blobs.should == 3
				@base.object("e9b02fdf95aa827c0bb2c244622120886a452bab").hook_blobs.should == 2
			end		  

			it "get all messages" do
				GitSniffer::Commit.add_hook(:message) { |commit| commit.message }
				@base.object("c025dce424130b546754eb391a13eb601c4a243c").hook_message.should == "say bye after say hello" 
				@base.object("00cb610e642d0fac84ad4dac479b98ef447099cd").hook_message.should == "bye commit"
				@base.object("e9b02fdf95aa827c0bb2c244622120886a452bab").hook_message.should == "hello commit"
			end

			it "get lines for each file" do
				GitSniffer::Blob.add_hook(:lines) { |blob| blob.content.split("\n").size }
				@base.object("473e66f56cf9dcb2b875961937148e159b70d2b7").hook_lines.should == 19
				@base.object("f050e6b7dfe73d6af9d867e3622c0cae3e818207").hook_lines.should == 15
				@base.object("f815e728173402ce9c19b090e5b85f93c5c422bf").hook_lines.should == 7
				@base.object("b909f7f1c27fc2ac344d3abda0e705645f556180").hook_lines.should == 12
				@base.object("6b468b62a9884e67ca19b673f8e14e1931d65036").hook_lines.should == 1
			end

			it "get lines for each commit" do
				GitSniffer::Blob.add_hook(:lines) { |blob| blob.content.split("\n").size }
				GitSniffer::Commit.add_hook(:lines) do |commit| 
					commit.blobs.inject(0) do |res, blob|
						res += blob.hook_lines
					end
				end
				@base.object("c025dce424130b546754eb391a13eb601c4a243c").hook_lines.should == 32
				@base.object("00cb610e642d0fac84ad4dac479b98ef447099cd").hook_lines.should == 23
				@base.object("e9b02fdf95aa827c0bb2c244622120886a452bab").hook_lines.should == 8 
			end

			it "get maxline for each commit blob" do
				GitSniffer::Commit.add_hook(:max_lines) do |commit| 
					commit.blobs.inject(0) do |res, blob|
						[res, blob.hook_lines].max
					end
				end
				GitSniffer::Blob.add_hook(:lines) { |blob| blob.content.split("\n").size }
				@base.object("c025dce424130b546754eb391a13eb601c4a243c").hook_max_lines.should == 19
				@base.object("00cb610e642d0fac84ad4dac479b98ef447099cd").hook_max_lines.should == 15
				@base.object("e9b02fdf95aa827c0bb2c244622120886a452bab").hook_max_lines.should == 7
			end

			it "return commits changed lines by committer" do
				GitSniffer::Commit.add_hook(:changed) do |commit|
					commit.diff_parent[:insert] + commit.diff_parent[:delete]
				end
				author_commits = @base.commits.group_by { |commit| commit.committer }
				author_commits["kiwi"].inject(0) do |res, commit|
					res += commit.hook_changed
				end.should == 26
			end

			it "return commits insert lines by committer" do
				GitSniffer::Commit.add_hook(:insert) do |commit|
					commit.diff_parent[:insert]
				end
				author_commits = @base.commits.group_by { |commit| commit.committer }
				author_commits["kiwi"].inject(0) do |res, commit|
					res += commit.hook_insert
				end.should == 25
			end
		end
end
