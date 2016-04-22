;=============================================================================
;+
; points:
;	ps_set_data
;
;
; PURPOSE:
;	Replaces the point-by-point data in a points struct.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	ps_set_data, ps, data
;
;
; ARGUMENTS:
;  INPUT:
;	ps:		Points struct.
;
;	data:		New point-by-point data array.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: 
;	noevent:	If set, no event is generated.
;
;	tags:	If given, data arrays are replaced only for these tags, and in 
;		this order.
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
;	ps_data
;
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale		11/2015
;	
;-
;=============================================================================
pro ps_set_data, psp, new_data, tags=select_tags, noevent=noevent
@nv.include
 ps = nv_dereference(psp)

 dim = size(new_data, /dim)
 ndim = n_elements(dim)
 nv = (nt = 1)
 ndat = dim[0]
 if(ndim GT 1) then nv = dim[1]
 if(ndim GT 2) then nt = dim[2]

 if((nv NE ps.nv) OR (nt NE ps.nt)) then ps_resize, ps, nv=nv, nt=nt


 if(NOT keyword_set(ps.data_p)) then $
  begin
   ps.data_p = nv_ptr_new(new_data)
   if(keyword_set(select_tags)) then ps.tags_p = nv_ptr_new(select_tags)
  end $
 else $
  begin
   if(NOT keyword_set(select_tags)) then *ps.data_p = new_data $
   else $
    begin
;stop
     data = *ps.data_p
     tags = ''
     if(ptr_valid(ps.tags_p)) then tags = *ps.tags_p

     w = nwhere(tags, select_tags)
     if(w[0] EQ -1) then return

     data[w,*,*] = new_data

     *ps.data_p = data
    end
  end


 nv_rereference, psp, ps
 nv_notify, psp, type = 0, noevent=noevent
 nv_notify, /flush, noevent=noevent
end
;===========================================================================
