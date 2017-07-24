;=============================================================================
;+
; NAME:
;	dat_set_gd
;
;
; PURPOSE:
;	Updates a generic descriptor contained in an object.  Similar to 
;	cor_set_gd, except descriptor inputs are sorted according to the
;	data descriptors contained in their generic descriptors.
;
;
; CATEGORY:
;	NV/PG
;
;
; CALLING SEQUENCE:
;	dat_set_gd, xd, gd, <descriptor keywords>
;
;
; ARGUMENTS:
;  INPUT:
;	xd:	Objects to modify.  The fields from any existing generic 
;		descriptors in these objects are retained in the new ones.
;
;	gd:	New generic descriptor.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: 
;	<x>d:	Input keyword for each descriptor type.  These are sorted
;		according to associated data descriptors.
;
;
;  OUTPUT: NONE
;
;
; RETURN: NONE 
;
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale		2/2017
;	
;-
;=============================================================================
pro dat_set_gd, xd, gd, noevent=noevent, _extra=gdx

 ;---------------------------
 ; get data descriptors
 ;---------------------------
 nxd = n_elements(xd)
 if(cor_class(xd[0]) EQ 'DATA') then dd = xd $
 else dd = cor_gd(xd, /dd, noevent=noevent)

 ;--------------------------------------------------
 ; build an array of all xds contained in inputs
 ;--------------------------------------------------
 xds = cor_cat_gd(gd)
 xds = append_array(xds, cor_cat_gd(gdx))
if(NOT keyword_set(xds)) then return

 ;--------------------------------------------------
 ; match input xds to xd generic descriptors
 ;--------------------------------------------------
 _dd = cor_gd(xds, /dd, noevent=noevent)
 if(NOT keyword_set(dd)) then $
       for i=0, nxd-1 do cor_set_gd, xd[i], xds=xds, noevent=noevent $
 else for i=0, nxd-1 do $
   begin
    w = where(_dd EQ dd[i])
    if(w[0] NE -1) then cor_set_gd, xd[i], xds=xds[w], noevent=noevent
   end

end
;===========================================================================



