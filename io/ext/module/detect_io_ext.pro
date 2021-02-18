;===========================================================================
; detect_io_ext.pro
;
;===========================================================================
function detect_io_ext, dd, arg, query=query
 if(keyword_set(query)) then return, 'FILETYPE'

 ;=============================
 ; determine function name
 ;=============================
 extname = ext_get_name(arg.filename)

 ;============================================
 ; check to see if such a function exists
 ;============================================
 if(NOT routine_exists(extname)) then return, 0

; which, extname, out=out
; if(out EQ 'Not found.') then return, 0

 return, 'EXT'
end
;===========================================================================
