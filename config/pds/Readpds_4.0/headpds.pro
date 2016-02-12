;------------------------------------------------------------------------------
; NAME: HEADPDS
;
; PURPOSE: To read a PDS label into an array variable
;
; CALLING SEQUENCE: Result = HEADPDS (filename [,/SILENT,/FILE,/FORMAT])
;
; INPUTS:
;    Filename: Scalar string containing the name of the PDS file to read
; OUTPUTS:
;    Result: PDS label array constructed from designated record
;
; OPTIONAL INPUT:
;    SILENT: suppresses any messages from the procedure
;    FILE: to be indicated if the file does not contain the label
;          [for purposes other than reading a label]
;    FORMAT: to be indicated if the file is ^STRUCTURE file
;
; EXAMPLES:
;    To read a PDS file TEST.PDS into a PDS header array, lbl:
;       IDL> lbl = HEADPDS("TEST.PDS",/SILENT)
;    To read a PDS file that may not contain a header:
;       IDL> lbl = HEADPDS("TEST2.TXT",/FILE)
;    To read a PDS format file FORMAT.FMT from the ^STRUCTURE:
;       IDL> fmt = HEADPDS("FORMAT.FMT", /FORMAT)
;
; PROCEDURES USED:
;    Functions: POINTPDS, PDSPAR, CLEAN, ADDEOBJ
;
; MODIFICATION HISTORY:
;    Written by: Puneet Khetarpal [January 24, 2003]
;
;    For detailed log of modifications to this routine, please see the
;    changelog.txt file.
;------------------------------------------------------------------------------

function HEADPDS, filename, SILENT=silent, FILE=file, FORMAT=format
    ; error protection:
    On_error, 2
    On_ioerror, SIGNAL

    ; check for number of parameters in function call, must be >= 1:
    params = N_params()
    if (params[0] LT 1) then begin
        print, "Error: Syntax - result = HEADPDS ( filename " + $
               "[,/SILENT,/FILE,/FORMAT] )"
        return, "-1"
    endif

    ; check for input of optional keywords:
    silent = keyword_set(SILENT)
    file = keyword_set(FILE)
    format = keyword_set(FORMAT)

    ; check whether the file exists and can be opened:
    openr, unit, filename, ERROR = err, /GET_LUN
    if (err LT 0) then begin
        print, "Error opening file " + filename + " ..."
        print, "...File either corrupted or invalid file name."
        return, "-1"
    endif

    ; check for correct PDS label file:
    if (NOT(FILE) AND NOT(FORMAT)) then begin
        temp = bytarr(160)
        readu, unit, temp
        if ((strpos(string(temp), "PDS_VERSION_ID") LT 0) AND $
            (strpos(string(temp), "SFDU_LABEL") LT 0) AND $
            (strpos(string(temp), "XV_COMPATIBILITY") LT 0)) then begin
            print, "ERROR: label must contain PDS_VERSION_ID keyword"
            return, "-1"
        endif
    endif
   
    ; initialize label variables:
    lbl = ""                ; holds the label string array
    flag = 0                ; set to -1 when END keyword is encountered
    objarr = "-1"           ; holds the name of the OBJECTs in stack
    objcount = 0            ; the number of objects to be processed
    linecountflag = 0       ; the current number of lines, acts as a flag
                            ;    for storing values into lbl variable

    ; inform user of status:
    if (NOT(SILENT)) then begin
        print, "Now reading header: ", filename
    endif

    ; set up file unit pointer:
    point_lun, unit, 0

    ; start reading the file and read until one had reached the "END"
    ; keyword in the file and until it is not the end of the file:
    while (flag NE -1) AND NOT(EOF(unit)) do begin
        ; read one line from file:
        ; Note- readf removes all \r\n characters from end of ln during read:
        ln = ""
        readf, unit, ln

        ; if not reading a "FILE" type then look for OBJECT and END_OBJECT
        ; keywords and set values appropriately, also pad the lines to 80 
        ; bytes:
        if NOT(FILE) then begin
            struct = ADDEOBJ(ln, objarr, objcount)   ; external routine
            if (struct.flag EQ -1) then begin
                return, "-1"
            endif
            ln = struct.ln
            objarr = struct.array
            objcount = struct.count
        endif else begin
            ln = ln + string([10B, 13B])
        endelse

        ; if lbl array has not been constructed, then assign lbl to ln
        ; else concatenate ln to lbl array and increment linecount:
        if (linecountflag EQ 0) then begin
            lbl = ln
            linecountflag = linecountflag + 1
        endif else begin
            lbl = [lbl, ln]
        endelse

        ; now check for "END" keyword in ln:
        ln2 = ln
        ln2 = CLEAN(ln2, /SPACE)  ; external routine
        if (ln2 EQ "END") then flag = -1
    endwhile

    ; close the file unit and free the unit number:
    close, unit
    free_lun, unit

    ; process ^STRUCTURE object in label if any:
    struct = PDSPAR(lbl, "^STRUCTURE", COUNT=strcount, INDEX=strindex)
    if (!ERR NE -1) then begin
        endobj = PDSPAR(lbl, "END_OBJECT", COUNT=eobjcount, INDEX=eobjindex)
      
        ; obtain the position where the contents of STRUCTURE file are
        ; to go in the lbl array, viz., before the last END_OBJECT keyword:
        structpos = where (eobjindex GT strindex[0])
        lblpos = eobjindex[structpos[0]]
        lastelem = n_elements(lbl) - 1

        ; obtain the pointer attributes for STRUCTURE, and read the file:
        pointer = POINTPDS (lbl, filename, "STRUCTURE")   ; external routine
        if (pointer.flag EQ -1) then begin
            print, "ERROR: structure pointer file missing"
            return, "-1"
        endif

        datafile = pointer.datafile
        fmtlabel = headpds (datafile, /FORMAT)

        ; insert fmtlabel into lbl array:
        lbl = [lbl[0:lblpos - 1], fmtlabel, lbl[lblpos:lastelem]]
    endif

    return, lbl

    ; error processing:
    SIGNAL: 
        On_ioerror, NULL
        print, 'ERROR reading file'
        return, -1
end
