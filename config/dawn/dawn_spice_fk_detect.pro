;=============================================================================
; dawn_spice_fk_detect
;
;=============================================================================
function dawn_spice_fk_detect, dd, kpath, time=time, reject=reject, strict=strict, all=all

 ;--------------------------------
 ; new naming convention
 ;--------------------------------
 all_files = file_search(kpath + 'dawn_v??.tf')

 if(keyword__set(all)) then return, all_files

 split_filename, all_files, dir, all_names
 ver = long(strmid(all_names, 6, 2))

 w = where(ver EQ max(ver))
 return, all_files[w]
end
;=============================================================================
