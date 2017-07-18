;=============================================================================
;+
; NAME:
;	sub_latlon
;
;
; PURPOSE:
;	Computes sub-observer latitude and longitude on a globe.
;
; CATEGORY:
;	NV/LIB/TOOLS
;
;
; CALLING SEQUENCE:
;    result = sub_latlon(gbx, v, sublat, sublon)
;
;
; ARGUMENTS:
;  INPUT:
;	gbx:	Array (nt) of any subclass of GLOBE.
;
;	v:	Array (nv,3,nt) giving the observer position in the BODY frame.
;
;  OUTPUT:
;	sublat:	Array (nv,nt) of latitude of sub-observer point on gbx.
;
;	sublon:	Array (nv,nt) of longitude of sub-observer point on gbx.
;
;
; KEYWORDS:
;  INPUT:
;	graphic:   If set, use planetographic coordinates.
;
;  OUTPUT:
;	body_pt:	Array (nv,3,nt) giving the sub-observer point in 
;			BODY coordinates.
;
;	surf_pt:	Array (nv,3,nt) giving the sub-observer point in 
;			SURFACE coordinates.
;
;
; RETURN: NONE
;
;
; MODIFICATION HISTORY:
;       Written by:     Spitale
;	
;-
;=============================================================================
pro sub_latlon, gbx, v, sublat, sublon, body_pt=body_pt, surf_pt=surf_pt, graphic=graphic

 nt = n_elements(gbx)
 nv = n_elements(v)/3/nt

 if(keyword__set(graphic)) then body_pt = glb_sub_point_graphic(gbx, v)
 body_pt = glb_sub_point(gbx, v)
 surf_pt = glb_body_to_globe(gbx, body_pt)
 if(keyword__set(graphic)) then surf_pt = glb_globe_to_graphic(gbx, surf_pt)
 sublat = reform(surf_pt[*,0,*], nv,nt, /over)
 sublon = reform(surf_pt[*,1,*], nv,nt, /over)

;; sublat = sublat
 sublon = reduce_angle(sublon, max=!dpi)
end
;===========================================================================



