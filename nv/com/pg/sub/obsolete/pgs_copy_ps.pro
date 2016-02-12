;=============================================================================
;+
; NAME:
;	pgs_copy_ps
;
;
; PURPOSE:
;	Copies a points structure.
;
;
; CATEGORY:
;	NV/PGS
;
;
; CALLING SEQUENCE:
;	pgs_copy_ps, ps_dst, ps_src
;
;
; ARGUMENTS:
;  INPUT:
;	ps_dst:		Points structure to copy to.
;
;	ps_src:		Points structure to copy from.
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
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale		5/2014
;	
;-
;=============================================================================
pro pgs_copy_ps, ps_dst, ps_src
nv_message, /con, name='pgs_copy_ps', 'This routine is obsolete.'

 if(NOT keyword_set(ps_src)) then return

 for i=0, n_elements(ps_src)-1 do $
  begin
   pgs_points, ps_src[i], p=p, v=v, f=f, tags=tags, data=data, name=name, desc=desc, input=input, $
        assoc_idp=assoc_idp
   ps_dst[i] = pgs_set_points(ps_dst[i], p=p, v=v, f=f, tags=tags, data=data, $
                          name=name, desc=desc, input=input, assoc_idp=assoc_idp)

   tag_list_copy, ps_dst[i].udata_tlp, ps_src[i].udata_tlp
  end

end
;==============================================================================
