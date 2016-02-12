;=============================================================================
;+
; NAME:
;	pgs_points
;
;
; PURPOSE:
;	Retrieves fields of a points structure.
;
;
; CATEGORY:
;	NV/PGS
;
;
; CALLING SEQUENCE:
;	pgs_points, pp, name=name, points=points, vectors=vectors, $
;	                        flags=flags, ...
;
;
; ARGUMENTS:
;  INPUT:
;	pp:		Point structure.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: NONE
;
;  OUTPUT:
;	name:		Point structure name.
;
;	desc:		Point structure description.
;
;	input:		Description of input data.
;
;	assoc_idp:	ID pointer of associated descriptor.
;
;	points:		Array of image points; [2,np,nt].
;
;	vectors:	Array of column vectors; [np,3,nt].
;
;	flags:		Array of flags; [np,nt].
;
;	tags:		Tags for point data; [nd].  These strings may be used
;			by pgs_data to identify point-by-point data
;			given by the 'data' keyword.
;
;	data:		Data for each point; [nd,np,nt].
;
;	uname:		Name of a user data array.
;
;	udata:		User data to associate with uname.
;
;	
;
;
; RETURN: NONE
;
;
; SEE ALSO:
;	pgs_set_points
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 1/1997
;	
;-
;=============================================================================
pro pgs_points, pp, points=points, $
                    vectors=vectors, $
                    flags=flags, $
                    data=data, tags=tags, name=name, desc=desc, $
                    uname=uname, udata=udata, assoc_idp=assoc_idp, input=input
nv_message, /con, name='pgs_points', 'This routine is obsolete.'
 nv_notify, pp, type = 1

 points = 0
 vectors = 0
 flags = 0
 data = 0
 tags = 0
 udata = 0

 if(ptr_valid(pp.points_p)) then points = *pp.points_p
 if(ptr_valid(pp.vectors_p)) then vectors = *pp.vectors_p
 if(ptr_valid(pp.tags_p)) then tags = *pp.tags_p
 if(ptr_valid(pp.flags_p)) then flags = *pp.flags_p 
 name = pp.name
 desc = pp.desc
 input = pp.input
 assoc_idp = pp.assoc_idp
 if(ptr_valid(pp.data_p)) then data = *pp.data_p

 if(keyword_set(uname)) then udata = tag_list_get(pp.udata_tlp, uname)
end
;===========================================================================
