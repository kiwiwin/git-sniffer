require_relative 'spec_helper'

describe GitSniffer::Base do

	before(:each) do
    @base = GitSniffer::Base.open(fixture_path(:simple_java))

		GitSniffer::Blob.add_hook(:cc) do |blob|
			GitSniffer::SingleFileMetric.max_cc(blob)
		end
	end

    it "check each blob cc" do
		@base.object("473e66f56cf9dcb2b875961937148e159b70d2b7").hook_cc.should == 4
	 	@base.object("f050e6b7dfe73d6af9d867e3622c0cae3e818207").hook_cc.should == 3
		@base.object("f815e728173402ce9c19b090e5b85f93c5c422bf").hook_cc.should == 1
		@base.object("b909f7f1c27fc2ac344d3abda0e705645f556180").hook_cc.should == 1

		begin
			@base.object("6b468b62a9884e67ca19b673f8e14e1931d65036").hook_cc.should == -1
		rescue GitSniffer::SingleFileCheckError => error  
  			error.file_name.should == ".gitignore"
  		end  
    end

    it "check each commit cc" do
	 	GitSniffer::Commit.add_hook(:cc) do |commit|
			commit.blobs.inject(0) do |res, blob|
				[res, blob.hook_cc].max
			end
		end

		begin
			@base.object("c025dce424130b546754eb391a13eb601c4a243c").hook_cc.should == 4
			@base.object("00cb610e642d0fac84ad4dac479b98ef447099cd").hook_cc.should == 3
			@base.object("e9b02fdf95aa827c0bb2c244622120886a452bab").hook_cc.should == 1
		rescue GitSniffer::SingleFileCheckError => error
			error.file_name.should == ".gitignore"
		end
	end
end
