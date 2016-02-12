;------------------------------------------------------------------------------
; NAME: READPDS
;
; PURPOSE: To read a PDS file into IDL data and label variables
;
; CALLING SEQUENCE: Result = READPDS (Filename [,/SILENT])
;
; INPUTS:
;    Filename: Scalar string containing the name of the PDS file to read
; OUTPUTS:
;    Result: PDS data structure constructed from designated record
;
; OPTIONAL INPUTS:
;    SILENT: suppresses any message from the procedure
;
; EXAMPLES:
;    To read a PDS file TEST.LBL into an IDL image array, img:
;       IDL> img = READPDS ("TEST.LBL",/SILENT)
;       IDL> help, /STRUCTURE, img
;            OBJECTS      INT       1
;            IMAGE        LONG     [200,200]
;    To read a PDS file with multiple objects:
;       IDL> data = READPDS ("MULTIPLE.LBL",/SILENT)
;       IDL> help, /STRUCTURE, data
;            OBJECTS      INT       2
;            TABLE        STRUCT    -> ARRAY[1]
;            IMAGE        STRUCT    -> ARRAY[1]
;
; PROCEDURES USED:
;    Functions: HEADPDS, OBJPDS, IMAGEPDS, TASCPDS, TBINPDS, ARASCPDS,
;        ARBINPDS, COLASPDS, COLBIPDS, QUBEPDS.
;
; MODIFICATION HISTORY:
;    Written by: Puneet Khetarpal [24 Feb, 2003]
;    For a complete list of modifications, see changelog.txt file.
;
;    nodata, dim arguments added: Spitale 3/10/2009
;
;------------------------------------------------------------------------------

;- level 1 --------------------------------------------------------------------

;------------------------------------------------------------------------------
; precondition: fname is a viable PDS file name, label is a viable PDS label,
;     and st contains either the value of 0 or 1.
; postcondition: the image data is read from fname, extracted and stored into
;     data array and returned to the main block.

;function DOIMAGE, fname, label, st
function DOIMAGE, fname, label, st, xsize, ysize, nodata=nodata		; Spitale 3/10/2009
    if (st EQ 0) then begin
;        data = IMAGEPDS (fname, label)           ; external routine
        data = IMAGEPDS (fname, label, xsize, ysize, nodata=nodata)           ; external routine
									; Spitale 3/10/2009
    endif else begin
;        data = IMAGEPDS (fname, label, /SILENT)  ; external routine
        data = IMAGEPDS (fname, label, /SILENT, xsize, ysize, nodata=nodata)  ; external routine
									; Spitale 3/10/2009
    endelse

    return, data
end

;------------------------------------------------------------------------------
; precondition: fname is a viable PDS file name, label is a viable PDS label,
;     st contains either the value of 0 or 1, and objindex is a valid index
;     for a table, series, spectrum, or palette object.
; postcondition: the tabular data is read from the file specified by fname 
;     and returned to the main block after checking for interchange format
;     keyword.

function DOTABLE, fname, label, st, objindex
    ; obtain interchange format keyword from label:
    inform = PDSPAR (label, "INTERCHANGE_FORMAT", INDEX=index)
    if (!ERR EQ -1) then begin
        print, "ERROR: " + fname + " missing required INTERCHANGE_FORMAT " + $
               "keyword."
        return, -1
    endif

    ; determine the index of the interchange format keyword that belongs
    ; to the current tabular object:
    w = where (index GT objindex)

    ; select which subroutine to pass on the tasks:
    if (strpos (inform(w[0]),"ASCII") GT -1) then begin
        if (st EQ 0) then begin
            data = TASCPDS (fname, label, objindex)          ; external routine
        endif else begin
            data = TASCPDS (fname, label, objindex, /SILENT) ; external routine
        endelse
    endif else if (strpos (inform(w[0]),"BINARY") GT -1) then begin
        if (st EQ 0) then begin
            data = TBINPDS (fname, label, objindex)          ; external routine
        endif else begin
            data = TBINPDS (fname, label, objindex, /SILENT) ; external routine
        endelse
    endif else begin
        print, "ERROR: Invalid PDS table interchange format" + inform[0]
        return, -1
    endelse

    return, data
end

