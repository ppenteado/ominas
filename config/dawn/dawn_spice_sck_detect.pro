;=============================================================================
; dawn_spice_sck_detect
;
;=============================================================================
function dawn_spice_sck_detect, dd, kpath, time=time, strict=strict, all=all

 ;--------------------------------
 ; new naming convention
 ;--------------------------------
 all_files = file_search(kpath + 'DAWN_203_*SCLKSCET.?????.tsc')

 if(keyword__set(all)) then return, all_files

 split_filename, all_files, dir, all_names

 junk = str_nnsplit(all_names, '.', rem=rem)
 ver = long(strmid(rem, 0, 5))

 w = where(ver EQ max(ver))
 return, all_files[w]
end
;=============================================================================
