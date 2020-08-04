#!/bin/sh
# Purpose: 3D grid, 165/45 azimuth, from the ETOPO5 from 5 arc min (here: Aleutian Trench)
# GMT modules: grdcut, grd2cpt, grdcontour, pscoast, grdview, logo, psconvert
# Unix prog: rm
# Step-1. Cut grid
gmt grdcut earth_relief_05m.grd -R74/100/2/23 -Gbb1_relief3d
#gmt grdcut ETOPO1_Ice_g_gmt4.grd -R74/100/2/23 -Gbb_relief3d
# gdalinfo bb1_relief3d -stats
# -4962.000, Maximum=2790.000

# Select a color palette
#gmt makecpt -Cglobe.cpt -V -T-4962/2790/500 > colors.cpt
gmt makecpt -Cturbo.cpt -V -T-4962/2790/500 > colors.cpt

# generate a file
ps=BB3D165.ps
# Add contour
gmt grdcontour geoid.egm96.grd -JM10c -R74/100/2/23\
    -p165/45 -C1 -A5+f8p,Palatino-Bold -Gd3c -Wthinnest,dimgray -Y3c\
    -U/-0.5c/-1c/"Data: ETOPO 5 arc min grid, EGM96 World Geoid Image 9.2"\
    -P -K > $ps
    
# Add coastlines, ticks, directional rose
gmt pscoast -J -R -p165/45 -B4/4NESW -Gdimgray -T216/42/1c\
    --MAP_ANNOT_OFFSET=0.1c -O -K >> $ps

# Step-5. Add coastlines, ticks, rose,
pscoast -J -R -p170/40 -B4/2NESW -Gdimgray -O -K -T148/32/1c \
    --MAP_ANNOT_OFFSET=0.1c >> $ps
gmt pstext -R -J -N -O -K \
    -F+f10p,Helvetica,darkblue+jLB+a-355 >> $ps << EOF
86.0 12 Bay of Bengal
EOF
gmt pstext -R -J -N -O -K \
    -F+f10p,Helvetica,darkblue+jLB+a-355 >> $ps << EOF
94.0 18 Andaman Sea
EOF
gmt pstext -R -J -N -O -K \
    -F+f7p,Helvetica,white+jLB >> $ps << EOF
81.5 9.5 Sri
81.0 9.0 Lanka
EOF
gmt pstext -R -J -N -O -K \
    -F+f10p,Helvetica,white+jLB+a-10 >> $ps << EOF
79.0 15.0 India
EOF
gmt pstext -R -J -N -O -K \
    -F+f7p,Helvetica,white+jLB >> $ps << EOF
96.5 18.0 Thailand
EOF
gmt pstext -R -J -N -O -K \
    -F+f7p,Helvetica,white+jLB >> $ps << EOF
96.0 20.7 Myanmar
EOF
gmt pstext -R -J -N -O -K \
    -F+f9p,Helvetica−Bold,white+jLB+a-40 >> $ps << EOF
96.0 4.5 Sumatra
EOF

# Add 3D -Qi300
grdview bb1_relief3d -J -R -JZ2i -Ccolors.cpt\
    -p165/45 -Qsm -N-7500+glightgray\
    -Wm0.07p -Wf0.1p,red -Wc0.1p,magenta\
    -B8/4/2000:"Bathymetry and topography (m)":ESwZ -S5 -Y4.5c \
    --FONT_LABEL=8p,Palatino-Bold,darkblue\
    --FONT_ANNOT_PRIMARY=7p,Helvetica,black \
    --MAP_FRAME_PEN=black -O -K >> $ps
    
# Add GMT logo
gmt logo -Dx10.5/0.0+o0.0c/-5.5c+w2c -O -K >> $ps

# Add title
gmt pstext -R0/10/0/10 -Jx1 -X-0.8c -Y0.0c -N -O -K \
-F+f10p,Palatino-Roman,black+jLB >> $ps << EOF
0.0 11.3 Composite overlay of the 3D topographic mesh model
0.0 10.8 on top of the 2D geoid contour plot
0.0 10.3 Bay of Bengal and Andaman Sea region, Indian Ocean
EOF

gmt pstext -R0/10/0/10 -Jx1 -X0.0c -Y-4.5c -N -O\
    -F+f8p,Palatino-Roman,dimgray+jLB >> $ps << EOF
0.5 0.0 Perspective view azimuth: 165/45\232
EOF

# Convert to image file using GhostScript (portrait orientation, 720 dpi)
gmt psconvert BB3D165.ps -A1.0c -E720 -Tj -P -Z
# Step-10. Clean up
#rm -f rainbowAT.cpt
