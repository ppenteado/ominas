;=============================================================================
;+
; NAME:
;	pgs_points_ps
;
;
; PURPOSE:
;	Retrieves fields of a points structure, but does not dereference
;	pointers.
;
;
; CATEGORY:
;	NV/PGS
;
;
; CALLING SEQUENCE:
;	pgs_points_ps, pp, name=name, points_ps=points_ps, vectors_ps=vectors_ps, $
;	                        flags_ps=flags_ps, ...
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
;	points_ps:	Pointer to array of image points.
;
;	vectors_ps:	Pointer to array of column vectors.
;
;	flags_ps:	Pointer to array of flags.
;
;	tags_ps:	Pointer to array of tags for point data.
;
;	data_ps:	Pointer to array of data for each point.
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
pro pgs_points_ps, pp, points_ps=points_ps, $
                    vectors_ps=vectors_ps, $
                    flags_ps=flags_ps, $
                    name=name, desc=desc, input=input, $
                    data_ps=data_ps;, tags_ps=tags_ps
nv_message, /con, name='pgs_points_ps', 'This routine is obsolete.'
 nv_notify, pp, type = 1

 points_ps = pp.points_p
 vectors_ps = pp.vectors_p
 data_ps = pp.data_p
 tags_ps = pp.tags_p
 flags_ps = pp.flags_p
 name = pp.name
 desc = pp.desc
 input = pp.input

end
;===========================================================================
