Every TclForth word compiles itself. This is equivalent to the Tcl way of passing control to Tcl commands. The compiler/interpreter parses the next word from the source and passes control to the word.

### Proc, Code, Colon (:) ###

A normal executable word appends a call to itself in the generated Tcl code, it adds its name and a closing ";".

*Example: dup appends " dup ; "*

###Objecttypes###

The object parses the following word in the source, and checks if it is a message. If yes, it fetches the method in its type array (the object sees its type in the type field in its database record). Else, if no message, uses the default message {}.

If the following word in the source is a method of this objecttype, the its script is added, else (no known method) the default method applies.


###Compiler###

The action of the compiler words is defined in the Forth system module. For example, the flow control words build a corresponding Tcl flow structure. The compiler words are defined in Tcl code.

###Code Window###

You can inspect the compiled Tcl code in the code window in the console. (Open the window in the Setupmenu.)
