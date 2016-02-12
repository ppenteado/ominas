;===========================================================================
; map_match_type
;
;
;===========================================================================
function map_match_type, _type
@nv_lib.include

 n = n_elements(_type)

 known_types = ['RECTANGULAR', $
                'MERCATOR', $
                'ORTHOGRAPHIC', $
                'STEREOGRAPHIC', $
                'MOLLWEIDE', $
                'SINUSOIDAL', $
                'PERSPECTIVE', $
                'OBLIQUE_DISK' $
                ]

 types = strarr(n)

 for i=0, n-1 do $
  begin
   len = strlen(_type[i])
   w = where(strmid(known_types, 0, len) EQ strupcase(_type[i]))
   if(w[0] NE -1) then types[i] = known_types[w[0]]
  end

 return, types
end
;===========================================================================

