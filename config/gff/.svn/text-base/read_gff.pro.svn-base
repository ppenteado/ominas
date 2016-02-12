;=============================================================================
; read_gff
;
;=============================================================================
function read_gff, f, offset, $
  noclose=noclose


 ;------------------------------------------
 ; f can be a filename or a file unit
 ;------------------------------------------
 if(size(f, /type) EQ 7) then openr, f, unit, /get_lun $
 else unit = f



 if(NOT keyword_set(noclose)) then close, unit

 return, data
end
;=============================================================================
