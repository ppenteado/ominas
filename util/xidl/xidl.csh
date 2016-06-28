##############################################################################
# xidl.csh
#
# XIDL
# ----  
#
#  The XIDL system is a simple mechanism that passes command-line arguments
#  from the shell prompt to an IDL program.  XIDL therefore allows IDL programs
#  to be started from the shell prompt in a convenient manner.  
#
#  XIDL programs should be called as follows:
#
#          xidl <idl_batch> + <arguments>
#
#  The '+' token  denotes the beginning of the argument list to be passed to
#  IDL.  The argument preceding '+' is assumed to be the name of an IDL batch
#  file.  xidl.csh saves the shell argument list to the environment array
#  XIDL_ARGS, and runs the IDL batch file xid.bat, followed by the user-
#  specified batch file <idl_batch>.  xidl.bat runs xidl.pro, which saves the 
#  argument list in a common block to be accessed by xidl_parse_argv and
#  xidl_argv, which may be used by <idl_batch> to set up a call to the 
#  desired IDL program via EXECUTE, using xidl_command.
#
#  XIDL was developed by Dr. Joseph Spitale as a shell interface for the
#  OMINAS system.
#
##############################################################################
setenv XIDL_ARGS "$*"

foreach i (1 2 3 4 5)
 if($argv[$i] == +) then
  @ i -= 1
  idl xidl.bat $argv[-$i]
  break
 endif
end

