#!/bin/sh
# Purpose: 3D grid, 165/30 azimuth, from the ETOPO5 from 5 arc min
# here: Philippine Trench
# GMT modules: grdcut, grd2cpt, grdcontour, pscoast, grdview, logo, psconvert
# Unix prog: rm
#
# Step-1. Cut grid
gmt grdcut earth_relief_05m.grd -R120/136/6/22 -Gpt3d_relief.nc
# Step-2. Create color palette
gmt grd2cpt @pt3d_relief.nc -Crainbow > rainbowPT.cpt
# Step-3. generate a file
ps=PT3D165.ps
# Step-4. Add contour
gmt grdcontour geoid.egm96.grd -JM3.5i \
    -R120/136/6/22 \
    -p150/45 -C1 -A5 -Gd3c -Wthinnest,dimgray -Y3c \
    -U/-0.8c/-1c \
    -P -K > $ps
# Step-5. Add coastlines, ticks, rose,
pscoast -J -R -p150/45 -B4/2NESW -Gdimgray -O -K -T148/32/1c \
    --MAP_ANNOT_OFFSET=0.1c >> $ps
# Step-6. Add 3D
grdview pt3d_relief.nc -J -R -JZ4c -CrainbowPT.cpt \
    -p150/45 -Qsm -N-9000+glightgray \
    -Wm0.1p -Wf0.1p,red -Wc0.1p,magenta \
    -B5/5/3000:"Bathymetry and topography (m)":nEswZ -Y4.5c \
    --FONT_LABEL=8p,Palatino-Bold,darkblue \
    --FONT_ANNOT_PRIMARY=7p,Helvetica,black -O -K >> $ps
# Step-7. Add GMT logo
gmt logo -Dx4.0/0.0+o0.0c/-6.0c+w2c -O -K >> $ps
# Step-8. Add title
gmt pstext -R0/10/0/10 -Jx1 -X-0.8c -Y1.5c -N -O -K \
    -F+f9p,Palatino-Roman,black+jLB >> $ps << EOF
0.0 10.0 Composite overlay  of the 3D topographic mesh model
0.0 9.5 on top of the 2D geoid contour plot
0.0 9.0 Region: Philippine Trench
0.0 8.5 Data: ETOPO 5 arc min grid,
0.0 8.0 Geoid Image 9.2 5 min grid
EOF
gmt pstext -R0/10/0/10 -Jx1 -X0.0c -Y0.0c -N -O \
    -F+f10p,Palatino-Roman,dimgray+jLB >> $ps << EOF
7.0 9.0 Perspective view azimuth: 150/45\232
EOF
# Step-9. Convert to image file using GhostScript (portrait orientation, 720 dpi)
gmt psconvert PT3D165.ps -A0.4c -E720 -Tj -P -Z
# Step-10. Clean up
rm -f jt3d_relief.nc rainbowJT.cpt
