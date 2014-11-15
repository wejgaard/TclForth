TclForth provides the classic Forth structures as well as useful constructs courtesy of Tcl. The structures also work on the command line in the Forth console, contrary to classical Forth. TclForth always compiles, interpret is compile&execute. (more=>...)

###Flow Control###

####if else then#

    : test { n -- }   n 0= if "is 0" else "not 0" then . ;


####case of endof endcase#

    : test { item -- }    
     item case 
     77 of "is77" endof   
     abc of "isabc" endof  
     endcase . ;

###Conditional Loops#

####begin again break#

    : test  { n -- }  begin n incr  n .  n 10 > if break then  again  ;

####begin until#

    : test  { n -- }  begin n incr  n .  n 10 > until  ;

####begin while repeat#

    : test  { n -- }  begin n 10 < while  n incr  n . repeat  ;

###Counted Loops#

####do loop I J K#

    0 variable sum  101 0 do  I sum add  loop  sum .

    3 0 do 13 10 do 103 100 do  I . J . K . space  loop loop loop  


####leave#

    0 variable sum  101 0 do  I sum add  I 10 > if leave then  loop  sum .


####times#

    3 times "onemoretime" . repeat


####foreach#

Use:  {data} {args} foreach ... repeat <br>
args are locals defined in the stack diagram of the word

    : do-foreach  { list | x -- }  list {x} foreach x x * . repeat  ;

    {11 22 33} do-foreach

For immediate use provide x as a global variable

    0 variable x  {1 2 3 4} {x} foreach x 7 * . repeat


####exit = return#

    : count  { start limit -- }  
      begin start incr start dup . limit > if exit then again ;

    0 99 count



