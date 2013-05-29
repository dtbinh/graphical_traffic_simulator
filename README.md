graphical_traffic_simulator
===========================

A project made in netlogo to simulate traffic movement
WHAT IS IT?

This simulation basically aims to predict the best path for a car to reach from one point to another based on the constraints like path length, traffic lights and construction sites.

HOW IT WORKS

In this simulation cars have been constrained to move only on white patches which signify roads, the source is the white patch with min-pxcor and destination is the patch with max-pxcor.The time taken by each car to reach destination is recorded. If cars pass through a construction site then the time taken by car to reach destination is increased by 4 ticks. If any car waits at a traffic light then it adds to its time taken. This time taken is then used to calculate average time taken by cars for each path. 

We can create our own path in this simulation or load some saved paths. We can also load saved images of real life maps and then draw paths by superimposing on the paths in those maps and then use the simulation for finding the most optimal path. 

HOW TO USE IT

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

The best path is not always the path with shortest path, it rather depends on other factors like traffic lights, construction sites as well.

EXTENDING THE MODEL

Try to improve other constraints like speed-breakers as well.

RELATED MODELS

Traffic grid.

CREDITS AND REFERENCE

For the code for drawing the paths I used the code in model "Pac-man level editor". 

COPYRIGHT NOTICE

Copyright 2003 Uri Wilensky. All rights reserved.
Permission to use, modify or redistribute this model is hereby granted, provided that both of the following requirements are followed: 
a) this copyright notice is included. 
b) this model will not be redistributed for profit without permission from Uri Wilensky. 

Contact Uri Wilensky for appropriate licenses for redistribution for profit.

This model was created as part of the projects: PARTICIPATORY SIMULATIONS: NETWORK-BASED DESIGN FOR SYSTEMS LEARNING IN CLASSROOMS and/or INTEGRATED SIMULATION AND MODELING ENVIRONMENT. The project gratefully acknowledges the support of the National Science Foundation (REPP & ROLE programs) -- grant numbers REC #9814682 and REC-0126227.
