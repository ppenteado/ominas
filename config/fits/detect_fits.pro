;===========================================================================
; detect_fits.pro
;
;===========================================================================
function __detect_fits, dd

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
 record = assoc(unit, bytarr(6,/nozero))
 s=string(record[0])
 if(s EQ 'SIMPLE') then status=1

 ;==============================
 ; close config file
 ;==============================
 close, unit
 free_lun, unit


 return, status
end
;===========================================================================



;===========================================================================
; detect_fits.pro
;
;===========================================================================
function detect_fits, dd

 filename = dat_filename(dd)
 header = dat_header(dd)
 status = 0

 ;===============================================
 ; if no header, read the beginning of the file
 ;===============================================
 if(keyword_set(header)) then s = header[0] $
 else $
  begin
   openr, unit, filename, /get_lun, error=error
   if(error NE 0) then nv_message, /anonymous, !err_string
   record = assoc(unit, bytarr(6,/nozero))
   s=string(record[0])
   close, unit
   free_lun, unit
  end


 ;==============================
 ; check for indicator string
 ;==============================
 if(s EQ 'SIMPLE') then status=1


 return, status
end
;===========================================================================
