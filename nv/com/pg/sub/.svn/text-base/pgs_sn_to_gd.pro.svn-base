;=============================================================================
; pgs_sn_to_gd
;
; xd not required to be homogeneous
;
;=============================================================================
function pgs_sn_to_gd, sns, xd


 nxd = n_elements(xd)

 sn_used = make_array(nxd, val=-1l)

 for i=0, nxd-1 do $
  begin
   sn = nv_extract_sn(xd[i])
   ww = where(sn_used EQ sn)
   if(ww[0] EQ -1) then $
    begin
     sn_used[i] = sn
     w = where(sn EQ sns)
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
        'STAR' : $
	   begin
            if(strupcase(get_core_name(xd[i])) EQ 'SUN') then $
	                               sund = append_array(sund, xd[i]) $
	    else sd = append_array(sd, xd[i])
	   end
        'RING' : rd = append_array(rd, xd[i])
        'CAMERA' : cd = append_array(cd, xd[i])
       endcase
      end
    end
  end 

 gd = pgs_make_gd(crd=crd, bd=bd, md=md, dkd=dkd, $
                  gbd=gbd, pd=pd, sd=sd, rd=rd, cd=cd, sund=sund)

 return, gd
end
;=============================================================================
