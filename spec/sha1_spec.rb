require_relative 'spec_helper'

describe GitSniffer::Base do
	context(:signle_commit) do
		before(:all) do
			@base =  GitSniffer::Base.open(fixture_path(:single_commit))
		end

 		it "should return 3 objects" do
			@base.objects.size == 3
		end
	
		it "should contain e923f854774fc767cb9e02a3d0d616d188a81c53" do
			@base.objects.include?("e923f854774fc767cb9e02a3d0d616d188a81c53").should == true
		end

		it "should return 1 blobs" do
			@base.blobs.size == 1
		end
	end
end
