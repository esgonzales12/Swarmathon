 ;----------------------------------------------------------------------------------------------

; Author: Arthur Gonzalez and Estefan Gonzales (Group 1)
; Date: 07/26/2020
; Title : Swarmathon 4
; School: CNM
; Course Number: CSCI 1108
; Course Title: CS for all: An Introduction to Computer Modeling
; Semester: Summer 2020
; Instructor: Dr. Chu Jong

 ;;Use the bitmap extension.
 extensions[bitmap]


  ;;1) use two breeds of robots: spiral-robots and DFS-robots
  ;add the spiral-robots breed here

  ;;DFS-robots breed
  breed [DFS-robots DFS-robot]                ;This initializes the two separate breeds of robots to perform our two different
  breed [spiral-robots spiral-robot]          ;search methods, the spiraling robots and the DFS robots.



  ;;2) spiral-robots need to know:
spiral-robots-own[

    ;;counts the current number of steps the robot has taken
  stepCount

    ;;the maximum number of steps a robot can take before it turns
  maxStepCount


    ;;is the robot searching?    ;Here we create the spiraling robot-owned variables for them to perform their functions. stepCount tracks the steps
  searching?                     ;of our spiraling robots, the maxStepCount is a value that the stepcount cannot reach without the robot making a turn.
                                 ;Searching? and Returning? are booleans established so we know whether or not they have found rocks.

    ;;is the robot returning?
  returning?
]




  ;;Updated from [Sw3] to be specific to DFS-robots.
  ;;DFS robots need to know:
  DFS-robots-own [
     ;;are they currently working with a list of rock locations? (in the processingList? state)
     processingList?

     ;;are they currently returning to the base? (in the returning? state)
     returning?

     ;;store a list of rocks we have seen
     ;;rockLocations is a list of lists: [ [a b] [c d]...[y z] ]            ;Here we initialize the DFS robot-owned variables for performing the DFS
     rockLocations                                                          ;search procedure we observed in Swarmathon 3. processingList? and
                                                                            ;returning? are booleans so we know whether the robot has found a rock
     ;;target coordinate x                                                  ;or is processing the list of rock locations. locX and locY are the active
     locX                                                                   ;targets for the DFS robots so they know where to head. InitialHeading
                                                                            ;stores the starting heading for these robots.
     ;;target coordinate y
     locY

     ;;what heading (direction they are facing in degrees) they start with
     initialHeading
    ]

  ;;patches need to know:
  patches-own [
     ;;base color before adding rocks   ;Our patches have a starting color that they store independently in order to
     baseColor                          ;return to that color once the rock on it has been picked up by a robot.
    ]

;------------------------------------------------------------------------------------
 ;;;;;;;;;;;;;;;;;;
 ;;    setup     ;; : MAIN PROCEDURE
 ;;;;;;;;;;;;;;;;;;
 ;------------------------------------------------------------------------------------
;Organize the code into main procedures and sub procedures.
to setup
  ca ;clear all
  cp ;clear patches
  bitmap:copy-to-pcolors bitmap:import "parkingLot.jpg" true    ;The setup button creates the environment as well as the rocks for the robots to collect.
  reset-ticks ;keep track of simulation runtime                 ;This calls on clear all and clear patches then imports the environment jpeg which
                                                                ;in this case is the parking lot. Afterwards it initializes ticks and calls on the
  ;setup calls these three sub procedures.                      ;robot spawning procedure, the rock spawning procedure and the base creation procedure.
  make-robots
  make-rocks
  make-base
end

;This sub procedure has been completed for you.
;------------------------------------------------------------------------------------
;------------------------------------------------------------------------------------
to make-rocks
   ask patches [ set baseColor pcolor]

   if distribution = "cross" or distribution = "random + cross" or distribution = "large clusters + cross"
   or distribution = "clusters + cross" or distribution = "random + clusters + cross"
   or distribution = "random + clusters + large clusters + cross"[make-cross]

   if distribution = "random" or distribution = "random + cross" or distribution = "random + clusters"
   or distribution = "random + large clusters" or distribution = "random + clusters + cross"
   or distribution = "random + clusters + large clusters + cross" [make-random]

   if distribution = "clusters" or distribution = "clusters + cross" or distribution = "random + clusters"
   or distribution = "clusters + large clusters" or distribution = "random + clusters + cross"
   or distribution = "random + clusters + large clusters + cross" [make-clusters]


   if distribution = "large clusters" or distribution = "large clusters + cross"              ;This is the main function defining the make-rocks procedure.
   or distribution = "random + large clusters"  or distribution = "clusters + large clusters" ;Depending on the values of the drop down "distribution"
   or distribution = "random + clusters + large clusters + cross" [make-large-clusters]       ;selection on the interface the patches will change their
                                                                                              ;colors depending on the sub procedure called.
end

