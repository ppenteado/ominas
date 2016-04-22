;=============================================================================
; pgs_idp_to_gd
;
; xd not required to be homogeneous
;
;=============================================================================
function pgs_idp_to_gd, idps, xd

 nxd = n_elements(xd)

 idp_used = make_array(nxd, val=nv_ptr_new())

 for i=0, nxd-1 do $
  begin
   idp = cor_idp(xd[i])
   ww = where(idp_used EQ idp)
   if(ww[0] EQ -1) then $
    begin
     idp_used[i] = idp
     w = where(idp EQ idps)
     if(w[0] NE -1) then $
      begin
       class = class_get(xd[i])
       case class of
        'CORE' : crd = append_array(crd, xd[i])
        'BODY' : bd = append_array(bd, xd[i])
        'MAP' : md = append_array(md, xd[i])
        'DISK' : dkd = append_array(dkd, xd[i])
        'GLOBE' : gbd = append_array(gbd, xd[i])
        'PLANET' : pd = append_array(pd, xd[i])
        'STAR' : sd = append_array(sd, xd[i])
        'STATION' : std = append_array(std, xd[i])
        'RING' : rd = append_array(rd, xd[i])
        'CAMERA' : cd = append_array(cd, xd[i])
       endcase
      end
    end
  end 

;stop
; star_names = cor_name(sd)
; w = where(star_names EQ 'SUN')
; if(w[0] NE -1) then $
;  begin
;   sund = sd[w[0]]
;   sd = rm_list_item(sd, w[0], only=0)
;  end

 if(keyword_set(sd)) then $
  begin
   sund = sd[0]
   sd = rm_list_item(sd, 0, only=0)
  end
 

 gd = pgs_make_gd(crd=crd, bd=bd, md=md, dkd=dkd, $
                  gbd=gbd, pd=pd, sd=sd, std=std, rd=rd, cd=cd, sund=sund)

 return, gd
end
;=============================================================================
