#!/bin/sh
# Purpose: 3D grid, 165/45 azimuth, from the ETOPO5 from 5 arc min (here: Jordan)
# GMT modules: grdcut, grd2cpt, grdcontour, pscoast, grdview, logo, psconvert
# Unix prog: rm


# Cut grid
#gmt grdcut ETOPO1_Ice_g_gmt4.grd -R29/42/-13/1 -Gtz_relief5.nc
gmt grdcut earth_relief_05m.grd -R29/42/-13/5 -Gtz_relief5.nc
gdalinfo -stats tz_relief5.nc
# Minimum=-3527.000, Maximum=4621.000
gmt makecpt -Cturbo.cpt -V -T-3527/4621 > myocean.cpt

# generate a file
ps=TZ_3D.ps
# -B1/1NESW
gmt grdcontour ETOPO1_Ice_g_gmt4.grd -JM10c -R29/42/-13/5 \
    -p165/30 -C250 --MAP_FRAME_AXES=WESN -Gd3c -Y3c \
    -U/-0.5c/-1c/"Data: World ETOPO 1/5 arc minute resolution grid" \
    -P -K > $ps

#Add coastlines, borders, rivers
gmt pscoast -R -J -p165/30 -P -Ia/thinner,blue \
    -Bpxg2f0.5a1 -Bpyg2f0.5a1 -Bsxg2 -Bsyg1 -Na -N1/thickest,tomato -W0.1p -Df -O -K >> $ps

# add colour legend
gmt psscale -Dg26.0/-10+w8.0c/0.4c+v+o0.0/0.5c+ml \
    -R -J -Cmyocean.cpt \
    --FONT_LABEL=8p,Helvetica,dimgray \
    --FONT_ANNOT_PRIMARY=7p,Helvetica,black \
    --MAP_ANNOT_OFFSET=0.1c \
    -Bg500f50a500+l"Colour scale legend: depth and height elevations (m)." \
    -I0.2 -By+lm -O -K >> $ps
    
# Add 3D
gmt grdview tz_relief5.nc -J -R -JZ3.5c -Cmyocean.cpt \
    -p165/30 -Qsm -N-3500+glightgray \
    -Wm0.07p -Wf0.1p,red \
    -B4/4/2000:"Bathymetry and topography (m)":ESwZ -S5 -Y5.0c \
    --FONT_LABEL=8p,Helvetica,darkblue \
    --FONT_ANNOT_PRIMARY=7p,Helvetica,black \
    --MAP_FRAME_PEN=black -O -K >> $ps

gmt pstext -R -J -N -O -K \
-F+jTL+f9p,25,white+jLB+a-300 >> $ps << EOF
41.8 -10.0 Indian Ocean
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,25,blue+jLB >> $ps << EOF
35.5 -3.0 Victoria
35.5 -3.8 Lake
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f9p,26,black+jLB+a-330 >> $ps << EOF
36.0 -5.0 Serengeti
36.0 -5.5 Plain
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f9p,26,black+jLB+a-350 >> $ps << EOF
42.5 -4.0 Masai
42.5 -4.8 Steppe
EOF
    
# Add GMT logo
gmt logo -Dx10.5/-5.5+o0.0c/-0.5c+w2c -O -K >> $ps

# Add title
gmt pstext -R0/10/0/10 -Jx1 -X-0.8c -Y0.0c -N -O -K \
-F+f12p,25,black+jLB >> $ps << EOF
-0.5 10.0 Tanzania: 3D topographic mesh model
EOF

gmt pstext -R0/10/0/10 -Jx1 -X0.0c -Y0.0c -N -O\
    -F+f8p,Helvetica,black+jLB >> $ps << EOF
-0.5 9.5 Perspective view
-0.5 9.0 Azimuth rotation: 165/30\232
-0.5 8.5 Base map: 2D relief contour plot
-0.5 8.0 Region: Tanzania
EOF

# Convert to image file using GhostScript (portrait orientation, 720 dpi)
gmt psconvert TZ_3D.ps -A1.2c -E720 -Tj -P -Z
