;=============================================================================
;+
; NAME:
;       naif_kernel_data
;
;
; PURPOSE:
;       Returns the lines from the data sections of a text kernel.
;
;
; CATEGORY:
;       UTIL/SPICE
;
;
; CALLING SEQUENCE:
;       data_lines = naif_kernel_data(lines) 
;
;
; ARGUMENTS:
;  INPUT:
;	file:		Name of a NAIF text kernel file.
;
;       keyword:        Name of a keyword.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: NONE
;
;  OUTPUT: NONE
;
;
; RETURN: 		Lines appearing inside the data sections..
;
;
; STATUS:
;       Complete.
;
;
; MODIFICATION HISTORY:
;       Written by:     Spitale      2/2020
;-
;=============================================================================
function naif_kernel_data, lines

 nlines = n_elements(lines)

 ;----------------------------------------------------
 ; find delimeters
 ;----------------------------------------------------
 wlines = strtrim(lines,2)
 wbegin = where(wlines EQ '\begindata')
 wtext = where(wlines EQ '\begintext')

 ;----------------------------------------------------
 ; extract data sections
 ;----------------------------------------------------
 count = lonarr(nlines)
 for i=0, n_elements(wbegin)-1 do count[wbegin[i]+1:*] += 1
 for i=0, n_elements(wtext)-1 do count[wtext[i]:*] -= 1
 wdata = where(count GT 0)

 return, str_cull(lines[wdata])
end
;=============================================================================

