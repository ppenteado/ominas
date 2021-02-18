;===========================================================================
; detect_io_geotiff.pro
;
;===========================================================================
function detect_io_geotiff, dd, arg, query=query
 if(keyword_set(query)) then return, 'FILETYPE'

 status = 0

 ;===============================================
 ; if no header, read the beginning of the file
 ;===============================================
 if(keyword_set(arg.header)) then b=byte(arg.header) else begin
   openr, unit, arg.filename, /get_lun, error=error
   if(error NE 0) then return, 0
   if((fstat(unit)).size LT 16) then return, 0
   b=bytarr(16)
   readu,unit,b
   free_lun, unit
  endelse
 if(n_elements(b) LE 1) then return, 0

 ;===================================
 ; check for tiff header 
 ;===================================
 
 if size(b,/type) eq 8 then begin
  tn=tag_names(b)
  if total(strmatch(tn,'INFO')+strmatch(tn,'GEO')+strmatch(tn,'PLANET')) eq 3 then return,'GEOTIFF' else return,0
 endif
 
 ;endianness
 case 1 of
   (b[0] eq 73B) and (b[1] eq 73B): bole=1
   (b[0] eq 77B) and (b[1] eq 77B): bole=0
   else: return,0 ; get out if magic numbers do not match tiff
 endcase
 
 if bole then mn=swap_endian(uint(b[2:3],0),/swap_if_big) else mn=swap_endian(uint(b[2:3],0),/swap_if_little)
 if ((mn ne 42) && (mn ne 43)) then return,0 ;get out if magic numbers do not match tiff or bigtiff 
 
 status=query_tiff(arg.filename,geotiff=geo)
 if size(geo,/type) ne 8 then return,0 ;must be geotiff, not just tiff


 if(status) then return, 'GEOTIFF'
 return, 0
end
;===========================================================================
