;----------------------------------------------------------
; restore the ominas save file
;----------------------------------------------------------
!except = 0
path = getenv('OMINAS_DIR')
;name = 'ominas' + !version.release+ '.sav'
name = 'ominas.sav'
ff = file_search(path+name)
if(NOT keyword_set(ff)) then name = 'ominas.sav'

restore, ff


