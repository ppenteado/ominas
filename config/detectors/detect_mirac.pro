;===========================================================================
; detect_mirac.pro
;
;===========================================================================
function detect_mirac, dd

 header = dat_header(dd) 

 instrument = sxpar(header, 'INSTRUME')
 if(strpos(instrument, 'MIRAC') NE -1) then return, 'MIRAC'
 
 return, ''
end
;===========================================================================
