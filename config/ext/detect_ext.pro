;===========================================================================
; detect_ext.pro
;
;===========================================================================
function detect_ext, dd

 filename = dat_filename(dd)
 header = dat_header(dd)

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
