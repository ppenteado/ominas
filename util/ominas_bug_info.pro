; docformat = 'rst'
;+
; :Author: Paulo Penteado (Paulo.Penteado@jpl.nasa.gov),
;-


;+
; :Description:
;    Prints out the most commonly useful information about the OMINAS environment
;    for debugging.
;
; :Params:
;    outfile: in, optional, type=string, default=''
;      If provided, output is written to that file, instead of to the terminal.
;
; :Author: Paulo Penteado (`http://www.ppenteado.net <http://www.ppenteado.net>`),
;-
pro ominas_bug_info,outfile
compile_opt idl2,logical_predicate
outfile=n_elements(outfile) ? outfile : ''

if outfile then openw,lun,outfile,/get_lun else lun=-1

;environment
spawn,'env | grep OMINAS_',ominas_vars
spawn,'env | grep NV_',nv_vars

count=file_lines(getenv('HOME')+path_sep()+'.ominas'+path_sep()+'ominas_setup.sh')
ominas_setup=strarr(count)
openr,luns,getenv('HOME')+path_sep()+'.ominas'+path_sep()+'ominas_setup.sh',/get_lun
readf,luns,ominas_setup
free_lun,luns
;ominas_setup=pp_readtxt(getenv('HOME')+path_sep()+'.ominas'+path_sep()+'ominas_setup.sh')
sep='--------------------------------------------------------------------------------'

printf,lun,'OMINAS variables:'
printf,lun,ominas_vars,format='(A)'
printf,lun,sep
printf,lun,'NV variables:'
printf,lun,nv_vars,format='(A)'
printf,lun,sep
printf,lun,'ominas_setup.sh:'
printf,lun,ominas_setup,format='(A)'
printf,lun,sep


;IDL
help,!version,output=version

printf,lun,''
printf,lun,'IDL:'
printf,lun,version,format='(A)'
printf,lun,sep
printf,lun,'environment IDL_PATH'
printf,lun,getenv('IDL_PATH')
printf,lun,sep
printf,lun,'environment IDL_DLM_PATH'
printf,lun,getenv('IDL_DLM_PATH')
printf,lun,sep
printf,lun,'preferences IDL_PATH'
printf,lun,pref_get('IDL_PATH')
printf,lun,sep
printf,lun,'preferences IDL_DLM_PATH'
printf,lun,pref_get('IDL_DLM_PATH')
printf,lun,sep

;OMINAS repo
printf,lun,''
printf,lun,'OMINAS repository:'
catch,err
if err then begin
  catch,/cancel
  printf,lun,'git failed'
endif else begin
  spawn,'cd '+getenv('OMINAS_DIR')+' && git log -n 1 --format="%h %aN %ad"',gitlog
  spawn,'cd '+getenv('OMINAS_DIR')+' && git status',gitstatus
  printf,lun,gitstatus[0:1],format='(A)'
  printf,lun,'Last commit:'
  printf,lun,gitlog,format='(A)'
endelse

;Icy
printf,lun,''
printf,lun,'Icy:'
catch,err
if err then begin
  catch,/cancel
  printf,lun,'Not found'
endif else begin
  help,'icy',/dlm,output=icydlm
  printf,lun,sep
  printf,lun,icydlm,format='(A)'
  printf,lun,sep
  printf,lun,cspice_tkvrsn('TOOLKIT'),format='(A)'
  printf,lun,sep
  cspice_ktotal,'ALL',count
  printf,lun,strtrim(count,2),' loaded kernels:'
  for i=0,count-1 do begin
    cspice_kdata,i,'ALL',file,type,source,handle,found
    printf,lun,i,file,format='(I,": ",A)'
  endfor
  printf,lun,sep
endelse



if outfile then free_lun,lun

end
