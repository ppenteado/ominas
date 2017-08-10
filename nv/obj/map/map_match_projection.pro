;===========================================================================
; map_match_projection
;
;
;===========================================================================
function map_match_projection, _projection
@core.include

 n = n_elements(_projection)

 known_projections = ['RECTANGULAR', $
                      'RECTANGULAR_DISK', $
                      'MERCATOR', $
                      'ORTHOGRAPHIC', $
                      'STEREOGRAPHIC', $
                      'MOLLWEIDE', $
                      'SINUSOIDAL', $
                      'PERSPECTIVE', $
                      'OBLIQUE_DISK', $
                      'EQUATORIAL_RING', $
                      'RING' $
                      ]

 projections = strarr(n)

 for i=0, n-1 do $
  begin
   len = strlen(_projection[i])
   w = where(strmid(known_projections, 0, len) EQ strupcase(_projection[i]))
   if(w[0] NE -1) then projections[i] = known_projections[w[0]]
  end

 return, projections
end
;===========================================================================

