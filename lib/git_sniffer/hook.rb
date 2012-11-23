require 'active_support/inflector'
require_relative 'base'

module GitSniffer
	module Hook
		def self.included(base)
			base.extend(ClassMethods)
		end

		def eigenclass
			class << self; self; end
		end

		def method_missing(method, *args, &block)
			if method =~ /hook_(.+)/
				eigenclass.instance_exec($1) do |attr|
					lazy_reader "hook_#{attr}".to_sym
					define_method "lazy_hook_#{attr}_source" do
						self.class.get_hook(attr.to_sym).call self
					end
				end
				return send method
			end
			super
		end

		module ClassMethods
			def get_hook(name)
				@hooks[name]
			end

			def add_hook(name, &block)
				@hooks ||= {}
				@hooks[name] = block
			end

			def remove_hook(name)
				@hooks.delete(name)
			end
		end
	end
end
