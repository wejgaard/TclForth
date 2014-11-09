tclforth
========

Test-Repo for  https://code.google.com/p/tclforth/



PLAYING AROUND -- LEARNING GIT

---

Tcl is a great software development environment, used and proven in many professional applications. For a quick overview see http://wiki.tcl/299. Due to its long use and continuing care by a dedicated development team Tcl is a truly mature system; you feel it all the way down to inner details. And now, with a little overlay, this universe is available in Forth.

Tcl commands and Forth words are closely related. Both are called by their interpreters to compile or execute. Both in effect create the programming language, and both languages can be changed and extended by you, the programmer. The deciding difference is the notation. Tcl uses the formal prefix notation for command arguments and an infix interpreter for math expressions. If we add a way to pass arguments on a stack, Tcl would be postfix and a postfix Tcl is a Forth system, TclForth.

We can study it with a few commands in the Forth console and the resulting Tcl code in the Codewindow.  (Open the Codewindow in the Setupmenu).

This is the definition of a Tcl command 'write':
```
ok> Tcl proc write {text} {printnl $text}
```
The word Tcl passes the following text to the Tcl interpreter.

To test the definition we still put Tcl in front because it is a Tcl command.
```
ok> Tcl write "Hello World!"
Hello World!
ok>
```

Now here is the same function written as a code word in Forth.
```
ok> Code Write { text -- }  printnl $text
```
This is converted by TclForth into
```
proc Write {} {
set text [pop] ; printnl $text
}
```
and again passed to Tcl for compilation.

Now test it the Forth way:
```
ok> "Hello World!" Write
Hello World!
ok>
```

####Discussion###

The only change needed to convert a Tcl command into a Forth word was the addition of ``` "set text [pop] ;" ``` in front of the code, which turns the stack argument 'text' into a local variable with this name. And we need a stack for the parameter, of course.

####Words###

TclForth provides the standard set of Forth words as far as they make sense. Lookup the words in the files forth.fth and tk.fth. And see how the words are used in console.fth.

To really use TclForth you will want some knowledge of Tcl. At least an overview of all the commands and features and how to use them.

####Books###
Brent B. Welch and Jeffrey Hobbs, Practical Programming in Tcl and Tk, 4. edition, Prentice Hall, 2003 --
This book contains all you might want to know deep into the Tcl system and is highly recommended.
It covers Tcl up to version 8.4.

John K. Ousterhout and Ken Jones, Tcl and the Tk Toolkit, second edition, Addison Westley, 2010 --
It is a complete revision of the first edition that describes Tcl version 8.5, the version of the Tcl runtimes in the TclForth apps.

Version 8.5 added dictionaries and themed widgets.

####Web###

*Tutorial*:  https://www.tcl.tk/man/tcl8.5/tutorial/tcltutorial.html

*Documentation*:  http://www.tcl.tk/man/tcl/contents.htm .
