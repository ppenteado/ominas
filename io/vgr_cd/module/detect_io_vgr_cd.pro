;===========================================================================
; detect_io_vgr_cd.pro
;
;===========================================================================
function detect_io_vgr_cd, dd, arg, query=query
 if(keyword_set(query)) then return, 'FILETYPE'

return, ''	; this detector is obsolete, needs to be updated
 status = 1 

 ;==============================
 ; open the file
 ;==============================
 openr, unit, arg.filename, /get_lun, error=error
 if(error NE 0) then nv_message, /anonymous, !err_string
 dat = fstat(unit)

 ;=================================
 ; read the first 1000 characters
 ;=================================
 if(dat.size LT 2000) then return, 0
 b = bytarr(2000,/nozero)
 readu, unit, b
 w = where(b EQ 0)
 if(w[0] NE -1) then b[w] = 32
 s = string(b)

 ;=================================
 ; check for key strings
 ;=================================
 if(strpos(s, 'ENCODING_HISTOGRAM') EQ -1) then status = 0
 if(strpos(s, 'ENGINEERING_TABLE') EQ -1) then status = 0
 if(strpos(s, 'SFDU_LABEL') EQ -1) then status = 0
 if(strpos(s, 'VOYAGER') EQ -1) then status = 0


 ;==============================
 ; close config file
 ;==============================
 close, unit
 free_lun, unit


 if(status) then return, 'VGR_CD' 
 return, 0
end
;===========================================================================
