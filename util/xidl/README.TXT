XIDL is a simple shell interface to IDL, which allows arguments to
be passed to IDL programs from the shell command prompt.  

Configure your (csh) environment as follows:

setenv XIDL_DIR         $HOME/idl_pro/xidl/
alias xidl              'csh $XIDL_DIR/xidl.csh'
setenv IDL_PATH          ${IDL_PATH}:+${XIDL_DIR}


