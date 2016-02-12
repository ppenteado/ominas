;=============================================================================
; dhh_extract
;
;=============================================================================
function dhh_extract, dh, section, dh_history=dh_history

 dh_history=''

 ;----------------------------------
 ; search for section
 ;----------------------------------
 w = where(dh EQ '<'+ section +'>')
 if(w[0] EQ -1) then return, ''

 w1 = where(strmid(dh[w[0]+1:*], 0, 1) EQ '<')

 if(w1[0] NE -1) then dh_section = dh[w[0]:w[0]+w1[0]-1] $
 else dh_section = dh[w[0]:*]



 ;----------------------------------
 ; separate history section
 ;----------------------------------
 w = where(strmid(dh, 0, 1) EQ '<')
 if(w[0] GT 0) then dh_history = dh[0:w[0]-1]



 return, dh_section
end
;=============================================================================