;Fill in the next sub procedure.
;------------------------------------------------------------------------------------
;; Create the number of spiral-robots equal to the value of the numberOfSpiralRobots slider.
;; Set their properties and their variables that you defined previously.
;; The create block for DFS-robots is identical to the code used for creating the
;; robots ins Swarmathon 3.
to make-robots

  ;;1) Create the number of spiral-robots based on the slider value.
  create-spiral-robots numberOfSpiralRobots[  ;The amount of spiraling robots spawned is equal to the variable slider numberOfSpiralRobots on the interface.


    ;;Set their size to 5.
    set size 5


    ;;Set their shape to "robot".
    set shape "robot"


    ;;Set their color to a color other than blue.
    set color red


    ;;Set maxStepCount to 0.     ;Here we define the main procedure for spawning our robots. First are the spiraling robots. The robots have size 5, shape of robot, and are
    set maxStepCount 0           ;red in color. We begin their maxStepCount and stepCount values at 0. Afterwards we initialize their booleans searching?
                                 ;and returning?, their searching? starts as true since they have not found any rocks and their returning? is false
                                 ;due to the same condition. Afterwards, in order to achieve a greater variety of spiraling trajectories we take the
    ;;Set stepCount to 0.        ;robot identification number of our spiraling robots, which is unique to all robots and multiply it by 90. This new
    set stepCount 0              ;number that is a multiple of 90 is the heading of our spiraling robots. After this has concluded we move to the spawn
                                 ;of our DFS robots.

    ;;Set searching? to true.
    set searching? true


    ;;Set returning? to false.
    set returning? false


    ;;Set their heading to who * 90--who is an integer that represents the robot's number.
    ;;So robots will start at (1 * 90) = 90 degrees, (2 * 90) = 180 degrees...etc.
    ;;This prevents the spirals from overlapping as much.
    set heading who * 90
  ]


  ;;Create the number of DFS-robots based on the slider value.
  create-DFS-robots numberOfDFSRobots[  ;The amount of DFS robots spawned is equal to the amount defined by the variable interface slider numberOfDFSRobots.

    ;;Set their size to 5.
    set size 5

    ;;Set their shape to "robot".     ;Our DFS robots begin with the same shape and size, with color blue instead. We initialize our boolean values here.
    set shape "robot"                 ;processingList? is beginning as false because our list starts empty. returning? is also false since we have
                                      ;not found any rocks. our variable rockLocations (a list) begins empty since we use this to store rock locations.
    ;;Set their color to blue.        ;Our target variables defined by locX and locY begin at 0 to denote we are at base. Our initial heading
    set color blue                    ;is a random number between 0 and 359.

    ;;Set processingList? to false.
    set processingList? false

    ;;Set returning? to false.
    set returning? false

    ;;Set rockLocations to an empty list.
    set rockLocations []

    ;;Set locX and locY to 0.
    set locX 0
    set locY 0

   ;;Set initialHeading to a random degree.
    set initialHeading random 360

    ;;Set the robot's heading to the value of initialHeading.
    set heading initialHeading

  ]

end

;------------------------------------------------------------------------------------
;;Place rocks in a cross formation.
to make-cross
  ask patches [
    ;;Set up the cross by taking the max coordinate value, doubling it, then only setting a rock if the
    ;;x or y coord is evenly divisible by that value.
    ;;NOTE: This technique assumes a square layout.
    let doublemax max-pxcor * 2
    if pxcor mod doublemax = 0 or pycor mod doublemax = 0 [ set pcolor yellow ]
  ]
end

;------------------------------------------------------------------------------------
;;Place rocks randomly.
to make-random
   let targetPatches singleRocks
     while [targetPatches > 0][
       ask one-of patches[
         if pcolor != yellow[
           set pcolor yellow
           set targetPatches targetPatches - 1
         ]
       ]
     ]
end

;------------------------------------------------------------------------------------
;;Place rocks in clusters.
to make-clusters
   let targetClusters clusterRocks
     while [targetClusters > 0][
       ask one-of patches[
         if pcolor != yellow and [pcolor] of neighbors4 != yellow[
           set pcolor yellow
           ask neighbors4[ set pcolor yellow ]
           set targetClusters targetClusters - 1
         ]
       ]
     ]
end

;------------------------------------------------------------------------------------
;;Place rocks in large clusters.
to make-large-clusters
   let targetLargeClusters largeClusterRocks
   while [targetLargeClusters > 0][
     ask one-of patches[
       if pcolor != yellow and [pcolor] of patches in-radius 3 != yellow[
         set pcolor yellow
         ask patches in-radius 3 [set pcolor yellow]
         set targetLargeClusters targetLargeClusters - 1
       ]
     ]
     ]
end

;------------------------------------------------------------------------------------  ;Here we define our rock creation functions as well as our
;Make a base at the origin.                                                            ;procedure to create the base. These functions are as they were
to make-base                                                                           ;in Swarmathon 3, other than the base function.
  ask patches[                                                                         ;The base function now creates a larger green patch at the center.
    if distancexy 0 0 < 4 [set pcolor green]
  ]

end
;------------------------------------------------------------------------------------
;------------------------------------------------------------------------------------
;------------------------------------------------------------------------------------
 ;;;;;;;;;;;;;;;;;;;;;;;;;
 ;;    ROBOT CONTROL    ;; : MAIN PROCEDURE
 ;;;;;;;;;;;;;;;;;;;;;;;;;
 ;------------------------------------------------------------------------------------
 ;;1) Finish the robot-control procedure. The different breeds of robots will perform
 ;; different behaviors.

to robot-control

  if count patches with [pcolor = yellow] = 0 [stop]
  ;;ask the DFS-robots to DFS.
  ask DFS-robots[DFS]

  ;;ask the spiral-robots to spiral.                              ;The main robot-control function is defined here. We ask our two separate groups of
  ask spiral-robots[spiral]                                       ;robots, the spiraling and the DFS to execute the spiral and DFS procedures respectively.
                                                                  ;We then talk to all of our agents by addressing them as turtles and define the
                                                                  ;behavior for when we have the pen-down switch activated. This lets all agents draw
  ;; We can use 'turtles' to ask *all* agents to do something.    ;their paths when the switch is "on". We also tick on each completion of these procedures.
  ;; Ask the turtles
  ask turtles [
    ;; Use an ifelse statement.
    ;;If the pen-down? switch is on, put the pen down
    ifelse pen-down?
    [pen-down]

    ;;Else take the pen up.
    [pen-up]
  ]
   tick ;;tick must be called from observer context, move into main procedure.
