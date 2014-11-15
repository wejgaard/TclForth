The parameter stack implies postfix notation. Postfix follows from transferring parameters on a stack.

###Operational###

Postfix notes how it is done, it is operational notation that describes how the operation is performed. Prefix and infix notation must be converted by the compiler for execution on the machine.  Infix feels familiar because we are trained in infix. However, we and the CPU evaluate the expression in postfix.

###Simple programming language###

  * No intermediate variables needed to transfer arguments
  * No block markers needed
  * Flow control ranges are delimited by meaningful words
  * No statement delimiters, continuous flow of action.
  * Definition sequence = execution sequence, easy tracing with single stepping
  * Arithmetic operations are clear, no parentheses, no priorities

###Formal notation has a price: Complexity###

You know the result of 2+3, now what is 2+3*4 ? No problem either, but note that you need an additional rule, the rule of precedence of arithmetic operators. And so does the compiler. Or you could use parentheses (another rule for you and the compiler) to specify (2+3)*4.

In postfix notation no additional rules are needed. You write 2 3 + 4 * +  or 2 3 4 * +

The complexity of infix notation is easily handled even in simple calculators, so why worry?
Because this is a fundamental problem in software. Each new level of formalism breeds new complexity. For you and for the compiler and interpreter.