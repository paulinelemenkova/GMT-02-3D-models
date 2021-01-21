#!/bin/sh
# Purpose: 3D grid, 125/45 azimuth, from the ETOPO1 from 1 arc min (here: Lebanon)
# GMT modules: grdcut, grd2cpt, grdcontour, pscoast, grdview, logo, psconvert
# Unix prog: rm

# Cut grid
#gmt grdcut ETOPO1_Ice_g_gmt4.grd -R33/48/3/15 -Get_relief1.nc
gmt grdcut earth_relief_05m.grd -R33/48/3/15 -Get_relief1.nc
gdalinfo -stats et_relief1.nc
# Minimum=-5358.000, Maximum=3447.000
#gmt makecpt -Cdem3.cpt -V -T-5358/3448 > myocean.cpt
gmt makecpt -Celevation.cpt -V -T-3000/4000 > myocean.cpt

# generate a file
ps=ET_3D.ps
# -B1/1NESW
    
# Add 3D
gmt grdview et_relief1.nc -JM10c -R33/48/3/15 -JZ3.2c -Cmyocean.cpt \
    -p125/30 -Qsm -N-3500+glightgray \
    -Wm0.07p -Wf0.1p,red \
    -B1/1/2000:"Bathymetry and topography (m)":wESZ -S5 \
    --FORMAT_GEO_MAP=ddd:mm:ss \
    --FONT_LABEL=8p,0,darkblue \
    --FONT_ANNOT_PRIMARY=7p,Helvetica,black \
    --MAP_FRAME_PEN=black -UBL/200p/-17p -K > $ps

# add color legend
gmt psscale -Dg33/0.0+w10.0c/0.4c+h+o0.0/0.0c+ml \
    -R -J -p125/30 -Cmyocean.cpt \
    -Bg500f50a1000+l"Color scale legend 'turbo': depth and height elevations (m)" \
    --FONT_LABEL=8p,Helvetica,dimgray \
    --FONT_ANNOT_PRIMARY=7p,Helvetica,black \
    --MAP_ANNOT_OFFSET=0.1c \
    -I0.2 -By+lm -O -K >> $ps
    
# Add GMT logo
gmt logo -Dx11.5/-0.7+o0.0c/-0.0c+w2c -O -K >> $ps

# Add title
gmt pstext -R0/10/0/10 -Jx1 -X-0.8c -Y0.0c -N -O -K \
-F+f12p,25,black+jLB >> $ps << EOF
-0.5 8.5 Ethiopia: 3D topographic mesh model based on ETOPO1
EOF
gmt pstext -R0/10/0/10 -Jx1 -X0.0c -Y0.0c -N -O\
    -F+f8p,Helvetica,black+jLB >> $ps << EOF
-0.5 8.0 Perspective view, azimuth rotation: 125/30\232
EOF

# Convert to image file using GhostScript (portrait orientation, 720 dpi)
gmt psconvert ET_3D.ps -A0.8c -E720 -Tj -P -Z
