;==============================================================================
; cas_radar_transform
; 
; based on documentation at https://pds-imaging.jpl.nasa.gov/data/cassini/cassini_orbiter/CORADR_0045/DOCUMENT/
;
;==============================================================================
function cas_uvis_transform, ima, label, force=force
  compile_opt idl2,logical_predicate
 
  if size(ima,/type) eq 8 then ima=ima.core
  ima=transpose(ima,[2,1,0])
  bb=fix(pdspar(label,'BAND_BIN'))
  if bb gt 1 then begin
    ima=ima[*,*,0:1024/bb-1]
  endif
 ;ima=reverse(ima,2)
 return, ima
end
;==============================================================================
