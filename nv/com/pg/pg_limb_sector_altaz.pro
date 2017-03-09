;=============================================================================
;+
; NAME:
;	pg_limb_sector_altaz 
;
; PURPOSE:
;	Constructs a limb sector outline for use with pg_profile_ring given
;	altitude and azimuth bounds.
; 
; CATEGORY:
;       NV/PG
;
; CALLING SEQUENCE:
;     outline_ptd=pg_limb_sector_altaz(cd=cd, gbx=gbx, alt, az, dkd=dkd)
;
;
; ARGUMENTS:
;  INPUT:
;      alt:	2-elements array giving the lower and upper altitude bounds
;		for the sector.
;
;      az:	2-elements array giving the lower and upper azimuth bounds
;		for the sector in radians, reliative to the skyplane 
;		projection of the planet's north pole.
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
;          gbx:     Globe descriptor giving the planet about whose limb
;                   the scan will be extracted.
;
;           gd:     Generic descriptor containing the above descriptors.
;
;       sample:     Sets the grid sampling in pixels.  Default is one.
;
;          naz:     Total number of samples in the azimuthal direction.  
;                   Determined by the 'sample' keyword by default.
;
;         nalt:     Total number of samples in the altitude direction.  
;                   Determined by the 'sample' keyword by default.
;
;          alt:     Array giving the altitude of each point in the sector.
;
;           az:     Array giving the azimuth of each point in the sector.
;
;           cw:     If set, azimuths are assumed to increase in the clockwise
;                   direction.
;
;        nodsk:     If set, skyplane disk image points will not be included 
;                   in the output POINT.
;
;      graphic:     If set, the sector is computed in the planetographic
;                   sense, i.e., lines of constant azimuth extend along 
;                   the local surface normal direction instead of the radial
;                   direction.
;
;
;  OUTPUT:
;          dkd:     Disk descriptor in the skyplane, centered on the planet
;                   with 0 axis along the skyplane projection of the north 
;                   pole.  For use with pg_profile_ring.
;
;         azimuths: Array giving azimuth at each sample.
;
;        altitudes: Array giving altitude at each sample.
;
;    limb_pts_body: Body coordinates of each limb points on planet surface.
;
;
;
; RETURN: 
;      POINT containing points on the sector outline.  The point
;      spacing is determined by the sample keyword.  The POINT objects
;      also contains the disk coordinate for each point, relative to the
;      returned disk descriptor, and the user fields 'nrad' and 'nlon' 
;      giving the number of points in altitude and azimuth.
;
; KNOWN BUGS:
;	The sector flips when it hits zero azimuth rather than retaining a 
;	consistent sense.
;
;
; ORIGINAL AUTHOR : 
;	Spitale; 8/2006
;
;-
;=============================================================================
function pg_limb_sector_altaz, cd=cd, gbx=_gbx, gd=gd, dkd=dkd, $
                         alt, _az, sample=sample, nodsk=nodsk, $
                         altitudes=altitudes, azimuths=azimuths, $
                         limb_pts_body=limb_pts_body, cw=cw, $
                         naz=__naz, nalt=__nalt, graphic=graphic
 
 az = _az
 if(keyword_set(cw)) then az = 2d*!dpi - az

 ;-----------------------------------------------
 ; dereference the generic descriptor if given
 ;-----------------------------------------------
 if(NOT keyword_set(cd)) then cd = dat_gd(gd, dd=dd, /cd)
 if(NOT keyword_set(_gbx)) then _gbx = dat_gd(gd, dd=dd, /gbx)

 if(NOT keyword__set(_gbx)) then $
            nv_message, name='pg_limb_sector_altaz', 'Globe descriptor required.'
 __gbx = get_primary(cd, _gbx)
 if(keyword__set(__gbx[0])) then gbx = __gbx $
 else  gbx = _gbx[0,*]

 ;-----------------------------------
 ; validate descriptors
 ;-----------------------------------
 if(n_elements(cds) GT 1) then nv_message, name='pg_limb_sector_altaz', $
                        'No more than one camera descriptor may be specified.'


 ;--------------------------
 ; construct sector
 ;--------------------------
 _naz = 100 & _nalt = 5

 outline_pts = get_limb_profile_outline(cd, gbx, dkd=dkd, $
                          alt=alt, az=az, nalt=_nalt, naz=_naz, graphic=graphic)
 dsk_outline_pts = image_to_disk(cd, dkd, outline_pts)
 rads = dsk_outline_pts[_naz+lindgen(_nalt),0]
 lons = dsk_outline_pts[lindgen(_naz), 1]

 nazrad = get_ring_profile_n(reform(outline_pts), cd, dkd, $
                                                   lons, rads, oversamp=sample)
 nalt = long(nazrad[1])>2 & naz = long(nazrad[0])

 if(keyword_set(__naz)) then naz = __naz
 if(keyword_set(__nalt)) then nalt = __nalt

 outline_pts = get_limb_profile_outline(cd, gbx, dkd=dkd, $
     alt=alt, az=az, nalt=nalt, naz=naz, limb=limb_pts_body, $
                           scan_alt=altitudes, scan_az=azimuths, graphic=graphic)
 if(keyword_set(cw)) then azimuths = 2d*!dpi - azimuths

 ;-------------------------------------------
 ; Return outline points
 ;-------------------------------------------
 dsk_outline_pts = 0

 if(NOT keyword_set(nodsk)) then $
                    dsk_outline_pts = image_to_disk(cd, dkd, outline_pts)

 outline_ptd = pnt_create_descriptors(points = outline_pts, $
                      desc = 'pg_limb_sector_altaz', $
                      data = transpose(dsk_outline_pts))
 cor_set_udata, outline_ptd, 'nrad', [nalt]
 cor_set_udata, outline_ptd, 'nlon', [naz]

 return, outline_ptd
end
;=====================================================================
