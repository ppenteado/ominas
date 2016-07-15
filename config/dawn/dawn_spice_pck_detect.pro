;=============================================================================
; dawn_spice_pck_detect
;
;
;=============================================================================
function dawn_spice_pck_detect, dd, kpath, time=time, reject=reject, strict=strict, all=all

 ;-----------------------------------
 ; general pck's
 ;-----------------------------------
 genk = eph_spice_pck_detect(dd, kpath, time=time, reject=reject, strict=strict, all=all)

 
 ;-----------------------------------
 ; dawn-specific pck's
 ;-----------------------------------
 all_files = file_search(kpath + 'dawn_vesta_v??.tpc')

 if(keyword__set(all)) then vk = all_files $
 else $
  begin
   split_filename, all_files, dir, all_names
   ver = long(strmid(all_names, 12, 2))

   w = where(ver EQ max(ver))
   vk = all_files[w]
  end


 if(keyword_set(genk)) then k = append_array(k, genk)
 if(keyword_set(vk)) then k = append_array(k, vk)
 return, k
end
;=============================================================================
