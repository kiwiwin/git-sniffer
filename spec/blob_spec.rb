require_relative 'spec_helper'

describe GitSniffer::Blob do
		context(:single_commit) do
			before(:all) do
				base = GitSniffer::Base.open(fixture_path(:single_commit))
				@blob = base.commits[0].blobs[0]
			end

			it "should return readme as file name" do
				@blob.name.should == "readme"
			end

			it "should return e923f854774fc767cb9e02a3d0d616d188a81c53 as sha" do
				@blob.sha.should == "e923f854774fc767cb9e02a3d0d616d188a81c53"
			end

			it "should return as content" do
				@blob.content.should == "single commit\n"
			end
		end
end
