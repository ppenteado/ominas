;=============================================================================
;+
; NAME:
;       plot_inertial
;
;
; PURPOSE:
;       Plots inertial vectors on a camera image.
;
;
; CATEGORY:
;       NV/LIB/TOOLS
;
;
; CALLING SEQUENCE:
;       plot_inertial, cd, v, r
;
;
; ARGUMENTS:
;  INPUT:
;	cd:	Camera descriptor.
;
;	v:	Inertial vectors giving origins of vectors to plot.  If only one
;		vector, this will be used as the origin for all of the plotted
;		vectors.
;
;	r:	Inertial vectors giving the vectors to plot, starting at
;		the given origins.
;
;  OUTPUT:
;       NONE
;
; STATUS:
;       Completed.
;
;
; MODIFICATION HISTORY:
;       Written by:     Spitale; 7/2002
;
;-
;=============================================================================
pro plot_inertial, cd, _v, r, color=color, thick=thick, labels=labels

 v = _v

 sr = size(r)
 nv = sr[1]

 sv = size(v)
 if(sv[1] EQ 1) then v = v##make_array(nv,val=1d)

 vv = inertial_to_image_pos(cd, v)
 rr = inertial_to_image_pos(cd, v+r)


 for i=0, nv-1 do plots, [vv[0,i],rr[0,i]], [vv[1,i],rr[1,i]], $
       psym=-1, color=color, thick=thick

 if(keyword__set(labels)) then $
         for i=0, nv-1 do xyouts, rr[0,i], rr[1,i], labels[i], color=color

end
;===========================================================================



