require 'active_support/inflector'
require_relative 'base'

module GitSniffer
	module Hook
		def self.included(base)
			base.extend(ClassMethods)
		end

		module ClassMethods
			def add_hook(name, &block)
				class_exec(name, block) do |attr, callback|
					lazy_reader "hook_#{attr}".to_sym
					define_method "lazy_hook_#{attr}_source" do
						callback.call self
					end
				end
			end
		end
	end
end
