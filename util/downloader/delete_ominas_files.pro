pro delete_ominas_files,dir
compile_opt idl2,logical_predicate
if ~n_elements(dir) then begin
  print,'delete_ominas_files: No directory specified'
  return
endif
print,'This will delete all files downloaded by the OMINAS installer at ',dir
print,'Are you sure (y/n)? '
ans=''
read,ans
if strlowcase(ans) ne 'y' then return
ps=path_sep()
odir=(file_search(dir)).replace(ps,'_')
odir=strjoin(strsplit(odir,'_',/extract),'_')
ts=file_search(['~'+ps+'.ominas'+ps+'timestamps'+ps+odir+'.json',$
'~'+ps+'.ominas'+ps+'timestamps'+ps+odir+'_*.json'],count=count)
if ~count then begin
  print,'delete_ominas_files: No timestamps files found for specified directory ('+dir+')'
  return
endif
r=[]
foreach tts,ts do r=[r,read_json(tts)]

print,'This will now delete the files'
print,r.filename
print,'Are you sure you want to delete the above files?'
read,ans
if strlowcase(ans) ne 'y' then return
;file_delete,r.filename,/allow_nonexistent,/verbose
end