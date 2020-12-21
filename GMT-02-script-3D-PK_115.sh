#!/bin/sh
# Purpose: 3D grid, 115/45 azimuth, from the ETOPO5 from 5 arc min (here: Pakistan)
# GMT modules: grdcut, grd2cpt, grdcontour, pscoast, grdview, logo, psconvert
# Unix prog: rm
# Step-1. Cut grid
gmt grdcut earth_relief_05m.grd -R60.0/80.0/23.5/37.2 -Gpkt_relief.nc
# gdalinfo pkt_relief.nc
# -3452,6917
gmt makecpt -Cturbo.cpt -V -T-3549/7966 > myocean.cpt

# generate a file
ps=PK3D115.ps

# Add contour
gmt grdcontour geoid.egm96.grd -JM10c -R60.0/80.0/23.5/37.2 \
    -p115/30 -C1 -A5+f10p,Helvetica -B4/4NESW -Gd3c -Y3c \
    -U/-0.5c/-1c/"Data: 2 min World Geoid Image 9.2, ETOPO 1 arc min grid" \
    -P -K > $ps

# add color legend
gmt psscale -Dg55/24+w8.0c/0.4c+v+o0.5/0.5c+ml \
    -R -J -Cmyocean.cpt \
    --FONT_LABEL=8p,Helvetica,dimgray \
    --FONT_ANNOT_PRIMARY=7p,Helvetica,black \
    --MAP_ANNOT_OFFSET=0.1c \
    -Bg500f50a500+l"Color scale legend: depth and height elevations (m)." \
    -I0.2 -By+lm -O -K >> $ps
    
# Add 3D
gmt grdview pkt_relief.nc -J -R -JZ3c -Cmyocean.cpt \
    -p115/30 -Qsm -N-2500+glightgray \
    -Wm0.07p -Wf0.1p,red \
    -B4/4/2000:"Bathymetry and topography (m)":ESwZ -S5 -Y5.0c \
    --FONT_LABEL=7p,Helvetica,darkblue \
    --FONT_ANNOT_PRIMARY=7p,Helvetica,black \
    --MAP_FRAME_PEN=black -O -K >> $ps
    
# Add GMT logo
gmt logo -Dx10.5/-5.5+o0.0c/-0.5c+w2c -O -K >> $ps

# Add title
gmt pstext -R0/10/0/10 -Jx1 -X-0.8c -Y0.0c -N -O -K \
-F+f10p,Helvetica,black+jLB >> $ps << EOF
0.0 8.0 Composite overlay of the 3D topographic mesh model
0.0 7.5 on top of the 2D geoid contour plot
EOF

gmt pstext -R0/10/0/10 -Jx1 -X0.0c -Y0.0c -N -O\
    -F+f8p,Helvetica,black+jLB >> $ps << EOF
7.0 7.7 Perspective view, azimuth rotation: 115/30\232
9.0 7.2 Region: Pakistan
EOF

# Convert to image file using GhostScript (portrait orientation, 720 dpi)
gmt psconvert PK3D115.ps -A1.0c -E720 -Tj -P -Z
