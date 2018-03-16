;==============================================================================
; cas_radar_transform
; 
; based on documentation at https://pds-imaging.jpl.nasa.gov/data/cassini/cassini_orbiter/CORADR_0045/DOCUMENT/
;
;==============================================================================
function cas_uvis_transform, ima, label, force=force
  compile_opt idl2,logical_predicate
 
  ima=ima
 
 return, ima
end
;==============================================================================
