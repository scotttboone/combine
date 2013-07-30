#!/bin/tcsh

foreach i ( 2 3 4 5 6 7 8 9 10 11 12 13 )
    foreach j ( 2005003 2005004 2005005 2005006 2005007 )
	source combinescript.csh $i $j
    end
end
