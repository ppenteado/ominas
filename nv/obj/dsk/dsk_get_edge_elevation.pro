;=============================================================================
;+
; NAME:
;	dsk_get_edge_elevation
;
;
; PURPOSE:
;	Computes elevations along the edge of a disk.
;
;
; CATEGORY:
;	NV/LIB/DSK
;
;
; CALLING SEQUENCE:
;	z = dsk_get_edge_elevation(dkd, lon, frame_bd)
;
;
; ARGUMENTS:
;  INPUT:
;	dkd:	 Array (nt) of any subclass of DISK.
;
;	lon:	 Array (nlon) of longitudes at which to compute elevations.
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
;	Array (nt x nlon) of elevations computed at each longitude on each 
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
function dsk_get_edge_elevation, dkd, dlon, frame_bd, inner=inner, outer=outer, $
    one_to_one=one_to_one, noevent=noevent
@core.include
 
 nv_notify, dkd, type = 1, noevent=noevent
 _dkd = cor_dereference(dkd)

 if(NOT keyword_set(inner)) then outer = 1

 if(keyword__set(inner)) then ii = 0 $
 else if(keyword__set(outer)) then ii = 1

 nlon = n_elements(dlon)
 nt = n_elements(_dkd)

 _inc = dsk_get_inc(dkd, frame_bd)
 _lan = dsk_get_lan(dkd, frame_bd)

 if(NOT keyword__set(one_to_one)) then $
  begin
   MM = make_array(nlon,val=1)

   a = [reform([_dkd.sma[0,ii,*]])]#MM				; nt x nlon
   i = _inc#MM							; nt x nlon
   lan = _lan#MM

   nl = dsk_get_nl()
   sub = linegen3y(nt,nlon,nl)

   l = (transpose(_dkd.l[*,ii,*]))[sub]			; nt x nlon x nl
   il = (transpose(_dkd.il[*,ii,*]))[sub]		; nt x nlon x nl
   lanl = (transpose(_dkd.lanl[*,ii,*]))[sub]		; nt x nlon x nl
  end $
 else $
  begin
   a = tr(reform([_dkd.sma[0,ii,*]]))				; 1 x nlon
   i = tr(_inc)							; 1 x nlon
   lan = tr(_lan)

   nl = dsk_get_nl()
   l = reform(transpose(_dkd.l[*,ii,*]), 1,nlon,nl, /over)	; 1 x nlon x nl
   il = reform(transpose(_dkd.il[*,ii,*]), 1,nlon,nl, /over)	; 1 x nlon x nl
   lanl = reform(transpose(_dkd.lanl[*,ii,*]), 1,nlon,nl, /over)	; nt x nlon x nl
  end


 return, dsk_shape_vertical(a, i, lan, dlon, l, il, lanl)
end
;===========================================================================
