;=============================================================================
;+
; NAME:
;       xidl
;
; PURPOSE:
;       Reads the XIDL_ARGV envoronment variable and extracts the argument
;	list, which is placed in a common block.
;
;
; CATEGORY:
;       XIDL
;
;
; CALLING SEQUENCE:
;       xidl
;
;
; ARGUMENTS:
;  INPUT: NONE
;
;  OUTPUT: NONE
;
;
; KEYWORDS: NONE
;
;
; SIDE EFFECTS:
;       The xidl_block common block is modified.
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
pro xidl
 common xidl_block, argv

 ;-----------------------------------------------
 ; get command line args stored by xidl.csh
 ;-----------------------------------------------
 _argv = str_sep(strtrim(getenv('XIDL_ARGS'),2), ' ')

 
 ;------------------------------------------------------------
 ; remove shell arguments preceding '+' and store argv list
 ;------------------------------------------------------------
 w = where(_argv EQ '+')

 argv = ''
 if(n_elements(_argv) GT w[0]+1) then argv = _argv[w[0]+1:*]

end
;=========================================================================



