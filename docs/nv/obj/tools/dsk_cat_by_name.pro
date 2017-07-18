;=============================================================================
;+
; NAME:
;       dsk_cat_by_name
;
;
; PURPOSE:
;	Concatenates the given disk descriptors into one descriptor 
;	encompassing all of the named descriptors.
;
;
; CATEGORY:
;       NV/LIB/TOOLS
;
;
; CALLING SEQUENCE:
;       dkx_cat = dsk_cat_by_name(dkx, names)
;
;
; ARGUMENTS:
;  INPUT:
;	dkx:	Array (nt) of any subclass of DISK.
;
;	names:	Array of names of disks to concatenate.
;
;  OUTPUT:
;       NONE
;
;
; KEYOWRDS:
;  INPUT: NONE
;
;  OUTPUT: NONE
;
;
; RETURN: 
;	A descriptor of the same class as dkx whose semimajor axes
;	encompass the all of the named input disks.
;
;
; MODIFICATION HISTORY:
;       Written by:     Spitale
;
;-
;=============================================================================
function dsk_cat_by_name, dkxs, names

 if(NOT keyword__set(dkxs)) then return, 0

 w = nwhere(cor_name(dkxs), names)
 if(w[0] EQ -1) then return, 0

 return, dsk_cat(dkxs[w])
end
;===============================================================================
