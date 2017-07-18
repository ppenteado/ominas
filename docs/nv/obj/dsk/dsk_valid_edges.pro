;=============================================================================
;+
; NAME:
;	dsk_valid_edges
;
;
; PURPOSE:
;	Determines which edges (i.e., inner/outer) in the input DISK objects 
;	are valid.
;
;
; CATEGORY:
;	NV/LIB/DSK
;
;
; CALLING SEQUENCE:
;	sub = dsk_valid_edges(dkd, </inner|/outer|/all>)
;
;
; ARGUMENTS:
;  INPUT:
;	dkd:	 Array (nt) of any subclass of DISK.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT:  
;	inner:	If set, only the inner edges are tested.
;
;	outer:	If set, only the outer edges are tested.
;
;	all:	If set, the inner and outer edges are tested, and must
;		both be valid to be selected.
;
;  OUTPUT: NONE
;
;
; RETURN:
;	Array of subscripts of the descriptors whose edges meet the criteria
;	defined by the input keyowrds.
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale
; 	Adapted by:	Spitale, 5/2016
;	
;-
;=============================================================================
function dsk_valid_edges, dkd, inner=inner, outer=outer, all=all, noevent=noevent
@core.include
 
 nv_notify, dkd, type = 1, noevent=noevent
 _dkd = cor_dereference(dkd)

 if(keyword_set(all)) then $
          return, where((_dkd.sma[0,0,*] GE 0) AND (_dkd.sma[0,1,*] GE 0))

 if(keyword_set(inner)) then ii = 0 $
 else if(keyword_set(outer)) then ii = 1 $
 else ii = [0,1]

 return, where(_dkd.sma[0,ii,*] GE 0)
end
;===========================================================================



