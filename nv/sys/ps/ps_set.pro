;=============================================================================
;+
; points:
;	ps_set
;
;
; PURPOSE:
;	Replaces fields in a points structure.  This is a convenient way of
;	setting multiple fields in one call, and only a single event is 
;	generated.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	ps_set, ps, <keywords>=<values>
;
;
; ARGUMENTS:
;  INPUT:
;	ps:		Points struct.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: 
;	<keywords>:	Points structure fields to set.
;
;	noevent:	If set, no event is generated.
;
;  OUTPUT: NONE
;
;
; RETURN: NONE
;
;
; STATUS:
;	Complete
;
;
; SEE ALSO:
;	ps_set_*
;
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale		12/2015
;	
;-
;=============================================================================
pro ps_set, ps, points=points, vectors=vectors, flags=flags, $
                 name=name, desc=desc, input=input, data=data, tags=tags, $
                 udata=udata, uname=uname, assoc_idp=assoc_idp, noevent=noevent

 if(defined(points)) then ps_set_points, ps, points, /noevent
 if(defined(vectors)) then ps_set_vectors, ps, vectors, /noevent
 if(defined(flags)) then ps_set_flags, ps, flags, /noevent
 if(defined(name)) then cor_set_name, ps, name, /noevent
 if(defined(desc)) then ps_set_desc, ps, desc, /noevent
 if(defined(input)) then ps_set_input, ps, input, /noevent
 if(defined(data)) then ps_set_data, ps, data, /noevent
 if(defined(tags)) then ps_set_tags, ps, tags, /noevent
 if(defined(assoc_idp)) then ps_set_assoc_idp, ps, assoc_idp, /noevent
 if(defined(udata)) then cor_set_udata, ps, udata, uname, /noevent

 nv_notify, ps, type = 0, noevent=noevent
 nv_notify, /flush, noevent=noevent
end
;===========================================================================
