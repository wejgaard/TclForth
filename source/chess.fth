\ File:    chess.fth
\ Project: TclForth
\ Version: 0.56
\ License: Tcl
\ Author:  Wolf Wejgaard
\ 
\ A Forth version of Richard Suchenwirth's Chess in Tcl -- http://wiki.tcl.tk/4070
\

\ ===================================================================================
\ Model
\ ===================================================================================

{} array board

{} list history

"white" string toMove

: reset { | setup i x y -- }
	cast setup list
	{r n b q k b n r
	 p p p p p p p p
	 . . . . . . . .
	 . . . . . . . .
	 . . . . . . . .
	 . . . . . . . .
	 P P P P P P P P
	 R N B Q K B N R} 
	setup setlist	
	0 i set
	{8 7 6 5 4 3 2 1} {y} foreach	
		{A B C D E F G H} {x} foreach
			i setup "$x$y" board set  
			i incr
		repeat	
	repeat
	"white" toMove set 	
	{} history setlist ;

: color { c -- color }	
	c ascii 97 < if "white" else "black" then color set ;

Code sameSide? { a b -- f }  
	set f [regexp {[a-z][a-z]|[A-Z][A-Z]} $a$b]

"white" variable side

: coords { square -- x y }  
	{} square split y set ascii 64 - x set ;

: square { x y -- sq } 	
	x 64 + char x set "$x$y" sq set ;

: valid? { move | from to fromMan toMan x y x0 y0 x1 y1 dx dy adx ady -- result } 
	"-" move split to set from set
	to {} = if 0 return then
	from board fromMan set to board toMan set
	fromMan color toMove != if 0 return then
	fromMan toMan sameSide? if 0 return then
	from coords y0 set x0 set  to coords y1 set x1 set
	x1 x0 - dup dx set abs adx set  y1 y0 - dup dy set abs ady set
	fromMan tolower "n" !=  adx not ady not or adx ady = or  and 
	if	x0 x set  y0 y set
		begin x x1 != y y1 != or while 
			x x0 != y y0 != or 	
			x y square board "." != and 
			if 0 return then   \ planned path is blocked
			dx sgn x add  dy sgn y add
		repeat
	then
	fromMan tolower case
		k of adx 2 < ady 2 < and return endof
		q of adx 0= ady 0= or adx ady = or return endof
		b of adx ady = return endof
		n of adx 1 = ady 2 = and adx 2 = ady 1 = and or return endof
		r of adx 0= ady 0= or return endof
	endcase
	fromMan case
		P of y0 2 = dy 2 = and  dy 1 = or  dx 0= toMan "." = and  and
			adx 1 = ady 1 = and "p" toMan sameSide? and  or return endof
		p of y0 7 = dy -2 = and dy -1 = or  dx 0= toMan "." = and  and
			adx 1 = ady 1 = and "P" toMan sameSide? and  or return endof
	endcase 
	0 result set ;

: validMoves { from | to move victim -- result }
	cast move string cast result list 
	{} result setlist
	board names {to} foreach
		"$from-$to" move set
		move valid? if
			to board victim set
			"-$victim" move append 
			move result append
		then
	repeat
	result sort ;

{k king q queen b bishop n knight r rook p pawn} array Name

{k 0 q 9 b 3.2 n 3 r 5 p 1 . 0} array Value

: values { | square man whitesum blacksum -- result }
	board names {square} foreach
		square board  man set
		man tolower Value 
		man color "white" = if whitesum add else blacksum add then
	repeat
	"w:$whitesum  b:$blacksum " result set ;

\ ===================================================================================
\ View
\ ===================================================================================

: Chessboard { -- }
	".t" "toplevel" Widget top
	"Chess in Forth" top title
	"? {console show}" top bind
	"<Escape> exit" top bind 
	"$::top.c" Canvas w 
	"-height 300 -width 300" w config
	"-fill both -expand 1" w pack
	"$::top.f" "frame" Widget frame 
;

0 variable info

Code Panel { -- }
	label  $::frame.e -width 30 -anchor w -textvar info -relief sunken
	button $::frame.u -text Undo  -command {undo; drawSetup}
	button $::frame.r -text Reset -command {reset; drawSetup}
	button $::frame.f -text Flip  -command {flipSides}
	eval pack [winfo children $::frame] -side left -fill both
	pack $::frame -fill x -side bottom
	trace add variable ::toMove write doMoveInfo 
	set ::info "white to move"

0 variable X

0 variable Y

