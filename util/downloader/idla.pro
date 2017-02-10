pro idla
compile_opt idl2,logical_predicate
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
  print,'Install IDLAstro?'
  inst=''
  read,inst
  if stregex(inst,'y|Y',/bool) then begin
    print,'Enter the location where you want to install IDLAstro'
    loc=''
    read,loc
    comm='git clone https://github.com/wlandsman/IDLAstro.git '+loc
    print,comm
    spawn,comm
    path=getenv('IDL_PATH') ? getenv('IDL_PATH') : pref_get('IDL_PATH')
    if ~strmatch(path,'*loc*') then begin
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
