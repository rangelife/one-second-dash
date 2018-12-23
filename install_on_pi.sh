#!/bin/bash -e

location=$(pwd)

echo > /etc/init.d/one-second-dash << EOF
#!/bin/bash -e
cd "$location"
./start.sh
EOF

chmod 755 /etc/init.d/one-second-dash

update-rc.d one-second-dash defaults