<img src="https://github.com/geoportti/Logos/blob/master/geoportti_logo_300px.png">

# Point cloud to CHM

This repository contains R-script that read LAZ point clouds and generate a digital height model (CHM). Script use lidR library - grid_canopy algorithm, see: https://rdrr.io/cran/lidR/man/grid_canopy.html

This script shows the technical way how calculate CHM in CSC environment using laz-files stored in directory `/proj/ogiir-csc/mml/laserkeilaus/`. Is doesn't give the most perfect results, used parameters should be changed. 
This script doesn't use the LAScatalog processing engine. There is the other R-script in repository https://github.com/geoporttishare/vegetation-height which use the LAScatalog processing engine, see https://rdrr.io/cran/lidR/man/catalog_apply.html

## Getting Started

This script is designed to work in CSC environment (https://www.csc.fi/get-started), but works also in your own desktop -  install all the required libraries (see Dependencies and Installing) and change parameter `LASPOLKU` (=path, where laz files are stored), see Running / Deployment.
Use RSrudio to run and test the script first time. RSrudio is already installed in the CSC Taito (and Puhti) environment, see detailed information https://research.csc.fi/-/r.

### Dependencies

CSC rspatial-env environment in Taito (Puhti), see https://research.csc.fi/-/rspatial-env, use libraries:
- lidR - https://cran.r-project.org/web/packages/lidR/index.html
- rgdal - https://cran.r-project.org/web/packages/rgdal/index.html
```
(library("gdalUtils", lib.loc="/homeappl/appl_taito/stat/R/R-3.5.0/lib64/R/library"))
```

### Installing

Desktop: RStudio download, see https://rstudio.com/products/rstudio/download/.

## Running / Deployment

CSC - Taito (and Puhti): see https://research.csc.fi/-/r; srun and sbatch

CSC and Desktop: RStudio => Code => Run region => Run All 
- Be sure to change the Laz files path (=`LASPOLKU`), it is recursive.

Example: Running the script in RStudio, where `LASPOLKU` = /proj/ogiir-csc/mml/laserkeilaus/2008_latest/2018/N544/, prints in Console:

    [1] "Tiedostojen maara yhteensa: 52 kpl"
    [1] "/homeappl/home/%username%/Downloads"
    [1] "Tiedosto: /proj/ogiir-csc/mml/laserkeilaus/2008_latest/2018/N544//1/N5443A1.laz"
    [1] "Tiedosto - koko polku: /proj/ogiir-csc/mml/laserkeilaus/2008_latest/2018/N544//1/N5443A1.laz"
    [1] "Hakemisto: /wrk/%username%/N544/1/"
    [1] "Tiedosto: N5443A1.laz"
    [1] "Tiedosto: N5443A1"
    [1] "Menossa kierros  : 1/52 kpl"
    [1] "Tiedosto olemassa: /proj/ogiir-csc/mml/laserkeilaus/2008_latest/2018/N544//1/N5443A1.laz"
    [1] "CHM valmis! "
    [1] "Rasteriksi tallennus alkaa...:/wrk/%username%/N544/1/N5443A1_chm_25_m.tif"
    [1] " => Rasteriksi muunnos OK! - tiedosto: /wrk/%username%/N544/1/N5443A1_chm_25_m.tif"
    [1] "Tiedosto: /proj/ogiir-csc/mml/laserkeilaus/2008_latest/2018/N544//1/N5443A2.laz"
    [1] "Tiedosto - koko polku: /proj/ogiir-csc/mml/laserkeilaus/2008_latest/2018/N544//1/N5443A2.laz"
    [1] "Hakemisto: /wrk/%username%/N544/1/"
    [1] "Tiedosto: N5443A2.laz"
    [1] "Tiedosto: N5443A2"
    [1] "Menossa kierros  : 2/52 kpl"
    [1] "Tiedosto olemassa: /proj/ogiir-csc/mml/laserkeilaus/2008_latest/2018/N544//1/N5443A2.laz"
    [1] "CHM valmis! "
    [1] "Rasteriksi tallennus alkaa...:/wrk/%username%/N544/1/N5443A2_chm_25_m.tif"
    [1] " => Rasteriksi muunnos OK! - tiedosto: /wrk/%username%/N544/1/N5443A2_chm_25_m.tif"
    [1] "Tiedosto: /proj/ogiir-csc/mml/laserkeilaus/2008_latest/2018/N544//1/N5443A3.laz"
    [1] "Tiedosto - koko polku: /proj/ogiir-csc/mml/laserkeilaus/2008_latest/2018/N544//1/N5443A3.laz"
    [1] "Hakemisto: /wrk/%username%/N544/1/"
    [1] "Tiedosto: N5443A3.laz"
    [1] "Tiedosto: N5443A3"
    ...
    [1] "Menossa kierros  : 52/52 kpl"
    [1] "Tiedosto olemassa: /proj/ogiir-csc/mml/laserkeilaus/2008_latest/2018/N544//1/N5444E4.laz"
    [1] "CHM valmis! "
    [1] "Rasteriksi tallennus alkaa...:/wrk/%username%/N544/1/N5444E4_chm_25_m.tif"
    [1] " => Rasteriksi muunnos OK! - tiedosto: /wrk/%username%/N544/1/N5444E4_chm_25_m.tif"

    [1] "Tiedostojen maara yhteensa: 52 kpl  haku: *_chm_25_m.tif"

    [1] "Virtuaalirasteriksi muunnos OK! - .vrt: /homeappl/home//%username%/Downloads///chm_out_all.vrt"
    [1] "Virtual to Raster tallennus alkaa...:/homeappl/home//%username%/Downloads//out_all_chm_25_m.tif"
    [1] "Rasteriksi muunnos OK! - tiedosto: /homeappl/home//%username%/Downloads//out_all_chm_25_m.tif"

## Use of parameters

- `HOME`: home environment
- `WRK`: working environment
- `resoluutio` = output raster resolution
- `out_vrt_file` = name of the virtual raster
- `teema_haku` = name of the tiff rasters in the WRK-directory
- `teema` = name of the 'theme'

## Output file and temporary files

The final output raster (the virtual raster and the tiff raster) is stored to the directory which the variable `HOME` refers. The name of the final raster is specified in the variable `output_vrt_tiff` (paste from the variable `HOME`, the variable `out_vrt_file` and the variable `teema_haku`, which consists of ("_",teema,"_",resolution,"_m.tif"))
Add all the temporary rasters are stored to the directory which the variable `WRK` refers. In the CSC environment the data in the `WRK` directory will be deleted after 90 days.

## Usage and Citing

When used, the following citing should be mentioned: "We made use of geospatial
data/instructions/computing resources provided by the Open Geospatial
Information Infrastructure for Research (oGIIR,
urn:nbn:fi:research-infras-2016072513) funded by the Academy of Finland."



