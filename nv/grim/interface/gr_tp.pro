;==============================================================================;
; gr_tp
;
;
;==============================================================================;
pro gr_tp, ptd, pn=pn, grn=grn

 if(keyword__set(grn)) then $
                     grim_data = grim_get_data(grim_grn_to_top(grn)) $
 else grim_data = grim_get_data(/primary)

 refresh = 0

 if(defined(pn)) then $
  begin
   if(pn EQ grim_data.pn) then refresh = 1
   planes = grim_get_plane(grim_data, /all)
   plane = planes[pn]
  end
 if(NOT defined(pn)) then refresh = 1

 npn = n_elements(pn)
 for i=0, npn-1 do $
    grim_add_tiepoint, grim_data, plane=plane[i], pnt_points(/cat, /vis, ptd)

 if(refresh) then grim_refresh, grim_data, /no_image
end
;==============================================================================;
