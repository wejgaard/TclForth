##TclForth

A multi-platform desktop Forth.

####Overview
TclForth uses Tcl/Tk as its native language. The Forth source code is compiled to Tcl procedures for execution in the Tcl run time system. Tcl commands and Forth words coexist as a symbiosis of Tcl and Forth. 


####Features#

* Universal desktop Forth, runs in Windows, OS-X, Linux, and more. 
* Native data types array, string, list, and dict.
* Native local variables.
* Native graphical toolkit based on Tk.
* Native database (Metakit).
* TclForth is provided as desktop apps for Windows and OS-X

Tcl view

* Arguments and results are transferred on a parameter stack. 
* Concatenative/postfix notation.

####Installation
[Download the appropriate release and the source code](https://github.com/wolfwejgaard/tclforth/releases) 

* Store the executable together with the source folder.
* Windows: Run tclforth.exe
* OS-X: Run tclforth.app

Both executables contain a Tcl runtime and a load routine for the TclForth source.




* Linux: Run tclforthx in a terminal or, if available, load tclsh. In the Tcl console:

```
    cd <source-directory>
    source tfmain.tcl
```

####Guide

See the [Wiki](https://github.com/wolfwejgaard/tclforth/wiki)

####Forum

https://groups.google.com/forum/#!forum/tclforth



###Release Notes

#####Version 0.6.0

* Adapted to GitHub conventions:
* The TclForth systems are now provided as releases.
* Semantic versioning.

#####Version 0.57

* Console: New prompt, command line starts at the left border
* Console: Accepts pasting of source with multiple units/definitions 
* Forth: Command 'range' added to strings
* Wiki: updated

######Version 0.56

* Console: Continue the command string on a new line with \<Ctrl+Enter\>
* Console: Put immediate action on the command line inside [ ]
* Tcl: If TclForth is started in a terminal, the terminal becomes the Tcl console (e.g. Linux)
* Forth: Word 'mod' added (alias of %) 
* Debugged: list join ,   ."  






