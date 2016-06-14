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
 if(type EQ 11) then object_ptd = pp $
 else object_ptd = pnt_create_descriptors(points=pp)

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
    NOT keyword_set(od) ) then user_ptd = object_ptd $
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
   limb_ptd = 0
   ring_ptd = 0
   term_ptd = 0
   star_ptd = 0
   center_ptd = 0
   user_ptd = 0

   n = n_elements(object_ptd)
   for i=0, n-1 do $
    begin
     desc = pnt_desc(object_ptd[i])

     if(NOT keyword_set(desc)) then $
                    user_ptd = append_array(user_ptd, object_ptd[i]) $
     else $
      begin
;       desc = strupcase(desc)
;       if((strpos(desc, 'LIMB'))[0] NE -1) then $
;                              limb_ptd = append_array(limb_ptd, object_ptd[i]) $
;       else if((strpos(desc, 'DISK_INNER'))[0] NE -1) then $
;                              ring_ptd = append_array(ring_ptd, object_ptd[i]) $
;       else if((strpos(desc, 'DISK_OUTER'))[0] NE -1) then $
;                              ring_ptd = append_array(ring_ptd, object_ptd[i]) $
;       else if((strpos(desc, 'TERMINATOR'))[0] NE -1) then $
;                              term_ptd = append_array(term_ptd, object_ptd[i]) $
;       else if((strpos(desc, 'STAR_CENTER'))[0] NE -1) then $
;                              star_ptd = append_array(star_ptd, object_ptd[i]) $
;       else if((strpos(desc, 'PLANET_CENTER'))[0] NE -1) then $
;                              center_ptd = append_array(center_ptd, object_ptd[i]) $
;       else user_ptd = append_array(user_ptd, object_ptd[i])

       case strupcase(desc) of
        'LIMB' : limb_ptd = append_array(limb_ptd, object_ptd[i])
        'DISK_INNER' : ring_ptd = append_array(ring_ptd, object_ptd[i])
        'DISK_OUTER' : ring_ptd = append_array(ring_ptd, object_ptd[i])
        'TERMINATOR' : term_ptd = append_array(term_ptd, object_ptd[i])
        'STAR_CENTER' : star_ptd = append_array(star_ptd, object_ptd[i])
        'PLANET_CENTER' : center_ptd = append_array(center_ptd, object_ptd[i])
        else : user_ptd = append_array(user_ptd, object_ptd[i])
       endcase

      end
    end

  end

 grim_data = grim_get_data(grnum=grnum)

 ;------------------------------
 ; set object points
 ;------------------------------
 if(keyword_set(limb_ptd)) then $
     grim_add_points, grim_data, limb_ptd, pd, cd=cd, name='limb', plane=plane
 if(keyword_set(ring_ptd)) then $
     grim_add_points, grim_data, ring_ptd, [rd,rd], cd=cd, name='ring', plane=plane
 if(keyword_set(term_ptd)) then $
     grim_add_points, grim_data, term_ptd, pd, cd=cd, name='terminator', plane=plane
 if(keyword_set(star_ptd)) then $
     grim_add_points, grim_data, star_ptd, sd, cd=cd, name='star', plane=plane
 if(keyword_set(center_ptd)) then $
     grim_add_points, grim_data, center_ptd, pd, cd=cd, name='planet_center', plane=plane


 ;------------------------------
 ; set user points
 ;------------------------------
 if(keyword_set(user_ptd)) then $
  begin
   if(keyword_set(tag)) then $
      grim_add_user_points, plane=plane, user_ptd, tag, $
                       psym=psym, symsize=symsize, color=color, /no_refresh $
   else $
    begin
     nuser = n_elements(user_ptd)
     all_tags = strarr(nuser)

     ;-------------------------
     ; determine unique tags
     ;-------------------------
     tags = ''
     for i=0, nuser-1 do $
      begin
       tag = pnt_desc(user_ptd[0])
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
       grim_add_user_points, plane=plane, user_ptd[w], $
                    tags[i], psym=psym, symsize=symsize, color=color, /no_refresh
      end

    end
  end


 if(refresh) then grim_refresh, grim_data, /no_image

end
;=============================================================================
