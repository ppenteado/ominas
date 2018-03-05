;===========================================================================
; detect_vicar.pro
;
;===========================================================================
function detect_vicar, dd

 filename = dat_filename(dd)
 header = dat_header(dd)
 status = 0


 ;===============================================
 ; if no header, read the beginning of the file
 ;===============================================
 if(keyword_set(header)) then s = header $
 else $
  begin
   openr, unit, filename, /get_lun, error=error
   if(error NE 0) then return, 0
   record = assoc(unit, bytarr(20,/nozero))
   s = string(record[0])
   close, unit
   free_lun, unit
  end


 ;===================================
 ; check for vicar label 
 ;===================================
 if(strpos(s[0], 'LBLSIZE') EQ 0) then status=1


 return, status
end
;===========================================================================
