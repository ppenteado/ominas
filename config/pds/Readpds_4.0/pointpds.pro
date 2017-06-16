;------------------------------------------------------------------------------
; NAME: POINTPDS
;
; PURPOSE: To process the pointer to an object in a PDS file
;
; CALLING SEQUENCE: Result = POINTPDS (label, filename, objectname)
;
; INPUTS:
;    Label: String array containing the PDS header
;    Filename: Scalar string containing the name of the PDS file to read
;    objectname: The name of the object to process pointer information for
; OUTPUTS:
;    Result: a structure containing the name of the datafile and the skip
;            offset in bytes
;
; OPTIONAL INPUT: none
;
; EXAMPLES:
;    To obtain information from TABLE.LBL on a TABLE object:
;       IDL> label = HEADPDS ("TABLE.LBL",/SILENT)
;       IDL> pointer = POINTPDS (label, "TABLE.LBL","TABLE")
;       IDL> help, /STRUCTURE, pointer
;            FLAG                      1
;            DATAFILE         "TABLE.TAB"
;            SKIP                   2056
;
; PROCEDURES USED:
;    Functions: PDSPAR, CLEAN, STR2NUM
;
; MODIFICATION HISTORY:
;    Written by: Puneet Khetarpal [August, 2002]
;    For a complete list of modifications, see changelog.txt file.
;
;------------------------------------------------------------------------------

function POINTPDS, label, fname, objname
    ; error protection:
    ;on_error, 2

    ; initialize structure:
    pointer = create_struct("flag", 1)    

    ; obtain record bytes keyword value:
    record_bytes = PDSPAR (label, "RECORD_BYTES")
    if (!ERR EQ -1) then begin
        print, "ERROR: missing required RECORD_BYTES keyword."
        GOTO, ENDFUN
    endif

    ; obtain pointer to objname:
    param = "^" + objname
    point = PDSPAR (label, param)
    if (!ERR EQ -1) then begin
        print, "ERROR: pointer to " + objname + " object missing."
        GOTO, ENDFUN
    endif

    ; clean and save pointer as backup:
    point = CLEAN(point[0], /SPACE)
    savepoint = point

    ; remove parentheses from string:
    rightp = strpos(point, "(" )
    leftp = strpos(point, ")" )
    if (rightp GT -1 AND leftp GT -1) then begin
        rightp = rightp + 1
        length = leftp - rightp
        point = strmid(point, rightp, length)
    endif

    ; check for <BYTES> flag and remove it if found:
    rightp = strpos (point, "<BYTES>")
    if (rightp GT -1) then begin
        byte_offset_flag = 1
        point = strmid(point, 0, rightp)
    endif else begin
        byte_offset_flag = -1
    endelse

    ; check for double quotes and extract:
    rightp = strpos (point, '"')
    if (rightp GT -1) then begin
        leftp = strpos (point,'"', rightp + 1)
    endif else begin
        leftp = -1
    endelse

    ; if there was a filename, save it:
    datafile = ""
    if (rightp GT -1 AND leftp GT -1) then begin
        rightp = rightp + 1
        length = leftp - rightp
        datafile = strmid (point, rightp, length)

        ; remove the file name from the pointer string:
        length = strlen(point) - leftp
        point = strmid (point, leftp + 1, length)
    endif else if (rightp EQ -1 XOR leftp EQ -1) then begin
        print, "ERROR: badly formatted file pointer " + savepoint
        GOTO, ENDFUN
    endif
 
    ; obtain bytes_offset or skip bytes:
    rightp = strpos (point, ",")
    if (rightp GT -1) then begin
        rightp = rightp + 1
        length = strlen(point)
        point = strmid (point, rightp, length - rightp)
    endif
   
    if (strlen(point) EQ 0) then begin
        skip = 0
    endif else begin
        skip = long(STR2NUM (point))
    endelse

    if (byte_offset_flag EQ -1 AND skip NE 0) then begin
        skip = (skip - 1) * record_bytes[0]
    endif

    ; if there is a datafile, then check:
    if (strlen(datafile) GT 0) then begin
        dir = fname
        rightp = strpos (dir, "/")
        last_slash = rightp
        while (rightp GE 0) do begin
            last_slash = rightp
            rightp = strpos (dir, "/", rightp + 1)
        endwhile
        if (last_slash GT 0) then begin
            dir = strmid (dir, 0, last_slash + 1)
        endif else begin
            dir = ""
        endelse

        ; if data file is in mixed case:
        fname = dir + datafile
        openr, unit, fname, ERROR=err, /GET_LUN
 
        ; if real name is in lower case:
        if (err NE 0) then begin
            fname = dir + strlowcase (datafile)
            openr, unit, fname, ERROR=err, /GET_LUN
        endif
   
        ; if real name is in upper case: 
        if (err NE 0) then begin
            fname = dir + strupcase (datafile)
            openr, unit, fname, ERROR=err, /GET_LUN
        endif
    
        if (err NE 0) then begin
            print, "ERROR: could not open data file: " + dir + datafile
            GOTO, ENDFUN
        endif

    endif else begin
        openr, unit, fname, ERROR=err, /GET_LUN
        if (err NE 0) then begin
            print, "ERROR: could not re-open " + fname
            GOTO, ENDFUN
        endif
    endelse

    close, unit
    free_lun, unit

    ; store pointer information in a structure:
    pointer = create_struct (pointer, "datafile", fname, "skip", skip)      

    return, pointer

    ENDFUN:
        pointer.flag = -1
        return, pointer
end
