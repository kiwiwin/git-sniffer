require_relative 'spec_helper'

describe GitSniffer::Hook do
		context(:simple_java) do
	    before(:each) do
				@base = GitSniffer::Base.open(fixture_path(:simple_java))
				@hook = GitSniffer::Hook.new(@base)
			end	

			it "get all blobs size" do
				@hook.add_commit_hook(:blobs){ |hook, commit| commit.blobs.size }
				@hook.commit_results.should ==  {@base.object("c025dce424130b546754eb391a13eb601c4a243c")=>{:blobs=>3},
																						@base.object("00cb610e642d0fac84ad4dac479b98ef447099cd")=>{:blobs=>3},
																						@base.object("e9b02fdf95aa827c0bb2c244622120886a452bab")=>{:blobs=>2}} 
			end		  

			it "get all messages" do
				@hook.add_commit_hook(:message) { |hook, commit| commit.message } 
				@hook.commit_results.should == {
																	@base.object("c025dce424130b546754eb391a13eb601c4a243c")=>{:message=>"say bye after say hello"}, 
																	@base.object("00cb610e642d0fac84ad4dac479b98ef447099cd")=>{:message=>"bye commit"},
																	@base.object("e9b02fdf95aa827c0bb2c244622120886a452bab")=>{:message=>"hello commit"}} 
			end

			it "get lines for each file" do
				@hook.add_blob_hook(:lines) {|hook, blob| blob.content.split("\n").size }
				@hook.blob_results.should == {	@base.object("473e66f56cf9dcb2b875961937148e159b70d2b7")=>{:lines=>19},
 																				@base.object("f050e6b7dfe73d6af9d867e3622c0cae3e818207")=>{:lines=>15},
																				@base.object("f815e728173402ce9c19b090e5b85f93c5c422bf")=>{:lines=>7},
																				@base.object("b909f7f1c27fc2ac344d3abda0e705645f556180")=>{:lines=>12},
																				@base.object("6b468b62a9884e67ca19b673f8e14e1931d65036")=>{:lines=>1}}
			end

			it "get lines for each commit" do
				@hook.add_blob_hook(:lines) { |hook, blob| blob.content.split("\n").size }
				@hook.add_commit_hook(:lines) do |hook, commit|
					commit.blobs.inject(0) do |res, blob|
						res += hook.blob_lines_result(blob)
					end
				end
				@hook.commit_results.should == { @base.object("c025dce424130b546754eb391a13eb601c4a243c")=>{:lines=>32},
 																				 @base.object("00cb610e642d0fac84ad4dac479b98ef447099cd")=>{:lines=>23},
																				 @base.object("e9b02fdf95aa827c0bb2c244622120886a452bab")=>{:lines=>8}} 
			end

			it "get maxline for each commit blob" do
				@hook.add_commit_hook(:max_lines) do |hook, commit|
					commit.blobs.inject(0) do |res, blob|
						res = [res, hook.blob_lines_result(blob)].max
					end
				end
				@hook.add_blob_hook(:lines) { |hook, blob| blob.content.split("\n").size }
				@hook.commit_results.should == {@base.object("c025dce424130b546754eb391a13eb601c4a243c")=>{:max_lines=>19},
 																				@base.object("00cb610e642d0fac84ad4dac479b98ef447099cd")=>{:max_lines=>15},
																				@base.object("e9b02fdf95aa827c0bb2c244622120886a452bab")=>{:max_lines=>7}} 
			end
		end
end
