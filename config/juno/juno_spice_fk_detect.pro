;=============================================================================
; juno_spice_fk_detect
;
;=============================================================================
function juno_spice_fk_detect, dd, kpath, sc=sc, time=time, strict=strict, all=all

 ;--------------------------------
 ; new naming convention
 ;--------------------------------
 all_files = file_search(kpath + 'juno_v*.tf')
; if(NOT keyword__set(all_files)) then $
;              nv_message, 'No kernel files found in ' + kpath + '.'

 if(keyword__set(all)) then return, all_files 
 
 return,max(all_files)
end
;=============================================================================
