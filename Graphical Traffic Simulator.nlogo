breed[cars car]
breed[nodes node]

globals [
endx endy
  startx starty
  best-path
  pos
  avg-time
  carsandpath
  possible-paths
  light-ahead
  flagf
  flagr
  flagl
  tool
  flagi
  minpath
  fastest
  slowest
  
]

turtles-own[
  glitch
  time-taken-short
  time-start-short
  car-recorded
  numconstrct
  time-recorded
  time-start
  time-taken
  mypath
  xcorlist
  ycorlist
  dir
  ]

;;lights-own[switch-time]

to get-blueprint
  import-pcolors image 
  set-starting
end

to setup
  clear-all
   
  set-default-shape nodes "circle"
  set best-path []
  set avg-time []
  set possible-paths []
    set carsandpath []
  set-default-shape cars "car"
  ask cars [set size 1]
  
  ask turtles [set color red]
end

to set-starting
  ask patches ;;with [pcolor = white]
  [if ((pxcor = min [pxcor] of patches ) and (pcolor = white))
    [set startx pxcor
    set starty pycor]]
  ask patches ;;with [pcolor = white]
  [if ((pxcor = max [pxcor] of patches ) and (pcolor = white))
    [set endx pxcor
    set endy pycor]]
end
to done
  ask patches [if (pcolor != white)
    [set pcolor green]]
  set-starting
end
to draw
  if mouse-down?
  [
    if tool = "Draw Roads"
    [ draw-boundary white ]
    
    if tool = "erase"
    [
      
      
      draw-boundary green
      
      ]
    
    if tool = "construction-site"
  [draw-boundary yellow]
  
  if tool = "create-node"
    [ask patch (round mouse-xcor) (round mouse-ycor) 
    [if not any? nodes-here
      [sprout-nodes 1[ set label ([who] of nodes-here)]
         ]
    ]
    ]
 
   if tool = "create-light"
    [ifelse random 100 > 50
      [draw-boundary red]
      [draw-boundary blue]]
  
  
  ]
   if tool = "remove-node"
    [if any? nodes-on patch (round mouse-xcor) (round mouse-ycor) 
      [ask nodes-on patch (round mouse-xcor) (round mouse-ycor) [die]]
      ]
end
 



;;to erase
 ;; if mouse-down? [
  ;;ask patch (round mouse-xcor) (round mouse-ycor)
  ;;[
    ;;set pcolor green
  ;;]
  ;;]
;;end

to draw-boundary [ boundary-color ]
  ask patch (round mouse-xcor) (round mouse-ycor)
  [
    
    set pcolor boundary-color 
      
  ]
end

