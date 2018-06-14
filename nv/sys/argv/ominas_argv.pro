;=============================================================================
;+
; NAME:
;       ominas_argv
;
; PURPOSE:
;       Returns the shell argument list.  Arguments are expanded
;	according to standard shell rules.  Arrays are specified as 
;	comma-delineated lists with no white space.  
;
;
; CATEGORY:
;       BAT
;
;
; CALLING SEQUENCE:
;       arg = ominas_argv(i)
;
;
; ARGUMENTS:
;  INPUT: 
;	i:	Index of positional argument to return.  If there are no 
;		positional arguments, or if i is invalid, then '' is returned.  
;		If i is not specified, then all arguments are returned.  
;
;  OUTPUT: NONE
;
;
; KEYWORDS: 
;  INPUT: 
;	keyvals: 
;		If set, keyword arguments are returned instead of positional 
;		arguments.  In this case, i has no meaning.
;
;	delim:	 Delimiters(s) to use instead of '==' and '='.
;
;	toggle:	 Toggle character(s) to use instead of '--' and '-'.
;
;  OUTPUT: NONE
;
;
; RETURN:
;       The requested argument.  Note all arguments are returned as strings.
;
;
; STATUS:
;       Complete.
;
;
; MODIFICATION HISTORY:
;       Adapted from xidl_argv by:     Spitale 6/2017
;
;-
;=============================================================================
function ominas_argv, i, delim=delim, toggle=toggle

 ;----------------------------------------------------------------
 ; strip out keyword/value pairs
 ;----------------------------------------------------------------
 values = ominas_value(delim=delim, toggle=toggle, keywords, argv0=argv)

 ;----------------------------------------------------------------
 ; return desired arguments
 ;----------------------------------------------------------------
 if(NOT keyword_set(argv)) then return, ''
 if(NOT defined(i)) then return, argv
 if(i GE n_elements(argv)) then return, ''

 return, argv[i]
end
;=========================================================================

