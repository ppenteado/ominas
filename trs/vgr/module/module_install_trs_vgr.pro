;=============================================================================
; module_install_trs_vgr
;
;=============================================================================
function module_install_trs_vgr, arg

 print, 'Downloading kernels'
 kernels_dir = arg.dir + '/kernels'
 spice_download_kernels, 'VOYAGER', kernels_dir, /verbose, update=arg.update

 return, 0
end
;=============================================================================
