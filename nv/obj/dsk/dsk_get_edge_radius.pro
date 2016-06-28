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
;	ta:	 Array (nta) of true anomalies at which to compute radii.
;
;	time:	 Array (nta) of epochs to use instead of that of dkd.
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
;	Array (nt x nta) of radii computed at each true anomaly on each 
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
     inner=inner, outer=outer, time=time, one_to_one=one_to_one, noevent=noevent
@core.include
 
 nv_notify, dkd, type = 1, noevent=noevent
 _dkd = cor_dereference(dkd)

 if(keyword__set(inner)) then ii = 0 $
 else if(keyword__set(outer)) then ii = 1

 nta = n_elements(ta)
 nt = n_elements(_dkd)

 if(NOT keyword__set(one_to_one)) then $
  begin
   MM = make_array(nta,val=1)

   a = [reform([_dkd.sma[0,ii,*]])]#MM				; nt x nta
   e = [reform([_dkd.ecc[0,ii,*]])]#MM				; nt x nta
   dap = [reform([_dkd.dap[0,*]])]#MM				; nt x nta

   nm = dsk_get_nm()
   sub = linegen3y(nt,nta,nm)

   m = (transpose(_dkd.m[*,ii,*]))[sub]			; nt x nta x nm
   em = (transpose(_dkd.em[*,ii,*]))[sub]		; nt x nta x nm
   tapm = (transpose(_dkd.tapm[*,ii,*]))[sub]		; nt x nta x nm
   dtapmdt = (transpose(_dkd.dtapmdt[*,ii,*]))[sub]	; nt x nta x nm
  end $
 else $
  begin
   a = tr(reform([_dkd.sma[0,ii,*]]))				; 1 x nta
   e = tr(reform([_dkd.ecc[0,ii,*]]))				; 1 x nta

   nm = dsk_get_nm()
   m = reform(transpose(_dkd.m[*,ii,*]), 1,nta,nm, /over)	; 1 x nta x nm
   em = reform(transpose(_dkd.em[*,ii,*]), 1,nta,nm, /over)	; 1 x nta x nm
   tapm = reform(transpose(_dkd.tapm[*,ii,*]), 1,nta,nm, /over)	; nt x nta x nm
   dtapmdt = reform(transpose(_dkd.dtapmdt[*,ii,*]), 1,nta,nm, /over) ; nt x nta x nm
  end


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
