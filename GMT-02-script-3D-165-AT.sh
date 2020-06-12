#!/bin/sh
# Purpose: 3D grid, 165/45 azimuth, from the ETOPO5 from 5 arc min (here: Aleutian Trench)
# GMT modules: grdcut, grd2cpt, grdcontour, pscoast, grdview, logo, psconvert
# Unix prog: rm
# Step-1. Cut grid
gmt grdcut earth_relief_05m.grd -R154/220/40/65 -Gat_relief.nc
# Step-2. Create color palette
gmt grd2cpt @at_relief.nc -Crainbow > rainbowAT.cpt
# Step-3. generate a file
ps=AT3D165.ps
# Step-4. Add contour
gmt grdcontour geoid.egm96.grd -JM10c -R154/220/40/65\
    -p165/45 -C1 -A5+f8p,Palatino-Bold -Gd3c -Wthinnest,dimgray -Y3c\
    -U/-0.5c/-1c/"Data: 2 min World Geoid Image 9.2, ETOPO 5 arc min grid"\
    -P -K > $ps
# Step-5. Add coastlines, ticks, directional rose
pscoast -J -R -p165/45 -B8/4NESW -Gdimgray\
    -T216/42/1c\
    --MAP_ANNOT_OFFSET=0.1c -O -K >> $ps
# Step-6. Add 3D
grdview at_relief.nc -J -R -JZ2i -CrainbowAT.cpt\
    -p165/45 -Qsm -N-7500+glightgray\
    -Wm0.07p -Wf0.1p,red -Wc0.1p,magenta\
    -B8/4/2000:"Bathymetry and topography (m)":ESwZ -S5 -Y4.0c \
    --FONT_LABEL=8p,Palatino-Bold,darkblue\
    --FONT_ANNOT_PRIMARY=7p,Helvetica,black \
    --MAP_FRAME_PEN=black -O -K >> $ps
# Step-7. Add GMT logo
gmt logo -Dx10.5/0.0+o0.0c/-5.5c+w2c -O -K >> $ps
# Step-8. Add title
gmt pstext -R0/10/0/10 -Jx1 -X-0.8c -Y0.0c -N -O -K \
-F+f10p,Palatino-Roman,black+jLB >> $ps << EOF
0.0 10.0 Composite overlay of the 3D topographic mesh model
0.0 9.5 on top of the 2D geoid contour plot
0.0 9.0 Region: the Aleutian Islands and Aleutian Trench, North Pacific Ocean
EOF
gmt pstext -R0/10/0/10 -Jx1 -X0.0c -Y0.0c -N -O\
    -F+f8p,Palatino-Roman,dimgray+jLB >> $ps << EOF
7.0 8.0 Perspective view azimuth: 165/45\232
EOF
# Step-9. Convert to image file using GhostScript (portrait orientation, 720 dpi)
gmt psconvert AT3D165.ps -A0.2c -E720 -Tj -P -Z
# Step-10. Clean up
rm -f rainbowAT.cpt
