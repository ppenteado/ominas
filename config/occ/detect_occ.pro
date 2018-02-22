;===========================================================================
; detect_occ.pro
;
;===========================================================================
function __detect_occ, dd

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
 if(strpos(s, 'LBLSIZE') EQ 0) then status = 1

 ;==============================
 ; close config file
 ;==============================
 close, unit
 free_lun, unit

 ;==============================================
 ; if vicar file, then reopen and look at label
 ;==============================================
 if(status EQ 1) then $
  begin
   xx = read_vicar(filename, label, /nodata, /silent)
   xx = vicgetpar(label, 'OCCFILE', stat=stat)
   if(keyword_set(stat)) then status = 0
  end


 return, status
end
;===========================================================================



;===========================================================================
; detect_occ.pro
;
;===========================================================================
function detect_occ, dd

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
;   if(error NE 0) then nv_message, /anonymous, !err_string
   if(error NE 0) then return, 0
   record = assoc(unit, bytarr(20,/nozero))
   s = string(record[0])
   close, unit
   free_lun, unit
  end



 ;===================================
 ; check for vicar label 
 ;===================================
 if(strpos(s[0], 'LBLSIZE') EQ 0) then status = 1

 ;==============================================
 ; if vicar file, then reopen and look at label
 ;==============================================
 if(status EQ 1) then $
  begin
   xx = read_vicar(filename, label, /nodata, /silent)
   xx = vicgetpar(label, 'OCCFILE', stat=stat)
   if(keyword_set(stat)) then status = 0
  end


 return, status
end
;===========================================================================
