
;Start with probe in hole, BELOW Z surface

; Wait until the planner queue is empty
%wait

; Set user-defined variables
%PROBE_DISTANCE = 20
%PROBE_FEEDRATE_A = 150
%PROBE_FEEDRATE_B = 50
%HOLE_DEPTH = 15
%PLATE_THICKNESS = 10

; for restoration at the end
%UNITS=modal.units
%DISTANCE=modal.distance

G91 ; Relative positioning
G21 ; Use millimeters

G10 L20 X0 Y0 ; set current position as xy zero for now

; Probe rear, slight right
G38.2 X1 Y[PROBE_DISTANCE] F[PROBE_FEEDRATE_A]
G1 Y-1 F[PROBE_FEEDRATE_B] ; back off a bit
G38.2 Y3 F[PROBE_FEEDRATE_B] ; probe again, slowly
G4 P1 ; wait for 1 second to ensure clear and accurate measure
%p1x = posx ; set the x/y coords for later
%p1y = posy

; set back to absolute mode and return to original spot
G90 
G0 X0 Y0
G91

; Probe 45deg
G38.2 X[PROBE_DISTANCE] Y[PROBE_DISTANCE] F[PROBE_FEEDRATE_A]
G1 X-1 Y-1 F[PROBE_FEEDRATE_B] ; back off a bit
G38.2 X3 Y3 F[PROBE_FEEDRATE_B] ; probe again, slowly
G4 P1 ; wait for 1 second to ensure clear and accurate measure
%p2x = posx ; set the x/y coords for later
%p2y = posy

; set back to absolute mode and return to original spot
G90 
G0 X0 Y0
G91

; Probe slight rear, far right
G38.2 X[PROBE_DISTANCE] Y1 F[PROBE_FEEDRATE_A]
G1 X-1 F[PROBE_FEEDRATE_B] ; back off a bit
G38.2 X3 F[PROBE_FEEDRATE_B] ; probe again, slowly
G4 P1 ; wait for 1 second to ensure clear and accurate measure
%p3x = posx ; set the x/y coords for later
%p3y = posy

; Figure out proper center https://stackoverflow.com/a/30106470 and set it
%ma = (p2y - p1y) / (p2x - p1x)
%mb = (p3y - p2y) / (p3x - p2x)
%cx = (ma * mb * (p1y - p3y) + mb * (p1x + p2x) - ma * (p2x + p3x)) / (2 * (mb - ma))
%cy = (-1 / ma) * (cx - (p1x + p2x) * 0.5) + (p1y + p2y) * 0.5

; Return to origin, move to true center, wait, set zero
G90 
G0 X0 Y0
G91
G0 X[cx] Y[cy]
G4 P1
G10 L20 X0 Y0

; Move up over the top, up and right to get over metal, probe down twice (quick, then slow) to get z height
G0 Z[HOLE_DEPTH]
G0 X15 Y15
G38.2 Z-25 F[PROBE_FEEDRATE_A] ;Fast Probe
G1 Z1 F[PROBE_FEEDRATE_B]
G38.2 Z-5 F[PROBE_FEEDRATE_B] ;Slow Probe
G10 L20 P1 Z[PLATE_THICKNESS]

; Move back up and over to the XY
G0 Z5
M6 ; Remove the probe
; Rapid back to zero for validation
G90 ; absolute positioning
G0 X0 Y0
G0 Z0

[UNITS] [DISTANCE] ;restore unit and distance modal state
