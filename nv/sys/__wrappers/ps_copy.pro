;==============================================================================
;+
; NAME:
;	ps_copy
;
;
; PURPOSE:
;	Copies all fields from the source points structure into the
;       destination points structure.
;
;
; CATEGORY:
;	NV/SYS/PS
;
;
; CALLING SEQUENCE:
;	ps_copy, ps_dst, ps_src
;
;
; ARGUMENTS:
;  INPUT:
;	ps_dst:	        Points structure to copy to.
;
;	ps_src:	        Points structure to copy from.
;
;
;  OUTPUT: NONE
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
;	Complete
;
;
; MODIFICATION HISTORY:
;  Spitale, 11/2015; 	Adapted from pgs_copy_ps
;	
;-
;==============================================================================
pro ps_copy, ps_dst, ps_src, noevent=noevent
return, nv_copy, ps_dst, ps_src, noevent=noevent


 if(NOT keyword_set(ps_src)) then return

 for i=0, n_elements(ps_src)-1 do $
  begin
   ps_get, ps_src[i], p=p, vec=v, f=f, tags=tags, data=data, noevent=noevent, $
                          name=name, desc=desc, input=input, assoc_idp=assoc_idp
   ps_set, ps_dst[i], p=p, vec=v, f=f, tags=tags, data=data, noevent=noevent, $
                          name=name, desc=desc, input=input, assoc_idp=assoc_idp

   tag_list_copy, cor_udata(ps_dst[i]), cor_udata(ps_src[i])
  end


end
;===========================================================================



;==============================================================================
pro __ps_copy, ps_dst, ps_src, noevent=noevent

 if(NOT keyword_set(ps_src)) then return

 for i=0, n_elements(ps_src)-1 do $
  begin
   nv_notify, ps_src[i], typ=1, desc='ALL', noevent=noevent
   ps = nv_dereference(ps_src[i])

   ;------------------------------------
   ; copy
   ;------------------------------------
   new_ps = ps

   if(ptr_valid(ps.points_p)) then $
	     new_ps.points_p = nv_ptr_new(*ps.points_p)
   if(ptr_valid(ps.vectors_p)) then $
	     new_ps.vectors_p = nv_ptr_new(*ps.vectors_p)
   if(ptr_valid(ps.flags_p)) then $
	     new_ps.flags_p = nv_ptr_new(*ps.flags_p)
   if(ptr_valid(ps.points_p)) then $
	     new_ps.points_p = nv_ptr_new(*ps.points_p)
   if(ptr_valid(ps.points_p)) then $
	     new_ps.points_p = nv_ptr_new(*ps.points_p)
   if(ptr_valid(ps.points_p)) then $
	     new_ps.points_p = nv_ptr_new(*ps.points_p)

   tag_list_copy, ps_dst[i].udata_tlp, ps_src[i].udata_tlp

   nv_rereference, ps_dst[i], new_ps

   ;--------------------------------------------------------------
   ; generate write event on original destination points struct
   ;--------------------------------------------------------------
   nv_notify, ps_src[i], type=0, desc='ALL', noevent=noevent
   nv_notify, /flush, noevent=noevent
  end


end
;===========================================================================
