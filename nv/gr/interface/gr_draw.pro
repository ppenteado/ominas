;=============================================================================
;	NOTE:	remove the second '+' on the next line for this header
;		to be recognized by extract_doc.
;++
; NAME:
;	gr_
;
;
; PURPOSE:
;	xx
;
;
; CATEGORY:
;	NV/GR
;
;
; CALLING SEQUENCE:
;	result = xx(xx, xx)
;	xx, xx, xx
;
;
; ARGUMENTS:
;  INPUT:
;	xx:	xx
;
;	xx:	xx
;
;  OUTPUT:
;	xx:	xx
;
;	xx:	xx
;
;
; KEYWORDS:
;  INPUT:
;	xx:	xx
;
;	xx:	xx
;
;  OUTPUT:
;	xx:	xx
;
;	xx:	xx
;
;
; ENVIRONMENT VARIABLES:
;	xx:	xx
;
;	xx:	xx
;
;
; RETURN:
;	xx
;
;
; COMMON BLOCKS:
;	xx:	xx
;
;	xx:	xx
;
;
; SIDE EFFECTS:
;	xx
;
;
; RESTRICTIONS:
;	xx
;
;
; PROCEDURE:
;	xx
;
;
; EXAMPLE:
;	xx
;
;
; STATUS:
;	xx
;
;
; SEE ALSO:
;	xx, xx, xx
;
;
; MODIFICATION HISTORY:
; 	Written by:	xx, xx/xx/xxxx
;	
;-
;=============================================================================
pro gr_draw, pp, gd=gd, cd=cd, pd=pd, rd=rd, sd=sd, sund=sund, od=od, $
       psym=psym, symsize=symsize, color=_color, tag=tag, pn=pn, grnum=grnum

 type = size(pp, /type)
 if(type EQ 10) then object_ps = pp $
 else object_ps = ps_init(p=pp)

 if(keyword_set(grnum)) then $
                     grim_data = grim_get_data(grim_grnum_to_top(grnum)) $
 else grim_data = grim_get_data(/primary)

 refresh = 0

 if(defined(pn)) then $
  begin
   if(pn EQ grim_data.pn) then refresh = 1
   planes = grim_get_plane(grim_data, /all)
   plane = planes[pn]
  end

 if(NOT defined(pn)) then refresh = 1

 if(keyword__set(_color)) then $
    if(size(_color, /type) NE 7) then __color = ctlookup(_color)
 if(keyword__set(__color)) then color = __color


 ;---------------------------------
 ; dereference generic descriptor
 ;---------------------------------
 pgs_gd, gd, cd=cd, pd=pd, rd=rd, sd=sd, sund=sund, od=od, gbx=gbx, dkx=dkx
 if(NOT keyword_set(pd)) then if(keyword__set(gbx)) then pd = gbx
 if(NOT keyword_set(rd)) then if(keyword__set(dkx)) then rd = dkx


 ;-------------------------------------------------------------
 ; if no descriptors given, treat all points as user points
 ;-------------------------------------------------------------
 if(NOT keyword_set(gd) AND $
    NOT keyword_set(cd) AND  $
    NOT keyword_set(pd) AND $
    NOT keyword_set(rd) AND $
    NOT keyword_set(sd) AND $
    NOT keyword_set(sund) AND $
    NOT keyword_set(od) ) then user_ps = object_ps $
 ;------------------------------
 ; otherwise, determine types
 ;------------------------------
 else $
  begin
   ;---------------------
   ; add descriptors
   ;---------------------
   grim, cd=cd, pd=pd, rd=rd, sd=sd, sund=sund, od=od, /no_erase, pn=pn

   ;---------------------
   ; add overlay points
   ;---------------------
   limb_ps = 0
   ring_ps = 0
   term_ps = 0
   star_ps = 0
   center_ps = 0
   user_ps = 0

   n = n_elements(object_ps)
   for i=0, n-1 do $
    begin
     desc = ps_desc(object_ps[i])

     if(NOT keyword_set(desc)) then $
                    user_ps = append_array(user_ps, object_ps[i]) $
     else $
      begin