to go
  ask cars
  [
    set flagl 1
    set flagr 1
    set flagf 1
    set flagi 0
    
    
    ask patch-ahead 1
    [if (pcolor = green)
      [set flagf 0]
    ]
    ask patch-left-and-ahead 90 1
    [if (pcolor = green)
      [set flagl 0]]
    
    ask patch-right-and-ahead 90 1
    [if (pcolor = green)
      [set flagr 0] ]
    
    ask patch-ahead 1
    [if (pcolor = red)
      [set light-ahead 1]
    ]
    ask patch-ahead 1
    [if (pcolor = blue)
      [set light-ahead 0]
    ]
    
    
    
    if((flagl = 0) and (flagr = 0) and (flagf = 1))
    [set heading heading + 0]
    
    if((flagl = 0) and (flagr = 1) and (flagf = 0))
    [set heading heading + 90]
    
    if((flagl = 1) and (flagr = 0) and (flagf = 0))
    [set heading heading - 90]
    
    if((flagl = 0) and (flagr = 1) and (flagf = 1))
    [
     
      set dir heading

      ifelse random 100 > 50
      [set heading heading + 90]
      [set heading heading + 0]
      set flagi 1
      ]
    
    if((flagl = 1) and (flagr = 0) and (flagf = 1))
    [
      set dir heading

      ifelse random 100 > 50
      [set heading heading - 90]
      [set heading heading + 0]
      set flagi 1]
    
    if((flagl = 1) and (flagr = 1) and (flagf = 0))
    [set dir heading

      ifelse random 100 > 50
      [set heading heading - 90]
      [set heading heading + 90]
      set flagi 1]
    
    if((flagl = 0) and (flagr = 0) and (flagf = 0))
    [set heading heading + 180]
    
    
    if((flagl = 1) and (flagr = 1) and (flagf = 1))
    [
      set dir heading

      ifelse random 100 < 66
      [ifelse random 100 > 50
        [set heading heading - 90]
        [set heading heading + 90]
      ]
      
      [set heading heading + 0]
    
    set flagi 1
    ]
    
    ;;set dir heading


    if (xcor = max-pxcor)
    [if(time-recorded = 0)
      [set time-taken-short (ticks - time-start-short)
        set time-taken ((ticks - time-start) + (4 * numconstrct))
        
        set time-recorded 1
      ]
      ifelse (not member? mypath possible-paths)
      [set possible-paths lput mypath possible-paths
        set carsandpath lput 1 carsandpath
        calc-avg
        set car-recorded 1
      ]
      
      [if (car-recorded = 0)
       [calc-avg
         set carsandpath replace-item (position mypath possible-paths) carsandpath ((item (position mypath possible-paths) carsandpath) + 1)
       set pos (position mypath possible-paths)
        
       set car-recorded 1]
       ]
      ;;if (not member? ([mypath] of cars with-min [time-taken])
      set minpath ([mypath] of one-of cars with-min [time-taken-short])
      set best-path   item (position (min avg-time) avg-time) possible-paths
      stop]
    
if (any? nodes-here)
[if (not member? ([who] of nodes-here) mypath)  
  [set mypath lput ([who] of nodes-here) mypath] ]
;;ifelse not any? turtles-on patch-ahead 1 
    
    ;;[
    
    
    ifelse (light-ahead = 0)
      [fd 1]
      [set time-start-short (time-start-short + 1)]
      ifelse (xcor >= max xcorlist )
      [if (not member? xcor xcorlist) 
        [set xcorlist lput xcor xcorlist]]
      [ifelse(flagi = 1)
       [ fd -1
        set heading dir
       ]
       [fd -1
         set heading heading - 180       
       ]
      ]
       
     ;;[if (dir = [dir - 180] of turtles-on patch-ahead 1) or (dir = [dir + 180] of turtles-on patch-ahead 1)
      ;;[fd 1]
      ;;]
   if (pcolor = yellow)
   [set numconstrct numconstrct + 1]
   
   
   ]
switch-color  
;;randomize-light
     set fastest ([who] of one-of cars with-min [time-taken])
      set slowest ([who] of one-of cars with-max [time-taken])
   
  
  tick
end

to again10
  create-cars 10[
    set time-start-short ticks
    set car-recorded 0
    set time-recorded 0
    set time-start ticks
    set mypath []
    set xcorlist [-16]
    set heading 90
    setxy startx starty 
    set size 1
    set flagl 1
    set flagr 1
    set flagf 1]
  
end
to again1
  create-cars 1[
    set time-start-short ticks
    set car-recorded 0
    set time-recorded 0
    set time-start ticks
    set mypath []
    set xcorlist [-16]
    set heading 90
    setxy startx starty 
    set size 1
    set flagl 1
    set flagr 1
    set flagf 1]
  
end
to switch-color
  ask patches
  [ifelse ((pcolor = red) and (ticks mod 5 = 0) )
    [set pcolor blue]
    [if ((pcolor = blue) and (ticks mod 5 = 0) )
    [set pcolor red]]
    ]
end

to randomize-light
 if ((ticks mod 80) = 0)
 
 
  [ask patches  
  [
  ifelse (random 2 = 0)
   
    [if (pcolor = red)
      [set pcolor blue]
    ]
    [if (pcolor = blue)
      [set pcolor red]]
  
  ]]
end

to calc-avg 
  ;;(position mypath possible-paths)
  set pos (position mypath possible-paths)
  
  ifelse (length avg-time = pos)
  [set avg-time lput time-taken avg-time]
[set avg-time (replace-item pos avg-time (round ((((item pos avg-time) * item pos carsandpath) + time-taken )/ ( (item pos carsandpath) + 1))))]
end  
to save-image
  export-view "useless.png"
end
 ;;to do-plots
  ;;set-current-plot "Time"
  ;;plot ticks
;;end
@#$#@#$#@
GRAPHICS-WINDOW
210
10
649
470
16
16
13.0
1
10
1
1
1
0
1
1
1
-16
16
-16
16
0
0
1
ticks

BUTTON
669
317
915
350
move-cars
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL

BUTTON
2
10
208
43
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL

BUTTON
3
312
207
345
use tool
draw
T
1
T
OBSERVER
NIL
NIL
NIL
NIL

BUTTON
2
345
131
378
draw roads
set tool \"Draw Roads\"
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL

BUTTON
779
358
1061
391
create 10 cars
again10
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL

BUTTON
134
368
205
401
erase
set tool \"erase\"
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL

BUTTON
1
378
130
411
create-node
set tool \"create-node\"
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL

MONITOR
649
10
1280
55
shortest-path
minpath
17
1
11

MONITOR
652
248
920
293
NIL
fastest
17
1
11

MONITOR
920
247
1236
292
NIL
slowest
17
1
11

BUTTON
2
445
130
478
construction site
set tool \"construction-site\"
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL

BUTTON
2
411
130
444
creat-light
set tool \"create-light\"
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL

MONITOR
650
53
1281
98
paths used till now
possible-paths
17
1
11

MONITOR
650
98
1281
143
cars count for each path
carsandpath
17
1
11

MONITOR
650
143
1281
188
average time taken on each path
avg-time
17
1
11

MONITOR
650
189
1282
234
best-path
best-path
17
1
11

CHOOSER
1
95
209
140
image
image
"newlightandpath.png" "pathandlight.png" "pathandlightwithconstrct.png" "shortestpath.png"
3

BUTTON
5
217
100
250
draw-own
done\n
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL

BUTTON
3
142
205
175
NIL
get-blueprint\n
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL

BUTTON
131
434
210
467
remove-node
set tool \"remove-node\"
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL

BUTTON
785
431
1057
464
save-image
save-image
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL

BUTTON
106
217
205
250
NIL
set-starting
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL

BUTTON
940
317
1180
350
create a car
again1
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL

@#$#@#$#@
WHAT IS IT?
-----------
This simulation basically aims to predict the best path for a car to reach from one point to another based on the constraints like path length, traffic lights and construction sites.


HOW IT WORKS
------------
In this simulation cars have been constrained to move only on white patches which signify roads, the source is the white patch with min-pxcor and destination is the patch with max-pxcor.The time taken by each car to reach destination is recorded.  If cars pass through a construction site then the time taken by car to reach destination is increased by 4 ticks. If any car waits at a traffic light then it adds to its time taken. This time taken is then used to calculate average time taken by cars for each path. 

We can create our own path in this simulation or load some saved paths. We can also load saved images of real life maps and then draw paths by superimposing on the paths in those maps and then use the simulation for finding the most optimal path. 


HOW TO USE IT
-------------
First pressing the "setup" button to intialise all the variables.
Then either load a preset design by using "get-blueprint" or press "draw-own" for drawing your own paths.
For drawing your own paths press on "draw roads" and then on "use-tool" then use mouse for drawing the roads. Use "traffic-lights", "construction sites" for coressponding use.

After making paths name the paths using "create nodes" for naming the paths. 

After that use "set-starting" for setting the source of car origin as the white patch with xcordinate as min-pxcor. 
There should also be a white patch with xcordinate as max-pxcor which will correspond to destination.

After all this create-cars and then use go button so that the cars start moving.

The reporters at left will tell about the shortest path, paths used till now, average time on each path. The list is read index relative ie first reading in the average path list will give the average time of the path which is first in the paths used till now list.  

Run the simulation atlest for 50 cars to get a correct reading.

THINGS TO NOTICE
----------------
The best path is not always the path with shortest path, it rather depends on other factors like traffic lights, construction sites as well.

EXTENDING THE MODEL
-------------------
Try to improve other constraints like speed-breakers as well.

RELATED MODELS
--------------
Traffic grid.

CREDITS AND REFERENCE
----------------------
For the code for drawing the paths I used the code in model "Pac-man level editor". 


COPYRIGHT NOTICE
----------------
Copyright 2003 Uri Wilensky. All rights reserved.
Permission to use, modify or redistribute this model is hereby granted, provided that both of the following requirements are followed: 
a) this copyright notice is included. 
b) this model will not be redistributed for profit without permission from Uri Wilensky. 

Contact Uri Wilensky for appropriate licenses for redistribution for profit.

This model was created as part of the projects: PARTICIPATORY SIMULATIONS: NETWORK-BASED DESIGN FOR SYSTEMS LEARNING IN CLASSROOMS and/or INTEGRATED SIMULATION AND MODELING ENVIRONMENT. The project gratefully acknowledges the support of the National Science Foundation (REPP & ROLE programs) -- grant numbers REC #9814682 and REC-0126227.
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
0
Rectangle -7500403 true true 151 225 180 285
Rectangle -7500403 true true 47 225 75 285
Rectangle -7500403 true true 15 75 210 225
Circle -7500403 true true 135 75 150
Circle -16777216 true false 165 76 116

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270

@#$#@#$#@
NetLogo 4.1.2
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 1.0 0.0
0.0 1 1.0 0.0
0.2 0 1.0 0.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180

@#$#@#$#@
0
@#$#@#$#@
