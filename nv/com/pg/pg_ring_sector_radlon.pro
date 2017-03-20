;=============================================================================
;+
; NAME:
;	pg_ring_sector_radlon 
;
; PURPOSE:
;	Constructs a ring sector outline for use with pg_profile_ring given
;	radius and longitude bounds.
; 
; CATEGORY:
;       NV/PG
;
; CALLING SEQUENCE:
;     outline_ptd = pg_ring_sector_radlon(cd=cd, dkx=dkx, rad, lon)
;
;
; ARGUMENTS:
;  INPUT:
;      rad:	2-element array giving the lower and upper radial bounds
;		for the sector.
;
;      lon:	2-elements array giving the lower and upper longitude bounds
;		for the sector in radians.
;
;  OUTPUT:
;	NONE
;
;
;
; KEYWORDS:
;  INPUT: 
;           cd:     Camera descriptor.
;
;	   dkx:     Disk descriptor describing the ring.
;
;           gd:     Generic descriptor containnig the above descriptors.
;
;       sample:     Sets the grid sampling in pixels.  Default is one.
;
;         nlon:     Total number of samples in the longitude direction.  
;                   Determined by the 'sample' keyword by default.
;
;         nrad:     Total number of samples in the radial direction.  
;                   Determined by the 'sample' keyword by default.
;
;        slope:     This keyword allows the longitude to vary as a function 
;                   of radius as: lon = slope*(rad - rad0).
;
;        nodsk:     If set, image points will not be included in the output 
;                   POINT.
;
;  OUTPUT:
;         NONE
;
;
; RETURN: 
;      POINT containing points on the sector outline.  The point
;      spacing is determined by the sample keyword.  The POINT object
;      also contains the disk coordinate for each point and the user fields
;      'nrad' and 'nlon' giving the number of points in radius and longitude.
;
; KNOWN BUGS:
;	The sector flips when it hits zero azimuth rather than retaining a 
;	consistent sense.
;
;
; ORIGINAL AUTHOR : 
;	Spitale; 5/2005
;
;-
;=============================================================================



;=============================================================================
; pg_ring_sector_radlon
;
;=============================================================================
function pg_ring_sector_radlon, cd=cd, dkx=dkx, gd=gd, $
                         rad, lon, sample=sample, slope=slope, nodsk=nodsk, $
                         nlon=__nlon, nrad=__nrad


 ;-----------------------------------------------
 ; dereference the generic descriptor if given
 ;-----------------------------------------------
 if(NOT keyword_set(cd)) then cd = dat_gd(gd, dd=dd, /cd)
 if(NOT keyword_set(dkx)) then dkx = dat_gd(gd, dd=dd, /dkx)

 ;-----------------------------------
 ; validate descriptors
 ;-----------------------------------
 if(n_elements(dkx) GT 1) then nv_message, name='pg_ring_sector_rad', $
                          'No more than one ring descriptor may be specified.'
 if(n_elements(cds) GT 1) then nv_message, name='pg_ring_sector_rad', $
                        'No more than one camera descriptor may be specified.'
 rd = dkx[0]



 ;--------------------------
 ; construct sector
 ;--------------------------
 _nlon = 10 & _nrad = 10
 outline_pts = get_ring_profile_outline(cd, rd, $
                        rad=rad, lon=lon, nrad=_nrad, nlon=_nlon, slope=slope)
 dsk_outline_pts = image_to_disk(cd, rd, outline_pts)
 rads = dsk_outline_pts[_nlon+lindgen(_nrad),0]
 lons = dsk_outline_pts[lindgen(_nlon), 1]

 nlonrad = get_ring_profile_n(reform(outline_pts), cd, rd, lons, rads, oversamp=sample)
 nrad = long(nlonrad[1]) & nlon = long(nlonrad[0])

 if(keyword_set(__nlon)) then nlon = __nlon
 if(keyword_set(__nrad)) then nrad = __nrad

 outline_pts = get_ring_profile_outline(cd, rd, $
                        rad=rad, lon=lon, nrad=nrad, nlon=nlon, slope=slope)


 ;-------------------------------------------
 ; Return outline points
 ;-------------------------------------------
 dsk_outline_pts = 0
 if(NOT keyword_set(nodsk)) then dsk_outline_pts = image_to_disk(cd, rd, outline_pts)

 outline_ptd = pnt_create_descriptors(points = outline_pts, $
                      desc = 'pg_ring_sector_rad', $
                      data = transpose(dsk_outline_pts))
 cor_set_udata, outline_ptd, 'nrad', [nrad]
 cor_set_udata, outline_ptd, 'nlon', [nlon]

 return, outline_ptd
end
;=====================================================================
