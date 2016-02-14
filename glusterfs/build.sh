vagrant destroy -f && sleep 10 && vagrant up
vagrant ssh gluster02 -- -t "sudo gluster peer probe gluster01.orc.com"
vagrant ssh gluster02 -- -t "sudo gluster volume create gv0 replica 2 gluster01.orc.com:/bricks/brick1/gv0 gluster02.orc.com:/bricks/brick1/gv0"
vagrant ssh gluster02 -- -t "sudo gluster volume start gv0 && sudo gluster volume info"
