



.macro LOAD_CONST
ldi @0, high(@2)
ldi @1, low(@2)

.endmacro

LOAD_CONST R16, R17, 1234