;       desc = strupcase(desc)
;       if((strpos(desc, 'LIMB'))[0] NE -1) then $
;                              limb_ps = append_array(limb_ps, object_ps[i]) $
;       else if((strpos(desc, 'DISK_INNER'))[0] NE -1) then $
;                              ring_ps = append_array(ring_ps, object_ps[i]) $
;       else if((strpos(desc, 'DISK_OUTER'))[0] NE -1) then $
;                              ring_ps = append_array(ring_ps, object_ps[i]) $
;       else if((strpos(desc, 'TERMINATOR'))[0] NE -1) then $
;                              term_ps = append_array(term_ps, object_ps[i]) $
;       else if((strpos(desc, 'STAR_CENTER'))[0] NE -1) then $
;                              star_ps = append_array(star_ps, object_ps[i]) $
;       else if((strpos(desc, 'PLANET_CENTER'))[0] NE -1) then $
;                              center_ps = append_array(center_ps, object_ps[i]) $
;       else user_ps = append_array(user_ps, object_ps[i])

       case strupcase(desc) of
        'LIMB' : limb_ps = append_array(limb_ps, object_ps[i])
        'DISK_INNER' : ring_ps = append_array(ring_ps, object_ps[i])
        'DISK_OUTER' : ring_ps = append_array(ring_ps, object_ps[i])
        'TERMINATOR' : term_ps = append_array(term_ps, object_ps[i])
        'STAR_CENTER' : star_ps = append_array(star_ps, object_ps[i])
        'PLANET_CENTER' : center_ps = append_array(center_ps, object_ps[i])
        else : user_ps = append_array(user_ps, object_ps[i])
       endcase

      end
    end

  end

 ;------------------------------
 ; get descriptor idp's
 ;------------------------------
 grim_data = grim_get_data(grnum=grnum)

 idp_cam = nv_ptr_new() & idp_plt = nv_ptr_new() & idp_rng = nv_ptr_new()
 idp_str = nv_ptr_new() & idp_sun = nv_ptr_new()
 if(keyword_set(cd)) then idp_cam = nv_extract_idp(cd)
 if(keyword_set(pd)) then idp_plt = nv_extract_idp(pd)
 if(keyword_set(rd)) then idp_rng = nv_extract_idp(rd)
 if(keyword_set(sd)) then idp_str = nv_extract_idp(sd)
 if(keyword_set(sund)) then idp_sun = nv_extract_idp(sund)

 ;------------------------------
 ; set object points
 ;------------------------------
 if(keyword_set(limb_ps)) then $
     grim_add_points, grim_data, limb_ps, name='limb', /replace, plane=plane, $
         idp_cam=idp_cam
 if(keyword_set(ring_ps)) then $
     grim_add_points, grim_data, ring_ps, name='ring', /replace, plane=plane, $
                             idp_cam=idp_cam
 if(keyword_set(term_ps)) then $
     grim_add_points, grim_data, term_ps, name='terminator', /replace, plane=plane, $
            idp_cam=idp_cam
 if(keyword_set(star_ps)) then $
     grim_add_points, grim_data, star_ps, name='star', /replace, plane=plane, $
            idp_cam=idp_cam
 if(keyword_set(center_ps)) then $
     grim_add_points, grim_data, center_ps, name='planet_center', /replace, plane=plane, $
                                              idp_cam=idp_cam


 ;------------------------------
 ; set user points
 ;------------------------------
 if(keyword_set(user_ps)) then $
  begin
   if(keyword_set(tag)) then $
      grim_add_user_points, plane=plane, user_ps, tag, $
                       psym=psym, symsize=symsize, color=color, /no_refresh $
   else $
    begin
     nuser = n_elements(user_ps)
     all_tags = strarr(nuser)

     ;-------------------------
     ; determine unique tags
     ;-------------------------
     tags = ''
     for i=0, nuser-1 do $
      begin
       tag = ps_desc(user_ps[0])
       all_tags[i] = tag
       w = where(tags EQ tag)
       if(w[0] EQ -1) then tags = [tags, tag]
      end
     if(keyword_set(tags)) then tags = tags[1:*]

     ;-------------------------
     ; add points by tag
     ;-------------------------
     ntags = n_elements(tags)
     for i=0, ntags-1 do $
      begin
       w = where(all_tags EQ tags[i])
       grim_add_user_points, plane=plane, user_ps[w], $
                    tags[i], psym=psym, symsize=symsize, color=color, /no_refresh
      end

    end
  end


 if(refresh) then grim_refresh, grim_data, /no_image

end
;=============================================================================
