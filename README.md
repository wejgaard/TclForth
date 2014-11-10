#TclForth#

TclForth is a Forth system that uses Tcl as its native language. The Forth source code is converted to Tcl procedures for execution in the Tcl run time system. Tcl commands and Forth words coexist as a symbiosis of Tcl and Forth.

TclForth applications run unchanged wherever Tcl runs, e.g. Windows, OS-X and Linux.

#### Installation = Download and Unzip #

The unzipped systems are immediately executable.

#### Executables #

The Windows and OS X executables are [http://wiki.tcl.tk/3663 starpacks]. They contain a Tcl runtime system for the platfom and a load routine for the TclForth source files. Double click the executable to start TclForth. 

You can also start TclForth loading the source files into an existing Tcl interpreter (wish) or a [http://wiki.tcl.tk/52 Tclkit], e.g. on another platform like Linux:
```
cd <sourcedirectory>
source tfmain.tcl
```

####Source Files#

Usually a starpack contains every part of the application including the source files. In TclForth the source files are handled externally, as they also serve as system documentation.
