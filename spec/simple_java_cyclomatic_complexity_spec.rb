require_relative 'spec_helper'

describe GitSniffer::Base do

	before(:each) do
    @base = GitSniffer::Base.open(fixture_path(:simple_java))
		@hook = GitSniffer::Hook.new(@base)	
		@hook.add_blob_hook(:cc) do |hook, blob|
			GitSniffer::SingleFileMetric.max_cc(blob.content)
		end
	end

    it "check each blob cc" do
		@hook.blob_results.should == 
		{ 
			@base.object("473e66f56cf9dcb2b875961937148e159b70d2b7") => {:cc => 4},
	 		@base.object("f050e6b7dfe73d6af9d867e3622c0cae3e818207") => {:cc => 3},
			@base.object("f815e728173402ce9c19b090e5b85f93c5c422bf") => {:cc => 1},
			@base.object("b909f7f1c27fc2ac344d3abda0e705645f556180") => {:cc => 1},
			@base.object("6b468b62a9884e67ca19b673f8e14e1931d65036") => {:cc => 0}
		}
    end

    it "check each commit cc" do
		@hook.add_commit_hook(:cc) do |hook, commit|
			commit.blobs.inject(0) do |res, blob|
				[res, hook.blob_cc_result(blob)].max
			end
		end
		@hook.commit_results.size.should == 3
		@hook.commit_results[@base.object("c025dce424130b546754eb391a13eb601c4a243c")].should == {:cc => 4}
		@hook.commit_results[@base.object("00cb610e642d0fac84ad4dac479b98ef447099cd")].should == {:cc => 3}
		@hook.commit_results[@base.object("e9b02fdf95aa827c0bb2c244622120886a452bab")].should == {:cc => 1}
	end
end
