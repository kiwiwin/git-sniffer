require_relative 'spec_helper'

class DummyLazy
	include GitSniffer::Lazy

	lazy_reader :hello
	def lazy_hello_source
		"hello"
	end
end

class DummyInitLazy
	include GitSniffer::Lazy

	lazy_reader :hello, :byebye, :init => :init_hello_and_byebye

	def init_hello_and_byebye
		@hello = "hello"
		@byebye = "byebye"
	end
end

describe DummyLazy do
	before(:each) do
		@lazy = DummyLazy.new
	end

	it "should return hello for hello" do
		@lazy.hello.should == "hello"
	end

	it "should return call lazy_hello_source only once" do
		@lazy.should_receive(:lazy_hello_source).once.and_call_original
		@lazy.hello.should == "hello"
		@lazy.hello.should == "hello"
	end
end

describe DummyInitLazy do
	before(:each) do
		@lazy = DummyInitLazy.new
	end

	it "should return hello for hello and byebye for byebye" do
		@lazy.hello.should == "hello"
		@lazy.byebye.should == "byebye"
	end

	it "should called init_hello_and_byebye only once" do
		@lazy.should_receive(:init_hello_and_byebye).once.and_call_original
		@lazy.hello.should == "hello"
		@lazy.hello.should == "hello"
		@lazy.byebye.should == "byebye"
	end
end
