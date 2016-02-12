;===========================================================================
; eph_spice_planets
;
;===========================================================================
function eph_spice_planets, dd, ref, target=target, time=sc_time, $
                            planets=planets, $
                            n_obj=n_obj, dim=dim, status=status, $ 
                            targ_list=targ_list, constants=constants, obs=obs

 if(NOT keyword_set(sc)) then sc = 0l

 ;----------------------------------------------------------------
 ; request all relevant planets if none specified
 ; if no targ_list file, then spice interface will get all bodies
 ;----------------------------------------------------------------
 if(NOT keyword_set(planets)) then planets = spice_read_targets(targ_list)

 ;----------------------------------------------------------------------------
 ; Move primary target to front of list 
 ;   If no planet names have been specified, or if TARGET_NAME was not in the
 ;   list, then the spice interface will retrieve all possible bodies from
 ;   the kernel pool.  In that case, TARGET_NAME is lost, so here, we 
 ;   record that string in the data descriptor.  The value of TARGET_DESC
 ;   is also provided as a backup.
 ;----------------------------------------------------------------------------
 if(NOT keyword_set(target)) then target = 'UNKNOWN' $
 else $
  begin
   nv_set_udata, dd, target, 'TARGET'

   w = where(planets EQ target)
   if(w[0] NE -1) then $
    begin
     if(n_elements(planets) EQ 1) then planets = target $
     else planets = [target, rm_list_item(planets, w[0], only='')]
    end
  end


 ;-----------------------------------------------------------
 ; get the descriptors 
 ;-----------------------------------------------------------
 return, eph_to_ominas( $
            spice_planets(dd, ref, $
		time = sc_time, $
		target = target, $
		plt_name = planets, $
		n_obj=n_obj, dim=dim, status=status, constants=constants, obs=obs) )


end
;===========================================================================



