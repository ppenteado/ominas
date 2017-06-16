;------------------------------------------------------------------------------
; NAME: CLEAN
;     
; PURPOSE: To remove all unprintable characters from the given string
; 
; CALLING SEQUENCE: Result = CLEAN (text, [/SPACE])
; 
; INPUTS:
;    Text: Scalar string of characters to be cleaned
; OUTPUTS:
;    Result: Scalar string of characters removed of all unprintable characters
;
; OPTIONAL INPUTS:
;    SPACE: removes all unprintable characters including all space chars.
;
; EXAMPLE:
;    To remove all unprintable chars except space
;       IDL> word = CLEAN ('the [tab]file is [lf][cr]')
;       IDL> print, word
;            the file is
;    To remove all unprintable chars including space
;       IDL> word = CLEAN ('the [tab]file is [lf][cr]',/SPACE)
;       IDL> print, word
;            thefileis
;
; PROCEDURES USED: none
;
; MODIFICATION HISTORY:
;    Written by Puneet Khetarpal, January 15, 2003
;    For a complete list of modifications, see changelog.txt file.
;
;------------------------------------------------------------------------------

function CLEAN, text, SPACE=space
    ; error protection:
    ;on_error, 2

    ; check for SPACE keyword specification:
    if keyword_set(SPACE) then space = 1 else space = 0

    ; process the text only if string is not NULL:
    status = size(text,/TYPE)
    if (status NE 7) then text = string(text)
    if (strlen(text) NE 0) then begin
        btext = byte(text)

        ; find the wanted chars ommitting or including the space char:
        if (space EQ 1) then begin
            pos = where (btext GT 32B AND btext LT 127B)
        endif else begin
            pos = where (btext GE 32B AND btext LT 127B)
        endelse

        ; assign processed value of text:
        if (pos[0] NE -1) then begin
            text = string(btext[pos])
        endif else text = ""
    endif
    return, text   
end
