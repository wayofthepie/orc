require 'open-uri'
require "yaml"

config_yaml = YAML.load_file(File.join(File.dirname(__FILE__),'config.yml'))
$config = config_yaml["cluster"]
puts $config
################################################################################
# General $config
$work_dir=ENV['WORK_DIR']

def get_new_token(*num_nodes)
    puts num_nodes
    sum_nums = num_nodes.reduce(:+)
    new_disco_url = "https://discovery.etcd.io/new?size=#{sum_nums}"
    puts new_disco_url
    token = open(new_disco_url).read
end

$disco_url = get_new_token($config["core"]["nodes"])

################################################################################
# Cluster node $config

class CommonNodeConfig
    attr_accessor :hostname
end

# CoreOS Services cluster $config.
class CoreServicesNodeConfig < CommonNodeConfig

    # Number of nodes in the core services cluster
    NUM_NODES = $config["core"]["nodes"]

    def initialize
        @disco_url = $disco_url
        # Core services node name prefix
        @name_prefix = $config["core"]["prefix"]

        # CPU's for a core services node
        @num_cpu = $config["core"]["ncpu"]

        # Mem size for a core services node
        @mem_size = $config["core"]["mem"]
    end

    attr_reader :disco_url
    attr_reader :name_prefix
    attr_reader :num_nodes
    attr_reader :num_cpu
    attr_reader :mem_size

    attr_accessor :ip

    def get_binding
        return binding()
    end
end

class KubeMasterNodeConfig < CommonNodeConfig

    NUM_NODES = $config["kube-master"]["nodes"]

    def initialize
        @disco_url = $disco_url
        # Core services node name prefix
        @name_prefix = $config["kube-master"]["prefix"]

        # CPU's for a core services node
        @num_cpu = $config["kube-master"]["ncpu"]

        # Mem size for a core services node
        @mem_size = $config["kube-master"]["mem"]
    end

    attr_reader :disco_url
    attr_reader :name_prefix
    attr_reader :num_cpu
    attr_reader :mem_size

    def get_binding
        return binding()
    end
end

class KubeWorkerNodeConfig < CommonNodeConfig

    NUM_NODES = $config["kube-worker"]["nodes"]

    def initialize
        @disco_url = $disco_url
        # Core services node name prefix
        @name_prefix = $config["kube-worker"]["prefix"]
        # CPU's for a core services node
        @num_cpu = $config["kube-worker"]["ncpu"]

        # Mem size for a core services node
        @mem_size = $config["kube-worker"]["mem"]
    end

    attr_reader :disco_url
    attr_reader :name_prefix
    attr_reader :num_nodes
    attr_reader :num_cpu
    attr_reader :mem_size

    def get_binding
        return binding()
    end
end
