;=============================================================================
;+
; NAME:
;       cspice_pckobj
;
;
; PURPOSE:
;       Like cspice_spkobj and cspice_ckobj, but for pcks.  Intended to be
;	replaced whenever NAIF adds this functionality to the toolkit.
;
;
; CATEGORY:
;       UTIL/SPICE
;
;
; CALLING SEQUENCE:
;       cspice_pckobj, pck, ids
;
;
; ARGUMENTS:
;  INPUT:
;	pck:		Name of a NAIF pck file.
;
;  OUTPUT: 
;	obj:		An Icy set data structure which contains 
;            		the union of its contents upon input with the set 
;            		of CK ID codes of each object for which ephemeris 
;            		data are present in the indicated CK file. The 
;            		elements of Icy sets are unique; hence each 
;            		ID code in `ids' appears only once, even if the CK 
;            		file contains multiple segments for that ID code. 
;
;      		      	The user must create 'ids' using cspice_celld. (Note:
;	            	a set is a type of cell).
;
;
; KEYWORDS:
;  INPUT: NONE
;
;  OUTPUT: NONE
;
;
; RETURN: NONE
;
;
; STATUS:
;       Incomplete: only the fields in obj needed by gen_spice_build_db are
;	filed in. 
;
;
; MODIFICATION HISTORY:
;       Written by:     Spitale      2/2020
;-
;=============================================================================
pro cspice_pckobj, pck, obj

 ;----------------------------------------------------
 ; get body ids
 ;----------------------------------------------------
 ids = naif_pckobj(pck)
 nids = n_elements(ids)

 ;----------------------------------------------------
 ; fill in obj structure
 ;----------------------------------------------------
 obj.base[obj.data:obj.data+nids-1] = long(ids)
 obj.card = nids

end
;=============================================================================


