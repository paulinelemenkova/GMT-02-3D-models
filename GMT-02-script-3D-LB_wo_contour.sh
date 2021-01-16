#!/bin/sh
# Purpose: 3D grid, 205/45 azimuth, from the ETOPO5 from 5 arc min (here: Lebanon)
# GMT modules: grdcut, grd2cpt, grdcontour, pscoast, grdview, logo, psconvert
# Unix prog: rm


# Cut grid
gmt grdcut ETOPO1_Ice_g_gmt4.grd -R34.7/36.7/32.8/34.8 -Glb_relief1.nc
gmt grdcut GEBCO_2019.nc -R34.7/36.7/32.8/34.8 -Glb_relief.nc
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
    -B0.5/0.5/2000:"Bathymetry and topography (m)":ESWZ -S5 \
    --FORMAT_GEO_MAP=ddd:mm:ss \
    --FONT_LABEL=8p,Helvetica,darkblue \
    --FONT_ANNOT_PRIMARY=7p,Helvetica,black \
    --MAP_FRAME_PEN=black -UBL/-10p/-12p -K > $ps
    
# Add GMT logo
gmt logo -Dx10.5/-0.5+o0.0c/-0.0c+w2c -O -K >> $ps

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
