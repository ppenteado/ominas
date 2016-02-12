;===========================================================================
; pgs_visible_points.pro
;
;===========================================================================
pro pgs_visible_points, pp, points=points, $
                            vectors=vectors, $
                            flags=flags, $
                            data=data, name=name, desc=desc, input=input, sub=sub
@pgs_include.pro
nv_message, /con, name='pgs_visible_points', 'This routine is obsolete.'
pgs_flagged_points, pp, mask=PGS_INVISIBLE_MASK, val=0b, $
                            points=points, $
                            vectors=vectors, $
                            flags=flags, $
                            data=data, name=name, desc=desc, input=input, sub=sub

end
;===========================================================================
