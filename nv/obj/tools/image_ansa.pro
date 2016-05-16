;=============================================================================
;+
; NAME:
;       image_ansa
;
;
; PURPOSE:
;	Computes ring ansa longitudes.
;
;
; CATEGORY:
;       NV/LIB/TOOLS
;
;
; CALLING SEQUENCE:
;       lons = image_ansa(cd, rd, radius)
;
;
; ARGUMENTS:
;  INPUT:
;	cd:	Camera descriptor.
;
;	dkx:	Any subclass of DISK.
;
;	radius:	Disk radius at which to compute ansa.
;
;  OUTPUT:  NONE
;
;
; KEYWORDS:
;  INPUT: NONE
;
;  OUTPUT: 
;	image_pts:	Image points corresponding to each ansa longitude
;			at the given radius.
;
;
; RETURN: 
;	Array (2) of longitudes
;
;
; MODIFICATION HISTORY:
;       Written by:     Spitale
;
;-
;=============================================================================


;===================================================================================
; ia_compute
;
;===================================================================================
function ia_compute, cd, rd, radius, lon0, image_pt=image_pt

 lon = lon0

 nlon = 100d
 range = !dpi

 prd = inertial_to_image_pos(cd, bod_pos(rd))#make_array(nlon, val=1d)

 repeat $
  begin
   lons = (dindgen(nlon) - nlon/2d)*range/nlon + lon

   body_pts = dsk_get_inner_disk_points(rd, frame=rd, dlon=lons, disk=disk_pts)
   image_pts = body_to_image_pos(cd, rd, body_pts)

   r = p_mag(prd - image_pts)
   w = where(r EQ max(r))

   image_pt = image_pts[*,w]
   dp = p_mag(image_pt - image_pts[*,w+1])

   lon = disk_pts[w[0],1]
   range = range / (nlon/2d)
  endrep until(dp LE 1)


 return, lon
end
;===================================================================================



;===================================================================================
; image_ansa
;
;===================================================================================
function image_ansa, cd, rd, radius, image_pts=image_pts

 lons = image_ansa_far(cd, rd)

 rdr = nv_clone(rd)
 sma = dsk_sma(rdr)
 sma[0] = radius
 dsk_set_sma, rdr, sma

 lon1 = ia_compute(cd, rdr, radius, lons[0], image_pt=image_pt1)
 lon2 = ia_compute(cd, rdr, radius, lons[1], image_pt=image_pt2)

 image_pts = transpose([transpose(image_pt1), transpose(image_pt2)])

 nv_free, rdr

 return, [lon1, lon2]
end
;===================================================================================
