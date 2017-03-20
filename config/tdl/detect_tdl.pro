;===========================================================================
; detect_tdl.pro
;
;===========================================================================
function detect_tdl, dd

 filename = dat_filename(dd)
 status=0

 ;==============================
 ; open the file
 ;==============================
 openr, unit, filename, /get_lun, error=error
 if(error NE 0) then nv_message, /anonymous, !err_string

 ;=================================
 ; read the first thirty characters
 ;=================================
 record = assoc(unit, bytarr(20,/nozero))
 s = string(record[0])
 if(strpos(s, 'TDL_LBLSIZE') NE -1) then status=1

 ;==============================
 ; close config file
 ;==============================
 close, unit
 free_lun, unit


 return, status
end
;===========================================================================
