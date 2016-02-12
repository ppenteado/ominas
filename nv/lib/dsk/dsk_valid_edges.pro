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
;	sub = dsk_valid_edges(dkx, </inner|/outer|/all>)
;
;
; ARGUMENTS:
;  INPUT:
;	dkx:	 Array (nt) of any subclass of DISK.
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
;	Array of subscripts of the descriptors whose edges meet th criteria
;	edfined by the input keyowrds.
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale
;	
;-
;=============================================================================
function dsk_valid_edges, dkxp, inner=inner, outer=outer, all=all
@nv_lib.include
 dkdp = class_extract(dkxp, 'DISK')
 nv_notify, dkdp, type = 1
 dkd = nv_dereference(dkdp)

 if(keyword_set(all)) then $
          return, where((dkd.sma[0,0,*] GE 0) AND (dkd.sma[0,1,*] GE 0))

 if(keyword_set(inner)) then ii = 0 $
 else if(keyword_set(outer)) then ii = 1 $
 else ii = [0,1]

 return, where(dkd.sma[0,ii,*] GE 0)
end
;===========================================================================



