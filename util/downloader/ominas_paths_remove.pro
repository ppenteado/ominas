pro ominas_paths_remove
compile_opt idl2,logical_predicate
print,'Checking to see if deletions are necessary in IDL paths...'
path=getenv('IDL_PATH') ? getenv('IDL_PATH') : PREF_GET('IDL_PATH')
dps=strsplit(path,':',/extract)
odir=getenv('OMINAS_DIR')
xdir=getenv('XIDL_DIR')
if odir then begin
  cdir=0B
  w=where(stregex(dps,'\+?'+odir+'/?',/bool),count,complement=wc,ncomplement=nwc)
  if nwc then begin
    np=strjoin(dps[wc],':')
    cdir=1B
  endif else np=path
  dps=strsplit(np,':',/extract)
  loc='~/ominas_data/idlastro'
  spawn,'eval echo '+loc,res
  loc=res 
  w=where(stregex(dps,'\+?'+loc+'/?',/bool),count,complement=wc,ncomplement=nwc)
  if nwc then begin
    np=strjoin(dps[wc],':')
    cdir=1B
  endif
  if cdir then begin
    if getenv('IDL_PATH') then begin
      openw,lun,'idlpathro.sh',/get_lun
      printf,lun,'export IDL_PATH="'+np+'"'
      free_lun,lun
      print,'OMINAS path removed from IDL_PATH'
    endif else begin
      pref_set,'IDL_PATH',np,/commit
      print,'OMINAS path removed from IDL preferences'
    endelse
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
      print,'OMINAS path removed from IDL_PATH'
    endif else begin
      pref_set,'IDL_PATH',np,/commit
      print,'OMINAS XIDL path removed from IDL preferences'
    endelse
  endif
endif

exit
end
