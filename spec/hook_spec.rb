require_relative 'spec_helper'

describe GitSniffer::Hook do
		context(:simple_java) do
	    before(:each) do
				base = GitSniffer::Base.open(fixture_path(:simple_java))
				@hook = GitSniffer::Hook.new(base)
			end	

			it "get all blobs size" do
				@hook.add_commit_hook(:blobs, lambda { |commit| commit.blobs.size } )
				@hook.run_hook
				@hook.all_commit_result.should == [{:blobs => 3},{:blobs => 3},{:blobs => 2}]
			end		  

			it "get all messages" do
				@hook.add_commit_hook(:message, lambda { |commit| commit.message } )
				@hook.run_hook
				@hook.all_commit_result.should == [{:message => "say bye after say hello"},
																					 {:message => "bye commit"},
																					 {:message => "hello commit"}]
			end
		end
end
