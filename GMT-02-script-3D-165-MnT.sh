#!/bin/sh
# Purpose: 3D grid, 215/45 azimuth, from the ETOPO5 from 5 arc min (here: Manila Trench)
# GMT modules: grdcut, grd2cpt, grdcontour, pscoast, grdview, logo, psconvert
# Unix prog: rm
# Step-1. Cut grid
gmt grdcut earth_relief_01m.grd -R117/123/12/21 -Gmnt_relief.nc
# Step-2. Create color palette
gmt grd2cpt @mnt_relief.nc -Crainbow > rainbowRT.cpt
# Step-3. generate a file
ps=MnT3D215.ps
# Step-4. Add contour
gmt grdcontour geoid.egm96.grd -JM10c -R117/123/12/21\
    -p215/30 -C1 -A5+f13p,Palatino-Bold -Gd3c -Wthinnest,dimgray -Y3c\
    -U/-0.5c/-1c/"Data: 2 min World Geoid Image 9.2, ETOPO 1 arc min grid"\
    -P -K > $ps
# Step-5. Add coastlines, ticks, directional rose
pscoast -J -R -p215/30 -B2/2NESW -Gdimgray\
    -T216/42/1c --FONT_ANNOT_PRIMARY=8p,Helvetica,black\
    --MAP_ANNOT_OFFSET=0.1c -O -K >> $ps
# Step-6. Add 3D
grdview mnt_relief.nc -J -R -JZ3.0c -CrainbowRT.cpt\
    -p215/30 -Qsm -N-7500+glightgray\
    -Wm0.07p -Wf0.1p,red -Wc0.1p,magenta\
    -B2/2/4000:"Bathymetry and topography (m)":eSWZ -S5 -Y6.5c \
    --FONT_LABEL=8p,Palatino-Bold,darkblue\
    --FONT_ANNOT_PRIMARY=7p,Helvetica,black \
    --MAP_FRAME_PEN=black -O -K >> $ps
# Step-7. Add GMT logo
gmt logo -Dx6.5/-2.0+o1.0c/-7.0c+w2c -O -K >> $ps
# Step-8. Add title
gmt pstext -R0/10/0/10 -Jx1 -X-0.8c -Y2.0c -N -O -K \
-F+f10p,Palatino-Roman,black+jLB >> $ps << EOF
0.0 10.0 Composite overlay of the 3D topographic mesh model
0.0 9.5 on top of the 2D geoid contour plot
0.0 9.0 Region: Luzon Island (Philippines) and Manila Trench, West Pacific Ocean
EOF
gmt pstext -R0/10/0/10 -Jx1 -X2.5c -Y0.0c -N -O\
    -F+f8p,Palatino-Roman,black+jLB >> $ps << EOF
7.0 8.0 Perspective view, azimuth rotation: 215/30\232
EOF
# Step-9. Convert to image file using GhostScript (portrait orientation, 720 dpi)
gmt psconvert MnT3D215.ps -A0.5c -E720 -Tj -P -Z
# Step-10. Clean up
rm -f rainbowRT.cpt
