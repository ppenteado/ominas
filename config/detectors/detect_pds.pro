;===========================================================================
; detect_pds.pro
;
;===========================================================================
function detect_pds, filename, udata

 status=0

 ;==============================
 ; open the file
 ;==============================
 openr, unit, filename, /get_lun, error=error
 if(error NE 0) then nv_message, !err_string

 ;=================================
 ; check the first few characters
 ;=================================
 record = assoc(unit, bytarr(14,/nozero))
 s = string(record[0])
 if(s EQ 'PDS_VERSION_ID') then status = 1

 ;==============================
 ; close config file
 ;==============================
 close, unit
 free_lun, unit

 return, status
end
;===========================================================================
