vagrant destroy -f && sleep 10 && vagrant up
vagrant ssh gluster02 -- -t "sudo gluster peer probe gluster01.vagrant.dev"
vagrant ssh gluster02 -- -t "sudo gluster volume create gv0 replica 2 gluster01.vagrant.dev:/bricks/brick1/gv0 gluster02.vagrant.dev:/bricks/brick1/gv0"
vagrant ssh gluster02 -- -t "sudo gluster volume start gv0 && sudo gluster volume info"
