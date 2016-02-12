;=============================================================================
;+
; NAME:
;       get_limb_profile_outline_linear
;
;
; PURPOSE:
;       Generates an outline of a rectangular limb sector.
;
; CATEGORY:
;       NV/LIB/TOOLS
;
;
; CALLING SEQUENCE:
;	result = get_limb_profile_outline_linear(cd, gbx, points)
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
;
; RETURN:
;       Array of image points defining the outline of the sector.
;
;
; MODIFICATION HISTORY:
;       Written by:     Spitale, 1/2009
;
;-
;=============================================================================
function get_limb_profile_outline_linear, cd, gbx, alt=calt, az0=caz0, rim=crim, points=points, $
        nalt=nalt, nrim=nrim, inertial=inertial, save_rims=save_rims, $
        scan_alt=alt, scan_rim=rim, limb_pts_body=limb_pts_body, graphic=graphic

 ;----------------------------------------
 ; get axis vectors
 ;----------------------------------------
 zz = (bod_orient(cd))[1,*] 			; optic axis vector
 vv = (bod_orient(gbx))[2,*]			; planet axis
 yy = v_unit(v_cross(zz, vv)) 			
 xx = v_unit(v_cross(yy, zz))			; zero of cylindrical radius along xx


 cam_pos_body = bod_inertial_to_body_pos(gbx, bod_pos(cd))


 ;----------------------------------------
 ; set up bounds if not given
 ;----------------------------------------
 if(keyword_set(points)) then $
  begin
  end 

; if(NOT keyword_set(cr)) then cr = -orb_lon_to_anom(dkd, clon, dkd)
; if(NOT keyword_set(clon)) then clon = orb_anom_to_lon(dkd, -cr, dkd)

; cmag = v_mag(glb_get_limb_points(gbx, cam_pos_body, 2, alpha=cr))
; if(NOT keyword_set(calt)) then calt = crad - cmag
; if(NOT keyword_set(crad)) then crad = calt + cmag

 ;----------------------------------------
 ; compute limb point
 ;----------------------------------------
 save_rims = crim

 limb_pt_body = glb_get_limb_points(gbx, cam_pos_body, 1, alpha=caz0)


 ;----------------------------------------
 ; scale limb points to desired altitudes
 ;----------------------------------------
 if(keyword_set(graphic)) then $
  begin
   dir = glb_surface_normal(gbx, limb_pt_body)
   inner_pt_body = limb_pt_body + dir * calt[0]
   outer_pt_body = limb_pt_body + dir * calt[1]
  end $
 else $
  begin
   dir = v_unit(limb_pt_body, mag=mags)
   mags = mags # make_array(3,val=1d)
   inner_pt_body = dir * (mags+calt[0])
   outer_pt_body = dir * (mags+calt[1])
  end


 ;----------------------------------------
 ; compute image scan direction
 ;----------------------------------------
 uu = p_unit((bod_inertial_to_body(cd, $
                bod_body_to_inertial(gbx, dir)))[[0,2]])
 u = [uu[1], -uu[0]]#make_array(nrim,val=1d)


 ;----------------------------------------
 ; compute image scan outline
 ;----------------------------------------
 rim = transpose((dindgen(nrim)*(crim[1]-crim[0])/double(nrim-1) + crim[0]) $
                                                          # make_array(2,val=1d))

 inner_pt = reform(body_to_image_pos(cd, gbx, inner_pt_body))#make_array(nrim,val=1d)
 outer_pt = reform(body_to_image_pos(cd, gbx, outer_pt_body))#make_array(nrim,val=1d)

 inner_pts = inner_pt + u*rim
 outer_pts = outer_pt + u*rim

 end_pts0_dir = (outer_pts[*,0] - inner_pts[*,0])#make_array(nalt,val=1d)
 end_pts0 = inner_pts[*,0]#make_array(nalt,val=1d) $
              + end_pts0_dir*transpose((dindgen(nalt)) $
                  / (nalt-1d)#make_array(2,val=1d))

 end_pts1_dir = (outer_pts[*,nrim-1] - inner_pts[*,nrim-1])#make_array(nalt,val=1d)
 end_pts1 = inner_pts[*,nrim-1]#make_array(nalt,val=1d) $
              + end_pts1_dir*transpose((dindgen(nalt)) $
                  / (nalt-1d)#make_array(2,val=1d))

 im_pts = transpose([transpose(inner_pts), $
                     transpose(end_pts1), $
                     transpose(outer_pts), $
                     transpose(end_pts0)])

 return, poly_rectify(reform(im_pts), [nrim, nalt, nrim, nalt])
end
;===========================================================================



