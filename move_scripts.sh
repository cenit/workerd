#!/bin/bash

# Inner script (usually not launched manually)
# to set permissions and locations of
# workerd-crond dependency scripts and
# conf files on remote device

chmod 755 workerd-bin-deploy
chmod 755 workerd-bin-sync
chmod 755 workerd-conf-deploy
chmod 755 workerd-conf-sync
chmod 755 workerd-crond
chmod 755 workerd-data-sync
chmod 755 workerd-errlog-sync
chmod 755 workerd-init
chmod 755 workerd-keep-alive
chmod 755 workerd-log-sync
chmod 755 workerd-starter

mv workerd-bin-deploy   /usr/bin/workerd-bin-deploy
mv workerd-bin-sync     /usr/bin/workerd-bin-sync
mv workerd-conf-deploy  /usr/bin/workerd-conf-deploy
mv workerd-conf-sync    /usr/bin/workerd-conf-sync
mv workerd-crond        /usr/bin/workerd-crond
mv workerd-data-sync    /usr/bin/workerd-data-sync
mv workerd-errlog-sync  /usr/bin/workerd-errlog-sync
mv workerd-init         /usr/bin/workerd-init
mv workerd-keep-alive   /usr/bin/workerd-keep-alive
mv workerd-log-sync     /usr/bin/workerd-log-sync
mv workerd-starter      /etc/init.d/workerd-starter
