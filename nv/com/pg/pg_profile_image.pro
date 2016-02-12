;=============================================================================
;+
; NAME:
;	pg_profile_image
;
;
; PURPOSE:
;	Generates a dn profile along a line in an image.
;
; CATEGORY:
;	NV/PG
;
;
; CALLING SEQUENCE:
;    result = pg_profile_image(dd, cd=cd, outline_ps)
;
;
; ARGUMENTS:
;  INPUT:
;	  dd:	Data descriptor.
;
; outline_ps:   points_struct giving the outline of the region to plot,
;               as produced by the pg_image_sector.
;
;  OUTPUT:
;        NONE
;
; KEYWORDS:
;  INPUT:
;	  cd:	Camera descriptor.  Needed for sinc interpolation. (to get PSF)
;
;         gd:   Optional generic descriptor containing cd.
;
;     interp:   Type of interpolation to use.  Options are:
;               'nearest', 'mean', 'bilinear', 'cubic', 'sinc'.
;
;         bg:	Uniform value to subtract from profile.
;
; arg_interp:   Arguments to pass to the interpolation function.
;
;
;  OUTPUT:
;    profile:   The profile.
;
;      sigma:   Array giving the standard deviation at each point in the
;		profile.
;
;    distance:  Array giving the distance, in pixels, along the profile.
;
;   image_pts:  Image point for each point along the profile.
;
;
; RETURN:
;	Two data descriptors: the first contains the profile; the second contains
;	the profile sigma.
;
;
; MODIFICATION HISTORY:
;       Written by:     Spitale, 6/2005
;	
;-
;=============================================================================
function pg_profile_image, dd, cd=cd, gd=gd, outline_ps, distance=distance, $
             interp=interp, arg_interp=arg_interp, sigma=sigma, profile=profile, $
             image_pts=image_pts, bg=bg

 ;-----------------------------------------------
 ; dereference the generic descriptor if given
 ;-----------------------------------------------
 pgs_gd, gd, cd=cd, dd=dd

 im = nv_data(dd)

 ;-----------------------------------
 ; get the points
 ;-----------------------------------
 outline_pts = ps_points(outline_ps)
 nl = ps_udata(outline_ps, 'nl')
 nw = ps_udata(outline_ps, 'nw')
 sample= ps_udata(outline_ps, 'sample')
 nl = nl[0] & nw = nw[0] & sample = sample[0]


 ;-----------------------------------------------
 ; set up sampling grid
 ;-----------------------------------------------
 if(nw EQ 1) then $
  begin
   p0 = outline_pts[*,0]
   p1 = outline_pts[*,nl-1]
  end $
 else $
  begin
   p0 = 0.5*(outline_pts[*,0] + outline_pts[*,nl+nw+nl])
   p1 = 0.5*(outline_pts[*,nl] + outline_pts[*,nl+nw])
  end
 p = tr([tr(p0), tr(p1)])

 
 ;-----------------------------------------------
 ; extract profile
 ;-----------------------------------------------
 profile = get_image_profile(im, cd, p, nl, nw, sample, $
       distance=distance, interp=interp, arg_interp=arg_interp, sigma=sigma, image_pts=image_pts)
 if(keyword_set(bg)) then profile = profile - bg[0]

 dd_prof = [ nv_init_descriptor(data=[tr(distance), $
                                 tr(profile)], id_string=nv_id_string(dd)), $
             nv_init_descriptor(data=[tr(distance), $
                                 tr(sigma)], id_string=nv_id_string(dd)) ]
 nv_set_header, dd_prof[0], nv_header(dd)
 nv_set_header, dd_prof[1], nv_header(dd)

 image_ps = ps_init(p=image_pts)
 nv_set_udata, dd_prof[0], image_ps, 'IMAGE_PS'
 nv_set_udata, dd_prof[1], image_ps, 'IMAGE_PS'

 return, dd_prof
end
;==============================================================================


pro test
;grim ~/casIss/1495/N1495308131_1.IMG over=rings
ingrid, dd=dd, cd=cd

outline_ps = pg_image_sector()
profile = pg_profile_image(dd, outline_ps, cd=cd, distance=distance)

;p = tvline()
;p = (convert_coord(/device, /to_data, double(p[0,*]), double(p[1,*])))[0:1,*]

;profile = pg_profile_image(dd, cd=cd, p, distance=distance)
plot, distance, profile


end
