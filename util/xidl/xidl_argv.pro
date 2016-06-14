;=============================================================================
;+
; NAME:
;       xidl_argv
;
; PURPOSE:
;       Returns an argument from the xidl argument list.
;
;
; CATEGORY:
;       XIDL
;
;
; CALLING SEQUENCE:
;       arg = xidl_argv(i)
;
;
; ARGUMENTS:
;  INPUT: 
;	i:	Index of the argument to return.  If there are no arguments,
;		or if i is invalid, then '' is returned.  If i is not 
;		specified, then all arguments are returned.  
;
;  OUTPUT: NONE
;
;
; KEYWORDS: NONE
;
;
; RETURN:
;       The requested argument.  Note all arguments are returned as strings.
;
; STATUS:
;       Completed.
;
;
; MODIFICATION HISTORY:
;       Written by:     Spitale
;
;-
;=============================================================================
function xidl_argv, i
 common xidl_block, argv

 if(n_elements(argv) EQ 0) then return, ''

 first = strmid(argv, 0, 1)
 w = where(first EQ '-')
 if(w[0] NE -1) then argv[w] = strmid(argv[w],1,1024) + '=1'

 if(n_elements(i) EQ 0) then return, argv
 if(i GE n_elements(argv)) then return, ''

 return, argv[i]
end
;=========================================================================



