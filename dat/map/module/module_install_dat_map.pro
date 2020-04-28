;=============================================================================
; module_install_dat_map
;
;=============================================================================
function module_install_dat_map, arg

 print, 'Downloading maps'

 url = "https://github.com/nasa/ominas_maps/"

stop
 git, 'clone', url, arg.dir


 print, 'Download complete.'

 return, 0
end
;=============================================================================
