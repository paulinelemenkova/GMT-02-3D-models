#!/bin/sh
# Purpose: 3D grid, 165/30 azimuth, from the ETOPO5 from 5 arc min (here: Vityaz and Vanuatu trenches)
# GMT modules: grdcut, grd2cpt, grdcontour, pscoast, grdview, logo, psconvert
# Unix prog: rm
#
# Step-1. Cut grid
gmt grdcut earth_relief_05m.grd -R160/170/-25/-10 -Gvv3d_relief.nc
# Step-2. Create color palette
gmt grd2cpt @vv3d_relief.nc -Celevation > rainbowVVT.cpt
# Step-3. generate a file
ps=VV3D165.ps
# Step-4. Add contour
gmt grdcontour earth_relief_01m.grd -JM3.5i \
    -R160/170/-25/-10 \
    -p160/45 -C500 -Gd6c -Wthinnest,dimgray -Y5.5c \
    -U/-0.8c/-1c \
    -P -K > $ps
# texts
gmt pstext -R -J -N -O -K \
-F+f12p,Helvetica−Bold,red+jLB+a-85 -Gwhite@40 >> $ps << EOF
169.2 -19.0 V a n u a t u  T r e n c h
EOF
gmt pstext -R -J -N -O -K \
-F+f12p,Times-Roman,red+jLB+a-44 -Gwhite@30 >> $ps << EOF
164.5 -20.7 New Caledonia Island
EOF
# Step-5. Add coastlines, ticks, rose,
pscoast -J -R -p160/45 -B2/2NESW -Gdimgray -O -K -T148/32/1c \
    --MAP_ANNOT_OFFSET=0.1c >> $ps
# Step-6. Add 3D
grdview vv3d_relief.nc -J -R -JZ4c -CrainbowVVT.cpt \
    -p160/45 -Qsm -N-9000+glightgray \
    -Wm0.1p -Wf0.1p,red -Wc0.1p,magenta \
    -B5/5/3000:"Bathymetry and topography (m)":nEswZ -Y6.5c \
    --FONT_LABEL=8p,Palatino-Bold,darkblue \
    --FONT_ANNOT_PRIMARY=7p,Helvetica,black -O -K >> $ps
# Step-7. Add GMT logo
gmt logo -Dx4.0/0.0+o0.0c/-8.0c+w2c -O -K >> $ps
# Step-8. Add title
gmt pstext -R0/10/0/10 -Jx1 -X-0.8c -Y4.0c -N -O -K \
    -F+f10p,Palatino-Roman,black+jLB >> $ps << EOF
0.0 10.0 Vanuatu Trench: composite overlay of the 3D topographic mesh model
0.0 9.5 on top of the 2D ETOPO1 contour plot
0.0 9.0 CPT: elevation
EOF
gmt pstext -R0/10/0/10 -Jx1 -X0.0c -Y0.0c -N -O \
    -F+f8p,Palatino-Roman,dimgray+jLB >> $ps << EOF
7.5 9.5 Perspective view azimuth rotation: 160/45\232
EOF
# Step-9. Convert to image file using GhostScript (portrait orientation, 720 dpi)
gmt psconvert VV3D165.ps -A0.4c -E720 -Tj -P -Z
# Step-10. Clean up
rm -f vv3d_relief.nc rainbowVVT.cpt
