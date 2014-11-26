\ File:    tk.fth
\ Project: TclForth
\ Version: 0.55
\ License: Tcl
\ Author:  Wolf Wejgaard
\ 

tcl package require Tk

\ ===================================================================================
\ General Widgets
\ ===================================================================================

\ Use: ".tkname" "type" Widget Forthname
\ Example: ".forth" "text" Widget Console
Objecttype Widget 
	instance   {uplevel #0 {set type [pop]; set obj [pop]; eval $type $obj}}
	{}         {push $obj}
	config     {eval $obj [concat configure [pop]]}
	pack       {eval [concat pack $obj [pop]]}
	bind       {eval [concat bind $obj [pop]]}
	wait       {tkwait window $obj}
	insert     {push [$obj index insert]}
	append     {$obj insert end [pop] ; $obj mark set insert end}
	delete     {swap ; $obj delete [pop] [pop]}
	yview      {$obj yview moveto [pop]}
	end        {push [$obj index end]}
	title      {wm title $obj [pop]}
	add        {eval $obj [concat add [pop]]}

\ ===================================================================================
\ Tk Menus
\ ===================================================================================

Objecttype Menu 
	instance   {uplevel #0 {set obj [pop]; menu $obj}}
	{}         {push $obj}
	addcommand {$obj add command -command [pop] -label [pop]}
	addmenu    {$obj add cascade -menu [pop] -label [pop]}

".menubar" Menu Menubar

\ Anchor Menubar in console window
tcl . config -menu .menubar

\ ===================================================================================
\ Canvas
\ ===================================================================================

Code createPoly { w polygon color outline tag -- }  
	$w create poly $polygon -fill $color -tag $tag -outline $outline

Code ItemGet { w tag field -- value }  
	set value [$w itemcget $tag $field]

Code ItemPut { w tag field value -- }  
	$w itemconfigure $tag $field $value

Code 3swap  { s1 s2 s3 -- s3 s2 s1 }

Code 4swap  { s1 s2 s3 s4 -- s4 s3 s2 s1 }

Code 5swap  { s1 s2 s3 s4 s5 -- s5 s4 s3 s2 s1 }

Code 6swap  { s1 s2 s3 s4 s5 s6 -- s6 s5 s4 s3 s2 s1 }

Code unlist { -- } set ::stack [join $::stack]

Objecttype Canvas  
	instance   {uplevel #0 {set obj [pop]; canvas $obj} }
	{}         {push $obj}
	create     {eval $obj [concat create [pop]]}
	text       {3swap; eval $obj [concat create text [pop] [pop] -text \"[pop]\"]}
	config     {eval $obj [concat configure [pop]]}
	set        {eval $obj [concat config [pop]]}
	rectangle  {6swap;	eval $obj [concat create rect [pop] [pop] [pop] [pop] -fill [pop] -tag \"[pop]\"]} 
	delete     {$obj delete [pop]}
	polygon    {4swap;	eval $obj [concat create poly \{[pop]\} -fill [pop] -outline [pop] -tag \"[pop]\"]} 
	scale      {5swap; eval $obj [concat scale \"[pop]\" [pop] [pop] [pop] [pop]]}
	move       {3swap; eval $obj [concat move [pop] [pop] [pop]]}
	bbox       {push [$obj bbox [pop]]; unlist}
	pack       {eval [concat pack $obj [pop]]}
	bind       {eval [concat bind $obj [pop]]}
	bindtag    {eval [concat $obj bind [pop]]}
	find       {push [eval $obj find [pop]]}
	gettags    {push [eval $obj gettags [pop]]}
	dtag       {$obj dtag [pop] [pop]}
	addtag     {3swap; $obj addtag [pop] [pop] [pop]}

\ ===================================================================================
\ Other
\ ===================================================================================

Code windowExists { w -- flag }  
	set flag [winfo exists $w]

\ Set title of main window
Code Title { text  -- }  
	wm title . $text

