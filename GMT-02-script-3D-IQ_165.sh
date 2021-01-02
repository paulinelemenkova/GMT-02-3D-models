#!/bin/sh
# Purpose: 3D grid, 165/45 azimuth, from the ETOPO5 from 5 arc min (here: Iran)
# GMT modules: grdcut, grd2cpt, grdcontour, pscoast, grdview, logo, psconvert
# Unix prog: rm
# Step-1. Cut grid
gmt grdcut earth_relief_05m.grd -R38/49/29/38 -Giq_relief5.nc
# gdalinfo -stats iq_relief5.nc
# Minimum=-39.000, Maximum=3233.000
gmt makecpt -Cturbo.cpt -V -T-39/3233 > myocean.cpt

# generate a file
ps=IQ_3D165.ps

gmt grdcontour earth_relief_05m.grd -JM10c -R38/49/29/38 \
    -p165/30 -C750 -B4/4NESW -Gd3c -Y3c \
    -U/-0.5c/-1c/"Data: World ETOPO 5 arc min grid" \
    -P -K > $ps

#Add coastlines, borders, rivers
gmt pscoast -R -J -p165/30 -P \
        -B4/4NESW -Ia/thinner,blue -Na -W0.1p -Df -O -K >> $ps

gmt pstext -R -J -N -O -K \
-F+jTL+f11p,26,blue+jLB+a-15 >> $ps << EOF
46.2 31.4 Tigris
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f11p,26,blue+jLB+a-15 >> $ps << EOF
44.7 30.3 Euphrates
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f12p,13,red4+jLB+a-47 -Gwhite@40 >> $ps << EOF
45.3 37.0 Z a g r o s M t s
EOF

# add color legend
gmt psscale -Dg34.8/32+w8.0c/0.4c+v+o0.0/0.5c+ml \
    -R -J -Cmyocean.cpt \
    --FONT_LABEL=8p,Helvetica,dimgray \
    --FONT_ANNOT_PRIMARY=7p,Helvetica,black \
    --MAP_ANNOT_OFFSET=0.1c \
    -Bg500f50a500+l"Color scale legend: depth and height elevations (m)." \
    -I0.2 -By+lm -O -K >> $ps
    
# Add 3D
gmt grdview iq_relief5.nc -J -R -JZ3c -Cmyocean.cpt \
    -p165/30 -Qsm -N-3500+glightgray \
    -Wm0.07p -Wf0.1p,red \
    -B4/4/2000:"Bathymetry and topography (m)":ESwZ -S5 -Y5.0c \
    --FONT_LABEL=8p,Helvetica,darkblue \
    --FONT_ANNOT_PRIMARY=7p,Helvetica,black \
    --MAP_FRAME_PEN=black -O -K >> $ps

gmt pstext -R -J -N -O -K \
-F+jTL+f11p,13,white+jLB+a-47 >> $ps << EOF
45.0 34.0 Mesopotamia
45.1 32.7 Foredeep Basin
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f12p,13,red4+jLB+a-47 -Gwhite@60 >> $ps << EOF
45.3 35.5 Z a g r o s  M t s
EOF
    
# Add GMT logo
gmt logo -Dx10.5/-5.5+o0.0c/-0.5c+w2c -O -K >> $ps

# Add title
gmt pstext -R0/10/0/10 -Jx1 -X-0.8c -Y0.0c -N -O -K \
-F+f10p,Helvetica,black+jLB >> $ps << EOF
0.0 8.7 3D topographic mesh model
0.0 8.2 Base map: 2D relief contour plot
0.0 7.7 Region: Iraq
EOF

gmt pstext -R0/10/0/10 -Jx1 -X0.0c -Y0.0c -N -O\
    -F+f8p,Helvetica,black+jLB >> $ps << EOF
7.0 8.0 Perspective view, azimuth rotation: 165/30\232
EOF

# Convert to image file using GhostScript (portrait orientation, 720 dpi)
gmt psconvert IQ_3D165.ps -A1.2c -E720 -Tj -P -Z
