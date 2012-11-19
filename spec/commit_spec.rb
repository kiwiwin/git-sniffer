require_relative 'spec_helper'

describe GitSniffer::Commit do
	context(:single_commit) do
		before(:all) do
			base = GitSniffer::Base.open(fixture_path(:single_commit))
			@commits = base.commits
		end

		it "should return 1 commit" do
			@commits.size.should == 1
		end

		it "should return 3e79e57cf125e8a8905ba91bd5e4ea1c3ee697c8 for first commit sha" do
			@commits[0].sha.should == "3e79e57cf125e8a8905ba91bd5e4ea1c3ee697c8"
		end

		it "should return 1 blob" do
			@commits[0].files.size.should == 1
		end

	end
end
