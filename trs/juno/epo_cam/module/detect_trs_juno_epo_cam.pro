;===========================================================================
; detect_trs_juno_epo_cam.pro
;
;===========================================================================
function detect_trs_juno_epo_cam, dd, arg, query=query
 if(keyword_set(query)) then return, 'INSTRUMENT'

if isa(label,'hash') && label.haskey('INSTRUMENT_NAME') $
;  then return,idl_validname(label['INSTRUMENT_NAME'],/convert_all)
  then if(idl_validname(label['INSTRUMENT_NAME'],/convert_all)) $
                                                       then return, 'JUNO_EPO_CAM'


 return, ''
end
;===========================================================================
