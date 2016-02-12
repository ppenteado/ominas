;===========================================================================
; detect_ext.pro
;
;===========================================================================
function detect_ext, filename, udata

 ;=============================
 ; determine function name
 ;=============================
 extname = ext_get_name(filename)

 ;============================================
 ; check to see if such a function exists
 ;============================================
 if(NOT routine_exists(extname)) then return, 0

; which, extname, out=out
; if(out EQ 'Not found.') then return, 0

 return, 1
end
;===========================================================================
