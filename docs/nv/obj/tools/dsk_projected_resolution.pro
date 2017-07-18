;=============================================================================
;+
; NAME:
;       dsk_projected_resolution
;
;
; PURPOSE:
;	Computes the resolution (actually scale) components at a point on a 
;	disk in a given camera.
;
;
; CATEGORY:
;       NV/LIB/TOOLS
;
;
; CALLING SEQUENCE:
;       res = dsk_projected_resolution(dkx, cd, p, scale)
;
;
; ARGUMENTS:
;  INPUT:
;	dkx:	Any subclass of DISK.
;
;	cd:	Camera descriptor.
;
;	p:	Point on the dkx in inertial coordinates.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: NONE
;
;  OUTPUT: 
;	rad:	Pixel scale in the radial direction.
;
;	lon:	Pixel scale in the longitude direction.
;
;	perp:	Pixel scale in the direction perpendicular to the 
;		projected longitude direction.
;	
;	rr:	Intercept radius.
;
;
; RETURN: 
;	Radial resolution on dkx at r, computed as the length of a
;	segment bisecting the intersection ellipse in the radial direction.
;
;
; MODIFICATION HISTORY:
;       Written by:     Spitale, usning an approach suggested by M. Tiscareno
;
;-
;=============================================================================
pro dsk_projected_resolution, dkd, cd, p, scale, $
	rad=resrad, $		; dist/pixel in radial direction
	lon=reslon, $		; dist/pixel in longitudinal direction
	perp=resperp, $		; dist/pixel in perp. to projected long. dir.
	rr=rr			; intercept radius

 if(NOT keyword_set(scale)) then scale = (cam_scale(cd))[0]

 nv = n_elements(p)/3					; assume  nt = 1
 mm = make_array(nv, val=1d)
 m = make_array(3, val=1d)

 dsk_orient = bod_orient(dkd)
 zz = dsk_orient[2,*] ## mm

 cam_pos = bod_pos(cd) ## mm
 dsk_pos = bod_pos(dkd) ## mm


 ;----------------------------------
 ; radial scale
 ;----------------------------------
 v = cam_pos - p
 range = v_mag(v)
 v = v_unit(v)
 vv = dsk_pos - p
 rr = v_mag(vv)
 vv = v_unit(vv)

 resrad = scale * range / v_mag(v_cross(v, vv))

 

 ;----------------------------------
 ; longitudinal scale
 ;----------------------------------
 vv = v_cross(zz, vv)

 reslon = scale * range / v_mag(v_cross(v, vv))



 ;----------------------------------
 ; perpendicular scale
 ;----------------------------------
 vv = dsk_get_perp(cd, dkd, p)

 resperp = scale * range / v_mag(v_cross(v, vv))


end
;==============================================================================



