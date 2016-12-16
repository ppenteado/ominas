;===========================================================================
; detect_vicar.pro
;
;===========================================================================
function detect_vicar, filename, udata

 status=0

 ;==============================
 ; open the file
 ;==============================
 openr, unit, filename, /get_lun, error=error
 if(error NE 0) then nv_message, /anonymous, !err_string

 ;=================================
 ; read the first thiry characters
 ;=================================
; record = assoc(unit, bytarr(7,/nozero))
; s=string(record[0])
; if(s EQ 'LBLSIZE') then status=1
 record = assoc(unit, bytarr(20,/nozero))
 s = string(record[0])
; if(strpos(s, 'LBLSIZE') NE -1) then status=1
 if(strpos(s, 'LBLSIZE') EQ 0) then status=1

 ;==============================
 ; close config file
 ;==============================
 close, unit
 free_lun, unit


 return, status
end
;===========================================================================
