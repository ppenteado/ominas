;===========================================================================
; map_lookup_defaults
;
;
;===========================================================================
function map_lookup_defaults, md0

 _md = {ominas_map}
 _md0 = cor_dereference(md0)

 _md.pole={ominas_map_pole}
 _md.pole.lat=!values.d_nan
 _md.pole.lon=!values.d_nan
 _md.pole.rot=!values.d_nan
; type = _md0[0].type
 type = map_match_type(_md0[0].type)

 ;---------------------------------
 ; disk polar projection
 ;---------------------------------
 w = where(type EQ 'OBLIQUE_DISK')
 if(w[0] NE -1) then $
  begin
   _md[w].scale = 1d
   _md[w].origin = _md0.size/2
   _md[w].center = [0d,0d]
; !! this won't work for multiple descriptors!!
  end

 ;---------------------------------
 ; rectangular projection
 ;---------------------------------
 w = where(type EQ 'RECTANGULAR')
 if(w[0] NE -1) then $
  begin
   _md[w].scale = 1d
   _md[w].origin = _md0.size/2
   _md[w].center = [0d,0d]
; !! this won't work for multiple descriptors!!
  end

 ;---------------------------------
 ; rectangular disk projection
 ;---------------------------------
 w = where(type EQ 'RECTANGULAR_DISK')
 if(w[0] NE -1) then $
  begin
   _md[w].scale = 1d
   _md[w].origin = _md0.size/2
   _md[w].center = [0d,0d]
; !! this won't work for multiple descriptors!!
  end

 ;---------------------------------
 ; mercator projection
 ;---------------------------------
 w = where(type EQ 'MERCATOR')
 if(w[0] NE -1) then $
  begin
   _md[w].scale = 1d
   _md[w].origin = _md0.size/2
   _md[w].center = [0d,0d]
  end

 ;---------------------------------
 ; orthographic projection
 ;---------------------------------
 w = where(type EQ 'ORTHOGRAPHIC')
 if(w[0] NE -1) then $
  begin
   _md[w].scale = 1d
   _md[w].origin = _md0.size/2
   _md[w].center = [!dpi/2d,0d]
  end

 ;---------------------------------
 ; stereographic projection
 ;---------------------------------
 w = where(type EQ 'STEREOGRAPHIC')
 if(w[0] NE -1) then $
  begin
   _md[w].scale = 1d
   _md[w].origin = _md0.size/2
   _md[w].center = [!dpi/2d,0d]
  end

 ;---------------------------------
 ; mollweide projection
 ;---------------------------------
 w = where(type EQ 'MOLLWEIDE')
 if(w[0] NE -1) then $
  begin
   _md[w].scale = 1d
   _md[w].origin = _md0.size/2
   _md[w].center = [0d,0d]
  end

 ;---------------------------------
 ; sinusoidal projection
 ;---------------------------------
 w = where(type EQ 'SINUSOIDAL')
 if(w[0] NE -1) then $
  begin
   _md[w].scale = 1d
   _md[w].origin = _md0.size/2
   _md[w].center = [0d,0d]
  end



 return, _md
end
;===========================================================================
