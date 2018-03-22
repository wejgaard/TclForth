# TclForth

A multi-platform desktop Forth system based on Tcl/Tk.  

### Overview
TclForth uses Tcl as its native language. The Forth code and colon words are compiled to Tcl procedures that pass arguments and results on a stack. The stack items are handled as local variables. The Forth and Tcl procedures coexist in the Tcl namespace and are all taken care of by the Tcl runtime system. Thus, the Tcl bytecode interpreter is also the inner interpreter of TclForth. For details see http://wiki.tcl.tk/37199.

I have built applications with TclForth for a while and release it as an open source project. The system is prepared as self-contained double-click executables for Windows and OS-X (starpacks) and as a set of source files for Tcl in Linux and elsewhere. Installation = unzip. 

### Features

* Universal desktop Forth 
* A TclForth program runs unchanged in Windows, OS-X, Linux, and more
* Native data types array, string, list, and dict
* Native local variables
* Native graphical toolkit based on Tk
* Native database (Metakit)
* Desktop apps for Windows and OS-X

### [Guide](https://github.com/wejgaard/tclforth/wiki)
TclForth is special. Explore a new Forth universe.

### [Comments](https://github.com/wejgaard/tclforth/issues) 
Use the Issues for Comments, Questions, Ideas. 

### [Release v0.7.0](https://github.com/wolfwejgaard/tclforth/releases) 

The **TclForth.zip** archive contains the source files as well as Tcl executables for Windows and OS-X, and shell code for Linux.

* Windows: Run tclforth.exe
* OS-X: Run tclforth.app
* Linux: Run tclforthx in a terminal. In the Tcl console:

```
    cd <source-directory>
    source tfmain.tcl
```


