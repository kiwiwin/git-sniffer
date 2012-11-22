require 'active_support/inflector'
require_relative 'base'

module GitSniffer
	class HookResult
		def initialize(shas)
			@result = {}
			shas.each { |sha| @result[sha] = {} }
		end

		def get_object_attr(object, attr)
			@result[object.sha][attr]
		end

		def set_object_attr(object, attr_name, result)
			@result[object.sha] ||= {}
			@result[object.sha][attr_name] = result
		end

		def has_object_attr?(object, attr)
			return false if !@result[object.sha]
			@result[object.sha][attr]
		end
	end

	class HookCallback
		def initialize
			@hooks = {}
		end

		def add_callback(type, attr, &callback)
			@hooks[type] ||= {}
			@hooks[type][attr] = callback
		end

		def get_callback(object, attr)
			@hooks[object.type.singularize][attr]
		end

		def get_type_callbacks(type)
			@hooks[type]
		end
	end

	class Hook
		def initialize(base)
			@base = base
			@hook_result = HookResult.new(@base.shas)
			@hook_callback = HookCallback.new
		end

		private
		def method_missing(method_id, *args, &block) 
			return @hook_callback.add_callback($1, *args, &block) if method_id.to_s =~ /^add_(\w+)_hook$/
			return type_results($1) if method_id.to_s =~ /^(\w+)_results$/
			return object_attr_result(*args, $2) if method_id.to_s =~ /^(\w+)_(\w+)_result$/
			super
		end

		def type_results(type)
			attr_names = @hook_callback.get_type_callbacks(type).keys
			@base.send(type.pluralize).inject({}) do |res, object|
				res[object.sha] = attr_names.inject({}) do |res, attr_name| 
					res[attr_name] = object_attr_result(object, attr_name); res
				end
				res
			end
		end

		def object_attr_result(object, attr_name)
			attr_name_sym = attr_name.to_sym
			calculate_attr_result(object, attr_name_sym) if !@hook_result.has_object_attr?(object, attr_name_sym)
			@hook_result.get_object_attr(object, attr_name_sym)
		end

		def calculate_attr_result(object, attr_name)
			hook = @hook_callback.get_callback(object, attr_name)
			@hook_result.set_object_attr(object, attr_name, hook.call(self, object))			
		end
	end
end
