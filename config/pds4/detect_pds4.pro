;===========================================================================
; detect_pds4.pro
;
;===========================================================================
function detect_pds4, dd

 filename = dat_filename(dd)
 header = dat_header(dd)

 ;===============================================
 ; there is no standard pds4 header
 ;===============================================
 if(keyword_set(header)) then return, 0 


 ;===============================================
 ; look at file
 ;===============================================
 openr, unit, filename, /get_lun, error=error
 if(error NE 0) then nv_message, /anonymous, !err_string

 stat = fstat(unit)
 n = stat.size < 65535

 record = assoc(unit, bytarr(n,/nozero))
 s = string(record[0])
 close, unit
 free_lun, unit


 ;===================================
 ; check for pds4 xml header 
 ;===================================
 if(strmid(s[0], 0, 13) NE '<?xml version') then return, 0
 if(strpos(s[0], '<Observation_Area>') EQ -1) then return, 0

 return, 1
end
;===========================================================================
