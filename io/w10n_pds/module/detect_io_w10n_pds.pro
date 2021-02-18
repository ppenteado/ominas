;===========================================================================
; detect_io_w10n_pds.pro
;
;===========================================================================
function detect_io_w10n_pds, dd, arg, query=query
 if(keyword_set(query)) then return, 'FILETYPE'

 ;if(keyword_set(arg.header)) then return, 0

 if (strpos(arg.filename,'https://pds-imaging.jpl.nasa.gov/w10n/') EQ 0 ) then return, 'W10N_PDS'
 if (strpos(arg.filename,'http://pds-imaging.jpl.nasa.gov/w10n/') EQ 0 ) then return, 'W10N_PDS'

 return, 0
end
;===========================================================================
