;=============================================================================
; juno_spice_ik_detect
;
;=============================================================================
function juno_spice_ik_detect, dd, kpath, sc=sc, time=time, strict=strict, all=all

 ;--------------------------------
 ; new naming convention
 ;--------------------------------
 all_files = file_search(kpath + 'juno_*_v*.ti')
; if(NOT keyword__set(all_files)) then $
;                nv_message, 'No kernel files found in ' + kpath + '.'

 if(keyword__set(all)) then return, all_files

 split_filename, all_files, dir, all_names
 snames=stregex(all_names,'juno_([^_]+)_v([[:digit:]]+)\.ti',/extract,/subexpr)
 insts=reform(snames[1,*])
 insts=insts[sort(insts)]
 insts=insts[uniq(insts)]
 reti=[]
 foreach inst,insts do begin
   w=where(snames[1,*] eq inst)
   files=all_names[w]
   mf=max(files,ml)
   reti=[reti,w[ml]]
 endforeach

  return, all_files[reti]
end
;=============================================================================
