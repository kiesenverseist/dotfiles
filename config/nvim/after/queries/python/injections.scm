; extends

; language injections for sql in python strings if the variable that string is
; assigned to ends with "sql" or it contains a line with a comment like "-- sql"

(assignment 
    left: (identifier) @_varx (#match? @_varx ".*sql$")
    right: (string (string_content) 
        @injection.content 
        (#set! injection.language "sql")
    )
) 

((string_content) 
    @injection.content 
    (#match? @injection.content "^\n*( )*-{2,}( )*[sS][qQ][lL]( )*\n")
    (#set! injection.language "sql")
)

((string_content) 
    @injection.content 
    (#match? @injection.content "^\n*( )*#( )*[yY][aA][mM][lL]( )*\n")
    (#set! injection.language "yaml")
)

((string_content) 
    @injection.content 
    (#match? @injection.content "^\n*( )*#( )*[tT][oO][mM][lL]( )*\n")
    (#set! injection.language "toml")
)
