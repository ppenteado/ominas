pro ominas_paths_remove
compile_opt idl2,logical_predicate
path=getenv('IDL_PATH') ? getenv('IDL_PATH') : PREF_GET('IDL_PATH')
dps=strsplit(path,':',/extract)
odir=getenv('OMINAS_DIR')
xdir=getenv('XIDL_DIR')
if odir then begin
  w=where(stregex(dps,'\+?'+odir+'/?',/bool),count,complement=wc,ncomplement=nwc)
  if nwc then begin
    np=strjoin(dps[wc],':')
    if getenv('IDL_PATH') then begin
      openw,lun,'idlpathro.sh',/get_lun
      printf,lun,'export IDL_PATH="'+np+'"'
      free_lun,lun
    endif else pref_set,'IDL_PATH',np,/commit
  endif
endif
if xdir then begin
  w=where(stregex(dps,'\+?'+xdir+'/?',/bool),count,complement=wc,ncomplement=nwc)
  if nwc then begin
    np=strjoin(dps[wc],':')
    if getenv('IDL_PATH') then begin
      openw,lun,'idlpathro.sh',/get_lun,/append
      printf,lun,'export IDL_PATH="'+np+'"'
      free_lun,lun
    endif else pref_set,'IDL_PATH',np,/commit
  endif
endif

exit
end
