require 'open-uri'


################################################################################
# General config
$work_dir=ENV['WORK_DIR']
puts $work_dir
def get_new_token(*num_nodes)
    sum_nums = num_nodes.reduce(:+)
    new_disco_url = "https://discovery.etcd.io/new?size=#{sum_nums}"
    token = open(new_disco_url).read
end

################################################################################
# Cluster node config

class CommonNodeConfig
    def initializ
        @disco_url = get_new_token($num_core_cluster)
    end

    attr_accessor :ip
    attr_accessor :hostname
end

# CoreOS Services cluster config.
class CoreServicesNodeConfig < CommonNodeConfig

    # Number of nodes in the core services cluster
    NUM_NODES = 2

    def initialize
        # Core services node name prefix
        @name_prefix = "core"

        # CPU's for a core services node
        @num_cpu = 2

        # Mem size for a core services node
        @mem_size = 1024
    end

    attr_reader :name_prefix
    attr_reader :num_nodes
    attr_reader :num_cpu
    attr_reader :mem_size

    def get_binding
        return binding()
    end
end

# CoreOS Worker cluster config. This is where the kubernetes cluster (masters
# and workers) resides.
class WorkerNodeConfig < CommonNodeConfig
    def initialize
        # Core services node name prefix
        @name_prefix = "work"

        # Number of nodes in the core services cluster
        @num_nodes = 2

        # CPU's for a core services node
        @num_cpu = 2

        # Mem size for a core services node
        @mem_size = 1024
    end

    attr_reader :name_prefix
    attr_reader :num_nodes
    attr_reader :num_cpu
    attr_reader :mem_size

    def get_binding
        return binding()
    end
end
