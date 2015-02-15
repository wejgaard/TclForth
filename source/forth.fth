Compiler \  SkipLine

\ File:    forth.fth
\ Project: TclForth
\ Version: 0.6.0
\ License: Tcl
\ Author:  Wolf Wejgaard
\ 

\ ===================================================================================
\ Comments
\ ===================================================================================

Compiler (  SkipComment

# this is a Tcl comment line 
\ this is a Forth comment line
( this is a Forth comment )

\ Code definitions are delimited by an empty line.
\ end-code is optional
Compiler end-code

\ Colon definitions are delimited by an empty line.
\ A semicolon is optional
Compiler ;

\ ===================================================================================
\ Parameter Stack
\ ===================================================================================

# The parameter stack is a list
Tcl set stack {}

proc pop {} {
	if {[llength $::stack]==0} {error "stack underflow"}
	set r [lindex $::stack end]; set ::stack [lreplace $::stack end end]
	return $r 
}

proc push {p} {
	lappend ::stack $p
}

Code .s { -- }  
	printnl $::stack

Code !s { -- }  
	set ::stack ""

\ Most stack handling words are defined already by their stack diagrams.
\ E.g. dup { n -- n n }  is compiled to proc dup {} {set n [pop]; push $n;  push $n; }

Code dup { n -- n n }

Code swap { n1 n2 -- n2 n1 }

Code over { n1 n2 -- n1 n2 n1 }

Code drop { n1 -- }

Code nip { n1 n2 -- n2 }

Code rot { n1 n2 n3 -- n2 n3 n1 }

Code depth { -- n }
	set n [llength $::stack]

\ ===================================================================================
\ Arithmetic
\ ===================================================================================

Code + { n1 n2 -- n3 } 
	set n3 [expr {$n1+$n2}]

Code 1+ { n1 -- n2 }
	set n2 [incr n1]

Code 1- { n1 -- n2 } 
	set n2 [incr n1 -1]

Code - { n1 n2 -- n3 }
	set n3 [expr {$n1-$n2}]

Code * { n1 n2 -- n3 } 
	set n3 [expr {$n1*$n2}]

Code / { n1 n2 -- n3 } 
	set n3 [expr {$n1/$n2}]

Code 2/ { n1 -- n2 }  
	set n2 [expr {$n1/2}]

Code % { n1 n2 -- n3 }  
	set n3 [expr {$n1%$n2}]

Code mod { n1 n2 -- n3 }  
	set n3 [expr {$n1%$n2}]

Code int { n1 -- n2 } 
	set n2 [expr int($n1)]

Code min { n1 n2 -- n } 
	if {$n1<$n2} {set n $n1} {set n $n2}

Code max { n1 n2 -- n } 
	if {$n1>$n2} {set n $n1} {set n $n2}

Code abs { n1 -- n2 }  
	set n2 [expr abs($n1)]

Code sgn { n1 -- n2 }  
	set n2 [expr {$n1>0? 1: $n1<0? -1: 0}]

\ ===================================================================================
\ Logic and Comparison
\ ===================================================================================

Code or { n1 n2 -- n3 }
	set n3 [expr $n1 || $n2]

Code and { n1 n2 -- n3 } 
	set n3 [expr $n1 && $n2]

Code not { n1 -- n2 }  
	set n2 [expr {!$n1}]

Code == { n1 n2 -- flag }  
	set flag [expr {$n1==$n2}]

Code = { n1 n2 -- flag }  
	set flag [expr {$n1==$n2}]

Code >= { n1 n2 -- flag }  
	set flag [expr {$n1>=$n2}]

Code <= { n1 n2 -- flag } 
	set flag [expr {$n1<=$n2}]

Code < { n1 n2 -- flag }  
	set flag [expr {$n1<$n2}]

Code > { n1 n2 -- flag }  
	set flag [expr {$n1>$n2}]

Code != { n1 n2 -- flag } 
	set flag [expr {$n1!=$n2}]

Code <> { n1 n2 -- flag }  
	set flag [expr {$n1!=$n2}]

Code 0= { n1 -- flag }  
	set flag [expr {$n1==0}]

Code 0< { n1 -- flag } 
	set flag [expr {$n1<0}]

Code 0> { n -- flag }
	set flag [expr {$n>0}]

\ ===================================================================================
\ Math Functions -- to be extended, Tcl has all you need
\ ===================================================================================

Code sqrt { n1 -- n2 } 
	set n2 [expr sqrt($n1)]

\ ===================================================================================
\ String and List Operators
\ ===================================================================================

\ Puts empty data {} on the stack. 
Compiler ""  
	appendcode "push \"\" ; "

Code endchar { s -- c }
	set c [string index $s end]

Code tolower { C -- c }  
	set c [string tolower $C]

Compiler split 
	appendcode { foreach {j} [split [pop] [pop]] {push $j} ; }

Code uppercase? { c -- f }  
	set f [regexp {[A-Z]} $c]

Compiler [
	set comp(imm) [string length $comp(code)]

Compiler ]
	set comp(icode) [string range $comp(code) $comp(imm) [string length $comp(code)]]
	incr comp(imm) -1
	set comp(code) [string range $comp(code) 0 $comp(imm)]
	eval $::comp(icode)

Compiler {  PushList

Compiler {} 
	appendcode "push \{\} ; "

\ ===================================================================================
\ Data Types  
\ ===================================================================================

Objecttype constant  
	instance  {set obj [pop]}
	{}        {push $obj}

Objecttype variable  
	instance  {set obj [pop]}
	{}        {push $obj}
	get       {push $obj}
	@         {push $obj}
	set       {set obj [pop]}
	!         {set obj [pop]}
	incr      {incr obj}
	decr      {incr obj -1}
	add	      {set obj [expr {$obj+[pop]}]}
	print     {printnl $obj}

Objecttype array   
	instance  {array set obj [pop]}
	{}        {push $obj([pop])}
	get	      {push $obj([pop])}
	set       {set obj([pop]) [pop]}
	!         {set obj([pop]) [pop]}
	incr      {incr obj([pop])}
	add	      {incr obj([pop]) [pop]}
	print     {printnl $obj([pop])}
	names     {push [array names obj]}

Objecttype string   
	instance  {set obj [pop]}
	{}        {push $obj}
	set       {set obj [pop]}
	!         {set obj [pop]}
	index     {push [string index $obj [pop]]}
	range     {swap; push [string range $obj [pop] [pop]]}
	length    {push [string length $obj]}
	tolower   {push [string tolower $obj]}
	append    {append obj [pop]}
	print     {printnl $obj}
	first     {push [string first [pop] $obj]}
	hexdump   {binary scan $obj H* hex; printnl [regexp -all -inline .. $hex]}

proc @list {obj i} {
	push [lindex $obj $i]
}

proc !list {obj i} {
	upvar #0 $obj object
	set object [lreplace $object $i $i [pop]]
}

proc lrevert list {
	set res {}
	set i [llength $list]
	while {$i} {lappend res [lindex $list [incr i -1]]}
	return $res
 }

Code end { list -- e }  
	set e [lindex $list end]

Objecttype list   
	instance  {set obj [pop]}
	{}        {@list $obj [pop]}  
	index     {@list $obj [pop]}
	set       {!list obj [pop]}  
	!         {!list obj [pop]}   
	getlist   {push $obj}  
	setlist   {set obj [pop]}  
	append    {lappend obj [pop]}
	push      {lappend obj [pop]}
	pop       {push [lindex $obj end]; set obj [lreplace $obj end end]}
	length    {push [llength $obj]}
	clear     {set obj ""}
	revert    {set obj [lrevert $obj]}
	sort      {set obj [lsort $obj]}
	join      {set obj [join $obj]}
	print     {printnl "{$obj}"} 
	search    {push [lsearch $obj [pop]]}
	last      {push [lindex $obj end]}

Objecttype file  
	instance  {set obj "[pop] handle" ; }
	{}        {@list $obj 1}   
	open-w    {push [open [lindex $obj 0] w]; !list obj 1 }
	open      {push [open [lindex $obj 0] r]; !list obj 1 }
	close     {close [lindex $obj 1]}
	put       {puts [lindex $obj 1] [pop]}
	get       {push [gets [lindex $obj 1]]}
	read      {push [read [lindex $obj 1]]}
	eof       {push [eof [lindex $obj 1]]}

\ use: cast <variable> <type>
Compiler cast  
	set obj [GetItem]; set type [GetItem]
	if [isLocal $obj] {
		set locals($obj) $type
	} {
		error "only locals can be casted"
	}

\ ===================================================================================
\ Flow Control
\ ===================================================================================

Compiler if  
	appendcode "if \[pop\]  \{\n"

Compiler then  
	appendcode \}\n

Compiler else 
	appendcode 	"\} else \{\n"

Compiler case 
	appendcode "switch \[pop\]  \{\n"
	GetItem
	appendcode "$comp(word) "

Compiler of  
	appendcode "  \{ "

Compiler endof  
	appendcode " \}\n"
	GetItem
	if {$comp(word)!="endcase"} {
		appendcode "$comp(word) "
	} {
		appendcode "\}\n"
	}

Compiler endcase  
	appendcode " \}\} \n \n "

Compiler foreach 
	appendcode "foreach  \[pop\] \[pop\] \{\n"

Compiler exit  
	appendcode "return ; "

Compiler return  
	appendcode "return ; "

\ ===================================================================================
\ Loops
\ ===================================================================================

Compiler begin  
	appendcode "\nwhile 1 \{\n"

Compiler until  
	appendcode "\nif \[pop\] break \}\n "

Compiler while  
	appendcode "\nif \{\[pop\]==0\} break \n"

Compiler repeat  
	appendcode \}\n

