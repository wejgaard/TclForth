# TclForth

A multi-platform desktop Forth system. 

## Overview
TclForth uses Tcl/Tk as its native language. The Forth source code is compiled to Tcl procedures for execution in the Tcl run time system. Tcl commands and Forth words coexist as a symbiosis of Tcl and Forth. 


## Features

* Universal desktop Forth, runs in Windows, OS-X, Linux, and more. 
* Native data types array, string, list, and dict.
* Native local variables.
* Native graphical toolkit based on Tk.
* Native database (Metakit).
* Desktop apps for Windows and OS-X
### Changes in Tcl
* Arguments and results are transferred on a parameter stack. 
* Concatenative/postfix notation.

## [Release 0.7.0](https://github.com/wolfwejgaard/tclforth/releases) 

The provided system contains the TclForth source files as well as Tcl executables for Windows and OS-X, and shell code for Linux.

* Windows: Run tclforth.exe
* OS-X: Run tclforth.app
* Linux: Run tclforthx in a terminal. 
- In the Tcl console:
```
    cd <source-directory>
    source tfmain.tcl
```

## Release Notes 

* Console: Accepts pasting of source with multiple units/definitions 
* Console: Continue the command string on a new line with \<Ctrl+Enter\>
* Console: Put immediate action on the command line inside [ ]

* If TclForth is started in a terminal, the terminal becomes the Tcl console.


## [Wiki/Guide](https://github.com/wolfwejgaard/tclforth/wiki)

## [Comments/Issues](https://github.com/wolfwejgaard/tclforth/issues)







