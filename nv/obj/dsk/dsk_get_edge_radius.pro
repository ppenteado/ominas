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
;	r = dsk_get_edge_radius(dkd, ta, frame_bd)
;
;
; ARGUMENTS:
;  INPUT:
;	dkd:	 Array (nt) of any subclass of DISK.
;
;	ta:	 Array (nv x nt) of true anomalies at which to compute radii.
;
;	time:	 Array (nt) of epochs to use instead of that of dkd.
;
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
;	Array (nv x nt) of radii computed at each true anomaly on each 
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
function dsk_get_edge_radius, dkd, ta, $
     inner=inner, outer=outer, time=time, noevent=noevent
@core.include

 nv_notify, dkd, type = 1, noevent=noevent
 _dkd = cor_dereference(dkd)

 if(keyword__set(inner)) then ii = 0 $
 else if(keyword__set(outer)) then ii = 1

 nt = n_elements(_dkd)
 nv = n_elements(ta) / nt

 a = reform((_dkd.sma)[0,ii,*])					; nt
 e = reform((_dkd.ecc)[0,ii,*])					; nt
 dap = reform((_dkd.dap)[0,ii,*])				; nt

 nm = dsk_get_nm()
 sub = linegen3y(nt,nv,nm)

 m = reform(transpose((_dkd.m)[*,ii,*]))			; nt x nm
 em = reform(transpose((_dkd.em)[*,ii,*]))			; nt x nm
 tapm = reform(transpose((_dkd.tapm)[*,ii,*]))			; nt x nm
 dtapmdt = reform(transpose((_dkd.dtapmdt)[*,ii,*]))		; nt x nm


 if(keyword_set(time)) then $
  begin
   dt = time - bod_time(dkd)

dtapdt = orb_compute_dtapdt(dkd, sma=a)

   tap = tap + dt*dtapdt
   tapm = tapm + (dt#make_array(nm,val=1d))*dtapmdt
  end


 return, dsk_shape_radial(a, e, dap, ta, m, em, tapm)
end
;===========================================================================
