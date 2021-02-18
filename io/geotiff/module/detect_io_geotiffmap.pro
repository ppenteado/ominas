;===========================================================================
; detect_io_geotiffmap.pro
;
;===========================================================================
function detect_io_geotiffmap, dd, arg, query=query
 if(keyword_set(query)) then return, 'INSTRUMENT'

 if(NOT keyword_set(dd)) then return, ''
 dh = dat_dh(dd)


 header=dat_header(dd)
 
 if size(header,/type) ne 8 then return,''
 tn=tag_names(header)
 if total(strmatch(tn,'INFO')+strmatch(tn,'GEO')+strmatch(tn,'PLANET')) ne 3 then return,''

 return, 'GEOTIFFMAP'
end
;===========================================================================
