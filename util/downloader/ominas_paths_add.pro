pro ominas_paths_add,icydir,ominasdir
compile_opt idl2,logical_predicate
verb=getenv('NV_VERBOSITY')
print,'Checking to see if IDL paths need to be changed...'

ominasdir=n_elements(ominasdir) ? ominasdir : getenv('OMINAS_DIR')
if ominasdir then begin
  idlastro_download,/auto,ominasdir
endif

if getenv('IDL_PATH') then begin
  path=getenv('IDL_PATH')
  if getenv('NV_VERBOSITY') then print,'Got path from IDL_PATH'
endif else begin
  path=PREF_GET('IDL_PATH')
  if getenv('NV_VERBOSITY') then print, 'Got path from preferences'
endelse
if verb then print,'ominas_paths_add: old path=',path

if icydir then begin
   print,'opath:',path
   print, stregex(path,'\+?/.*/ominas_data/icy/lib/*',/bool)
  if ~stregex(path,'\+?/.*/ominas_data/icy/lib/*',/bool) then path+=':+'+file_expand_path(icydir+'/lib/')
endif
if verb then print,'ominas_paths_add: icydir=',icydir,' ominasdir=',ominasdir
xidldir=getenv('XIDL_DIR')
if ominasdir then begin
  if ~stregex(path,'\+?'+ominasdir+'/*(:.+)?$',/bool) then path+=':+'+ominasdir
  if ~stregex(path,'\+?'+xidldir+'/*(:.+)?$',/bool) then path+=':+'+xidldir
;  !path=path
;  idlastro_download,/auto,ominasdir
endif

if icydir || ominasdir then begin
  if getenv('IDL_PATH') then begin 
    openw,lun,'idlpath.sh',/get_lun 
    printf,lun,'export IDL_PATH="'+path+'"' 
    free_lun,lun
    print,'OMINAS paths added to IDL_PATH'
  endif else begin
    PREF_SET, 'IDL_PATH', path, /COMMIT
    print,'OMINAS paths set in IDL preferences'
  endelse
  if verb then print,'path=',path
endif

dlm_path=getenv('IDL_DLM_PATH') ? getenv('IDL_DLM_PATH') : PREF_GET('IDL_DLM_PATH')
if icydir then begin
  if ~stregex(dlm_path,'\+?/.*/ominas_data/icy/lib/*',/bool) then dlm_path+=':+'+file_expand_path(icydir+'/lib/')
if getenv('IDL_DLM_PATH') then begin
  openw,lun,'idlpath.sh',/get_lun,/append
  printf,lun,'export IDL_DLM_PATH="'+dlm_path+'"'
  free_lun,lun
  print,'Icy path added to IDL_DLM_PATH'
endif else begin
  PREF_SET, 'IDL_DLM_PATH', dlm_path, /COMMIT
  print,'Icy path set in IDL preferences'
endelse
if verb then print,'dlm_path=',dlm_path
endif
;print, ominasdir+' added to IDL_PATH'

exit

end
