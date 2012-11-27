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
end
