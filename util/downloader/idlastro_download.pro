pro idlastro_download,auto=auto,ominasdir,orc=orc
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
    if getenv('NV_VERBOSITY') then print,'Installing IDLAstro to ',loc
    if file_test(loc,/directory) then begin
      if file_test(loc+'/.git',/directory) then st=0 else st=1
    endif else begin
      comm='git clone https://github.com/wlandsman/IDLAstro.git '+loc
      print,comm
      spawn,comm,exit_status=st
    endelse
    if (st ne 0) then begin
      print,'Download through git failed, using zip file instead'
      locl='~/ominas_data/'
      spawn,'eval echo '+locl,res
      locl=res
      certf=file_expand_path(ominasdir)+'/util/downloader/ca-bundle.crt'
      j=pp_wget('https://github.com/wlandsman/IDLAstro/archive/master.zip',localdir=locl,ssl_certificate_file=certf)
      j.geturl
      file_unzip,locl+'/master.zip',locl;,/verbose
      loc=locl+'/IDLAstro-master'
    endif
    path=getenv('IDL_PATH') ? getenv('IDL_PATH') : pref_get('IDL_PATH')
    if getenv('NV_VERBOSITY') then print,'idlastro_download: old path=',path
    if ~strmatch(path,'*'+loc+'*') then begin
      path+=':+'+loc+'/pro'
    endif
    if getenv('IDL_PATH') then begin
      nl=file_lines(orc+'/idlpath.sh')
      if nl then begin
        pathr=strarr(nl)
        openr,lun,orc+'/idlpath.sh',/get_lun
        readf,lun,pathr
        free_lun,lun
      endif else pathr=['']
      pathr=pathr[where(~stregex(pathr,'[^#]*IDL_PATH=[^#]*'+loc,/bool),/null)]
      pathline='if [ `echo $IDL_PATH | grep -co "'+loc+'/pro"` == 0 ]; then '
      pathline+='export IDL_PATH="${IDL_PATH:+$IDL_PATH:}+'+loc+'/pro"; fi'
      pathr=[pathr,pathline]
      openw,lun,orc+'/idlpath.sh',/get_lun
      ;printf,lun,'export IDL_PATH="'+path+'"'
      printf,lun,pathr,format='(A0)'
      ;printf,lun,'export IDL_PATH="${IDL_PATH:+$IDL_PATH:}+'+loc+'/pro"'
      free_lun,lun
      print,'IDLAstro path set in IDL_PATH: ',path
      setenv,'IDL_PATH='+path
    endif else begin
      PREF_SET, 'IDL_PATH', path, /COMMIT
      print,'IDLAstro path set in preferences: ',path
    endelse
  endif
endelse

end
