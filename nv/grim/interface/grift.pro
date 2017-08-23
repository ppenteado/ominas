;=============================================================================
;+
; NAME:
;	grift
;
;
; PURPOSE:
;	External access to GRIM data.  Purloins object and array references
;	from GRIM so that they may be manipulated on the command line or by an
;	external agent.  The returned descriptors allow direct access to the 
;	memory images of GRIM's objects, so any changes made affect the 
;	objects that GRIM is using.  GRIM monitors those objects and updates 
;	itself whenever a change occurs.  
;
;
; CATEGORY:
;	NV/GR
;
;
; CALLING SEQUENCE:
;	grift, arg, <xd>=<xd>, <overlay>_ptd=<overlay>_ptd
;
;
; ARGUMENTS:
;  INPUT:
;	arg:	GRIM window number or GRIM data struture.  If not given, the 
;		most recently accessed grim instance is used.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT:
;	plane:	Grim plane structure(s) instead of giving pn.  Note all planes
;		must belong to the same grim instance.
;
;	pn:	Plane number(s) to access.  If not given, then current plane
;		is used.
;
;	all:	If set, all planes are used.
;
;	active:	If set, only active memebrs of the selected objects are
;		returned.
;
;  OUTPUT:
;	gd:	Generic descriptor containing all of GRIM's descriptors.  
;		For multiple planes, a list is returned with each element
;		corresponding to a plane.
;
;	<xd>:	Any descriptor maintained by GRIM.
;
;	<xdx>:	Returnds all descriptors containing the given class, e.g., 
;		bx, gbx, dkx.   Not implemented.
;
;	<overlay>_ptd:
;		POINT object giving the points for the overlay of type <overlay>.
;
;	object_ptd:
;		POINT object giving all overlay points.
;
;	tie_ptd:
;		POINT object giving the tie points.  For multiple planes, a 
;		list is returned with each element corresponding to a plane.
;
;	curve_ptd:
;		POINT object giving the curve points.  For multiple planes, a 
;		list is returned with each element corresponding to a plane.
;
;
; EXAMPLE:
;	(1) Open a GRIM window, load an image, and compute limb points.
;
;	(2) At the command line, type:
;
;		IDL> grift, cd=cd
;		IDL> pg_repoint, [50,50], 0d, cd=cd
;
;	GRIM should detect the change to the camera descriptor and update
;	itself by recomputing the limb points and refreshing the display.
;
;
; SEE ALSO:
;	grim, graft
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 7/2002
;	
;-
;=============================================================================
pro grift, arg, plane=planes, pn=pn, all=all, active=active, grn=grn, gd=gd, $
         dd=dd, $
         cd=cd, $
         md=md, $
         pd=pd, $
         rd=rd, $
         sd=sd, $
         std=std, $
         ard=ard, $
         ltd=ltd, $
         od=od, $
         bx=bx, $
         bbx=bbx, $
         dkx=dkx, $
         limb_ptd=limb_ptd, $
         ring_ptd=ring_ptd, $
         star_ptd=star_ptd, $
         station_ptd=station_ptd, $
         array_ptd=array_ptd, $
         term_ptd=term_ptd, $
         plgrid_ptd=plgrid_ptd, $
         center_ptd=center_ptd, $
         shadow_ptd=shadow_ptd, $
         reflection_ptd=reflection_ptd, $
         object_ptd=object_ptd, $
         tie_ptd=tie_ptd, $
         curve_ptd=curve_ptd, $
