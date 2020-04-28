;=============================================================================
; module_install_trs_cas_iss
;
;=============================================================================
function module_install_trs_cas_iss, arg


stop
 ;-------------------------------------------------
 ; download VICAR-format PSF files
 ;-------------------------------------------------
 print, 'Downloading ISS PSF files'

 psfs_dir = arg.dir + '/psfs'
 file_mkdir, psfs_dir

 url = 'https://pds-rings.seti.org/holdings/volumes/COISS_0xxx/COISS_0011/calib/xpsf/'
 wcp, url, psfs_dir, /verbose, update=arg.update

 ;- - - - - - - - - - - - - - - - - - - - - - - 
 ; make link to default PSF file
 ;- - - - - - - - - - - - - - - - - - - - - - - 
; file_link_decrapified, $
;              psfs_dir + '/xpsf_wac_ir2_ir1.img', $
;              psfs_dir + '/xpsf_default_generic.img'




 return, 0
end
;=============================================================================
