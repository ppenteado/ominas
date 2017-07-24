;=============================================================================
;+
; NAME:
;	graft
;
;
; PURPOSE:
;	Graft arrays into GRIM.  Adds POINT arrays to GRIM.  
;
;
; CATEGORY:
;	NV/GR
;
;
; CALLING SEQUENCE:
;	graft, arg, <xd>=<xd>
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
;	user:	 If set, graft does not try to determine what type of overlay 
;		 (e.g., limb, ring) is given.
;
;	gd:	Generic descriptor containing <xd> inputs. 
;
;
; SIDE EFFECTS:
;	In addition to replacing internal POINT objects, GRAFT updates
;	GRIM's internal descriptor set using the generic desciptor
;	cntained in the input array.  
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
   psym=psym, symsize=symsize, color=_color, tag=tag, pn=pn, grn=grn, user=user

 type = size(arg, /type)
 if(type EQ 11) then object_ptd = arg $
 else object_ptd = pnt_create_descriptors(points=arg)
 nobj = n_elements(object_ptd)

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


 ;------------------------------------------------------------------
 ; add overlay points
 ;------------------------------------------------------------------
 xds = !null

 for i=0, nobj-1 do $
  begin
   ;- - - - - - - - - - - - - - - - - - - - - - - - - - - -
   ; get descriptors
   ;- - - - - - - - - - - - - - - - - - - - - - - - - - - -
   xds = append_array(xds, cor_cat_gd(cor_gd(object_ptd[i])))

   ;- - - - - - - - - - - - - - - - - - - - - - - - - - - -
   ; determine what type of overlay
   ;- - - - - - - - - - - - - - - - - - - - - - - - - - - -
   if(NOT keyword_set(user)) then desc = pnt_desc(object_ptd[i])

   if(NOT keyword_set(desc)) then $
		user_ptd = append_array(user_ptd, object_ptd[i]) $
   else $
    case strupcase(desc) of
     'LIMB' : limb_ptd = append_array(limb_ptd, object_ptd[i])
     'GLOBE_GRID' : grid_ptd = append_array(grid_ptd, object_ptd[i])
     'DISK_INNER' : ring_ptd = append_array(ring_ptd, object_ptd[i])
     'DISK_OUTER' : ring_ptd = append_array(ring_ptd, object_ptd[i])
     'TERMINATOR' : term_ptd = append_array(term_ptd, object_ptd[i])
     'STAR_CENTER' : star_ptd = append_array(star_ptd, object_ptd[i])
     'PLANET_CENTER' : center_ptd = append_array(center_ptd, object_ptd[i])
     'ARRAY' : array_ptd = append_array(array_ptd, object_ptd[i])
     'STATION' : station_ptd = append_array(station_ptd, object_ptd[i])
     else : user_ptd = append_array(user_ptd, object_ptd[i])
    endcase
  end

 ;------------------------------
 ; add descriptors to grim
 ;------------------------------
 gd = cor_create_gd(xds)
 sund = cor_dereference_gd(gd, name='SUN') 	; this stinks; another reason to
						; stop treating the sun specially
						; in grim
 grim, gd=gd, sund=sund, /no_refresh

 ;------------------------------
 ; add object points to grim
 ;------------------------------
 grim_data = grim_get_data(grn=grn)

 if(keyword_set(limb_ptd)) then $
	 grim_add_points, grim_data, limb_ptd, name='limb', plane=plane
 if(keyword_set(grid_ptd)) then $
	 grim_add_points, grim_data, grid_ptd, name='planet_grid', plane=plane
 if(keyword_set(ring_ptd)) then $
	 grim_add_points, grim_data, ring_ptd, name='ring', plane=plane
 if(keyword_set(term_ptd)) then $
	 grim_add_points, grim_data, term_ptd, name='terminator', plane=plane
 if(keyword_set(star_ptd)) then $
	 grim_add_points, grim_data, star_ptd, name='star', plane=plane
 if(keyword_set(center_ptd)) then $
	 grim_add_points, grim_data, center_ptd, name='planet_center', plane=plane
 if(keyword_set(station_ptd)) then $
	 grim_add_points, grim_data, station_ptd, name='station', plane=plane
 if(keyword_set(array_ptd)) then $
	 grim_add_points, grim_data, array_ptd, name='array', plane=plane


 ;------------------------------
 ; set user points
 ;------------------------------
 if(keyword_set(user_ptd)) then $
  begin
   if(keyword_set(tag)) then $
      grim_add_user_points, plane=plane, user_ptd, tag, $
		     psym=psym, symsize=symsize, color=color, /no_refresh $
   else $
    begin
     nuser = n_elements(user_ptd)
     all_tags = strarr(nuser)

     ;-------------------------
     ; determine unique tags
     ;-------------------------
     tags = ''
     for i=0, nuser-1 do $
      begin
       tag = pnt_desc(user_ptd[0])
       all_tags[i] = tag
       w = where(tags EQ tag)
       if(w[0] EQ -1) then tags = [tags, tag]
      end
     if(keyword_set(tags)) then tags = tags[1:*]

     ;-------------------------
     ; add points by tag
     ;-------------------------
     ntags = n_elements(tags)
     for i=0, ntags-1 do $
      begin
       w = where(all_tags EQ tags[i])
       grim_add_user_points, plane=plane, user_ptd[w], $
		    tags[i], psym=psym, symsize=symsize, color=color, /no_refresh
      end

    end
  end


 if(refresh) then grim_refresh, grim_data;, /no_image

end
;=============================================================================
