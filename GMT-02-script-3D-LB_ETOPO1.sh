#!/bin/sh
# Purpose: 3D grid, 205/45 azimuth, from the ETOPO1 from 1 arc min (here: Lebanon)
# GMT modules: grdcut, grd2cpt, grdcontour, pscoast, grdview, logo, psconvert
# Unix prog: rm


# Cut grid
gmt grdcut ETOPO1_Ice_g_gmt4.grd -R34.7/36.7/32.8/34.8 -Glb_relief1.nc
#gmt grdcut GEBCO_2019.nc -R34.7/36.7/32.8/34.8 -Glb_relief.nc
gdalinfo -stats lb_relief1.nc
# Minimum=-2007.000, Maximum=2973.000
gmt makecpt -Cturbo.cpt -V -T-2020/2973 > myocean.cpt

# generate a file
ps=LB_3D.ps
# -B1/1NESW
    
# Add 3D
gmt grdview lb_relief1.nc -JM10c -R34.7/36.7/32.8/34.8 -JZ3.5c -Cmyocean.cpt \
    -p205/30 -Qsm -N-3500+glightgray \
    -Wm0.07p -Wf0.1p,red \
    -B0.5/0.5/2000:"Bathymetry and topography (m)":WeSZ -S5 \
    --FORMAT_GEO_MAP=ddd:mm:ss \
    --FONT_LABEL=8p,Helvetica,darkblue \
    --FONT_ANNOT_PRIMARY=7p,Helvetica,black \
    --MAP_FRAME_PEN=black -UBL/-10p/-12p -K > $ps

gmt pstext -R -J -N -O -K \
-F+jTL+f9p,25,white+jLB+a-282 >> $ps << EOF
36.15 33.85 Lebanon  Mts
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f9p,25,darkbrown+jLB+a-295 >> $ps << EOF
36.33 33.8 Beqaa Valley
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f9p,25,white+jLB+a-305 >> $ps << EOF
36.50 33.88 Anti-Lebanon
36.70 33.98 Mts
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f9p,26,white+jLB >> $ps << EOF
35.2 33.6 Mediterranean
35.4 33.5 Sea
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,13,yellow+jLB >> $ps << EOF
35.62 33.73 Beiruth
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
35.85 33.7 0.3c
EOF

# add color legend
gmt psscale -Dg34.7/32.5+w10.0c/0.4c+h+o0.0/0.0c+ml \
    -R -J -p205/30 -Cmyocean.cpt \
    -Bg500f50a500+l"Color scale legend 'turbo': depth and height elevations (m)" \
    --FONT_LABEL=8p,Helvetica,dimgray \
    --FONT_ANNOT_PRIMARY=7p,Helvetica,black \
    --MAP_ANNOT_OFFSET=0.1c \
    -I0.2 -By+lm -O -K >> $ps
    
# Add GMT logo
gmt logo -Dx12.5/-0.5+o0.0c/-0.0c+w2c -O -K >> $ps

# Add title
gmt pstext -R0/10/0/10 -Jx1 -X-0.8c -Y0.0c -N -O -K \
-F+f12p,25,black+jLB >> $ps << EOF
#-0.5 10.0 Lebanon: 3D topographic mesh model based on GEBCO (15 arc second resolution)
-0.5 10.0 Lebanon: 3D topographic mesh model based on ETOPO1 (1 arc minute resolution)
EOF

gmt pstext -R0/10/0/10 -Jx1 -X0.0c -Y0.0c -N -O\
    -F+f8p,Helvetica,black+jLB >> $ps << EOF
-0.5 9.5 Perspective view, azimuth rotation: 205/30\232
EOF

# Convert to image file using GhostScript (portrait orientation, 720 dpi)
gmt psconvert LB_3D.ps -A0.8c -E720 -Tj -P -Z
