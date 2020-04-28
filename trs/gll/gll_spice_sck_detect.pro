;=============================================================================
; gll_spice_sck_detect
;
;=============================================================================
function gll_spice_sck_detect, dd, kpath, sc=sc, time=time, $
                                         strict=strict, all=all

; sc = 'gll'
 sc = 'mk'
 all_files = file_search(kpath + sc + '?????.tsc')
all_files = file_search(kpath + '*.tsc')

all=1
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
