TclForth provides the following data types. Implemented as [objecttypes](./Objecttypes). 


###Variable###
Methods: get @ set ! incr decr add print

```
Example: 55 variable var
Use:     var 5 + .     5 var add     var print     var incr     77 var set    var @ 20 * var !
```

###Array###
Methods: _get set incr add print names_

```
Example: {} array A
Use:     11 1 A set    22 2 A set    1 A 2 A +  ( -- 33 )
```

###String###
Methods: _get set index length tolower append print
```
Example:  "a little message " string S
Use:      "for you" S append    S print
```

###List###
Messages: _index @ put set ! getlist get setlist append push pop length clear revert sort join print search last
```
Example:  {11 22 33} list L
Use:      1 L index   ( -- 22 )    1 L get  ( -- 22 )       1 L   ( -- 22 )
          1 L 2 L + ( -- 55 )
          L getlist ( -- {11 22 33} )
          888 L push   L getlist   ( -- {11 22 33 888} )
          L pop   ( -- {11 22 33} 888 )
```

###File###
Methods: _handle open-w open-r close put get eof_

    Example:  " source.tcl" file sfile    
    Use:  sfile open-r
          begin sfile get .cr
               sfile eof
          until
          sfile close