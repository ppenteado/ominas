;=============================================================================
; dawn_format_comment
;
;=============================================================================
function dawn_format_comment, od

 if(class_get(od[0]) EQ 'CAMERA') then $
        return, 'cam_orient <==> Dawn C-matrix; lengths in km'

 if(keyword__set(class_extract(od, 'GLOBE'))) then return, 'lengths in km'

 
 return, 'No conversion performed'
end
;=============================================================================
