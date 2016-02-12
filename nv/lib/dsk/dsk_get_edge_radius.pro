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
;	r = dsk_get_edge_radius(dkx, lon, frame_bd)
;
;
; ARGUMENTS:
;  INPUT:
;	dkx:	 Array (nt) of any subclass of DISK.
;
;	lon:	 Array (nlon) of longitudes at which to compute radii.
;
;	time:	 Array (nlon) of epochs to use instead of that of dkxp.
;
;	frame_bd:	Subclass of BODY giving the frame against which to 
;			measure inclinations and nodes, e.g., a planet 
;			descriptor.  One for each dkx.
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
;	
;-
;=============================================================================
function dsk_get_edge_radius, dkxp, lon, frame_bd, inner=inner, outer=outer, time=time, $
    one_to_one=one_to_one
@nv_lib.include
 dkdp = class_extract(dkxp, 'DISK')
 nv_notify, dkdp, type = 1
 dkd = nv_dereference(dkdp)

 if(keyword__set(inner)) then ii = 0 $
 else if(keyword__set(outer)) then ii = 1

 nlon = n_elements(lon)
 nt = n_elements(dkd)

 if(NOT keyword__set(one_to_one)) then $
  begin
   MM = make_array(nlon,val=1)

   a = [reform([dkd.sma[0,ii,*]])]#MM				; nt x nlon
   e = [reform([dkd.ecc[0,ii,*]])]#MM				; nt x nlon
   lp = orb_arg_to_lon(dkdp, dsk_get_ap(dkdp, frame_bd), frame_bd)#MM

   nm = dsk_get_nm()
   sub = linegen3y(nt,nlon,nm)

   m = (transpose(dkd.m[*,ii,*]))[sub]			; nt x nlon x nm
   em = (transpose(dkd.em[*,ii,*]))[sub]		; nt x nlon x nm
   lpm = (transpose(dkd.lpm[*,ii,*]))[sub]		; nt x nlon x nm
   dlpmdt = (transpose(dkd.dlpmdt[*,ii,*]))[sub]	; nt x nlon x nm
  end $
 else $
  begin
   a = tr(reform([dkd.sma[0,ii,*]]))				; 1 x nlon
   e = tr(reform([dkd.ecc[0,ii,*]]))				; 1 x nlon
   lp = tr(orb_arg_to_lon(dkdp, dsk_get_ap(dkdp, frame_bd), frame_bd))

   nm = dsk_get_nm()
   m = reform(transpose(dkd.m[*,ii,*]), 1,nlon,nm, /over)	; 1 x nlon x nm
   em = reform(transpose(dkd.em[*,ii,*]), 1,nlon,nm, /over)	; 1 x nlon x nm
   lpm = reform(transpose(dkd.lpm[*,ii,*]), 1,nlon,nm, /over)	; nt x nlon x nm
   dlpmdt = reform(transpose(dkd.dlpmdt[*,ii,*]), 1,nlon,nm, /over) ; nt x nlon x nm
  end


 if(keyword_set(time)) then $
  begin
   dt = time - bod_time(dkxp)

   dlpdt = orb_compute_dlpdt(dkdp, frame_bd, sma=a)

   lp = lp + dt*dlpdt
   lpm = lpm + (dt#make_array(nm,val=1d))*dlpmdt
  end


 return, dsk_shape_radial(a, e, lp, lon, m, em, lpm)
end
;===========================================================================
