require_relative 'spec_helper'

describe GitSniffer::Commit do
	context(:single_commit) do
		before(:all) do
			base = GitSniffer::Base.open(fixture_path(:single_commit))
			@commits = base.commits
			@commit = @commits[0]
		end

		it "should return commit for type" do
			@commit.type.should == "commit"
		end

		it "should return 1 commit" do
			@commits.size.should == 1
		end

		it "should return 3e79e57cf125e8a8905ba91bd5e4ea1c3ee697c8 for first commit sha" do
			@commit.sha.should == "3e79e57cf125e8a8905ba91bd5e4ea1c3ee697c8"
		end

		it "should return 1 blob" do
			@commit.blobs.size.should == 1
		end
	end
	
	context(:simple_java) do
	  before(:all) do
			@base = GitSniffer::Base.open(fixture_path(:simple_java))
			@commits = @base.commits	    
			@commit = @base.object("c025dce424130b546754eb391a13eb601c4a243c")
		end
		
		it "should return 3 commit" do
		    @commits.size.should == 3
		end
		
		it "should return 2 blob" do
		    @commit.blobs.size.should == 3
		end

		it "test commit_date" do
				@commit.commit_date.should == Time.at(1353472551).to_datetime
		end

		it "should return kiwi as commiter" do
				@commit.committer.should == "kiwi"	
		end

		it "should return kiwi.swhite.coder@gmail.com as committer_email" do
				@commit.committer_email.should == "kiwi.swhite.coder@gmail.com"
		end

		it "should has only one parent" do
				@commit.parents.size.should == 1
		end 

		it "should return parent sha is 00cb610e642d0fac84ad4dac479b98ef447099cd" do
				@commit.parents[0].sha.should == "00cb610e642d0fac84ad4dac479b98ef447099cd"
		end

		it "should return diff parent is {:file => 2, :insert => 10, :delete => 1}" do
				@commit.diff_parent.should == {:file => 2, :insert => 10, :delete => 1}
		end
	end
end
