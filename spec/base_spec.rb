require_relative 'spec_helper'

describe GitSniffer::Base do
	
	context(:signle_commit) do 
		before(:all) do
			@base = GitSniffer::Base.open(fixture_path(:single_commit))
		end

		it "should return single_commit.git for path"	do
			@base.path.should == fixture_path(:single_commit)
		end
	end

	context(:simple_java) do
		before(:all) do
			@base = GitSniffer::Base.open(fixture_path(:simple_java))
		end

		it "should return commit sort by date" do
			@base.commits(:sort_by => :commit_date).collect { |commit| commit.sha }.should == 
			[ "e9b02fdf95aa827c0bb2c244622120886a452bab", 
				"00cb610e642d0fac84ad4dac479b98ef447099cd", 
				"c025dce424130b546754eb391a13eb601c4a243c"]
		end
	end
end
