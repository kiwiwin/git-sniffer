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
	end
end
