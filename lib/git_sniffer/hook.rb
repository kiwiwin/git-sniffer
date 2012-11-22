require 'active_support/inflector'
require_relative 'base'

module GitSniffer
	class HookResult
		def initialize(shas)
			@result = {}
			shas.each { |sha| @result[sha] = {} }
		end

		def get_attr_result(sha, attr)
			@result[sha][attr]
		end

		def set_attr_result(sha, attr_name, result)
			@result[sha] ||= {}
			@result[sha][attr_name] = result
		end

		def has_sha_attr_result?(sha, attr)
			return false if !@result[sha]
			@result[sha][attr]
		end
	end

	class Hook
		def initialize(base)
			@base = base
			@hook_result = HookResult.new(@base.shas)
		end

		private
		def method_missing(method_id, *args, &block) 
			return add_type_hook($1, *args, &block) if method_id.to_s =~ /^add_(\w+)_hook$/
			return type_results($1) if method_id.to_s =~ /^(\w+)_results$/
			return type_attr_result($1, *args) if method_id.to_s =~ /^(\w+)_attr_result$/
			super
		end

		def type_results(type)
			attr_names = @hooks[type].keys
			@base.send(type.pluralize).inject({}) do |res, object|
				res[object.sha] = attr_names.inject({}) do |res, attr_name| 
					res[attr_name] = type_attr_result(type.singularize, object.sha, attr_name); res
				end
				res
			end
		end

		def add_type_hook(type, args, &block)
			@hooks ||= {}
			@hooks[type] ||= {}
			@hooks[type][args] = block
 		end

		def get_type_attr_hook(type, attr_name)
			@hooks[type][attr_name]
		end

		def type_attr_result(type, sha, attr_name)
			calculate_attr_result(type, sha, attr_name) if !@hook_result.has_sha_attr_result?(sha, attr_name)
			@hook_result.get_attr_result(sha, attr_name)
		end

		def calculate_attr_result(type, sha, attr_name)
			hook = get_type_attr_hook(type.singularize, attr_name)
			@hook_result.set_attr_result(sha, attr_name, hook.call(self, @base.object(sha)))			
		end
	end
end