_ref_extra=ex

 ;--------------------------------------------
 ; clear output arrays
 ;--------------------------------------------
 dd = !null
 cd = !null
 md = !null
 pd = !null
 rd = !null
 sd = !null
 std = !null
 ard = !null
 ltd = !null
 od = !null
 bx = !null
 gbx = !null
 dkx = !null
 limb_ptd = !null
 ring_ptd = !null
 star_ptd = !null
 station_ptd = !null
 array_ptd = !null
 term_ptd = !null
 plgrid_ptd = !null
 center_ptd = !null
 shadow_ptd = !null
 reflection_ptd = !null
 object_ptd = !null
 tie_ptd = !null
 curve_ptd = !null

 ;----------------------------------------------------------------
 ; interpret argument
 ;----------------------------------------------------------------
 arg_type = size(arg, /type)
 if(arg_type EQ 8) then grim_data = arg $
 else if(arg_type NE 0) then grn = arg

 if(defined(grn)) then grim_data = grim_get_data(grim_grn_to_top(grn)) $
 else grim_data = grim_get_data(/primary)

 if(NOT keyword_set(grim_data)) then grim_data = grim_get_data(planes[0])

 grn = grim_data.grn

 
 ;----------------------------------------------------------------
 ; get planes
 ;----------------------------------------------------------------
 if(NOT keyword_set(planes)) then $
  begin
   if(keyword_set(all)) then planes = grim_get_plane(grim_data, /all) $
   else planes = grim_get_plane(grim_data)
  end
 nplanes = n_elements(planes)


 ;----------------------------------------------------------------
 ; build outputs
 ;----------------------------------------------------------------
 gd = list(length=nplanes)
 tie_ptd = list(length=nplanes)
 curve_ptd = list(length=nplanes)

 for i=0, nplanes-1 do $
  begin
   plane = planes[i]

   ;- - - - - - - - - - - - - - - - - - - - - - - - - - - -
   ; active objects
   ;- - - - - - - - - - - - - - - - - - - - - - - - - - - -
   if(keyword_set(active)) then $
    begin
     ddi = (cdi = (ltdi = (odi = !null)))
     pd = append_array(active_pd, (pdi=grim_get_active_xds(plane, 'PLANET')))
     rd = append_array(active_rd, (rdi=grim_get_active_xds(plane, 'RING')))
     sd = append_array(active_sd, (sdi=grim_get_active_xds(plane, 'STAR')))
     std = append_array(active_std, (stdi=grim_get_active_xds(plane, 'STATION')))
     ard = append_array(active_ard, (ardi=grim_get_active_xds(plane, 'ARRAY')))

     limb_ptd = append_array(limb_ptd, grim_get_active_overlays(grim_data, 'LIMB'))
     ring_ptd = append_array(ring_ptd, grim_get_active_overlays(grim_data, 'RING'))
     star_ptd = append_array(star_ptd, grim_get_active_overlays(grim_data, 'STAR'))
     term_ptd = append_array(term_ptd, grim_get_active_overlays(grim_data, 'TERMINATOR'))
     plgrid_ptd = append_array(plgrid_ptd, grim_get_active_overlays(grim_data, 'PLANET_GRID'))
     center_ptd = append_array(center_ptd, grim_get_active_overlays(grim_data, 'CENTER'))
     shadow_ptd = append_array(shadow_ptd, grim_get_active_overlays(grim_data, 'SHADOW'))
     reflection_ptd = append_array(reflection_ptd, grim_get_active_overlays(grim_data, 'REFLECTION'))
     station_ptd = append_array(station_ptd, grim_get_active_overlays(grim_data, 'STATION'))
     array_ptd = append_array(array_ptd, grim_get_active_overlays(grim_data, 'ARRAY'))
     object_ptd = append_array(object_ptd, grim_get_active_xds(plane))
    end $
   ;- - - - - - - - - - - - - - - - - - - - - - - - - - - -
   ; all objects
   ;- - - - - - - - - - - - - - - - - - - - - - - - - - - -
   else $
    begin
     dd = cor_cull(append_array(dd, (ddi=plane.dd)))
     cd = cor_cull(append_array(cd, (cdi=grim_xd(plane, /cd))))
     if(keyword_set(cd)) then if(cor_class(cd[0]) EQ 'MAP') then md = cd
     pd = cor_cull(append_array(pd, (pdi=grim_xd(plane, /pd))))
     rd = cor_cull(append_array(rd, (rdi=grim_xd(plane, /rd))))
     sd = cor_cull(append_array(sd, (sdi=grim_xd(plane, /sd))))
     std = cor_cull(append_array(std, (stdi=grim_xd(plane, /std))))
     ard = cor_cull(append_array(ard, (ardi=grim_xd(plane, /ard))))
     ltd = cor_cull(append_array(ltd, (ltdi=grim_xd(plane, /ltd))))
     od = cor_cull(append_array(od, (odi=grim_xd(plane, /od))))

     limb_ptd = append_array(limb_ptd, *(grim_get_overlay_ptdp(grim_data, plane=plane, 'LIMB')))
     ring_ptd = append_array(ring_ptd, *(grim_get_overlay_ptdp(grim_data, plane=plane, 'RING')))
     star_ptd = append_array(star_ptd, *(grim_get_overlay_ptdp(grim_data, plane=plane, 'STAR'))) 
     term_ptd = append_array(term_ptd, *(grim_get_overlay_ptdp(grim_data, plane=plane, 'TERMINATOR'))) 
     plgrid_ptd = append_array(plgrid_ptd, *(grim_get_overlay_ptdp(grim_data, plane=plane, 'PLANET_GRID'))) 
     center_ptd = append_array(center_ptd, *(grim_get_overlay_ptdp(grim_data, plane=plane, 'CENTER'))) 
     shadow_ptd = append_array(shadow_ptd, *(grim_get_overlay_ptdp(grim_data, plane=plane, 'SHADOW'))) 
     reflection_ptd = append_array(reflection_ptd, *(grim_get_overlay_ptdp(grim_data, plane=plane, 'REFLECTION'))) 
     station_ptd = append_array(station_ptd, *(grim_get_overlay_ptdp(grim_data, plane=plane, 'STATION'))) 
     array_ptd = append_array(array_ptd, *(grim_get_overlay_ptdp(grim_data, plane=plane, 'ARRAY'))) 
     object_ptd = append_array(object_ptd, grim_cat_points(grim_data))
    end

   ;- - - - - - - - - - - - - - - - - - - - - - - - - - - -
   ; tie points and curves
   ;- - - - - - - - - - - - - - - - - - - - - - - - - - - -
   tie_ptd[i] = *plane.tiepoint_ptdp
   curve_ptd[i] = *plane.curve_ptdp

   ;- - - - - - - - - - - - - - - - - - - - - - - - - - - -
   ; generic descriptor
   ;- - - - - - - - - - - - - - - - - - - - - - - - - - - -
   gd[i] = cor_create_gd(dd=ddi, cd=cdi, pd=pdi, rd=rdi, $
                            ltd=ltdi, sd=sdi, ard=ardi, std=stdi, od=odi)
  end

 ;------------------------------------------------------------------
 ; don't return lists if only one plane
 ;------------------------------------------------------------------
 if(nplanes EQ 1) then $
  begin
   if((n_elements(gd) EQ 1) AND (NOT keyword_set(gd[0]))) then gd = !null $
   else gd = gd.ToArray()
   tie_ptd = tie_ptd.ToArray()
   curve_ptd = curve_ptd.ToArray()
  end


end
;=============================================================================
