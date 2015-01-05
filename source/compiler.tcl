# File:    compiler.tcl
# Project: TclForth
# Version: 0.57
# License: Tcl
# Author:  Wolf Wejgaard  
#

set comp(text) {}   ;# source text of the unit
set comp(code) {}   ;# compiled tcl code
set comp(word) {}   ;# currently compiled word/item
set comp(i) 0       ;# current index in source text
set comp(end) 0     ;# end of source text
set comp(in) {}     ;# input parameters tcl code
set comp(out) {}    ;# output parameters tcl code
set comp(prev) 0    ;# saved current index
set comp(imm) 0     ;# start of imm code
set comp(icode) {}  ;# imm code

proc GetItem {} {
	global comp
	if {$comp(i)>=$comp(end)} {set comp(word) "" ; return $comp(word)}
	set reg [regexp -indices -start $comp(i)  {\S+} $comp(text) range]
# if $reg==0 {set comp(word) "", return $comp(word)} 
	set start [lindex $range 0]
	set end [lindex $range 1]
	set comp(word) [string range $comp(text) $start $end ] 
	set comp(prev) $start
	incr end; 	set comp(i) $end
	if {$comp(word)=="."} {set comp(word) ".."}
	return $comp(word)
}

proc EmptyLine {} {
	global f line
	gets $f line
	while {[string first {\ } $line]==0 || [string first {#} $line]==0} {gets $f line}
	set line [string trim $line]
	expr {$line==""}
}

# Next program unit. 
# A unit is a block of source text terminated by an empty line
proc GetUnit {} {
	global f line comp
	while {[EmptyLine]&&[eof $f]==0} {}
	set code $line	
	while { ![EmptyLine]  && [eof $f]==0} {
		set code $code\n$line
	}
	set comp(text) $code
	set comp(end) [string length $comp(text)]
	set comp(i) 0
}

# Forth word list array
# For each name the entry contains the corresponding compile code 
set words(name) code

proc MakeProc {} {
	global comp 
	set comp(code) $comp(text) 
	uplevel #0 {eval $comp(text)}
}

# Creates a Forth proc that receives and passes its arguments on the data stack. 
proc MakeCode {} {
	global comp words
	set comp(name) [GetItem] 
	set comp(code) "proc $comp(name) \{\} \{ "
	CompileStack
	if {$comp(in)!=""} {append comp(code) "\n$comp(in) "}
	append comp(code) [string range $comp(text) $comp(i) $comp(end)]
	append comp(code) " \n$comp(out) \} "
	set words($comp(name))  "CompWord $comp(name)"
	eval $comp(code)
}

proc MakeCompiler {} {
	global comp words
	GetItem
	set comptext [string range $comp(text) $comp(i) $comp(end)]
	set words($comp(word)) [string trimleft $comptext]
}

proc MakeColon {} {
	global comp words
	set comp(name) [GetItem]
	set words($comp(name))  "CompWord $comp(name)"
	set comp(code) "proc $comp(name) \{\} \{\n"
	CompileStack
	if {$comp(in)!=""} {append comp(code) "$comp(in) \n"}
	GetItem
	CompileColon	
	append comp(code) " $comp(out) \n\} "
	eval $comp(code)
}

proc EvalTcl {} {
	global comp
	incr comp(i)
	set comp(code) [string range $comp(text) $comp(i) $comp(end)]
	uplevel #0 {eval $comp(code)}
}

# Interprets = compiles and executes a Forth script
proc EvalForth {} {
	global comp words
	set comp(i) 0
	GetItem
	CompileColon	
	uplevel #0 {eval $comp(code)}
}

# Called by Forth word "
proc PushText {} {
	global comp 
	set start $comp(i); incr start
	set end [string first {"} $comp(text) $start]
	if {$end<0} {error "String not finished"}
	incr end -1 
	set text [string range $comp(text) $start $end]
	incr end 2; set comp(i) $end
	append comp(code) "push \"$text\" ; "
}

# Called by Forth word { 
proc PushList {} {
	global comp 
	set start $comp(i)
	set end [string first \} $comp(text) $start]
	if {$end<0} {error "List not finished"}
	incr start; incr end -1 
	set text [string range $comp(text) $start $end]
	incr end 2; set comp(i) $end
	append comp(code) "push \{$text\}  ; "
}

proc SkipLine {} {
	global comp
	set eol [string first \n $comp(text) $comp(i)]
	if $eol>0 {
		incr eol; 	set comp(i) $eol
	} {
		set comp(i) $comp(end)
	}
}

proc SkipComment {} {
	global comp
	set eoc [string first ) $comp(text) $comp(i)]
	if $eoc>0 {
		incr eoc; 	set comp(i) $eoc
	} {
		set comp(i) $comp(end)
	}
}

# Compile action of code and colon words
proc CompWord {name} {
	global comp
	append comp(code) " $name ; " 
}

# Compile action of most compiler=immediate words
proc appendcode {code} {
	global comp
	append comp(code) $code
}

# Called by definer objecttype.
# Creates an objecttype array. 
# The indices are messages, the values are method scripts.
# Example use:
# objecttype Variable
# 		get  {push $obj}	
#		set  {set obj [pop]} 
#		... 
proc MakeObjecttype {} {
	global comp words 
	set objtype [GetItem] 
	set words($objtype)  "MakeObject ::$objtype"	
	set comp(code) "array set $objtype  {"
	append comp(code) [string range $comp(text) $comp(i) $comp(end)]
	append comp(code) " }"
	uplevel #0 {eval $comp(code)}
}

# Creates an instance of objtype.
proc MakeObject {objtype} {
	global comp words
	set object [GetItem] ;# name of object
	set words($object) "CompObject $objtype"	
	if {[array names $objtype -exact instance]!=""} {
		AppendObjectCode $object [set ${objtype}(instance)]
	} {
		AppendObjectCode $object {set obj {} ; }
	}
}

# If the following source item is a message of objecttype type
# the corresponding method script is appended,
# else the default method {} is used.
proc AppendMethod {object type} {
	global comp words
	if [isLocal $object] { } {set object "::$object"}			
	set comp(prev) $comp(i); 
	set message [GetItem]
	if [info exists ::${type}($message)] {
		set method [set ::${type}($message)]
	} {
		set message ""
		set method [set ::${type}($message)]
		set comp(i) $comp(prev)	
	}
	AppendObjectCode $object $method
}

proc CompObject {objtype} {	
	global comp
	AppendMethod $comp(word) $objtype
}

# Replaces the dummy "obj" in the appended method code by 
# the current object's name
proc AppendObjectCode {object method} {
	global comp 
	set code [string map "obj $object" $method]
	append comp(code) "$code ; "
}

# Handles the Forth stack diagram { in1 .. | local1 .. -- out1 .. }
# Accepts short form {} and {--} for empty diagrams
proc CompileStack {} {
	global comp locals
	array unset locals   
	set comp(in) {} ; set comp(out) {} ; set stackvar true
	GetItem
	if {$comp(word)=="\{\}"} return
	if {$comp(word)=="\{--\}"} return
	if {$comp(word)!="\{"} {error "stack diagram missing"}  
	GetItem 
	while {$comp(word) != "--"} {
		if {$comp(word)=="\}"} {error "stack error: missing '--'"}
		if {$comp(word)==""} {error "stack error: missing '--'"}
		if {$comp(word)=="|"} {set stackvar false; GetItem; continue} 
		if $stackvar {
			set comp(in) [linsert $comp(in) 0 "set $comp(word) \[pop\] ; "]
		} {
			set comp(in) [lappend comp(in) "set $comp(word) 0 ; "] 
		}
		set locals($comp(word)) {variable}
		GetItem
	}
	GetItem 
	while {$comp(word) != "\}" } {
		if {$comp(word)==""} {error "stack error: missing '\}'"}
		set comp(out) [lappend comp(out) "push \$$comp(word) ; "] 
		set locals($comp(word)) {variable}
		GetItem
	}
	set comp(in) [join $comp(in)]
	set comp(out) [join $comp(out)]
}

# Returns true if word is a number (int, double, decimal, octal, hex)
proc isNumber {word} {	
	return [expr [string is integer -strict $word]||[string is double -strict $word]]
}

proc isLocal {word} {
	global locals
	expr {[array names locals -exact $word]!=""}
}

proc isString {} {
	global comp
	if {[string first {"} $comp(word)]==0} {
		set comp(i) $comp(prev); PushText
		return 1
	} {
		return 0
	}
}

proc isList {} {
	global comp
	if {[string first \{ $comp(word)]==0} {
		set comp(i) $comp(prev); PushList
		return 1
	} {
		return 0
	}
}

proc CompileColon {} {
	global comp lcname locals words 
	while {$comp(word) != "" } {
		if [isLocal $comp(word)] {
			set object $comp(word);  
			set type $locals($object)
			AppendMethod $object ::$type
		}  {
			if [info exists words($comp(word))] {
				uplevel #0 {eval $words($comp(word))}			
			} else {
				if [isNumber $comp(word)] {
					append comp(code) "push $comp(word) ; "
				} {
					if {![isString]&&![isList]} {ShowCompCode; error "$comp(word) is undefined"; }
				}
			}
		}
		GetItem 
	}
}

# To be overwritten in Forth Console
proc ShowCompCode {} {
	puts $::comp(code)
}

proc SetupInterpreter {} {
	global comp view locals doi doj dok 
	array unset locals
	set doi 0; set doj -1; set dok -2  
	set comp(code) {}; set comp(objtype) {}
}

proc InterpretText {} {
	global definer  
	SetupInterpreter
	set definer [string tolower [ GetItem ]]
	switch $definer {
		proc MakeProc
		tcl EvalTcl
		compiler MakeCompiler
		immediate MakeCompiler
		code MakeCode
		:  MakeColon
		objecttype MakeObjecttype
		datatype MakeObjecttype
		default EvalForth
	}
}

proc LoadUnit {} {
	InterpretText
	puts $::comp(code)\n
}

proc LoadForth {file} {
	global f
	set f [open $file r]; 	fconfigure $f -encoding binary
	while {[eof $f]==0} { 	
		GetUnit
		LoadUnit
	}
	close $f
}

# Print vectors, will be redefined for output to the console widget.
proc print {text} {
	puts -nonewline $text
}

proc printnl {text} {
	puts $text
}

