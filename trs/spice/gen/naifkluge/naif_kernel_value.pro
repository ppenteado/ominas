;=============================================================================
;+
; NAME:
;       naif_kernel_value
;
;
; PURPOSE:
;       Returns the value associated with a variable in a text NAIF kernel.
;
;
; CATEGORY:
;       UTIL/SPICE
;
;
; CALLING SEQUENCE:
;       value = naif_kernel_value(file, keyword) 
;
;
; ARGUMENTS:
;  INPUT:
;	file:		Name of a NAIF text kernel file.
;
;       keyword:        Name of a keyword to match.  Wildcards are allowed.
;
;  OUTPUT: 
;	keys:		Matched keywords.
;
;
; KEYWORDS:
;  INPUT: NONE
;
;  OUTPUT: NONE
;
;
; RETURN: 		Value associated with the specified keyword.
;
;
; STATUS:
;       Incomplete: '+=' syntax not fully implemented.
;
;
; MODIFICATION HISTORY:
;       Written by:     Spitale      2/2020
;-
;=============================================================================
function naif_kernel_value, file, keyword, keys=keys

 ;----------------------------------------------------
 ; read file
 ;----------------------------------------------------
 lines = read_txt_file(file, /raw)

 ;----------------------------------------------------
 ; extract data sections
 ;----------------------------------------------------
 lines = naif_kernel_data(lines)

 ;----------------------------------------------------
 ; separate keywords and values
 ;----------------------------------------------------
 keys = str_nnsplit(lines, '=', rem=vals)

 ;----------------------------------------------------
 ; record appending assignments
 ;----------------------------------------------------
 fkeys = str_flip(keys)
 wapp = where(strmid(fkeys,0,1) EQ '+')
 if(wapp[0] NE -1) then keys[wapp] = str_flip(strmid(fkeys[wapp],1,128))
 keys = strtrim(keys, 2)

 ;----------------------------------------------------
 ; clean up value strings
 ;----------------------------------------------------
 vals = strep_char(vals, '(', ' ')
 vals = strep_char(vals, ')', ' ')
 vals = strep_char(vals, ',', ' ')
 vals = strep_char(vals, "'", ' ')
 vals = strtrim(vals, 2)

 ;----------------------------------------------------
 ; match keyword
 ;----------------------------------------------------
 w = where(strmatch(keys, keyword))
 if(w[0] EQ -1) then return, ''
keys = keys[w]
return, vals[w]
 if(n_elements(w) EQ 1) then return, vals[w]

 ;----------------------------------------------------
 ; sort out appendments versus assignments
 ;----------------------------------------------------
 ww = nwhere(wapp, w)
 wwapp = wapp[ww]
;vals[wwapp]
stop



end
;=============================================================================

; val = naif_kernel_value('/home/spitale/ominas_data/trs/cas/kernels/pck/cpck_rock_01Oct2007.tpc', 'NAIF_BODY_CODE')

; val = naif_kernel_value('/home/spitale/ominas_data/trs/cas/kernels/pck/cpck_rock_01Oct2007.tpc', 'BODY*_GM')
