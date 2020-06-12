#!/bin/sh
# Purpose: 3D grid, 165/30 azimuth, from the ETOPO5 from 5 arc min (here: Izu-Bonin Trench)
# GMT modules: grdcut, grd2cpt, grdcontour, pscoast, grdview, logo, psconvert
# Unix prog: rm
#
# Step-1. Cut grid
gmt grdcut earth_relief_05m.grd -R135/150/27/36 -Gib3d_relief.nc
# Step-2. Create color palette
gmt grd2cpt @ib3d_relief.nc -Crainbow > rainbowIBT.cpt
# Step-3. generate a file
ps=IBT3D170.ps
# Step-4. Add contour
gmt grdcontour geoid.egm96.grd -JM3.5i \
    -R135/150/27/36 -B4g00m\
    -p170/40 -C1 -A5 -Gd3c -Wthinnest,dimgray -Y3c \
    -U/-0.8c/-1c \
    -P -K > $ps
# Step-5. Add coastlines, ticks, rose,
pscoast -J -R -p170/40 -B4/2NESW -Gdimgray -O -K -T148/32/1c \
    --MAP_ANNOT_OFFSET=0.1c >> $ps
gmt pstext -R -J -N -O -K \
    -F+f10p,Helvetica−Bold,darkblue+jLB+a-255 >> $ps << EOF
144.0 28.0 Izu-Bonin
EOF
gmt pstext -R -J -N -O -K \
    -F+f10p,Helvetica−Bold,darkblue+jLB+a-272 >> $ps << EOF
143.3 31.5 Trench
EOF
# Step-6. Add 3D
grdview ib3d_relief.nc -J -R -JZ4c -CrainbowIBT.cpt \
    -p170/40 -Qsm -N-9000+glightgray \
    -Wm0.1p -Wf0.1p,red -Wc0.1p,magenta \
    -B5/2/3000:"Bathymetry and topography (m)":nEswZ -Y4.0c \
    --FONT_LABEL=8p,Palatino-Bold,darkblue \
    --FONT_ANNOT_PRIMARY=7p,Helvetica,black -O -K >> $ps
# Step-7. Add color legend
gmt psscale -Dg130.5/23+w10.0c/0.4c+v+o0.3/0i+ml \
    -R135/150/27/36 -J -CrainbowIBT.cpt \
    --FONT_LABEL=8p,Helvetica,dimgray \
    --FONT_ANNOT_PRIMARY=7p,Helvetica,black \
    --MAP_ANNOT_OFFSET=0.1c \
    -Baf+l"Color scale legend: depth and height elevations (m)." \
    -I0.2 -By+lm -O -K >> $ps
# Step-8. Add GMT logo
gmt logo -Dx4.0/0.0+o0.0c/-5.0c+w2c -O >> $ps
# Step-9. Convert to image file using GhostScript (portrait orientation, 720 dpi)
gmt psconvert IBT3D170.ps -A0.4c -E720 -Tj -P -Z
# Step-10. Clean up
rm -f ib3d_relief.nc rainbowIBT.cpt
