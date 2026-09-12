# GMT 3D Models — 3D Perspective Relief and Terrain Mapping Scripts

A collection of over 30 GMT (Generic Mapping Tools) shell scripts for building 3D perspective relief models of topography and bathymetry. Elevation grids are rendered as shaded 3D surfaces and mesh models with grdview at controlled viewing azimuth and elevation, often composited with 2D geoid or bathymetric contours. The scripts have been used to generate 3D map figures across the author's geoscientific and cartographic publications.

## What the scripts do

Each script builds a complete 3D perspective figure, typically chaining:

- grid clipping and subsetting (grdcut) over a study-area bounding box
- colour palette generation from the grid (grd2cpt / makecpt)
- 3D surface / mesh rendering (grdview) with a vertical exaggeration (-JZ) and perspective (-p azimuth/elevation)
- draped illumination, mesh (-Qm) or surface (-Qs) styling
- 2D contour underlays (grdcontour), coastlines and frames (pscoast) in perspective
- annotations, titles and view labels (pstext), GMT logo (logo)
- export to raster (psconvert) at high resolution
- cleanup of temporary grids and CPTs (rm)

## Data sources

Global elevation and bathymetry grids: ETOPO (1 and 5 arc-minute), GEBCO and GMT earth_relief tiles; geoid contours from EGM96. Coastlines from GSHHG via GMT.

## File naming

Scripts follow GMT-02-script-3D-...-XX.sh, where XX is an ocean trench, sea or country tag (e.g. JT = Japan Trench, MAT = Middle America Trench, IBT = Izu-Bonin Trench, LB = Lebanon, TZ = Tanzania). A numeric tag (e.g. 165, 115) encodes the perspective azimuth; suffixes such as _mesh, _wo_contour or a source grid (_ETOPO1, _GEBCO) mark variants.

## Requirements

- GMT 6.x (Generic Mapping Tools): https://www.generic-mapping-tools.org
- A POSIX shell (bash/sh)
- The relevant relief grid(s) (ETOPO / GEBCO / earth_relief) available locally

## Usage

Place the required relief grid in the working directory, adjust the -R region, -p perspective and -JZ vertical scale at the top of the chosen script, then run:

    bash GMT-02-script-3D-165-JT.sh

The script writes a PostScript file and converts it to a raster image (JPG/PNG) via psconvert.

## Author and citation

Polina Lemenkova
ORCID: https://orcid.org/0000-0002-5759-1089

These scripts accompany figures in the author's geoscientific and cartographic papers; please cite the specific article a given map appears in. The full publication list is available via the ORCID record above.

## License

See the LICENSE file in this repository.
