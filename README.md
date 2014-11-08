tclforth
========

Test-Repo for  https://code.google.com/p/tclforth/


##Words##

The Forth interpreter handles the following types of words.

### proc ###

TclForth needs a couple of native Tcl procedures, e.g. stack handling words.

```
proc push {p} {
    lappend ::stack $p
}
```

###Code ###

Code words interface Forth with Tcl, handle I/O, events, GUI, etc. They are the low level kernel words of the Forth system.

The code words are Tcl procs without formal arguments. !TclForth replaces the formal argument by a stack diagram. The compiler uses the diagram to add the appropriate [Stack stack] handling. The stack arguments are converted to local variables in the proc..

Example: The Forth word

```
Code int { n1 -- n2 }
    set n2 [expr int($n1)]
```
is compiled to
```
proc int {} {
    set n1 [pop];  set n2 [expr int($n1)]; push $n2 ;
}
```

==Colon (:)==

The colon word is defined by Forth words.

TF provides a simple solution for the threading of Forth code and the appropriate inner interpreter: We pass the job to Tcl. Colon words are procs that call Forth procs. The execution engine of Tcl is the inner interpreter of Forth.

{{{
: <name> { -- } <Forth source> ;
}}}

Again, arguments are accepted and results are returned on the parameter stack.

{ -- }  is stack notation.

Example:
{{{
: Prompt { -- }
     depth 0> withStack and
     if   "$::stack ok>"
     else "ok>"
     then Console append update
;
}}}
becomes
{{{
proc Prompt {} {
     depth;  0>; push $::withStack; and;
     if [pop]  {
          push "$::stack ok>";
     } else {
          push "ok>";
     }
     $::Console insert end [pop]; update;
}
}}}

== Compiler ==

As in Tcl, flow control in Forth is handled by the flow words themselves: IF THEN etc are words that are executed when the source is compiled. They are known as immediate words in Forth, !TclForth calls them compilers. A compiler word executes when the source is loaded.

{{{
Compiler <name> <host action>
}}}

The compiler words define action in the host and are written in Tcl code.

== Objecttype ==

!TclForth handles data as ObjectTypes.

{{{
Objecttype <name>  <array of messages and methods>
}}}

The !ObjectTypes replace CREATE ... DOES ...

== Tcl ==

{{{
Tcl set x 0
}}}

The text after Tcl is passed unchanged to the Tcl interpreter.

--

Note: The defining words are case tolerant. You can also write code, compiler, objecttype, tcl.
However, the defined word names are case sensitive.
