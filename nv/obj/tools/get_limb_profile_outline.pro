;=============================================================================
;+
; NAME:
;       get_limb_profile_outline
;
;
; PURPOSE:
;       Generates an outline of a limb sector.
;
; CATEGORY:
;       NV/LIB/TOOLS
;
;
; CALLING SEQUENCE:
;	result = get_limb_profile_outline(cd, gbx, points)
;
;
; ARGUMENTS:
;  INPUT:
;	cd:	Camera descriptor.
;
;	gbx:	Globe descriptor.
;
;	points:	Array (2,2) of image points defining opposite corners
;		of the sector.
;
;  OUTPUT:
;	NONE
;
;
; KEYWORDS:
;  INPUT:
;	NONE 
;
;  OUTPUT:
;	inertial:	Inertial vectors corresponding to the limb sector 
;			outline points.
;
;	dkd:	Disk descriptor corresponding to the skyplane.
;
;
; RETURN:
;       Array of image points defining the outline of the sector.
;
;
; MODIFICATION HISTORY:
;       Written by:     Spitale, 8/2006
;
;-
;=============================================================================
function get_limb_profile_outline, cd, gbx, points, alt=calt, az=caz, $
        nalt=nalt, naz=naz, inertial=inertial, dkd=dkd, save_azs=save_azs, $
        scan_alt=alt, scan_az=az, limb_pts_body=limb_pts_body, graphic=graphic

 ;----------------------------------------
 ; construct disk descriptor on skyplane
 ;----------------------------------------
 dkd = dsk_create_descriptors(1, name='SKYPLANE')
 bod_set_pos, dkd, bod_pos(gbx)
 sma = dsk_sma(dkd)
 sma[0,0] = 0d & sma[0,1] = 1d
 zz = (bod_orient(cd))[1,*] 		; optic axis vector
 vv = (bod_orient(gbx))[2,*]		; planet axis
 yy = v_unit(v_cross(zz, vv)) 			
 xx = v_unit(v_cross(yy, zz))		; zero of azimuth along xx (pole)
 orient = [xx, yy, zz]

 dsk_set_sma, dkd, sma
 bod_set_orient, dkd, orient

 cam_pos_body = bod_inertial_to_body_pos(gbx, bod_pos(cd))


 ;----------------------------------------
 ; set up bounds if not given
 ;----------------------------------------
 if(keyword_set(points)) then $
  begin
   dsk_pts = image_to_disk(cd, dkd, points, frame=dkd, body=body_pts)

   crad = dsk_pts[*,0]
   ss = sort(crad)
   crad = crad[ss]

   clon = dsk_pts[*,1]
   clon = clon[ss]
  end 

 if(NOT keyword_set(caz)) then caz = -orb_lon_to_anom(dkd, clon, dkd)
 if(NOT keyword_set(clon)) then clon = orb_anom_to_lon(dkd, -caz, dkd)

 cmag = v_mag(glb_get_limb_points(gbx, cam_pos_body, 2, alpha=caz))
 if(NOT keyword_set(calt)) then calt = crad - cmag
; if(NOT keyword_set(crad)) then crad = calt + cmag


 ;----------------------------------------
 ; compute limb points
 ;----------------------------------------
 save_azs = caz

 az = dindgen(naz)*(caz[1]-caz[0])/double(naz-1) + caz[0]
 limb_pts_body = glb_get_limb_points(gbx, cam_pos_body, naz, alpha=az)

 ;-------------------------------------------------------
 ; scale limb points to desired altitudes
 ;-------------------------------------------------------
 if(keyword_set(graphic)) then $
  begin
   dirs = glb_surface_normal(gbx, limb_pts_body)
   inner_pts_body = limb_pts_body + dirs * calt[0]
   outer_pts_body = limb_pts_body + dirs * calt[1]
  end $
 else $
  begin
   dirs = v_unit(limb_pts_body, mag=mags)
   mags = mags # make_array(3,val=1d)
   inner_pts_body = dirs * (mags+calt[0])
   outer_pts_body = dirs * (mags+calt[1])
  end

 inner_pts = bod_body_to_inertial_pos(gbx, inner_pts_body)
 outer_pts = bod_body_to_inertial_pos(gbx, outer_pts_body)

 inner_pts_disk = dsk_body_to_disk(dkd, $
                   bod_inertial_to_body_pos(dkd, inner_pts), frame=dkd)
 outer_pts_disk = dsk_body_to_disk(dkd, $
                   bod_inertial_to_body_pos(dkd, outer_pts), frame=dkd)


 ;----------------------------------------
 ; compute image coordinates
 ;----------------------------------------
 f = dindgen(nalt)/double(nalt-1)

 dir = outer_pts[0,*] - inner_pts[0,*]
 end_pts0 = (dir##make_array(nalt, val=1d)) * (f#make_array(3,val=1d)) $
              + inner_pts[0,*]##make_array(nalt, val=1d)
 dir = outer_pts[naz-1,*] - inner_pts[naz-1,*]
 end_pts1 = (dir##make_array(nalt, val=1d)) * (f#make_array(3,val=1d)) $
              + inner_pts[naz-1,*]##make_array(nalt, val=1d)

 inertial_pts = [inner_pts, end_pts0, outer_pts, end_pts1]

 im_pts = cam_focal_to_image(cd, $
              cam_body_to_focal(cd, $
                bod_inertial_to_body_pos(cd, inertial_pts)))

 az = reduce_angle(az)
 return, poly_rectify(reform(im_pts), [naz, nalt, naz, nalt])
end
;===========================================================================