end


;------------------------------------------------------------------------------------
;:::::::::::::::::::::::::::::   SPIRAL ROBOT BEHAVIOR  :::::::::::::::::::::::::::::
;------------------------------------------------------------------------------------
 ;;;;;;;;;;;;;;;;;;;
 ;;    spiral     ;; : MAIN PROCEDURE
 ;;;;;;;;;;;;;;;;;;;
 ;------------------------------------------------------------------------------------
;;1) Write the spiral procedure.
 to spiral

   ;;If the robots can't move, they've hit the edge. They need to go back to the base and start a new spiral.
   ;;Also reset their variables so they can start over.
  if not can-move? 1 [
                                                                  ;This defines behavior for the main spiral procedure used by our spiral robots.
                                                                  ;We begin with conditions for reaching the boundaries of the world. When the robot
   ;;Set returning? to true to get them to go back to the base.   ;reaches the edge of the world and cannot move it sets its returning? boolean
    set returning? true                                           ;true so it will call on the return-to-base-spiral procedure. It also reduces its
                                                                  ;stepCount and maxStepCount values to 0 so the robot will not continue searching in
                                                                  ;a spiral. After this the condition for behavior based on the returning? boolean
   ;;Set stepCount and maxStepCount back to 0.                    ;is established.
    set stepCount 0
    set maxStepCount 0
  ]


 ;;If they are returning? they should do the return-to-base-spiral procedure.
  if returning? [return-to-base-spiral]


 ;;The following code makes a spiral.
 ;;The robot increases the distance it travels in a line
 ;;before making a left turn.

 ;;if the robot's stepCount is greater than 0,   ;Our function within this procedure asks our spiraling robots the value of stepCount in an ifelse
  ifelse stepCount > 0[                          ;statement. While the stepCount is greater than 0 and the robot is searching? the robot will move
                                                 ;foward one step and call on the look-for-rocks procedure. After this the stepCount is reduced by
                                                 ;1 in order to track steps in terms of when the spiraling robots will need to turn. Per the ifelse
   ;;if the robot is searching?                  ;based on stepCount, when the stepcount is 0 the robot knows that it is time to turn. While there
    if searching?[                               ;are no more steps the robot turns the amount defined by the variable slider turnAngle to the left.
                                                 ;It then manages its maxStepCount value and increases it by one afterwards setting the stepCount
                                                 ;value equal to the new maxStepCount value so the robot can continue to move in a spiral.
     ;;Go forward 1.
      fd 1


     ;;look-for rocks,
      look-for-rocks


     ;;then reduce stepCount by 1.
      set stepCount stepCount - 1
    ]
  ]


 ;Else, no steps remain.
  [

   ;; the robot should turn left based on the value of turnAngle,
    left turnAngle


   ;;increase the maxStepCount by 1,
    set maxStepCount maxStepCount + 1


   ;;then set the value of stepCount to the value of maxStepCount.
    set stepCount maxStepCount
  ]

 end

 ;Fill in the next two sub procedures.
 ;------------------------------------------------------------------------------------
 ;;1) Write look-for-rocks the same way you did for Swarmathon 1 (before site fidelity).

 to look-for-rocks
   ;;Ask the 8 patches around the robot (neighbors)
  ask neighbors[

     ;;if the patch color is yellow,
    if pcolor = yellow[


     ;;  Change the patch color back to its original color.  ;This defines the look-for-rocks procedure. The robot asks the 8 surrounding patches
      set pcolor baseColor                                   ;their color, if the color is yellow it turns its baseColor and the robot then changes
                                                             ;its searching? off and its returning? true since it has found a rock. The robots
                                                             ;shape is then changed to reflect that it is holding a rock.
       ;; The robot asks itself to:
      ask myself [


         ;; Turn off searching?,
        set searching? false


         ;; Turn on returning?,
        set returning? true


         ;; and set its shape to the one holding the rock.
        set shape "robot with rock"
      ]
    ]
  ]


 end

 ;------------------------------------------------------------------------------------
 ;;2) Write return-to-base-spiral.
 ;; We want to make a separate procedure for returning for the spiraling robots.
 ;; This is largely a design decision. We could add modify our existing DFS
 ;; return-to-base procedure to make it work for spiral robots, but this way we can keep the
 ;; code for both completely separate, whch makes it easier to read (and troubleshoot!).
 ;; return-to-base-spiral is much like return-to-base from Swarmathon 1,
 ;; but with the condition that the robot sets its heading to one of the cardinal
 ;; directions upon returning home.

 to return-to-base-spiral

   ; If we've reached the origin, we're at the base.  ;Here we define the return-to-base-spiral procedure. While there is a return-to-base procedure
  ifelse pxcor = 0 and pycor = 0[                     ;already, our spiraling robots have a different coded method for setting their headings from
                                                      ;base since they travel in a spiral. This function is made to establish that difference.
                                                      ;This function begins with an ifelse, given the coordinates of the robot are that of the base
                                                      ;they set searching? true and returning? false, their shape is changed to reflect that they
     ;;set searching? to true,                        ;have dropped off their rock and then set their heading, this is unique to the spiraling robots.
    set searching? true                               ;We mentione earlier that the heading of the spiraling robots is in multiples of 90 based off
                                                      ;of the individual robot owned identification number. This is how the heading is established in
                                                      ;the return-to-base-spiral procedure. This is all performed assuming the coordinates are 0 0,
     ;set returning? to false,                        ;if they are not the robot faces coordinates 0 0 (base) and proceeds to move forward 1.
    set returning? false


     ;set its shape to the robot without the rock
    set shape "robot"


     ;;choose a cardinal direction for the robot.
    set heading who * 90
  ]


   ;;Else we're not at the origin/base yet--face it.
  [facexy 0 0]


   ;;Go forward 1.
  fd 1

 end

