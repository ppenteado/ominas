;===========================================================================
; map_lookup_defaults
;
;
;===========================================================================
;function map_lookup_defaults, n, type
function map_lookup_defaults, _md

 n = n_elements(_md)
 md = replicate({map_descriptor}, n)

; type = _md[0].type
 type = map_match_type(_md[0].type)

 ;---------------------------------
 ; disk polar projection
 ;---------------------------------
 w = where(type EQ 'OBLIQUE_DISK')
 if(w[0] NE -1) then $
  begin
   md[w].scale = 1d
   md[w].origin = _md.size/2
   md[w].center = [0d,0d]
; !! this won't work for multiple descriptors!!
  end

 ;---------------------------------
 ; rectangular projection
 ;---------------------------------
 w = where(type EQ 'RECTANGULAR')
 if(w[0] NE -1) then $
  begin
   md[w].scale = 1d
   md[w].origin = _md.size/2
   md[w].center = [0d,0d]
; !! this won't work for multiple descriptors!!
  end

 ;---------------------------------
 ; mercator projection
 ;---------------------------------
 w = where(type EQ 'MERCATOR')
 if(w[0] NE -1) then $
  begin
   md[w].scale = 1d
   md[w].origin = _md.size/2
   md[w].center = [0d,0d]
  end

 ;---------------------------------
 ; orthographic projection
 ;---------------------------------
 w = where(type EQ 'ORTHOGRAPHIC')
 if(w[0] NE -1) then $
  begin
   md[w].scale = 1d
   md[w].origin = _md.size/2
   md[w].center = [!dpi/2d,0d]
  end

 ;---------------------------------
 ; stereographic projection
 ;---------------------------------
 w = where(type EQ 'STEREOGRAPHIC')
 if(w[0] NE -1) then $
  begin
   md[w].scale = 1d
   md[w].origin = _md.size/2
   md[w].center = [!dpi/2d,0d]
  end

 ;---------------------------------
 ; mollweide projection
 ;---------------------------------
 w = where(type EQ 'MOLLWEIDE')
 if(w[0] NE -1) then $
  begin
   md[w].scale = 1d
   md[w].origin = _md.size/2
   md[w].center = [0d,0d]
  end

 ;---------------------------------
 ; sinusoidal projection
 ;---------------------------------
 w = where(type EQ 'SINUSOIDAL')
 if(w[0] NE -1) then $
  begin
   md[w].scale = 1d
   md[w].origin = _md.size/2
   md[w].center = [0d,0d]
  end



 return, md
end
;===========================================================================
