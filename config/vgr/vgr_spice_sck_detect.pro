;=============================================================================
; vgr_spice_sck_detect
;
;=============================================================================
function vgr_spice_sck_detect, dd, kpath, time=time, reject=reject, strict=strict, all=all

 sc = vgr_parse_inst(nv_instrument(dd), cam=cam)
 all_files = findfile(kpath + sc + '?????.tsc')

 ;--------------------------------
 ; new naming convention
 ;--------------------------------
 if(keyword__set(all)) then return, all_files

 split_filename, all_files, dir, all_names
 ver = long(strmid(all_names, 3, 5))

 w = where(ver EQ max(ver))
 return, all_files[w]
end
;=============================================================================
