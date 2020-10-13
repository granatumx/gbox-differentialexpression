!bquote
`gbox-multitool` is a gbox that provides a number of original gboxes from R.
!equote

===== Prerequisites =====

You mainly need a working copy of "Docker": "http://docker.com". It is used
exclusively to manage system configurations for running numerous tools
across numerous platforms.

===== Installation =====

* All docker images are at "https://hub.docker.com/u/granatumx".
* All github repos are at "https://github.com/granatumx/*".

First set up your scripts and aliases to make things easier. This command should pull the container if
it does not exist locally which facilitates installing on a server.
!bc sys
source <( docker run --rm -it granatumx/scripts:1.0.0 gx.sh )
!ec

This command makes `gx` available. You can simply run `gx` to obtain a list of scripts available.

The GranatumX database should be running to install gboxes. The gbox sources do not need to be installed.
A gbox has a gbox.tgz compressed tar file in the root directory which the installer copies out and uses
to deposit the preferences on the database. Since these gboxes are in fact docker images, they will be
pulled if they do not exist locally on the system. Convenience scripts are provided for installing specific gboxes.

!bc sys
$ gx run.sh                                         # Will start the database, taskrunner, and webapp
$ gx installGbox.sh granatumx/gbox-multitool:1.0.0  # Install this gbox

# Now go to http://localhost:34567 and see this gbox installed when you add a step.
!ec

===== Notes =====

The gbox has a set of parameters passed into it on the frontend. These are defined in the `yamls/*.yaml` file.
This tool uses R functions for the granatum_sdk to set up the gbox.
