#!/bin/sh
# Purpose: 3D grid, 165/30 azimuth, from the ETOPO1 (here: Lebanon)
# GMT modules: grdcut, grd2cpt, grdcontour, pscoast, grdview, logo, psconvert
# Unix prog: rm
# Cut grid
gmt grdcut ETOPO1_Ice_g_gmt4.grd -R128/150/30/46 -Glb_relief1.nc
#gmt grdcut GEBCO_2019.nc -R128/150/30/46 -Glb_relief.nc
gdalinfo -stats lb_relief1.nc
# Minimum=-2007.000, Maximum=2973.000
gmt makecpt -Cturbo.cpt -V -T-2020/2973 > myocean.cpt

# generate a file
ps=LB_3D.ps
# -B1/1NESW
gmt grdcontour lb_relief.nc -JM10c -R128/150/30/46 \
    -p165/30 -C250 \
    --FONT_ANNOT_PRIMARY=8p,0,blue \
    --MAP_FRAME_AXES=WESN --FORMAT_GEO_MAP=ddd:mm:ss\
    -Gd3c -Y3c -Bpxg1f0.1a0.5 -Bpyg0.5f0.1a0.5 -Bsxg1 -Bsyg1 \
    -U/-0.5c/-1c/"Contour: ETOPO 1 arc minute resolution grid" \
    -P -K > $ps

#Add coastlines, borders, rivers
gmt pscoast -R -J -p165/30 -P -Ia/thinner,blue \
    -Na -N1/thickest,tomato -W0.1p -Df -O -K >> $ps
#-Bpxg2f0.5a1 -Bpyg2f0.5a1 -Bsxg2 -Bsyg1

# texts
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,25,black+jLB+a-300 -p165/30 -Gwhite@40 >> $ps << EOF
35.94 34.02 Lebanon  Mts
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f12p,25,darkbrown+jLB+a-310 -p165/30 -Gwhite@50 >> $ps << EOF
35.88 33.7 Beqaa Valley
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,25,black+jLB+a-308 -p165/30 -Gwhite@40 >> $ps << EOF
36.15 33.8 Anti-Lebanon Mts
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f12p,26,blue2+jLB -p165/30 >> $ps << EOF
35.0 34.0 Mediterranean
35.0 33.8 Sea
EOF
gmt pstext -R -J -N -O -K \
-F+f13p,13,black+jLB -p165/30 -Gwhite@30 >> $ps << EOF
35.53 33.88 Beiruth
EOF
gmt psxy -R -J -Sc -W0.5p -p165/30 -Gyellow -O -K << EOF >> $ps
35.51 33.88 0.30c
EOF

# add color legend
gmt psscale -Dg34.2/32.8+w8.0c/0.4c+v+o0.0/0.5c+ml \
    -R -J -Cmyocean.cpt \
    --FONT_LABEL=8p,0,dimgray \
    --FONT_ANNOT_PRIMARY=7p,0,black \
    --MAP_ANNOT_OFFSET=0.1c \
    -Bg500f50a500+l"Color scale legend: depth and height elevations (m)." \
    -I0.2 -By+lm -O -K >> $ps
    
# Add 3D
gmt grdview lb_relief.nc -J -R -JZ3.5c -Cmyocean.cpt \
    -p165/30 -Qsm -N-3500+glightgray \
    -Wm0.07p -Wf0.1p,red \
    -B0.5/0.5/2000:"Bathymetry and topography (m)":ESwZ -S5 -Y5.0c \
    --FORMAT_GEO_MAP=ddd:mm:ss \
    --FONT_LABEL=8p,Helvetica,darkblue \
    --FONT_ANNOT_PRIMARY=7p,Helvetica,black \
    --MAP_FRAME_PEN=black -O -K >> $ps
    
# Add GMT logo
gmt logo -Dx10.5/-5.5+o0.0c/-0.5c+w2c -O -K >> $ps

# Add title
gmt pstext -R0/10/0/10 -Jx1 -X-0.8c -Y0.0c -N -O -K \
-F+f12p,25,black+jLB >> $ps << EOF
-0.5 9.0 Lebanon: 3D topographic mesh model based on GEBCO
EOF

gmt pstext -R0/10/0/10 -Jx1 -X0.0c -Y0.0c -N -O\
    -F+f8p,Helvetica,black+jLB >> $ps << EOF
-0.5 8.5 Perspective view, azimuth rotation: 165/30\232
-0.5 8.0 Base map: 2D relief contour plot
EOF

# Convert to image file using GhostScript (portrait orientation, 720 dpi)
gmt psconvert LB_3D.ps -A1.2c -E720 -Tj -P -Z
