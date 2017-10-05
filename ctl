#!/bin/bash
## ctl
## Mac Radigan
##
## Copyright 2016 Mac Radigan
## All Rights Reserved

  d=${0%/*}; f=${0##*/}; n=${f%.*}; e=${f##*.}
  if [ -f /opt/current.env ]; 
  then
    .  /opt/current.env
  fi

  S__SUCCESS=0
  S__NO_SUCH_COMMAND=1

  usage()
  {
    >&2 cat <<-EOT 
		$f [args]
			  demo                  - run the demo
EOT
    exit ${S__SUCCESS}
  }

  die()
  {
    code=$1; shift
    msg=$1;  shift
    (>&2 echo "ERROR ${code}: ${msg}")
    exit $code
  }

  warn()
  {
    code=$1; shift
    msg=$1;  shift
    (>&2 echo "WARN ${code}: ${msg}")
    exit $code
  }

  if [[ "$#" == "0" ]]; then
    usage
  fi

  util()
  {
    cmd=$1; shift
    case $cmd in
      find)
        /usr/bin/find $*
        ;;
      shell)
        /bin/bash $*
        ;;
      ls)
        /bin/ls $*
        ;;
      cat)
        /bin/cat $*
        ;;
      ps)
        /bin/ps $*
        ;;
      exec)
        exec $*
        ;;
      *)
        die $S__NO_SUCH_COMMAND "invalid utility: $cmd, must be one of ( find | shell | exec | ls | cat | ps )"
        ;;
    esac
  }

  run()
  {
    #cmd=$1; shift
    #$cmd $*
    env DISPLAY=:3 /usr/bin/stumpwm --eval '(load #P"~/quicklisp/setup.lisp")' 1>/dev/null 2>/dev/null
  }

  sigint()
  {
    (>&2 echo "shutting down")
    /etc/init.d/nginx stop
    kill 0
  }

  trap sigint SIGINT

  cmd=$1; shift
  case $cmd in
    demo)
      run
      ;;
    util)
      util $*
      ;;
    *)
      die $S__NO_SUCH_COMMAND "invalid command: $cmd"
      ;;
  esac

  exit $S__SUCCESS

## *EOF*
