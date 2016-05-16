;=============================================================================
;+
; NAME:
;	dsk_get_edge_radius
;
;
; PURPOSE:
;	Computes radii along the edge of a disk.
;
;
; CATEGORY:
;	NV/LIB/DSK
;
;
; CALLING SEQUENCE:
;	r = dsk_get_edge_radius(dkd, lon, frame_bd)
;
;
; ARGUMENTS:
;  INPUT:
;	dkd:	 Array (nt) of any subclass of DISK.
;
;	lon:	 Array (nlon) of longitudes at which to compute radii.
;
;	time:	 Array (nlon) of epochs to use instead of that of dkd.
;
;	frame_bd:	Subclass of BODY giving the frame against which to 
;			measure inclinations and nodes, e.g., a planet 
;			descriptor.  One for each dkd.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT:  
;	inner:	If set, the inner edge is used.
;
;	outer:	If set, the outer edge is used.
;
;  OUTPUT: NONE
;
;
; RETURN:
;	Array (nt x nlon) of radii computed at each longitude on each 
;	disk.
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale
; 	Adapted by:	Spitale, 5/2016
;	
;-
;=============================================================================
function dsk_get_edge_radius, dkd, lon, frame_bd, inner=inner, outer=outer, time=time, $
    one_to_one=one_to_one, noevent=noevent
@core.include
 
 nv_notify, dkd, type = 1, noevent=noevent
 _dkd = cor_dereference(dkd)

 if(keyword__set(inner)) then ii = 0 $
 else if(keyword__set(outer)) then ii = 1

 nlon = n_elements(lon)
 nt = n_elements(_dkd)

 if(NOT keyword__set(one_to_one)) then $
  begin
   MM = make_array(nlon,val=1)

   a = [reform([_dkd.sma[0,ii,*]])]#MM				; nt x nlon
   e = [reform([_dkd.ecc[0,ii,*]])]#MM				; nt x nlon
   lp = orb_arg_to_lon(dkd, dsk_get_ap(dkd, frame_bd), frame_bd)#MM

   nm = dsk_get_nm()
   sub = linegen3y(nt,nlon,nm)

   m = (transpose(_dkd.m[*,ii,*]))[sub]			; nt x nlon x nm
   em = (transpose(_dkd.em[*,ii,*]))[sub]		; nt x nlon x nm
   lpm = (transpose(_dkd.lpm[*,ii,*]))[sub]		; nt x nlon x nm
   dlpmdt = (transpose(_dkd.dlpmdt[*,ii,*]))[sub]	; nt x nlon x nm
  end $
 else $
  begin
   a = tr(reform([_dkd.sma[0,ii,*]]))				; 1 x nlon
   e = tr(reform([_dkd.ecc[0,ii,*]]))				; 1 x nlon
   lp = tr(orb_arg_to_lon(dkd, dsk_get_ap(dkd, frame_bd), frame_bd))

   nm = dsk_get_nm()
   m = reform(transpose(_dkd.m[*,ii,*]), 1,nlon,nm, /over)	; 1 x nlon x nm
   em = reform(transpose(_dkd.em[*,ii,*]), 1,nlon,nm, /over)	; 1 x nlon x nm
   lpm = reform(transpose(_dkd.lpm[*,ii,*]), 1,nlon,nm, /over)	; nt x nlon x nm
   dlpmdt = reform(transpose(_dkd.dlpmdt[*,ii,*]), 1,nlon,nm, /over) ; nt x nlon x nm
  end


 if(keyword_set(time)) then $
  begin
   dt = time - bod_time(dkd)

   dlpdt = orb_compute_dlpdt(dkd, frame_bd, sma=a)

   lp = lp + dt*dlpdt
   lpm = lpm + (dt#make_array(nm,val=1d))*dlpmdt
  end


 return, dsk_shape_radial(a, e, lp, lon, m, em, lpm)
end
;===========================================================================
