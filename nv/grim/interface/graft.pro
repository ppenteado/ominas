;=============================================================================
;+
; NAME:
;	graft
;
;
; PURPOSE:
;	Grafts POINT arrays into GRIM.  
;
;
; CATEGORY:
;	NV/GR
;
;
; CALLING SEQUENCE:
;	graft, arg
;
;
; ARGUMENTS:
;  INPUT:
;	arg:	POINT object or array of image points.  
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT:
;	pn:	 Plane number to access.  If not given, then current plane
;		 is used.
;
;	grn:	 ID of GRIM instance to use.  If not given, then current one
;		 is used.
;
;	psym:	 Plotting symbol.
;
;	tag:	 If given, the array is added as user data with this tag name.
;
;	symsize: Plotting symbol size.
;
;	color:	 Plotting color.
;
;	psym:	 Plotting symbol.
;
;
;
; EXAMPLE:
;	(1) Open a GRIM window, load an image, and compute planet centers.
;
;	(2) At the command line, type:
;
;		IDL> grift, gd=gd
;		IDL> limb_ptd = pg_limb(gd=gd, gbx=gd.pd)
;		IDL> graft, limb_ptd
;
;	GRIM should plot the new overlay.
;
;
; SEE ALSO:
;	grim, grift
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale
;	
;-
;=============================================================================
pro graft, arg, $
   psym=psym, symsize=symsize, color=_color, tag=tag, pn=pn, grn=grn

 type = size(arg, /type)
 if(type EQ 11) then ptd = arg $
 else ptd = pnt_create_descriptors(points=arg)
 nobj = n_elements(ptd)

 ;------------------------------------------------------------------
 ; determine which GRIM window
 ;------------------------------------------------------------------
 if(keyword_set(grn)) then $
                     grim_data = grim_get_data(grim_grn_to_top(grn)) $
 else grim_data = grim_get_data(/primary)

 refresh = 0

 ;------------------------------------------------------------------
 ; determine which GRIM plane
 ;------------------------------------------------------------------
 plane = grim_get_plane(grim_data)
 planes = grim_get_plane(grim_data, /all)

 if(NOT defined(pn)) then $
    if(n_elements(dim) EQ 1) then pn = plane.pn

 if(defined(pn)) then $
  begin
   w = where(grim_data.pn EQ pn)
   if(w[0] NE -1) then refresh = 1
   plane = planes[pn]
  end $
 else refresh = 1


 ;------------------------------------------------------------------
 ; parse color input
 ;------------------------------------------------------------------
 if(keyword__set(_color)) then $
    if(size(_color, /type) NE 7) then __color = ctlookup(_color)
 if(keyword__set(__color)) then color = __color


 ;------------------------------
 ; set user points
 ;------------------------------
 if(keyword_set(tag)) then $
    grim_add_user_points, plane=plane, pnt_compress(ptd), tag, $
        	   psym=psym, symsize=symsize, color=color, /no_refresh $
 else $
  begin
   for i=0, n_elements(ptd)-1 do $
    begin
     tag = pnt_desc(ptd[i]) + '-' + cor_name(ptd[i])
     grim_add_user_points, plane=plane, ptd[i], $
                  tag, psym=psym, symsize=symsize, color=color, /no_refresh
    end
  end


 if(refresh) then grim_refresh, grim_data;, /no_image

end
;=============================================================================