;-----------------------------------------------------------------------------
; precondition: fname is a viable PDS file name, label is a viable PDS label,
;     st is either set to 0 or 1, and objindex is a valid index for an 
;     array object:
; postcondition: the array data is read from the file, and returned to the
;     main block.

function DOARRAY, fname, label, st, objindex
    ; obtain interchange format keyword from label:
    inform = PDSPAR (label, "INTERCHANGE_FORMAT", INDEX=index)
    if (!ERR EQ -1) then begin
        print, "ERROR: " + fname + " missing required INTERCHANGE_FORMAT " + $
               "keyword."
        return, -1
    endif

    ; determine the index of the interchange format keyword that belongs to
    ; the current object:
    w = where (index GT objindex)

    ; select which subroutine to pass the task to:
    if (strpos (inform(w[0]),"ASCII") GT -1) then begin
        if (st EQ 0) then begin
            data = ARASCPDS (fname, label)           ; external routine
        endif else begin
            data = ARASCPDS (fname, label, /SILENT)  ; external routine
        endelse
    endif else if (strpos (inform(w[0]),"BINARY") GT -1) then begin
        ; check for number of axes gt 2 for KECK data:
        axes = CHECK_AXES(label, objindex)           ; external routine
        if (axes GT 2) then begin
            if (st EQ 0) then begin
                data = ARBINPDS2 (fname, label, objindex)  ; external routine
            endif else begin
                data = ARBINPDS2 (fname, label, objindex, /SILENT) 
            endelse
        endif else begin
            if (st EQ 0) then begin
                data = ARBINPDS (fname, label)           ; external routine
            endif else begin
                data = ARBINPDS (fname, label, /SILENT)  ; external routine
            endelse
        endelse
    endif else begin
        print, "ERROR: Invalid PDS table interchange format" + inform[0]
        return, -1
    endelse

    return, data
end

;-----------------------------------------------------------------------------
; precondition: fname is a viable PDS file name, label is a viable PDS label,
;     st is either set to 0 or 1, and objindex is a valid index for an 
;     collection object:
; postcondition: the collection data is read from the file, and returned to the
;     main block.

function DOCOLLECTION, fname, label, st, objindex
    ; obtain interchange format keyword from label:
    inform = PDSPAR (label,"INTERCHANGE_FORMAT", INDEX=index)
    if (!ERR EQ -1) then begin
        print, "ERROR: " + fname + " missing required INTERCHANGE_FORMAT " + $
               "keyword."
        return, -1
    endif

    ; determine the index of the interchange format keyword that belongs to
    ; the current object:
    w = where (index GT objindex)

    ; select which subroutine to pass the task to:
    if (strpos (inform(w[0]),"ASCII") GT -1) then begin
        if (st EQ 0) then begin
            data = COLASPDS (fname,label)          ; external routine
        endif else begin
            data = COLASPDS (fname,label,/SILENT)  ; external routine
        endelse
    endif else if (strpos (inform(w[0]),"ASCII") GT -1) then begin
        if (st EQ 0) then begin
            data = COLBIPDS (fname, label)         ; external routine
        endif else begin
            data = COLBIPDS (fname, label,/SILENT) ; external routine
        endelse
    endif else begin
        print, "ERROR: Invalid PDS table interchange format " + inform[0]
        return, -1
    endelse

    return, data
end

;-----------------------------------------------------------------------------
; precondition: fname is a viable PDS file name, label is a viable PDS label,
;     and st is either set to 0 or 1.
; postcondition: the qube data is read from the file, and returned to the
;     main block.

function DOQUBE, fname, label, st
    if (st EQ 0) then begin
        data = QUBEPDS(fname, label) 
    endif else begin
        data = QUBEPDS (fname, label, /SILENT)
    endelse

    return, data
end

;- level 0 --------------------------------------------------------------------

