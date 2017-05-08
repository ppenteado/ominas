pro ominas_paths_add,icydir
compile_opt idl2,logical_predicate
path=getenv('IDL_PATH') ? getenv('IDL_PATH') : PREF_GET('IDL_PATH')
if icydir then begin
  if ~stregex(path,'\+?/.*/ominas_data/icy/lib/?',/bool) then path+=':+'+file_expand_path(icydir+'/lib/')
endif
ominasdir=getenv('OMINAS_DIR')
xidldir=getenv('XIDL_DIR')
if ominasdir then begin
  if ~stregex(path,'\+?'+ominasdir+'/?',/bool) then path+=':+'+ominasdir
  if ~stregex(path,'\+?'+xidldir+'/?',/bool) then path+=':+'+xidldir
;  !path=path
  idlastro_download,/auto
endif

if icydir || ominasdir then begin
  if getenv('IDL_PATH') then begin 
    openw,lun,'idlpath.sh',/get_lun 
    printf,lun,'export IDL_PATH="'+path+'"' 
    free_lun,lun 
  endif else PREF_SET, 'IDL_PATH', path, /COMMIT
endif

dlm_path=getenv('IDL_DLM_PATH') ? getenv('IDL_DLM_PATH') : PREF_GET('IDL_DLM_PATH')
if icydir then begin
  if ~stregex(dlm_path,'\+?/.*/ominas_data/icy/lib/?',/bool) then dlm_path+=':+'+file_expand_path(icydir+'/lib/')
if getenv('IDL_DLM_PATH') then begin
  openw,lun,'idlpath.sh',/get_lun,/append
  printf,lun,'export IDL_DLM_PATH="'+dlm_path+'"'
  free_lun,lun
endif else PREF_SET, 'IDL_DLM_PATH', dlm_path, /COMMIT
endif
print, ominasdir+' added to IDL_PATH'


exit

end
