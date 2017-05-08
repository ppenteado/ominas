pro idlastro_download,auto=auto
compile_opt idl2,logical_predicate
auto=keyword_set(auto)
routs=['cntrd','minmax']
ex=intarr(n_elements(routs))
foreach rout,routs,ir do begin
  ex[ir]=routine_exists(rout)
endforeach
nex=total(ex,/int)
if nex eq n_elements(routs) then begin
  print,'All needed IDLAstro routines are already present'
endif else begin
  print,'There are missing IDLAstro routines.'
  if auto then begin
    print,'Auto installing'
    inst='y'
  endif else begin
    print,'Install IDLAstro?'
    inst=''
  read,inst
  endelse
  if stregex(inst,'y|Y',/bool) then begin
    ;if ~auto then begin
    ;  print,'Enter the location where you want to install IDLAstro [~/ominas_data/idlastro]'
    ;  loc=''
    ;  read,loc
    ;  if ~ strlen(strtrim(loc,2)) then loc='~/ominas_data/idlastro'
    ;endif else loc='~/ominas_data/idlastro'
    loc='~/ominas_data/idlastro'
    spawn,'eval echo '+loc,res
    loc=res
    comm='git clone https://github.com/wlandsman/IDLAstro.git '+loc
    print,comm
    spawn,comm,exit_status=st
    if (st ne 0) then begin
      print,'Download through git failed, using zip file instead'
      locl='~/ominas_data/'
      spawn,'eval echo '+locl,res
      locl=res
      j=pp_wget('https://github.com/wlandsman/IDLAstro/archive/master.zip',localdir=locl)
      j.geturl
      file_unzip,locl+'/master.zip',locl;,/verbose
      loc=locl+'/IDLAstro-master'
    endif
    path=getenv('IDL_PATH') ? getenv('IDL_PATH') : pref_get('IDL_PATH')
    if ~strmatch(path,'*'+loc+'*') then begin
      path+=':+'+loc+'/pro'
    endif
    if getenv('IDL_PATH') then begin
      openw,lun,'idlpath.sh',/get_lun,/append
      printf,lun,'export IDL_PATH="'+path+'"'
      free_lun,lun
    endif else PREF_SET, 'IDL_PATH', path, /COMMIT
  endif
endelse

end
