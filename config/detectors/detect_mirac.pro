;===========================================================================
; detect_mirac.pro
;
;===========================================================================
function detect_mirac, header, udata

 instrument = sxpar(header, 'INSTRUME')
 if(strpos(instrument, 'MIRAC') NE -1) then return, 'MIRAC'
 
 return, ''
end
;===========================================================================