{#ffd39b #6e8b3d} list cColors

: manPolygon { man -- shape }
	man tolower case
	b of {-10 8 -5 5 -9 0 -6 -6 0 -10 6 -6 9 0 5 5 10 8 6 10 0 6 -6 10} endof
	k of {-8 10 -10 1 -3 -1 -3 -3 -6 -3 -6 -7 -3 -7 -3 -10
			3 -10 3 -7 6 -7 6 -3 3 -3 3 -1 10 1 8 10} endof
	n of {-8 10 -1 -1 -7 0 -10 -4 0 -10 6 -10 10 10} endof
	p of {-8 10 -8 7 -5 7 -2 -1 -4 -5 -2 -10 2 -10 4 -5 2 -1 5 7 8 7 8 10} endof
	r of {-10 10 -7 1 -10 0 -10 -10 -5 -10 -5 -6 -3 -6 -3 -10
   			3 -10 3 -6 5 -6 5 -10 10 -10 10 0 7 1 10 10} endof
	q of {-6 10 -10 -10 -3 0 0 -10 3 0 10 -10 6 10} endof
	endcase shape set ;

35 variable sqw

: center { x0 y0 x1 y1 -- xc yc }  
	x0 x1 + 2/ xc set  y0 y1 + 2/ yc set ;

: drawMan { where what -- } 
	what "." = if return then
	what manPolygon  
	what uppercase? if "white" "black" else "black" "gray" then 
	"mv @$where" w polygon
	"@$where" 0 0 sqw 0.035 * dup w scale
	"@$where" "$where"	w bbox center  w move ;

: drag { x y -- }  
	"current" x X - y Y - w move  x X set y Y set  ;

: bindBoard { -- }
	{<Configure> drawBoard} w bind  
	{mv <1> "push $::w; push %x; push %y; click"} w bindtag
	{mv <B1-Motion> "push %x; push %y; drag"} w bindtag
	{mv <ButtonRelease-1> "push %x; push %y; release"} w bindtag ;

: drawSetup { | x y -- }
	"mv" w delete
	9 1 do 9 1 do
		I y set J 64 + char x set "$x$y" dup board drawMan
	loop loop ;

: drawBoard { | x0 x y rows row cols col cIndex tag -- }
	cast rows list  
	cast cols list
	w windowExists if "all" w delete then
	15 x0 set  x0 x set  5 y set  0 cIndex set 35 sqw set
	{8 7 6 5 4 3 2 1} rows setlist 	{A B C D E F G H} cols setlist
	side "white" != if rows revert cols revert then
	rows getlist {row} foreach
	 	7 y sqw 2/ + row w text
		cols getlist {col} foreach
			x y  sqw x add  x y sqw + cIndex cColors "square $col$row" w rectangle
			1 cIndex - cIndex set 
		repeat
		x0 x set sqw y add 
		1 cIndex - cIndex set 
	repeat
	x0 sqw 2/ - x set
	8 y add  \ letters go below chess board
	cols getlist {col} foreach sqw x add  x y col w text repeat
	drawSetup ;

: drawChess { -- }  
	Chessboard Panel w bindBoard reset drawBoard ;

\ ===================================================================================
\ Control
\ ===================================================================================

: moveInfo { -- }  
	"$::toMove to move - [values; pop]" info set ;

\ Need procedure to accept the three arguments for a trace command. The arguments are not used here. 
\ Note: The colon word moveInfo is called in a Tcl proc. 
proc doMoveInfo {- - -} {moveInfo}

Code getFrom { w -- from }  
	$w raise current
	regexp {@(..)} [$w gettags current] -> from

0 variable From

: click { w cx cy | move victim to fill newfill -- }
	cx X set  cy Y set
	w getFrom From set 
	From validMoves {move} foreach
		"-" move split victim set to set drop
		w to "-fill" ItemGet fill set
		fill "green" !=  fill "red" != and if
			victim "." = if "green" else "red" then newfill set
			w to "-fill" newfill ItemPut
			"$w itemconfigure $to -fill $fill" 1000 doafter
		then 
	repeat ;

: moveMan { move | to from FromMan -- ToMan }
	cast move string
	"-" move split  to set  from set
	from board FromMan set  to board ToMan set
	"-$ToMan" move append 
	FromMan to board set  "." from board set
	move history append
	toMove "white" = if "black" else "white" then toMove set ;

: distance { xa ya xb yb -- xd yd }  
	xa xb - xd set  ya yb - yd set  ;

: release { cx cy | to item tags victim target -- }
	cast tags list
	{} to set
	"overlap $cx $cy $cx $cy" w find {item} foreach
		item w gettags tags setlist   
		"square" tags search 0 >=	if tags pop to set break	then
	repeat
	"$::From-$to" valid? if  
		"$::From-$to" moveMan victim set  
		victim tolower "k" = if "Checkmate" info set  then
		"@$to" w delete
		"@$::From" "current" w dtag
		"@$to" "withtag" "current" w addtag
		to target set
	else From target set  \ go back on invalid move
	then
	"current"  target w bbox center  "current" w bbox center  distance  w move  ;

: undo { | from to hit -- }
	history length 0= if return then
	"-"  history pop split  hit set  to set  from set
	to board  from board  set
	hit {} = if "." else hit then to board set
	toMove "white" = if "black" else "white" then  toMove set ;

: flipSides { -- }
	"all" w delete
	side "white" = if "black" else "white" then side set
	drawBoard ;

drawChess

