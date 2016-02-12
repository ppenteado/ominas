;===========================================================================
; pgs_selected_points.pro
;
;===========================================================================
pro pgs_selected_points, pp, points=points, $
                            vectors=vectors, $
                            flags=flags, $
                            data=data, name=name, desc=desc, input=input, sub=sub
@pgs_include.pro
nv_message, /con, name='pgs_selected_points', 'This routine is obsolete.'
pgs_flagged_points, pp, PGS_SELECT_MASK, $
                            points=points, $
                            vectors=vectors, $
                            flags=flags, $
                            data=data, name=name, desc=desc, input=input, sub=sub

end
;===========================================================================
