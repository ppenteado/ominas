;=======================================================================================
; spice_ids
;
;=======================================================================================
function spice_ids, name


 cspice_bodn2c, name, id, found
 if(NOT found) then return, -1
 return, id






stop

 id = 0l

 path = spice_bin_path()
 status = call_external(path + 'spice_io.so', 'get_naif_id', $
                        value=[1,0], name, id)

 if(status NE 0) then $
  begin
   nv_message, name = 'spice_ids', $
                       'No NAIF ID definded for "' + name + '"
   return, -1
  end


 return, id
end
;=======================================================================================
