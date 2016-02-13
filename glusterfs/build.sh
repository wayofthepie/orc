vagrant destroy -f && sleep 10 && vagrant up
vagrant ssh gluster02 -- -t "sudo gluster peer probe 192.168.56.10"
vagrant ssh gluster02 -- -t "sudo gluster volume create gv0 replica 2 192.168.56.10:/bricks/brick1/gv0 192.168.56.11:/bricks/brick1/gv0"
vagrant ssh gluster02 -- -t "sudo gluster volume start gv0 && sudo gluster volume info"
