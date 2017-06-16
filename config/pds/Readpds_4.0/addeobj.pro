;------------------------------------------------------------------------------
; NAME: ADDEOBJ
; 
; PURPOSE: To insert END_OBJECT keyword values if not present, and pad the
;          lines to 80 bytes
;
; CALLING SEQUENCE: Result = ADDEOBJ (ln, objarr, objcount)
; 
; INPUTS:
;    Ln: Scalar string containing a line from label for PDS file.
;    Objarr: String array containing the values of OBJECT keyword in label.
;    Objcount: The total count of objects in the objarr to be processed.
;
; OUTPUTS:
;    Result: Updated PDS label string with END_OBJECT keyword value
;
; OPTIONAL INPUT: none.
;
; MODIFICATION HISTORY:
;    Written by: Puneet Khetarpal [June 28, 2004]
;------------------------------------------------------------------------------

function ADDEOBJ, ln, objarr, objcount
    ; error protection:
    ;on_error, 2

    ; initialize structure to be returned:
    struct = create_struct("flag", 1)

    ; check for number of arguments in function call, must equal 3:
    params = N_params()
    if (params[0] LT 3) then begin
        print, "Syntax - result = ADDEOBJ (ln, objarr, objcount)"
        GOTO, ENDFUN
    endif

    ; format line to 80 bytes if not:
    length = strlen(ln)
    if (length LT 78) then begin       
        pad = make_array(78 - length, /BYTE, VALUE = 32B)
        ln = ln + string(pad) + string([10B, 13B])
    endif else begin
        ln = ln + string([10B, 13B])
    endelse

    ; determine the position of OBJECT or END_OBJECT keyword in ln string:
    tempstr = ln
    tempstr = CLEAN(tempstr, /SPACE)          ; external routine
    objpos = strpos(tempstr, "OBJECT=")
    end_objpos = strpos(tempstr, "END_OBJECT")

    ; check for OBJECT keyword:
    if ((objpos[0] GT -1) AND (end_objpos[0] EQ -1)) then begin
        ; if present then extract OBJECT value by separating the string
        ; into two via the "=" separator:
        if (!VERSION.RELEASE GT 5.2) then begin
            arr = strsplit(ln, "=", /EXTRACT)
        endif else begin
            arr = str_sep(ln, "=")         ; routine obsolete in IDL v. > 5.2
        endelse
        name = CLEAN(arr[1], /SPACE)          ; external routine

        ; if there are currently no objects in the objarr, then assign 
        ; objarr to the extracted name of the OBJECT, else concatenate
        ; the value to objarr, and increment objcount by 1:
        if (objcount EQ 0) then begin
            objarr = name
        endif else begin
            objarr = [objarr, name]
        endelse
        objcount = objcount + 1

    endif else if (end_objpos GT -1) then begin
        ; if END_OBJECT keyword found in the string, then first check
        ; whether there are any viable objarr elements left to be processed
        ; for the found END_OBJECT keyword:
        if (objcount EQ 0) then begin
            print, "Error: Inconsistent number of OBJECT and END_OBJECT " + $
                   "keywords found."
            GOTO, ENDFUN
        endif

        ; determine whether the string already has an "=" character:
        pos = strpos(ln, "=")
        if (pos[0] EQ -1) then begin
            ; if not, then position to write onto string is right after
            ; the word "END_OBJECT":
            pos = strpos(ln, "END_OBJECT")
            pos = pos + strlen("END_OBJECT") + 1
            src = "= " + objarr[objcount - 1]
        endif else begin
            ; first check to ensure that the END_OBJECT param matches
            ; OBJECT param, obtain object parameter, and end object param:
            src = objarr[objcount - 1]
            eobjparam = CLEAN(strmid(ln, pos + 1), /SPACE)

            ; if object param not equals end object param, then error:
            if (eobjparam NE src) then begin
                print, "Error: OBJECT (" + src + ") and END_OBJECT (" + $
                       eobjparam + ") value mismatch."
                GOTO, ENDFUN
            endif

            ; else extract string upto the already included "=" sign:
            pos = pos + 2
            ln = strmid (ln, 0, pos - 1)

            ; format line to 80 bytes if not:
            length = strlen(ln)
            if (length LT 78) then begin       
                pad = make_array(78 - length, /BYTE, VALUE = 32B)
                ln = ln + string(pad) + string([10B, 13B])
            endif else begin
                ln = ln + string([10B, 13B])
            endelse
        endelse

        ; insert the OBJECT value into END_OBJECT value keyword, and
        ; decrement objcount, and reconstruct objarr:
        strput, ln, src, pos
        objcount = objcount - 1
        temp = objarr[0:objcount]
        objarr = temp
    endif

    ; add to the struct the ln, objarr, and objcount vars:
    struct = create_struct(struct, "ln", ln, "array", objarr, "count",objcount)
    return, struct

    ENDFUN:
        ; if error, then set struct.flag to -1 and return struct:
        struct.flag = -1
        return, struct
end
