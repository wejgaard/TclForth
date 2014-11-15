
####Global Variables###

The defined objecttypes are global.

####Local Variables ###

Local variables are also handled as objecttypes. Initially a local has the type variable, thus the messages and methods of a variable apply to a local. The variable can be cast to a different type.

Example:
```
 : PrintLength   ( mystring -- )
    cast mystring string
    mystring length .cr
```