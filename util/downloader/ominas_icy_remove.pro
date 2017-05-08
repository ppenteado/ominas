pro ominas_icy_remove
compile_opt idl2,logical_predicate
path=getenv('IDL_PATH') ? getenv('IDL_PATH') : PREF_GET('IDL_PATH')
dps=strsplit(path,':',/extract)
w=where(stregex(dps,'\+?/.*/ominas_data/icy/lib/?',/bool),count,complement=wc,ncomplement=nwc)
if nwc then begin
  np=strjoin(dps[wc],':')
  print,'Setting IDL_PATH to ',np
  if getenv('IDL_PATH') then begin
    openw,lun,'idlpathr.sh',/get_lun
    printf,lun,'export IDL_PATH="'+np+'"'
    free_lun,lun
  endif else pref_set,'IDL_PATH',np,/commit
endif
dlm_path=getenv('IDL_DLM_PATH') ? getenv('IDL_DLM_PATH') : PREF_GET('IDL_DLM_PATH')
dps=strsplit(dlm_path,':',/extract)
w=where(stregex(dps,'\+?/.*/ominas_data/icy/lib/?',/bool),count,complement=wc,ncomplement=nwc)
if nwc then begin
  ndp=strjoin(dps[wc],':')
  print,'Setting IDL_DLM_PATH to ',ndp
  if getenv('IDL_DLM_PATH') then begin
    openw,lun,'idlpathr.sh',/get_lun,/append
      printf,lun,'export IDL_DLM_PATH="'+ndp+'"'
    free_lun,lun
  endif else pref_set,'IDL_DLM_PATH',ndp,/commit
endif
exit
end