;------------------------------------------------------------------------------------
;:::::::::::::::::::::::::::::    DFS ROBOT BEHAVIOR  :::::::::::::::::::::::::::::::
;------------------------------------------------------------------------------------
 ;;;;;;;;;;;;;;;;;
 ;;    DFS      ;; : MAIN PROCEDURE
 ;;;;;;;;;;;;;;;;;
 ;------------------------------------------------------------------------------------

to DFS

  ;;Put the exit condition first. Stop when no yellow patches (rocks) remain.
  if count patches with [pcolor = yellow] = 0 [stop]

  ;;All sub procedures called after this (set-direction, do-DFS, process-list) are within the ask robots block.
  ;;So, the procedures act as if they are already in ask robots.
  ;;That means that when you write the sub procedures, you don't need to repeat the ask robots command.


  ask DFS-Robots [                                                             ;Defines the main DFS procedure for the DFS-Robots.
                                                                               ;If the robot cannot move at all its reached a boundary so it proceeds
                                                                               ;to call on the do-DFS procdure. This is followed by an ifelse in the
   ;;If the robot can't move, it must've reached a boundary.                   ;same command block, given the rockLocations are not empty the robot
    if not can-move? 1[                                                        ;will set the processingList? boolean true, otherwise the rockLocations
     ;;Add the last rock to our list if we're standing on it by calling do-DFS.;list is empty the robot will turn the returning? boolean to true in order
      do-DFS                                                                   ;to go back to base. After the conditions for not being able to move are
                                                                               ;established our next if statement, this calls the process-list function
     ;;If there's anything in our list, turn on the processingList? status.    ;given our processList? boolean is true and the robot is not returning to
      ifelse not empty? rockLocations                                          ;base. The next if statement has the robot call on the return-to-base
      [set processingList? true]                                               ;procedure while returning? is true. The next if statement asks the state
                                                                               ;of the processingList? and returning? booleans, given they are both false
                                                                               ;the robot will call the do-DFS procedure in order to search and find rocks.
     ;;else go home to reset our search angle.
      [set returning? true]
  ]


   ;;Main control of the procedure goes here in an ifelse statement.
   ;;Check if we are in the processing list state and not returning. If we are, then process the list.
   ;;(While we are processing, we'll also sometimes be in the returning? state
   ;;at the same time when we're dropping off rocks.
   ;;Robots should only process the list though when they're not dropping off a rock.
      if processingList? and not returning? [process-list]

   ;;If returning mode is on, the robots should return-to-base.
      if returning? [return-to-base]

   ;;Else, if the robots are not processing a list and not returning, they should do DFS.
      if not processingList? and not returning? [do-DFS]

  ]

end

;------------------------------------------------------------------------------------
 ;;;;;;;;;;;;;;;;;;
 ;; process-list ;; : MAIN PROCEDURE
 ;;;;;;;;;;;;;;;;;;
;------------------------------------------------------------------------------------
to process-list

  ;;Control the robots based on the status of their internal list of rocks.
  ;;If the robot's list is not empty:
  ifelse not empty? rockLocations[

   ;If locX and locY are set to 0, then we just started or we just dropped off a rock.             ;Defines the process-list procedure. This begins with
    if locX = 0 and locY = 0 [                                                                     ;an ifelse statement, given the rockLocations list
                                                                                                   ;is not empty the robot is asked if its coordinates
                                                                                                   ;are that of the base, if they are their target
    ;;If they are, then we need a new destination, so reset our target coordinates, locX and locY. ;coordinates are reset by calling the reset coords
    ;;We'll write the code for that in a sub procedure, so just call the procedure for now.        ;procedure. After the coordinates are established,
      reset-target-coords                                                                          ;whether they are at base or otherwise we can then
    ]                                                                                              ;call the move-to-location procedure to pursue
                                                                                                   ;our target coordinates. Per our ifelse statement
    ;;Now move-to-location of locX locY.                                                           ;given the rock locations are empty, processingList?
    ;;We'll write the code for that in a sub procedure, so just call the procedure for now.        ;is false. After ifelse concludes the robot moves
    move-to-location                                                                               ;forward one step.
  ]

  ;;rockLocations is empty. We're done processing the list.
  [set processingList? false]

  ;;Go forward 1 step.
  fd 1

end

;------------------------------------------------------------------------------------
;;Reset the robot's target coordinates when they are still processing the list but
;;have just dropped off a rock and don't know where to go.
;;Recall that rockLocations is a list of lists: [ [a b] [c d]...[y z] ]
to reset-target-coords

  ;;if rockLocations is not empty
  if not empty? rockLocations[

       ;;Grab the first element of rockLocations, a list of 2 coordinates: [a b]    ;Defines the procedure rest-target-coords procedure. Asks the robot
    let loc first rockLocations                                                     ;if the rockLocations list is empty, given it is not a local variable
                                                                                    ;list loc is established in order to give the robots a target. The
       ;;Now set robots-own x to the first element of this [a _]                    ;list loc pulls the first element from the rockLocations list
    set locX first loc                                                              ;once the robot has this element it pulls the values from the list
                                                                                    ;and sets them as their target coordinates, these are defined by
       ;;and robots-own y to the last. [_ b]                                        ;locX and locY, the first number in the element pulled from the list
    set locY last loc                                                               ;is the x coordinate. After the target coordinates are established
                                                                                    ;the coordinates the robot is targetting are removed from rockLocations
                                                                                    ;after all the robot who just used them is already on its way.

       ;;and keep everything but the first list of coords (the ones we just used)
       ;;in rockLocations. --> [ [c d]...[y z] ]
       set rockLocations but-first rockLocations
  ]

end
;------------------------------------------------------------------------------------

;;The robot arrived at its locX locY. Pick up the rock and set the robot's mode
;;to returning so it can drop off the rock. Remain in processing state so the robot goes
;;back to processing the list after dropping off the rock.
to move-to-location


  ;;If we've reached our target coordinates locX and locY,                          ;Defines the move-to-location procedure, this begins with and ifelse
  ifelse (pxcor = locX and pycor = locY)[                                           ;statement. Given the current patch coordinates are equal to the
                                                                                    ;coordinates that are defined by the targets locX and locY the robot
                                                                                    ;has found a rock, the rocks shape is changed to reflect it carrying
       ;; pick up the rock by setting the robot's shape to the one holding the rock,;the rock it has found, then the patch the rock was found on is
    set shape "robot with rock"                                                     ;asked to change its color back to its starting color. After this
                                                                                    ;the robots returning? boolean is set to true since it has found a rock
       ;; and ask the patch-here to return to its base color.                       ;concluding the command for when a robot has reached its target location.
    ask patch-here [ set pcolor baseColor ]                                         ;Otherwise if the coordinates they are on are not the target coordinates
                                                                                    ;the robot will proceed to face the target coordinates defined by locX
       ;; Turn on returning? mode.                                                  ;and locY bringing it to its target.
       set returning? true
  ]

  ;Else the robot has not arrived yet; face the target location.
  [facexy locX locY]

 end

;------------------------------------------------------------------------------------
 ;;We've used the return-to-base procedure many times.
 ;;This time, we'll make some changes to support list processing.
 to return-to-base

 ;; If we're at the origin, we found the base.            ;Defines the procedure return-to-base, begins
  ifelse pcolor = green [                                 ;with an ifelse statement, given the robots
                                                          ;patch color is green (the robot is on base)
                                                          ;the robot then changes from holding the rock
 ;; Change the robot's shape to the one without the rock. ;back to "robot", the returning boolean is
    set shape "robot"                                     ;changed to false, and their target coordinates
                                                          ;as defined by locX and locY are set to 0 to
 ;; We've arrived, so turn off returning? mode.           ;signify the they are at base. After this is
    set returning? false                                  ;processed there is a second if statement within
                                                          ;the command block, while the robots processingList?
 ;; set locX                                              ;boolean is false the variable initialHeading
    set locX 0                                            ;is increased by the value defined by searchAngle
                                                          ;and then the robot faces the new initialHeading value.
 ;;and locy to 0. Robots will return to base if they don't find anything.
    set locY 0

  ;;Use an if statement. A robot can also be here if it has finished processing a list
  ;;of if it didn't find anything at the current angle and was sent back to base.
  ;;If this happened, change its heading so it searches in a different direction.
  ;;It will begin to search +searchAngle degrees from its last heading.
   if not processingList?[
     set initialHeading initialHeading + searchAngle
     set heading initialHeading
   ]
 ]

 ;; Else, we didn't find the origin yet--face the origin.   ;Otherwise the robot has not found the base and will face 0 0 and move forward.
 [ facexy 0 0 ]

 ;; Go forward 1.
 fd 1

 end

;------------------------------------------------------------------------------------
 ;;;;;;;;;;;;;;;;;
 ;; do-DFS      ;; : MAIN PROCEDURE
 ;;;;;;;;;;;;;;;;;
 ;------------------------------------------------------------------------------------
;;Write the do-DFS procedure. do-DFS finds rocks and stores them in a list.
to do-DFS                         ;Here we define the do-DFS procedure. This has the robot ask the patch it is on its color, if the color is yellow
                                  ;the robot creates a local variable that holds the coordinates of the rock it just found. Afterwards it manages
  ;;ask the patch-here            ;its robot-owned list rockLocations by adding the location values to the list of rockLocations while also
  ask patch-here[                 ;removing any duplicates on the list. After the list management based on its coordinates is complete the robot moves
                                  ;forward one step.
     ;;if its pcolor is yellow,
     if pcolor = yellow[

      ;;make a list of the coords of the rock we're on.
      let location (list pxcor pycor)

          ;;to add those coordinates to the front of their list of rocklocations and remove any duplicates.
         ask myself[ set rockLocations remove-duplicates (fput location rockLocations)]

     ]
  ]

  ;;Go forward 1.
  fd 1

end
@#$#@#$#@
GRAPHICS-WINDOW
235
13
748
527
-1
-1
5.0
1
10
1
1
1
0
0
0
1
-50
50
-50
50
0
0
1
ticks
5.0

BUTTON
14
10
81
44
setup
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
89
11
207
45
robot-control
robot-control
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

MONITOR
15
60
129
105
rocks remaining
count patches with [pcolor = yellow]
17
1
11

CHOOSER
17
148
225
193
distribution
distribution
"cross" "random" "clusters" "large clusters" "random + cross" "clusters + cross" "clusters + large clusters" "large clusters + cross" "random + clusters" "random + large clusters" "random + clusters + cross" "random + clusters + large clusters + cross"
11

SLIDER
17
199
189
232
singleRocks
singleRocks
0
100
50.0
5
1
NIL
HORIZONTAL

SLIDER
17
237
189
270
clusterRocks
clusterRocks
0
50
30.0
5
1
NIL
HORIZONTAL

SLIDER
18
338
190
371
numberOfDFSRobots
numberOfDFSRobots
0
10
6.0
1
1
NIL
HORIZONTAL

SLIDER
18
381
190
414
searchAngle
searchAngle
1
90
1.0
1
1
NIL
HORIZONTAL

SLIDER
18
453
191
486
numberOfSpiralRobots
numberOfSpiralRobots
0
10
0.0
1
1
NIL
HORIZONTAL

SWITCH
17
109
129
142
pen-down?
pen-down?
1
1
-1000

SLIDER
19
496
191
529
turnAngle
turnAngle
0
90
1.0
1
1
NIL
HORIZONTAL

TEXTBOX
19
324
169
342
sliders for DFS-robots\n
11
0.0
1

TEXTBOX
18
436
168
454
sliders for spiral-robots
11
0.0
1

SLIDER
17
282
189
315
largeClusterRocks
largeClusterRocks
0
20
5.0
1
1
NIL
HORIZONTAL

@#$#@#$#@
## WHAT IS IT?

Swarmathon 4 is another simulation of robot executed search procedures. Within this Swarmathon we take advantage of the DFS search from the previous Swarmathon and then add a spiral search. For these search procedures we have created two separate breeds of robots, those that DFS search and those that spiral search. The objective stays the same, the robots need to collect all of the rocks in the environment in order to complete their mission. For this mission we are in a parking lot. 

## HOW IT WORKS

The Swarmathon 4 project calls on a number of robot-owned, patch-owned, and local variables as well as a number of procedures. Procedures included in the simulation are: setup, make-robots, make-cross, make-random, make-clusters, make-large-clusters, make-base, make-rocks, DFS, process-list, reset-target-coords, move-to-location, return-to-base, do-DFS and few new spiraling procedures: spiral, return-to-base-spiral. Our robots own a number of variables. The first variable is a boolean value, this is processingList? our robots will behave accordingly whether this variable is true or false. The next variable is another boolean: returning?. After this we have rockLocations, this is a list the robots own in order to find and move towards patches that have rocks. The next variables are locX and locY wich are single numbers that the robots use as their target coordinates for a given rock. Our last robot-owned variable is initialHeading, this is changed depending on where we want our robot to face. Lastly of the variables we have a patches-owned variable: baseColor. This is used for all patches to track the first color that they have when they are created. Once all of our variables are established we can begin with the Setup procedure. The setup procedure creates our environment with a variable amount of rocks and hardcoded robot values. We call on 3 procedures to create the environment. make-robots creates the robots, make-rocks creates our rocks based off of interface sliders and make-base creates the green patch at the center of the world for our robots to use as a base of operations and starting point. Next we have our make-robots procedure, Our robots have the shape “robot” and a size of 5. processingList? and returning? begin as false, the rockLocations list also starts as an empty list ie “[]”. Our target coordinates locX and locY are also starting at 0 to signify they are at base so the robots can respond accordingly. Our robots initial heading is a random number between 0 and 360 degrees. This heading is a value that our robot-owned variable initialHeading is set equal to. After this we set the condition for when the pen-down? boolean is true, while it is true we have the pen down. Next we have our make-cross procedure, this allows for our environment to include cross shaped patches of rocks in our environment. This procedure uses math and gathers the maximum coordinates of a square, given a number of patches are able to evenly divide the maximum of the coordinate values in the direction of x or y then the patches will be turned yellow. This mathematical procedure creates the shape of a cross based off of the values of the environment. In order to make random single rocks in the environment we have a procedure make-random. This procedure randomly creates yellow patches given certain conditions are met. The procedure calls on the slider established variable singleRocks and sets the local variable targetPatches equal to that value. While the value is greater than 0 a random patch out of a list of all patches is asked its color, given it is not yellow or black the patch then turns yellow. After this concludes the value defined by the local variable targetPatches is reduced by one, ultimately concluding after the number defined by singleRocks is 0. In order to make clusters of rocks we have yet another rock procedure, this is called make-clusters. This procedure creates the relatively small rock clusters within the environment. The procedure calls on the slider established variable clusterRocks and then establishes a local variable targetRocks to be equal to this amount. After this a random patch pulled from the list of patches is asked its color while it is not yellow or black and its 4 surrounding neighbors are not yellow or black the patch and its neighbors are told to turn yellow. After this the targetCluster value established earlier is reduced by one, ultimately concluding after the value is empty. For the last of the rock procedures we have one that creates the largest clusters for the environment. This procedure is called make-large-clusters. The procedure calls on the slider established variable largeClusterRocks and sets a local variable targetClusters equal to that amount. After this a random patch is pulled from a list of all patches and asked its color as well as the color of patches in a 3 patch radius, given they are all not black or yellow the patches will turn yellow. After this concludes the amount of targetLargeClusters is reduced by one finishing when the value is 0. After we have all of our specific rock formations coded we have our base procedure, make-base. This procedure creates a green patch at the center of the world with coordinates 0 0. This procedure asks patches if their distance from coordinates 0 0 and given their is no distance the patch is turned green. Next we have our core rock building function, make-rocks. This procedure calls on the procedures for specific rock formations dependant on the variable drop down on the interface called distribution. This function is the core of how rocks in the environment are made. Now that all of the environmental business is out of the way we can begin searching for rocks. Our main procedure DFS does just this. The procedure begins with a condition for the end of the simulation, that is when there are no more yellow patches in the world we are told to stop. Given there are still rocks in the world we have a few if statements and commands to direct our robots. If the robot cannot move at all its reached a boundary so it proceeds to call on the do-DFS procdure. This is followed by an ifelse in the same command block, given the rockLocations are not empty the robot will set the processingList? boolean true, otherwise the rockLocations list is empty the robot will turn the returning? boolean to true in order to go back to base. After the conditions for not being able to move are established we reach our next if statement, this calls the process-list function given our processList? boolean is true and the robot is not returning to base. The next if statement has the robot call on the return-to-base procedure while returning? is true. The following if statement asks the state of the processingList? and returning? booleans, given they are both false the robot will call the do-DFS procedure in order to search and find rocks. At the end of these if statements and processing by robots there is a tick. The following procedure processing-list allows the robots to face their targets as defined by locX and locY in order to move towards rocks. This begins with an ifelse statement, given the rockLocations list is not empty the robot is asked if its coordinates are that of the base, if they are their target coordinates are reset by calling the reset coords procedure. After the coordinates are established, whether they are at base or otherwise we can then call the move-to-location procedure to pursue our target coordinates. Otherwise the rock locations are empty and processingList? is false. After ifelse concludes the robot moves forward one step. In order to make sure our target coordinates are accurate and we are headed towards our targets defined by locX and locY we have the reset-target-coords function. This procedure asks the robot if the rockLocations list is empty, given it is not a local variable list loc is established in order to give the robots a target. The list loc pulls the first element from the rockLocations list, once the robot has this element it pulls the values from the list and sets them as their target coordinates, these are defined by locX and locY, the first number in the element pulled from the list is the x coordinate. After the target coordinates are established the coordinates the robot is targetting are removed from rockLocations so our robots are not seeking the same rocks. So our robots will move to their target coordinates we have created a procedure: move-to-location. This begins with a conditional for whether or not their target coordinates are that of their target. Given the current patch coordinates are equal to the coordinates that are defined by the targets locX and locY the robot has found a rock, the rocks shape is changed to reflect it carrying the rock it has found, then the patch the rock was found on is asked to change its color back to its starting color. After this the robots returning? boolean is set to true since it has found a rock concluding the command for when a robot has reached its target location. Otherwise if the coordinates they are on are not the target coordinates the robot will proceed to face the target coordinates defined by locX and locY bringing it to its target. Next we have our procedure for having the robots return back to their starting point or base, which is the green patch at the center of the world, the robots ask the patch they are on its color and react appropriately. given the robots patch color is green the robot then changes its shape from holding the rock back to “robot”, the returning boolean is changed to false, and their target coordinates as defined by locX and locY are set to 0 to signify the they are at base. After this is processed there is a second if statement within the command block, while the robots processingList? boolean is false the variable initialHeading is increased by the value defined by searchAngle and then the robot faces the new initialHeading value. Finally we have our do-DFS procedure. This manages the working list of rock locations for all robots while having them inquire as to the color of any given patch. When the patch color is yellow the robot creates a local variable list called location that holds the coordinates of the rock found. The robot then adjusts its robot owned variable rockLocations list by adding its current recorded coordinates to the list and removing any duplicates. After this is done the robot moves forward. New to the Swarmathon 4 project are spiraling robots, for these robots to run effectively we have separate breeds of robots that are denoted by color. Blue robots run our DFS procedures using our classic Swarmathon 3 deterministic search, while red robots use a new spiral search. The spiral procedure calls on new spiral-robot-owned variables stepCount and maxStepCount in order to process the conditions for turning. The spiral procedure also uses classic robot-owned variables and procedures. Boolean variables like returning? and searching? are incorporated here as well as the look-for-rocks procedure and the return-to-base-spiral procedure. At the start of the spiral procedure we create a condition for when the robot has reaches the boundaries of the world, this only happens when the robot has achieved its full spiral from its starting point at spawn. When the robot reaches the boundaries of the world we reduce the stepCount and maxStepCount(these track steps to allow the robot to know when to turn) to 0 and set returning to true. In the spiral procedure we define behavior for when returning? is true, this condition has the robot call on the return-to-base spiral procedure. This procedure is similar to the return-to-base procedure however it is critical that the robot departs base with a spiraling heading that we create by multiplying the robot identification number by a multiple of 90. Other than the different conditions for the heading from base the return procedure is almost identical to the original return-to-base procedure. After the conditions for boundaries are established within the Spiral procedure we define the behavior of the spiral-robots while the searching? boolean is true with a preceeding qualification:  an ifelse statement for stepCount > 0. This means the stepcount being greater than 0 OR equal to 0 drives the main spiraling procedure, and as it happens the counts are managed within this procedure as well. So while our stepcount is greater than 0 our robots will move forward one and call on the look-for-rocks procedure and then reduce the stepCount by 1. The stepCount variable amount being reduced is the main notification to the robot that it is time to turn, so in the case our stepcount is 0 (per our ifelse statement) the robot will then turn to the left the amount defined by the variable slider turnAngle. After turning the robot manages the stepCounts by increasing maxStepcount by 1 and then setting the stepCount equal to the new value of maxStepCount creating a looping effect. This concludes the procedures and functionality within Swarmathon 4 with two breeds and two types of search logic. 



## HOW TO USE IT

Establish the variable sliders and drop downs on the interface to the environment and robot conditions you prefer. The two different types of searches performed by two different breeds of robots make for more sliders specific to each breed. Choose the search angles and amount of each while also selecting the distribution and amount of rocks you would like in the environment. You have one more option that you can establish during or before the simulation starts, this is the pen-down switch on the interface. If you would like to track the paths of the robots turn this switch on. Once you have configured the settings for the simulation initialize the environment and the robots by clicking the Setup button. Once you have the environment and robots you can click the robot-control button to begin the simulation. Pause the simulation at any time by clicking the robot-control button again. 

## THINGS TO NOTICE

Notice the different patterns the robots take by turning the pen-down switch on. Here you will be able to observe the red robots making spiraling patterns while the blue robots will continue in a more linear search pattern. Notice the ticks required based on different configurations of the variable sliders and values. Exhaustive search procedurally explores the entire world with varying directions and known locations. This is beneficial as having a method to explore every possible direction hardcoded into the program makes it so you don't have to wait on the random chance that a robot will arrive at the desired rock location. A wiggle walk will only be so predictable in its outcome and ability to find far isolated rocks, even though site fidelity assists other robots in finding larger clusters of rocks its almost entirely useless when locating rocks on the edges of the world. Deterministic search goes through all possibilities in a structured fashion while also keeping track of locations of rocks.  

## THINGS TO TRY

Try setting the DFS search angle to the smallest value for a quicker DFS search performed by the blue robots. Adjust the amounts of robots within the environment and attempt to find the most optimal settings for clearing the parking lot of rocks. What are good parameters for a 6 robot search with maximum rocks including clusters? After a number of trials the DFS seems to be the most effective in terms of overall ticks, so I set the search angle to 1 and spawned all 6 robots as DFS robots. This seemed to have the lowest average ticks required for the mission to finish. I believe this is the case since robots performing a DFS scan the world outward in segments. Thus the smaller the segments and turn angles the more rocks the robots will be able to collect by exploring virtually the entire environment. This theory held true when trying variations of both DFS and Spiraling robot ratios. 

## EXTENDING THE MODEL

We have now combined a couple of different search types within the Swarmathon projects, one not incorporated here is any use of pheromones to lead robots to patches of rocks it has located. Try including the pheromone function and see the results of having three different types of searching procedures to clear the environment. 

## NETLOGO FEATURES

N/A

## RELATED MODELS

N/A

## CREDITS AND REFERENCES

N/A
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

robot
true
1
Polygon -16777216 true false 75 60 105 15 135 15 90 75 75 60
Polygon -16777216 true false 225 60 195 15 165 15 210 75 225 60
Rectangle -16777216 true false 30 105 75 165
Rectangle -16777216 true false 30 210 75 270
Rectangle -16777216 true false 75 120 225 255
Rectangle -16777216 true false 225 210 270 270
Rectangle -16777216 true false 225 105 270 165
Rectangle -16777216 true false 90 120 210 195
Rectangle -2674135 true true 120 120 180 240
Rectangle -16777216 true false 195 225 210 240
Rectangle -16777216 true false 120 60 180 90
Rectangle -16777216 true false 135 90 165 120
Polygon -2674135 true true 180 75 210 90 210 105 180 90 180 75
Polygon -2674135 true true 120 75 90 90 90 105 120 90 120 75
Rectangle -7500403 true false 75 105 225 120
Line -2674135 true 90 120 90 240
Line -2674135 true 210 120 210 240
Line -2674135 true 135 90 165 90
Line -16777216 false 75 165 225 165
Line -16777216 false 75 180 225 180
Rectangle -7500403 true false 75 240 225 255

robot with rock
true
1
Rectangle -1184463 true false 120 0 180 45
Polygon -16777216 true false 75 60 105 15 135 15 90 75 75 60
Polygon -16777216 true false 225 60 195 15 165 15 210 75 225 60
Rectangle -16777216 true false 30 105 75 165
Rectangle -16777216 true false 30 210 75 270
Rectangle -16777216 true false 75 120 225 255
Rectangle -16777216 true false 225 210 270 270
Rectangle -16777216 true false 225 105 270 165
Rectangle -16777216 true false 90 120 210 195
Rectangle -2674135 true true 120 120 180 240
Rectangle -16777216 true false 120 60 180 90
Rectangle -16777216 true false 135 90 165 120
Polygon -2674135 true true 180 75 210 90 210 105 180 90 180 75
Polygon -2674135 true true 120 75 90 90 90 105 120 90 120 75
Rectangle -7500403 true false 75 105 225 120
Line -2674135 true 75 240 225 240
Line -2674135 true 90 120 90 240
Line -2674135 true 210 120 210 240
Line -2674135 true 135 90 165 90
Line -16777216 false 75 165 225 165
Line -16777216 false 75 180 225 180
Rectangle -7500403 true false 75 240 225 255

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

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

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.1.1
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
