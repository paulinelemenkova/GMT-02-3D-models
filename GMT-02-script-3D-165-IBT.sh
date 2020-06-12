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
ps=IBT3D165.ps
# Step-4. Add contour
gmt grdcontour geoid.egm96.grd -JM3.5i \
    -R135/150/27/36 \
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
# Step-7. Add GMT logo
gmt logo -Dx4.0/0.0+o0.0c/-5.0c+w2c -O -K >> $ps
# Step-8. Add title
gmt pstext -R0/10/0/10 -Jx1 -X-0.8c -Y1.5c -N -O -K \
    -F+f10p,Palatino-Roman,black+jLB >> $ps << EOF
0.0 8.0 Izu-Bonin Trench: 3D composite mesh model
0.0 7.5 Overlay of the topographic 3D on top of the 2D geoid contour plot
0.0 7.0 Data: ETOPO 5 arc min grid, World Geoid Image 9.2 5 min grid
EOF
gmt pstext -R0/10/0/10 -Jx1 -X0.0c -Y0.0c -N -O \
    -F+f8p,Palatino-Roman,dimgray+jLB >> $ps << EOF
7.0 6.0 Perspective view azimuth: 170/40\232
EOF
# Step-9. Convert to image file using GhostScript (portrait orientation, 720 dpi)
gmt psconvert IBT3D165.ps -A0.4c -E720 -Tj -P -Z
# Step-10. Clean up
rm -f ib3d_relief.nc rainbowIBT.cpt
