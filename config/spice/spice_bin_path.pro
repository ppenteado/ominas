;===========================================================================
; spice_bin_path
;
;
;===========================================================================
function spice_bin_path

 nv_spice = getenv('NV_SPICE')
 if(nv_spice EQ '') then $
         nv_message, 'spice_bin_path', 'NV_SPICE variable not set.'

 platform = getenv('OMINAS_PLATFORM')
 if(platform EQ '') then $
     nv_message, 'spice_bin_path', 'OMINAS_PLATFORM variable not set.'

 add = ''


 return, nv_spice+'/bin/'+platform+add+'/'

end
;===========================================================================
