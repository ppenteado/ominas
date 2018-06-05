;=============================================================================
;+
; NAME:
;       ominas_argv
;
; PURPOSE:
;       Returns the shell argument list.  Arguments are expanded
;	according to standard shell rules.  "-" and "--" are used instead 
;	of "/" to set a keyword to one.  Arrays are specified as 
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
function ominas_argv, i, keyvals=keyvals

 ;----------------------------------------------------------------
 ; get IDL arguments
 ;----------------------------------------------------------------
 argv = command_line_args()
 if(n_elements(argv) EQ 0) then return, ''

 ;----------------------------------------------------------------
 ; get IDL arguments
 ;----------------------------------------------------------------
 w = where(argv NE '-args')
 if(w[0] EQ -1) then return, ''
 argv = argv[w]

 ;----------------------------------------------------------------
 ; parse switch characters
 ;----------------------------------------------------------------
 first = strmid(argv, 0, 1)
 first2 = strmid(argv, 0, 2)
 _arg = strmid(argv,1,1024)
 __arg = strmid(argv,2,1024)

 w = where(first EQ '-')
 if(w[0] NE -1) then argv[w] = _arg[w] + '=1'

 w = where(first2 EQ '--')
 if(w[0] NE -1) then argv[w] = __arg[w] + '=1'

 ;----------------------------------------------------------------
 ; distinguish keyword=value vs positional args
 ;----------------------------------------------------------------
 kv = ''
 w = where(strpos(argv, '=') NE -1, comp=ww)
 if(w[0] NE -1) then kv = argv[w]
 if(keyword_set(keyvals)) then return, kv

 ;----------------------------------------------------------------
 ; retain only positional args, if any
 ;----------------------------------------------------------------
 if(ww[0] EQ -1) then return, ''
 argv = argv[ww]

 ;----------------------------------------------------------------
 ; return desired arguments
 ;----------------------------------------------------------------
 if(NOT defined(i)) then return, argv
 if(i GE n_elements(argv)) then return, ''

 return, argv[i]
end
;=========================================================================



