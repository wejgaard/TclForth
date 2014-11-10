#TclForth#

TclForth is a Forth system that uses Tcl/Tk as its native language. The Forth source code is compiled to Tcl procedures for execution in the Tcl run time system. Tcl commands and Forth words coexist as a symbiosis of Tcl and Forth.

[link zu wiki](./wiki)

TclForth applications run unchanged wherever Tcl runs, e.g. Windows, OS-X and Linux.

#### Installation = Download and Unzip #

The unzipped systems are immediately executable.

#### Executables #

The Windows and OS X executables are [starpacks](http://wiki.tcl.tk/3663) . They contain a Tcl runtime system for the platfom and a load routine for the TclForth source files. Double click the executable to start TclForth. 

You can also start TclForth loading the source files into an existing Tcl interpreter (wish) or a [Tclkit](http://wiki.tcl.tk/52), e.g. on another platform like Linux:
```
cd <sourcedirectory>
source tfmain.tcl
```

####Source Files#

Usually a starpack contains every part of the application including the source files. In the TclForth system the source files are handled externally, as they also serve as system documentation and let you easily change the system.
