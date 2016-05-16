;=============================================================================
; dawn_spice_spk_components
;
;=============================================================================
pro dawn_spice_spk_components, all_names, jd_start=jd_start, jd_stop=jd_stop, jd_release=jd_release


 ;-------------------------------------
 ; extract start time
 ;-------------------------------------
 jd_start = yymmdd_to_jd(strmid(all_names, 9, 6))


 ;-------------------------------------
 ; extract stop time
 ;-------------------------------------
 jd_stop = yymmdd_to_jd(strmid(all_names, 16, 6))


 ;-------------------------------------
 ; extract release date
 ;-------------------------------------
 jd_release = yymmdd_to_jd(strmid(all_names, 23, 6))


end
;=============================================================================



;=============================================================================
; dawn_spice_spk_detect
;
; Only kernels whose filenames match the standard convention and whose 
; coverage dates are within djd days of the given image are returned.
;
;=============================================================================
function dawn_spice_spk_detect, dd, spkpath, djd=djd, time=time, $
                             all=all, reject=reject, strict=strict
common dawn_spice_spk_block, all_files, all_names_block, spkpath_block, $
      jd_start_block, jd_stop_block, jd_release_block

 if(NOT keyword_set(djd)) then djd = 1d			; days, +/-

 label = dat_header(dd)
 

 ;--------------------------------
 ; get image jd
 ;--------------------------------
 if(NOT keyword_set(time)) then jd = spice_str2jed(dawn_spice_time(label)) $
 else jd = spice_et2jed(time)

 jd = jd[0]



 ;--------------------------------
 ; get spk jd's
 ;--------------------------------
 if(keyword_set(spkpath_block)) then $
  if(spkpath NE spkpath_block) then jd_start_block = ''

 if(NOT keyword_set(jd_start_block)) then $
  begin
   all_files = findfile(spkpath + '/dawn_*_??????[-,_]??????_??????*.bsp')
   if(keyword_set(all)) then return, all_files



   ;--------------------------------------------------
   ; extract components 
   ;--------------------------------------------------
   split_filename, all_files, dir, all_names
   all_names = str_nnsplit(all_names, '.')

   dawn_spice_spk_components, all_names, jd_start=_jd_start, jd_stop=_jd_stop, $
      jd_release=_jd_release
   jd_start_block = append_array(jd_start_block, _jd_start)
   jd_stop_block = append_array(jd_stop_block, _jd_stop)
   jd_release_block = append_array(jd_release_block, _jd_release)

   spkpath_block = spkpath
   all_names_block = all_names
  end

 jd_start = jd_start_block
 jd_stop = jd_stop_block
 jd_release = jd_release_block
 all_names = all_names_block



 ;--------------------------------------------------------------------
 ; compare dates
 ;--------------------------------------------------------------------
 w = where((jd GE jd_start-djd) AND (jd LE jd_stop+djd))
 if(w[0] NE -1) then $
  begin 
   jd_start = jd_start[w] & jd_stop = jd_stop[w]
   jd_release = jd_release[w]
   spk_files = all_files[w]
  end 



 ;----------------------------------------------------------
 ; if no kernels found, then return first spk file in order
 ; to avoid naiflib error 
 ;----------------------------------------------------------
 if(NOT keyword_set(spk_files)) then spk_files = all_files[0]


 return, spk_files
end
;=============================================================================
