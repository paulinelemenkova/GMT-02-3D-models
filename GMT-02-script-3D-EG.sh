#!/bin/sh
# Purpose: 3D grid, 125/45 azimuth, from the ETOPO1 from 1 arc min (here: Panama)
# GMT modules: grdcut, grd2cpt, grdcontour, pscoast, grdview, logo, psconvert
# Unix prog: rm

exec bash
# Cut grid

gmt grdcut GEBCO_2019.nc -R31/33.3/25/27 -Geg_relief3D.nc
#gmt grdcut earth_relief_05m.grd -R31/33.3/25/27 -Geg_relief3D.nc
gdalinfo -stats eg_relief3D.nc
# Minimum=-4622.000, Maximum=3601.000, Mean=-1332.511, StdDev=1497.265
#gmt makecpt -Cdem1.cpt -V -T-300/1500 > myocean.cpt
#gmt makecpt -Cdem3.cpt -V -T-200/1500 > myocean.cpt
#gmt makecpt -Celevation.cpt -V -T-100/1500 > myocean.cpt
#gmt makecpt -Cjet.cpt -V -T0/1000 > myocean.cpt
gmt makecpt -Crainbow.cpt -V -T0/600 > myocean.cpt

# generate a file
ps=EG_3D.ps
    
# Add 3D
gmt grdview eg_relief3D.nc -JM10c -R31/33.3/25/27 -JZ1.5c -Cmyocean.cpt \
    -p-160/40 -Qsm -N-500+glightgray \
    -Wm0.07p -Wf0.1p,red \
    -B0.5/0.5/500:"Heights (m)":WeSZ -S5 \
    --FORMAT_GEO_MAP=ddd:mm:ss \
    --FONT_LABEL=7p,0,darkblue \
    --FONT_ANNOT_PRIMARY=7p,Helvetica,black \
    --MAP_FRAME_PEN=black -UBL/250p/-30p -K > $ps
    
#gmt pscoast -JM10c -R31/33.3/25/27 -p-160/40 -Ia/thick,blue -Na -W0.1p -Df -O -K >> $ps

# add color legend
gmt psscale -Dg31.0/24.60+w10.3c/0.4c+h+o0.0/0i+ml+e \
    -R -J -p-160/40 -Cmyocean.cpt \
    -Bg100f10a100+l"Color scale legend 'rainbow': depth and height elevations (m)" \
    --FONT_LABEL=8p,Helvetica,dimgray \
    --FONT_ANNOT_PRIMARY=7p,0,black \
    --MAP_ANNOT_OFFSET=0.1c \
    -I0.2 -By+lm -O -K >> $ps
    
# Add GMT logo
gmt logo -Dx0.1/-1.2+o0.0c/0.0c+w2c -O -K >> $ps

# Add title
gmt pstext -R0/10/0/10 -Jx1 -X-0.8c -Y0.0c -N -O -K \
-F+f10p,25,black+jLB >> $ps << EOF
0.7 8.5 Qena Bend: 3D topographic mesh model
EOF
gmt pstext -R0/10/0/10 -Jx1 -X0.0c -Y0.0c -N -O\
    -F+f8p,0,black+jLB >> $ps << EOF
0.7 8.0 Perspective view
0.7 7.5 azimuth rotation: 160/40\232
EOF

# Convert to image file using GhostScript (portrait orientation, 720 dpi)
gmt psconvert EG_3D.ps -A0.8c -E720 -Tj -P -Z
