#!/bin/sh
# Purpose: 3D grid, 165/45 azimuth, from the ETOPO5 from 5 arc min (here: Jordan)
# GMT modules: grdcut, grd2cpt, grdcontour, pscoast, grdview, logo, psconvert
# Unix prog: rm


# Cut grid
gmt grdcut ETOPO1_Ice_g_gmt4.grd -R34/38/29/34 -Gjo_relief5.nc
gdalinfo -stats jo_relief5.nc
# Minimum=-2190.000, Maximum=2334.000
gmt makecpt -Cturbo.cpt -V -T-2190/2334 > myocean.cpt

# generate a file
ps=JO_3D.ps
# -B1/1NESW
gmt grdcontour ETOPO1_Ice_g_gmt4.grd -JM10c -R34/38/29/34 \
    -p205/30 -C250 --MAP_FRAME_AXES=WESN -Gd3c -Y3c \
    -U/-0.5c/-1c/"Data: World ETOPO 1 arc minute resolution grid" \
    -P -K > $ps

#Add coastlines, borders, rivers
gmt pscoast -R -J -p205/30 -P -Ia/thinner,blue \
    -Bpxg2f0.5a1 -Bpyg2f0.5a1 -Bsxg2 -Bsyg1 -Na -N1/thick,tomato -W0.1p -Df -O -K >> $ps

# add color legend
gmt psscale -Dg33.8/29+w8.0c/0.4c+v+o0.0/0.5c+ml \
    -R -J -Cmyocean.cpt \
    --FONT_LABEL=8p,Helvetica,dimgray \
    --FONT_ANNOT_PRIMARY=7p,Helvetica,black \
    --MAP_ANNOT_OFFSET=0.1c \
    -Bg500f50a500+l"Color scale legend: depth and height elevations (m)." \
    -I0.2 -By+lm -O -K >> $ps
    
# Add 3D
gmt grdview jo_relief5.nc -J -R -JZ3.5c -Cmyocean.cpt \
    -p205/30 -Qsm -N-3500+glightgray \
    -Wm0.07p -Wf0.1p,red \
    -B4/4/2000:"Bathymetry and topography (m)":ESwZ -S5 -Y5.0c \
    --FONT_LABEL=8p,Helvetica,darkblue \
    --FONT_ANNOT_PRIMARY=7p,Helvetica,black \
    --MAP_FRAME_PEN=black -O -K >> $ps
    
# Add GMT logo
gmt logo -Dx10.5/-5.5+o0.0c/-0.5c+w2c -O -K >> $ps

# Add title
gmt pstext -R0/10/0/10 -Jx1 -X-0.8c -Y0.0c -N -O -K \
-F+f10p,Helvetica,black+jLB >> $ps << EOF
0.0 11.0 Dead Sea Transform Fault: 3D Topographic Mesh Model
EOF

gmt pstext -R0/10/0/10 -Jx1 -X0.0c -Y0.0c -N -O\
    -F+f8p,Helvetica,black+jLB >> $ps << EOF
11.5 11.0 Perspective view
11.5 10.5 Azimuth rotation: 205/30\232
11.5 10.0 Base map: 2D relief contour plot
11.5 9.5 Region: Jordan
EOF

# Convert to image file using GhostScript (portrait orientation, 720 dpi)
gmt psconvert JO_3D.ps -A1.2c -E720 -Tj -P -Z
