require 'open-uri'

class CloudConfigBindings

    def initialize(ip, disco_url)
        @ip = ip
        @disco_url = disco_url
    end

    def get_binding
        return binding()
    end
end

def get_new_token(*num_nodes)
    sum_nums = num_nodes.reduce(:+)
    new_disco_url = "https://discovery.etcd.io/new?size=#{sum_nums}"
    token = open(new_disco_url).read
end


# Size of the central CoreOS cluster created by Vagrant
$num_core_cluster=3

# Size of the CoreOS worker cluster
$num_work_cluster=0
$core_name_prefix="core"
$worker_name_prefix="work"
$new_disco_url = get_new_token($num_core_cluster, $num_work_cluster)

