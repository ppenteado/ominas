;===========================================================================
; detect_io_occ.pro
;
;===========================================================================
function detect_io_occ, dd, arg, query=query
 if(keyword_set(query)) then return, 'FILETYPE'

 status = 0

 ;===============================================
 ; if no header, read the beginning of the file
 ;===============================================
 if(keyword_set(arg.header)) then s = arg.header $
 else $
  begin
   openr, unit, arg.filename, /get_lun, error=error
   if(error NE 0) then return, 0
   if((fstat(unit)).size LT 20) then return, 0
   record = assoc(unit, bytarr(20,/nozero))
   s = string(record[0])
   close, unit
   free_lun, unit
  end


 ;===================================
 ; check for vicar label 
 ;===================================
 if ~isa(s,'string') then return,0
 if(strpos(s[0], 'LBLSIZE') EQ 0) then status = 1

 ;==============================================
 ; if vicar file, then reopen and look at label
 ;==============================================
 if(status EQ 1) then $
  begin
   xx = read_vicar(arg.filename, arg.header, /nodata, /silent)
   xx = vicgetpar(arg.header, 'OCCFILE', stat=stat)
   if(keyword_set(stat)) then status = 0
  end


 if(status) then return, 'OCC'
 return, 0
end
;===========================================================================