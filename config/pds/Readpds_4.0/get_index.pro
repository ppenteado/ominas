;-----------------------------------------------------------------------------
; NAME: GET_INDEX
;
; PURPOSE: To obtain the END_OBJECT index position for a specified PDS object
;          in a PDS label.
;
; CALLING SEQUENCE: Result = GET_INDEX (label, start index)
;
; INPUTS:
;    label: String array containing the object information according to
;           PDS standards. The label must meet all PDS standards.
;    start index: Integer specifying the index of the OBJECT for which
;                 the END_OBJECT index is desired. Start index must be
;                 a valid object index in the label string array.
;
; OUTPUTS:
;    Result: A scalar integer specifying the END_OBJECT index in the label
;            string array for which the start index was specified.
;
; OPTIONAL INPUT: none
;
; EXAMPLES:
;    To obtain the index of the table array starting at label index 7:
;    IDL> label = HEADPDS ("TABLE.LBL", /SILENT)
;    IDL> index = GET_INDEX (label, 7)
;    IDL> help, index
;    INDEX          LONG      =           60
;
; PROCEDURES USED:
;    CLEAN, OBJPDS, PDSPAR
;
; MODIFICATION HISTORY:
;    Written by: Puneet Khetarpal [February 24, 2004]
;    For a complete list of modifications, see changelog.txt file.
;
;-----------------------------------------------------------------------------

function GET_INDEX, label, startindex
    ; error protection:
    ;ON_ERROR, 2
   
    ; check number of arguments:
    if (n_params() LT 2) then begin
        print, "Syntax: result = GET_INDEX (label, startindex)"
        return, -1
    endif

    ; check for a valid starting index position:
    position = strpos(label[startindex], "OBJECT")
    position2 = strpos(label[startindex], "END_OBJECT")
    if ((position[0] EQ -1) or (position2[0] GT 0)) then begin
        print, "Error: Invalid start index position specified."
        return, -1
    endif

    ; get all objects matching object name at startindex:
    objpos = strpos(label[startindex], '=')
    objname = CLEAN(strmid(label[startindex], objpos + 1), /SPACE) ; external
    objects = OBJPDS(label, objname)                     ; external routine
   
    ; get all objects for END_OBJECT keyword and match with current object:
    end_objects = PDSPAR(label, "END_OBJECT", COUNT=eobjcount, INDEX=eobjindex)
    match_pos = where(objname EQ end_objects)
   
    ; take all the matched endobjects and store them:
    if (match_pos[0] NE -1) then begin
        end_objects = end_objects[match_pos]
        eobjindex = eobjindex[match_pos]
        eobjcount = n_elements(match_pos)
    endif else begin
        print, "Error: no END_OBJECT keywords found for specified OBJECT index"
        return, -1
    endelse 

    ; check the count of the specified start object index:
    obj_pos = where(objects.index EQ startindex)
    nth_object = obj_pos[0] + 1

    ; end index = end object @ index = (end object count - nth object count)
    end_index = eobjindex[eobjcount - nth_object]

    return, end_index
end
