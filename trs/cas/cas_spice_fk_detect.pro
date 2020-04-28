;=============================================================================
; cas_spice_fk_detect
;
;=============================================================================
function cas_spice_fk_detect, dd, kpath, sc=sc, time=time, $
                                        strict=strict, all=all

 ;--------------------------------
 ; new naming convention
 ;--------------------------------
 all_files = file_search(kpath + 'cas_v??.tf')
; if(NOT keyword__set(all_files)) then $
;              nv_message, 'No kernel files found in ' + kpath + '.'

 if(keyword__set(all)) then return, all_files

 split_filename, all_files, dir, all_names
 ver = long(strmid(all_names, 5, 2))

 w = where(ver EQ max(ver))
 return, all_files[w]
end
;=============================================================================
