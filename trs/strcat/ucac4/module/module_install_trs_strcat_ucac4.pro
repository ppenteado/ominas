;=============================================================================
; module_install_trs_strcat_ucac4
;
;=============================================================================
function module_install_trs_strcat_ucac4, arg

 ;---------------------------------------------------------------------
 ; download files
 ;---------------------------------------------------------------------
 print, 'Downloading UCAC4 data'
 urlb = 'ftp://cdsarc.u-strasbg.fr/pub/cats/more/UCAC4/u4b/'
 urli = 'ftp://cdsarc.u-strasbg.fr/pub/cats/more/UCAC4/u4i/'

 wcp, urli, arg.dir, /verbose, update=arg.update
 wcp, urlb, arg.dir, /verbose, update=arg.update

 print, 'UCAC4 Installation complete'
 return, 0
end
;=============================================================================