;function READPDS, filename, SILENT=silent
function READPDS, filename, label, SILENT=silent, nodata=nodata, dim=dim		; Spitale 3/10/2009
    ; error protection:
    on_error, 2
    params = n_params()

    ; check for number of parameters in function call:
    if (params LT 1) then begin
        print, "Error - Syntax: result = READPDS (filename [,/SILENT])"
        return, -1
    endif
    if (keyword_set(SILENT)) then st = 1 else st = 0

    ; obtain PDS label:
    if (st EQ 0) then begin
        label = HEADPDS (filename)             ; external routine
    endif else begin
        label = HEADPDS (filename, /SILENT)    ; external routine
    endelse
    if (label[0] EQ "-1") then begin
        return, -1
    endif

    ; obtain all viable objects from label array:
    objects = OBJPDS (label,"ALL")         ; external routine
    if (objects.flag EQ -1) then begin
        print, "Error: No viable PDS object found in " + filename
        return, -1
    endif
    objarray = objects.array
    objindex = objects.index
    objcount = objects.count

    ; check whether there exist BIT_COLUMN, BIT_ELEMENT, and CONTAINER
    ; objects in the PDS file:
    bcol_objs = OBJPDS(label, "BIT_COLUMN")       ; external routine
    belem_objs = OBJPDS(label, "BIT_ELEMENT")     ; external routine
    cont_objs = OBJPDS(label, "CONTAINER")        ; external routine
    if (bcol_objs.flag EQ 1 OR belem_objs.flag EQ 1 $
         OR cont_objs.flag EQ 1) then begin
        print, "Error: either BIT_COLUMN, BIT_ELEMENT, or CONTAINER object"+$
               " found. Currently not supported by PDSREAD."
        return, -1
    endif

    ; initialize the object structure
    result = create_struct("objects", objcount)

    ; create a flag structure to hold flags for each OBJECT type, where each
    ; flag field is used to ascribe whether to perform multiple object read.
    ; is set to 1 to read multiple, and -1 otherwise:
    flag = create_struct("array", 1, "collection", 1, "image", 1)

    ;/******* start loop to populate viable objects ************************/
    for i = 0, objcount - 1 do begin
        obj = objarray[i]

        ; check for each type of OBJECT and read the individual objects:
        ; first check whether multiple object read flag is set to -1
        ; if flag EQ 1 then process ARRAY, COLLECTION, and IMAGE objects,
        ; and set their respective flags to -1:

        ; test to process ARRAY:
        pos = strpos(obj, "ARRAY")
        if ((pos[0] GT -1) AND (flag.array EQ 1)) then begin
            data = DOARRAY (filename, label, st, objindex[i])  ; subroutine
            flag.array = -1
            result = create_struct (result, objarray[i], data)
        endif

        ; test to process COLLECTION:
        pos = strpos(obj, "COLLECTION")
        if ((pos[0] GT -1) AND (flag.collection EQ 1)) then begin
            data = DOCOLLECTION (filename, label, st, objindex[i]) ; subroutine
            flag.collection = -1
            result = create_struct (result, objarray[i], data)
        endif

        ; test to process IMAGE:
        pos = strpos(obj, "IMAGE")
        if ((pos[0] GT -1) AND (flag.image EQ 1)) then begin
;            data = DOIMAGE (filename, label, st)              ; subroutine
            data = DOIMAGE (filename, label, st, xsize, ysize, nodata=nodata)              ; subroutine
									; Spitale 3/10/2009
            flag.image = -1
            result = create_struct (result, objarray[i], data)
        endif

        ; test to process QUBE:
        if (strpos(obj, "QUBE") GT -1) then begin
            data = DOQUBE (filename, label, st)               ; subroutine
            result = create_struct (result, objarray[i], data)
        endif

        ; test to process TABLE, SERIES, PALETTE, or SPECTRUM:
        if ((strpos(obj, "TABLE") GT -1) OR $
            (strpos(obj, "SERIES") GT -1) OR $
            (strpos(obj, "PALETTE") GT -1) OR $
            (strpos(obj, "SPECTRUM") GT -1)) then begin
             data = DOTABLE (filename, label, st, objindex[i])  ; subroutine
             result = create_struct (result, objarray[i], data)
        endif
    endfor

    ; display the contents of the structure if not in silent mode:
    if (st EQ 0) then begin
        help, /structure, result
    endif

    if(keyword_set(xsize)) then dim = xsize			; Spitale 3/10/2009
    if(keyword_set(ysize)) then dim = [dim, ysize]
    if(keyword_set(zsize)) then dim = [dim, zsize]

    return, result
end
