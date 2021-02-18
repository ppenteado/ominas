;===========================================================================
; detect_io_pds_pds4.pro
;
;===========================================================================
function detect_io_pds_pds4, dd, arg, query=query
 if(keyword_set(query)) then return, 'FILETYPE'

 ;==============================================================================
 ; there is no standard pds4 header so don't continue if a header is present
 ;==============================================================================
 if(keyword_set(arg.header)) then return, 0 


 ;===============================================
 ; check first few bytes for xml file
 ;===============================================
 openr, unit, arg.filename, /get_lun, error=error
 if(error NE 0) then return, 0

 if((fstat(unit)).size LT 13) then return, 0
 record = assoc(unit, bytarr(13,/nozero))
 s = string(record[0])
 close, unit
 free_lun, unit

 if(s NE '<?xml version') then return, 0



 ;=================================================
 ; check entire xml file for pds4 characteristics
 ;=================================================
 openr, unit, arg.filename, /get_lun, error=error
 if(error NE 0) then nv_message, /anonymous, !err_string
 stat = fstat(unit)
 n = stat.size < 65535

 record = assoc(unit, bytarr(stat.size,/nozero))
 s = string(record[0])
 close, unit
 free_lun, unit
 
 if(strpos(s, '<Observation_Area>') EQ -1) then return, 0



 return, 'PDS4'
end
;===========================================================================
