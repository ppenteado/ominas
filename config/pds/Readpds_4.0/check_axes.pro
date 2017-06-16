function CHECK_AXES, label, objindex
;-----------------------------------------------------------------------------
; NAME:
;    CHECK_AXES
;
; PURPOSE:
;    Determine the number of axes for an array object PDS file.
; 
; CALLING SEQUENCE:
;    Result = CHECK_AXES(label, objindex)
;
; INPUTS:
;    label: string array containing the "header" from the PDS file.
;    objindex: an integer specifying the starting index in the label for the
;              current array object to be processed.
;
; OUTPUTS:
;    result: an integer specifying the number of axes for the array object
;            at the specified index in the label. 
;
; EXAMPLE:
;    To obtain the number of axes for a KECK 6D array object file, where
;    the array object starts at index 53:
;    IDL> label = headpds ('focus0037.lbl')
;    IDL> axes = check_axes(label,53)
;    IDL> print, axes
;    6
;
; PROCEDURES USED:
;    Functions: PDSPAR, GET_INDEX, CLEAN
;
; MODIFICATION HISTORY:
;    Written by Puneet Khetarpal [March 16, 2004]
;----------------------------------------------------------------------------
   ; error protection:
   ;ON_ERROR, 2

   if (n_params() LT 2) then begin
      print, "Syntax: result = CHECK_AXES(label, objindex)"
      return, -1
   endif

   ; get AXES keyword values:
   glob_axes = PDSPAR(label, 'AXES',INDEX=axesindex)
   if (!ERR EQ -1) then begin
      print, "Error: missing required AXES keyword."
      return, -1
   endif

   ; get end_object index for current objindex:
   endobjindex = GET_INDEX(label, objindex)

   ; get position of axes keyword for the current object in label array:
   pos = where (axesindex GT objindex AND axesindex LT endobjindex)
   ; extract the value of the axes keyword at the position and clean:
   axes = glob_axes[pos[0]]
   axes = CLEAN(axes, /SPACE)

   return, axes
end
