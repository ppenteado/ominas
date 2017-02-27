#=======================================================================
#+
# MULTI-MISSION SHELL EXAMPLE
# ---------------------------
#
#   Created by Joe Spitale
#   
#   Feb 2017
#
#    This example file usees the grim xidl alias to run grim from a shell.
#    The command loads all of the images in the demo data directory, representing
#    several missions, and computes geometrc quantities for each.
#
#    This example file can be executed from the UNIX command line using::
#
#     multimission_example.sh
#
#    or the command may be pasted directly at the shell prompt.
#-
#=======================================================================
grim data/*.img data/n* data/*.IMG over=planet_center,limb,terminator,ring

