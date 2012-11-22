require "git_sniffer/version"
require "git_sniffer/base"
require "git_sniffer/commit"
require "git_sniffer/blob"
require "git_sniffer/hook"
require "git_sniffer/single_file_metric"

module GitSniffer
  HOME_DIR = "#{File.dirname(__FILE__)}/.."
end
