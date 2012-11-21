require_relative 'base'

module GitSniffer
	class Hook
		def initialize(base)
			@base = base
			@commit_hooks = {}
			@blob_hooks = {}
		end

		def add_commit_hook(hook_name, hook_proc)
			@commit_hooks[hook_name] = hook_proc
		end

		def add_blob_hook(hook_name, hook_proc)
			@blob_hooks[hook_name] = hook_proc
		end

		def run
			run_blobs
			run_commits
		end

		def run_blobs
			@blob_results ||= {}			
			@base.blobs.each do |blob|
				@blob_results[blob.sha] = @blob_hooks.inject({}) do |res, hook|
					res[hook[0]] = hook[1].call(blob); res
				end
			end
		end

		def run_commits
			@commit_results ||= {} 
			@base.commits.each do |commit|
				@commit_results[commit.sha] = @commit_hooks.inject({}) do |res, hook|
					res[hook[0]] = hook[1].call(self, commit); res
				end
			end
		end

		def all_commit_result
			@commit_results
		end

		def all_blob_result
			@blob_results
		end

		def blob_result(sha, name)
			@blob_results[sha][name]
		end
	end
end
