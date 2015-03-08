#!/bin/sh
#

RETVAL=0
prog="vagrant"

start() {
	echo $"Starting $prog:"
	cd buildserver && vagrant up && cd ..
	cd puppetmaster && vagrant up && cd ..
	cd puppetagent && vagrant up && cd ..
	RETVAL=$?
	[ "$RETVAL" = 0 ] 
	echo
}

halt() {
	echo $" $prog:"
	cd buildserver && vagrant halt && cd ..
	cd puppetmaster && vagrant halt && cd ..
	cd puppetagent && vagrant halt && cd ..
	RETVAL=$?
	[ "$RETVAL" = 0 ] && 
	echo
}

reload() {
	echo $"Reloading $prog:"
	cd buildserver && vagrant reload && cd ..
	cd puppetmaster && vagrant reload && cd ..
	cd puppetagent && vagrant reload && cd ..
	echo
}

suspend() {
	echo $"Suspending $prog:"
	cd buildserver && vagrant suspend && cd ..
	cd puppetmaster && vagrant suspend && cd ..
	cd puppetagent && vagrant suspend && cd ..
	echo
}

resume() {
	echo $"Resuming $prog:"
	cd buildserver && vagrant resume && cd ..
	cd puppetmaster && vagrant resume && cd ..
	cd puppetagent && vagrant resume && cd ..
	echo
}

destroy() {
	echo $"Destoying $prog:"
	cd buildserver && vagrant destroy && cd ..
	cd puppetmaster && vagrant destroy && cd ..
	cd puppetagent && vagrant destroy && cd ..
	echo
}

status() {
	echo $"Status $prog: buildserver"
	cd buildserver && vagrant status && cd ..
	echo $"Status $prog: puppetmaster"
	cd puppetmaster && vagrant status && cd ..
	echo $"Status $prog: puppetagent"
	cd puppetagent && vagrant status && cd ..
	echo
}

case "$1" in
	start)
		start
		;;
	halt)
		halt
		;;
	reload)
		reload
		;;
	suspend)
    	suspend
    	;;
    resume)
		resume
		;;
	destroy)
		destroy
		;;
	status)
		status
		;;
	*)
		echo $"Usage: $0 {start|halt|reload|suspend|resume|destroy|status}"
		RETVAL=1
esac
exit $RETVAL
ddO#!/bin/bash


cd buildserver && vargrant up
cd ../puppetmaster && vagrant up
cd ../puppetagent && vagrant up
cd ..
