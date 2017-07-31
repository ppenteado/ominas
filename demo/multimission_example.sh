#=======================================================================
#+
# MULTI-MISSION SHELL EXAMPLE
# ---------------------------
#
#   Created by Joe Spitale
#   
#   Feb 2017
#
#    This example file uses the grim alias to run grim from a shell.
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
grim 'data/N1350122987_2.IMG data/2100r.img data/c3440346.gem' over=planet_center,limb,terminator,ring

