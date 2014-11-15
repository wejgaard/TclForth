
Forth passes arguments and results on a parameter stack.

The stack is often used for intermediate storage of values and Forth provides a range of words for manipulating it: DUP SWAP OVER ROT DROP and others. This can make Forth programs difficult to read.

TclForth provides the stack mainly for passing parameters. The parameters are converted to local variables.

####  Notation ###

The stack notation has the general form { in | local -- out } with zero or more input, local and output parameters. All parameters are handled as local variables in the body of the word.

Example
```
  { in1 in2 | loc1 loc2 -- out1 }
```
When the word is executed, the input locals are set to the arguments on the stack.
The top-of-stack goes to in2, the second-on-stack goes to in1, and the arguments are removed from the stack.

Loc1 and 2 represent further locals that are used in the word. They are set to zero initially.

The output locals are defined but not initialized. They are meant to be set by the word. At the end of the word, the out values are pushed on the stack. Forth words can leave more than one result.

#### Implementation ###

The compiler adds two stubs of code. For the example above: In front of the words' body it inserts:
```
   set in2 [pop]; set in1 [pop]; set loc1 0; set loc2 0;
```
At the end it appends:
```
    push $out
```

#### Leave results without setting a result variable ###

If you exit a word with 'return' the stack remains in its present state. This is handy if you have many possible return values  in a case statement. (e.g. the word valid? in Chess for Forth)