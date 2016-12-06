; docformat = 'rst'
;+
; :Author: Paulo Penteado (`http://www.ppenteado.net <http://www.ppenteado.net>`)
;-
;+
; :Description:
;    Parses date strings into julian dates. More formats will be supported in
;    the future. Example dates in currently supported formats:
;    
;    Fri, 22 Jan 2016 18:03:25 GMT
;      
;
; :Params:
;    idstr: in, required
;    
;      String(s) with date(s) to be converted to JD. Can be scalar or array.
;      
; :Examples:
; 
;   Convert Fri, 22 Jan 2016 18:03:25 GMT::
;   
;     print,pp_parse_date('Fri, 22 Jan 2016 18:03:25 GMT')
;     ;       2457410.3
;
;
;
; :Author: Paulo Penteado (`http://www.ppenteado.net <http://www.ppenteado.net>`)
;-
function pp_parse_date,idstr
compile_opt idl2,logical_predicate

dstr=strtrim(idstr,2)
ret=(size(dstr))[0] ? replicate(0d0,n_elements(dstr)) : 0d0

wkds='(sun)|(mon)|(tue)|(wed)|(thu)|(fri)|(sat)'
mona=['jan','feb','mar','apr','may','jun','jul','aug','sep','oct','nov','dec']
mons='('+strjoin(mona,')|(')+')'
f1s='('+wkds+'),? +([[:digit:]]{1,2}) +('+mons+') +([[:digit:]]+) +([[:digit:]]{1,2}):([[:digit:]]{1,2}):([[:digit:]]{1,2})'
f1=stregex(dstr,f1s,/bool,/fold_case)

foreach ds,dstr,ids do begin
  if f1[ids] then begin
    dss=stregex(ds,f1s,/extract,/subexpr,/fold_case)
    yr=fix(dss[23])
    mon=(where(dss[11:22]))[0]+1
    day=fix(dss[9])
    h=fix(dss[24])
    m=fix(dss[25])
    s=fix(dss[26])
    ret[ids]=julday(mon,day,yr,h,m,s)
  endif
endforeach

return,ret
end
