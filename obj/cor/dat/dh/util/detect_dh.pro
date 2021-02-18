;===========================================================================
; detect_dh.pro
;
;===========================================================================
function detect_dh, dd, arg, query=query
stop
 if(keyword_set(query)) then return, 'FILETYPE'

 status = 0

 ;==============================
 ; open the file
 ;==============================
 openr, unit, arg.filename, /get_lun, error=error
; if(error NE 0) then nv_message, /anonymous, !err_string
 if(error NE 0) then return, 0

 ;=================================
 ; read the first thirty characters
 ;=================================
 record = assoc(unit, bytarr(9,/nozero))
 s = string(record[0])
 if(strpos(s, 'history =') EQ 0) then status = 1

 ;==============================
 ; close config file
 ;==============================
 close, unit
 free_lun, unit


 if(status) then return, 'DH'
 return, 0
end
;===========================================================================
