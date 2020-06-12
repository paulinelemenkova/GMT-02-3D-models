#!/bin/sh
# Purpose: 3D grid, 165/30 azimuth, from the ETOPO5 from 5 arc min (here: Yap and Palau trenches)
# GMT modules: grdcut, grd2cpt, grdcontour, pscoast, grdview, logo, psconvert
# Unix prog: rm
#
# Step-1. Cut grid
gmt grdcut earth_relief_05m.grd -R130/140/2/12 -Gypt_relief.nc
# Step-2. Create color palette
gmt grd2cpt @ypt_relief.nc -Crainbow > rainbowYPT.cpt
# Step-3. generate a file
ps=YPT3D165.ps
# Step-4. Add contour
gmt grdcontour geoid.egm96.grd -JM3.5i -R130/140/2/12 -p165/45 -C1 -A5 -Gd3c -Wthinnest,dimgray -Y3c -U/-0.5c/-1c/"Data: 2 min World Geoid Image 9.2, ETOPO 5 arc min grid" -P -K > $ps
# Step-5. Add coastlines, ticks, rose,
pscoast -J -R -p165/45 -B4/2NESW -Gdimgray -O -K -T168/42/1c \
    --MAP_ANNOT_OFFSET=0.1c >> $ps
# Step-6. Add 3D
grdview ypt_relief.nc -J -R -JZ4c -CrainbowYPT.cpt -p165/45 \
    -Qsm -N-7500+glightgray \
    -Wm0.1p -Wf0.1p,red -Wc0.1p,magenta \
    -B5/5/2000:"Bathymetry and topography (m)":nEswZ -Y4.5c \
    --FONT_LABEL=8p,Palatino-Bold,darkblue -O -K >> $ps
# Step-7. Add color legend
gmt psscale -Dg129.5/4+w10.0c/0.4c+v+o0.3/0i+ml \
    -R132/140/4/12 -J -CrainbowYPT.cpt \
    --FONT_LABEL=8p,Helvetica,dimgray \
    --FONT_ANNOT_PRIMARY=7p,Helvetica,black \
    --MAP_ANNOT_OFFSET=0.1c \
    -Baf+l"Color scale legend: depth and height elevations (m)." \
    -I0.2 -By+lm -O -K >> $ps
# Step-8. Add GMT logo
gmt logo -Dx4.0/0.0+o0.0c/-6.7c+w2c -O -K >> $ps
# Step-9. Add title
gmt pstext -R0/10/0/10 -Jx1 -X-0.8c -Y0.0c -N -O -K \
-F+f10p,Palatino-Roman,black+jLB >> $ps << EOF
0.0 10.0 Composite overlay  of the 3D topographic mesh model
0.0 9.5 on top of the 2D geoid contour plot
0.0 9.0 Region: Yap and Palau trenches
EOF
gmt pstext -R0/10/0/10 -Jx1 -X0.0c -Y0.0c -N -O \
-F+f8p,Palatino-Roman,dimgray+jLB >> $ps << EOF
7.0 9.0 Perspective view azimuth: 165/45\232
EOF
# Step-10. Convert to image file using GhostScript (portrait orientation, 720 dpi)
gmt psconvert YPT3D165.ps -A1.0c -E720 -Tj -P -Z
# Step-11. Clean up
rm -f rainbowYPT.cpt
