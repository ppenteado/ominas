;===========================================================================
; detect_pds4.pro
;
;===========================================================================
function detect_pds4, dd

 filename = dat_filename(dd)
 header = dat_header(dd)

 ;==============================================================================
 ; there is no standard pds4 header so don't continue if a header is present
 ;==============================================================================
 if(keyword_set(header)) then return, 0 


 ;===============================================
 ; check first few bytes for xml file
 ;===============================================
 openr, unit, filename, /get_lun, error=error
 if(error NE 0) then nv_message, /anonymous, !err_string

 record = assoc(unit, bytarr(13,/nozero))
 s = string(record[0])
 close, unit
 free_lun, unit

 if(s NE '<?xml version') then return, 0



 ;=================================================
 ; check entire xml file for pds4 characteristics
 ;=================================================
 openr, unit, filename, /get_lun, error=error
 if(error NE 0) then nv_message, /anonymous, !err_string
 stat = fstat(unit)
 n = stat.size < 65535

 record = assoc(unit, bytarr(stat.size,/nozero))
 s = string(record[0])
 close, unit
 free_lun, unit
 
 if(strpos(s, '<Observation_Area>') EQ -1) then return, 0



 return, 1
end
;===========================================================================