Compiler again  
	appendcode \n\}\n

Compiler break  
	appendcode "break ; "

Compiler do  
	incr ::doi; incr ::doj; incr ::dok; 
	appendcode "set start$::doi \[pop\]; set limit$::doi \[pop\]; set incr$::doi 1
	for \{set _i$::doi \$start$::doi\} \{\$_i$::doi < \$limit$::doi \} \{incr _i$::doi \$incr$::doi  \} \{\n"

Compiler loop  
	incr ::doi -1; incr ::doj -1; incr ::dok -1; 
	appendcode "\}\n"

Compiler +loop  
	appendcode "set incr$::doi \[pop\]; \}\n"	
	incr ::doi -1; incr ::doj -1; incr ::dok -1;

Compiler I  
	appendcode "push \$_i$::doi; "

Compiler J 
	appendcode "push \$_i$::doj; "

Compiler K 
	appendcode "push \$_i$::dok; "

Compiler leave 
	appendcode " break ;  "

\ use: n times ... repeat
Compiler times
	incr ::doi; 
	appendcode "set limit$::doi \[pop\]; while \{\$limit$::doi>0\} \{incr limit$::doi -1; "

\ ===================================================================================
\ Print
\ ===================================================================================

Compiler ."  
	PushText ; appendcode "print \[pop\] ; "

\ Use . or .. - The compiler replaces . by .. with respect for Tk.
Code .. { text -- }  
	print "$text "

Code cr { -- } 
	printnl ""

Code .cr { text -- }  
	printnl $text

Code space { -- }   
	print " "

: spaces { n -- } 
	n times space repeat
;

Code emit { a -- }  
	print  [format %c $a]

\ Example: "A" ascii  ( -- 65 )
Code ascii { s -- a } 
	binary scan $s "c" a

\ Returns the ASCII value of the first char. 
\ Example:  asciiOf cdefg  ( -- 99 ) 
Compiler asciiOf  
	push [GetItem]; ascii;

\ Returns character c of ASCII value a 
\ Example: 65 char ( -- A )
Code char  { a -- c }  
	set c [format %c $a]

\ ===================================================================================
\ Timing
\ ===================================================================================

Compiler update  
	appendcode " update ; "

Compiler sleep  
	appendcode " after \[pop\] ;  "

Compiler wait  
	appendcode " after \[pop\] \{set _ 0\}; vwait _

Compiler doafter  
	appendcode " after \[pop\] \[pop\] ;  "

\ ===================================================================================
\ Exceptions
\ ===================================================================================

\ Use: catch <command>
\ only single command, no list. 
\ End catch with: "message" ErrorMsg 
\ or with: error" message" 
Compiler catch  
	GetItem
	appendcode "if \{\[catch $comp(word) result\]\} \{
	printnl \$result; 
	\}
	"

Compiler error"  
	PushText
	appendcode " error \[pop\] ; "

Code ErrorMsg { text -- }  
	error $text

Code alias { new old -- } 
	set ::words($new) "CompWord $old"
	end-code

Code tcleval { command -- }  
	eval $command

