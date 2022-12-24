#!/bin/sh
# Purpose: 3D grid, 165/30 azimuth, from the ETOPO1 (here: Japan)
# GMT modules: grdcut, grd2cpt, grdcontour, pscoast, grdview, logo, psconvert
# Unix prog: rm
# Cut grid
gmt grdcut ETOPO1_Ice_g_gmt4.grd -R128/150/30/46 -Gjp_relief1.nc
#gmt grdcut GEBCO_2019.nc -R128/150/30/46 -Glb_relief.nc
gdalinfo -stats jp_relief1.nc
# Minimum=-9651.000, Maximum=3481.000, Mean=-2429.672, StdDev=2497.488
gmt makecpt -Cturbo.cpt -V -T-9651/3481 > myocean.cpt

# generate a file
ps=JP_3D.ps
# -B1/1NESW
gmt grdcontour jp_relief1.nc -JM10c -R128/150/30/46 \
    -p165/30 -C500 \
    --FONT_ANNOT_PRIMARY=8p,0,blue \
    --MAP_FRAME_AXES=WESN --FORMAT_GEO_MAP=ddd:mm:ss\
    -Gd3c -Y3c -Bpxg1f1.0a2.0 -Bpyg1.0f0.5a2.0 -Bsxg1 -Bsyg1 \
    -U/-0.5c/-1c/"Contour: ETOPO 1 arc minute resolution grid" \
    -P -K > $ps

#Add coastlines, borders, rivers
gmt pscoast -R -J -p165/30 -P -Ia/thinner,blue \
    -Na -N1/thickest,tomato -W0.1p -Df -O -K >> $ps
#-Bpxg2f0.5a1 -Bpyg2f0.5a1 -Bsxg2 -Bsyg1

# texts

# add color legend
gmt psscale -Dg34.2/32.8+w8.0c/0.4c+v+o0.0/0.5c+ml \
    -R -J -Cmyocean.cpt \
    --FONT_LABEL=8p,0,dimgray \
    --FONT_ANNOT_PRIMARY=7p,0,black \
    --MAP_ANNOT_OFFSET=0.1c \
    -Bg500f50a500+l"Color scale legend: depth and height elevations (m)." \
    -I0.2 -By+lm -O -K >> $ps
    
# Add 3D
gmt grdview jp_relief1.nc -J -R -JZ3.5c -Cmyocean.cpt \
    -p165/30 -Qsm -N-3500+glightgray \
    -Wm0.07p -Wf0.1p,red \
    -B0.5/0.5/2000:"Bathymetry and topography (m)":ESwZ -S5 -Y5.0c \
    --FORMAT_GEO_MAP=ddd:mm:ss \
    --FONT_LABEL=8p,0,darkblue \
    --FONT_ANNOT_PRIMARY=8p,0,black \
    --MAP_FRAME_PEN=black -O -K >> $ps
    
# Add GMT logo
gmt logo -Dx10.5/-5.5+o0.0c/-0.5c+w2c -O -K >> $ps

# Add title
gmt pstext -R0/10/0/10 -Jx1 -X-0.8c -Y0.0c -N -O -K \
-F+f12p,25,black+jLB >> $ps << EOF
-0.5 9.0 Japan: 3D topographic mesh model based on GEBCO
EOF

gmt pstext -R0/10/0/10 -Jx1 -X0.0c -Y0.0c -N -O\
    -F+f10p,0,black+jLB >> $ps << EOF
-0.5 8.5 Perspective view, azimuth rotation: 165/30\232
-0.5 8.0 Base map: 2D relief contour plot
EOF

# Convert to image file using GhostScript (portrait orientation, 720 dpi)
gmt psconvert JP_3D.ps -A1.2c -E720 -Tj -P -Z
