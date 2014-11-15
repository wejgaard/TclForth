
###An introductory Tour###

The usual Forth stack action.
```
ok> 33 44
(33 44) ok> * .
1452 ok>
```
The prompt line shows the stack contents in parentheses.
```
ok> "Hello World"
({Hello World}) ok> . cr
Hello World
ok>
```
Now try some definitions.
```
ok> : Star { -- } "*" . ;
ok> Star
* ok>
```
No space is needed after the first `"` in a string definition.
```
ok> : Stars { n -- } n times Star repeat ;
ok> 5 Stars
* * * * * ok
```
The stack parameter n is converted to a local variable and removed from the stack before the body of the definition is executed. More in [Stack Stack].
```
ok> : Grid { m -- }  m times m Stars cr repeat
ok> 3 Grid
* * *
* * *
* * *
ok>
```
Locals come handy here. Compare it to a stack based definition, two dup's and a drop.

You can change the behavior of a loaded word without having to reload the words that use it.
Suppose you prefer to print the Stars without trailing spaces: Just redefine Star.
```
ok> : Star {} "*" ascii emit ;
ok> Star
*ok
ok> 3 Stars
***
ok> 3 Grid
***
***
***
```
Tcl replaces the code in the loaded procedure. The change is active for all procedures that use this word.
You can program on a running TF program and instantly test the changes.

One more useful Tcl feature:
```
ok> 33 variable V
ok> "The value of V is $V" . cr
The value of V is 33
ok>
```
Variables are substituted in strings. Add a $ to retrieve the value.

--

TclForth is just Forth - with a twist.