# ./csc_las2chm_raster_all_final.R
# 
# lidar aineistojen luku, chm teko ja muunnos virtulaalirasterista tiff-rasteriksi
#
# SYKE/TK/MH 03.07.2019, päivitys 16.12.2019

library(lidR)
#
library(rgdal)
#library(installr)
# library("gdalUtils", lib.loc="/homeappl/appl_taito/stat/R/R-3.5.0/lib64/R/library")
#
gdal_setInstallation()

# aika
t <- Sys.time()
aika_str <- strftime(t,"%Y%m%d%H%M%S")

# parameters
#
# resoluutio
resoluutio = 5
# teema - part of the output file name
# and seach files in workings directories
#
teema = "chm"
# tiff tiedostot talletuvat teema haku loppunimella 
#"_",teema,"_",resoluutio,"_m.tif"
teema_haku = paste0("_",teema,"_",resoluutio,"_m.tif")
teema_pattern = paste0("*_",teema,"_",resoluutio,"_m.tif")
# output final name - lopullinen alkunimi
out_vrt_file = paste0(teema,"_out_all")

#
full.names=TRUE

# whoami
username <- system("whoami", intern=TRUE)

# folders
# /wrk/ + username
TEMP = paste0("/tmp/",username)
# WRK
WRK = paste0("/wrk/",username)
#HOME 
HOME = paste0("/homeappl/home//",username,"/Downloads//")

# laz files
# reads all files, see recursive=TRUE
# hakemisto, josta laz-tiedostot luetaan
# 
LASPOLKU <- "/proj/ogiir-csc/mml/laserkeilaus/2008_latest/2018/N544/"
# 
setwd(HOME)

# luuppi
# read files
files <- list.files(path=LASPOLKU, pattern="*.laz", full.names=TRUE, recursive=TRUE)
maara = length(files)
print(paste0("Tiedostojen maara yhteensa: ",paste0(maara," kpl")))

kier = 0
print (getwd())

# loop starts
#
for (file in files){
  name <- file
  # 
  print (paste0("Tiedosto: ",name))
  print (paste0("Tiedosto - koko polku: ",name))
  #
  hak_strings =  strsplit(name, "/")[[1]]
  #
  m = length(hak_strings)
  # 
  hakemisto_1 = hak_strings[m-1]
  hakemisto_2 = hak_strings[m-2]
  if (hakemisto_2 == "") {
    hakemisto_2 = hak_strings[m-3]    
  }
  
  wrk_hakemisto_1 = paste0(WRK, "/", hakemisto_2, "/", hakemisto_1, "/")
  print (paste0("Hakemisto: ", wrk_hakemisto_1))
  
  wrk_hakemisto_2 = paste0(WRK, "/", hakemisto_2, "/")
  if (!dir.exists(wrk_hakemisto_2)){
    # mkdir
    dir.create(wrk_hakemisto_2, showWarnings = TRUE, recursive = FALSE, mode = "0777")
    print (paste0("Hakemisto: ", wrk_hakemisto_2, "luotu!!!"))
  }
  if (!dir.exists(wrk_hakemisto_1)){
    # mkdir
    dir.create(wrk_hakemisto_1, showWarnings = TRUE, recursive = FALSE, mode = "0777")
    print (paste0("Hakemisto: ", wrk_hakemisto_1, " luotu!!!"))
  }
  
  basename <- basename(name)
  print (paste0("Tiedosto: ",basename))
  basename_noext<- tools::file_path_sans_ext(basename(name))
  print (paste0("Tiedosto: ",basename_noext))
  # 
  LASFILE <- basename_noext # "N5443B3"
  # LASFILE_FULL
  LASFILE_FULL = name
  
  # output tiff
  # tallennus wrk_hakemisto_1:oon
  output_tiff = paste0(wrk_hakemisto_1,LASFILE,"_",teema,"_",resoluutio,"_m.tif") 
  
  # file exists rstudio
  if(!file.exists(output_tiff)){  
    # read las file
    las = readLAS(LASFILE_FULL)
    
    kier = kier + 1
    
    msg = paste0("Menossa kierros  : ", kier, "/",maara," kpl")
    print (msg)
    
    #
    if (is.empty(las)) return (NULL)
    
    print (paste0("Tiedosto olemassa: ",LASFILE_FULL))
    
    # create chm - use defaulf parameters
    # see: https://rdrr.io/cran/lidR/man/grid_canopy.html
    # parameters; resoluutio
    #
    thr <- c(0,2,5,10,15)
    edg <- c(0,1.5)
    # chm <- grid_canopy(las,20,pitfree(thr,edg))
    chm <- grid_canopy(las,resoluutio,pitfree(thr,edg))
    
    # 
    print ("CHM valmis! ")
    
    if (require(rgdal)){
      #
      # crs(chm) <- CRS('+init=EPSG:3067')
      #
      # save to raster
      print (paste0("Rasteriksi tallennus alkaa...:",output_tiff))
      #
      rf <- writeRaster(chm,filename=output_tiff,format="GTiff", overwrite=TRUE)
      #
      print (paste0(" => Rasteriksi muunnos OK! - tiedosto: ", output_tiff))
    }
  } 
  else {
    print (paste0("  Rasteri on jo olemassa! - tiedosto: ", output_tiff))
  }
}

#
valid_install <- !is.null(getOption("gdalUtils_gdalPath"))

# list raster files
tiff_files <- list.files(path=WRK, pattern=teema_pattern, full.names=TRUE, recursive=TRUE)

maara = length(tiff_files)
print(paste0("Tiedostojen maara yhteensa: ",paste0(maara," kpl  haku: ", teema_pattern)))

if (maara > 0){
  if(valid_install)
  {
    #
    # output virtual raster
    #
    out_vrt_chm <- file.path(HOME, paste0(out_vrt_file,".vrt"))
    
    # tiedostot listattuna
    # 
    gdalUtils::gdalbuildvrt(gdalfile = c(tiff_files), output.vrt = out_vrt_chm , overwrite = TRUE)
    
    #
    print (paste0("Virtuaalirasteriksi muunnos OK! - .vrt: ", out_vrt_chm))

    #
    if (require(rgdal)){
      #
      # crs(chm) <- CRS('+init=EPSG:3067')
      #
      if(file.exists(out_vrt_chm)){  
        # lopullinen rasteri virtuaalirasterista
        # hakemistoon HOME, rastert luetaan teema_haku maarityksista
        # teema_haku = "_",teema,"_",resoluutio,"_m.tif"
        # 
        output_vrt_tiff = paste0(HOME,out_vrt_file,teema_haku) 
        
        print (paste0("Virtual to Raster tallennus alkaa...:",output_vrt_tiff))
        #  
        # virtual raster to tiff HOME directory
        #
        gdal_translate(out_vrt_chm,output_vrt_tiff)
        #
        print (paste0("Rasteriksi muunnos OK! - tiedosto: ", output_vrt_tiff))
      }
    }
  }
}
# warnings()
#
# Invalid file: the header states the file contains 9549745 returns numbered '1' but 14679941 were found.
#
# mahdollinen ratkaisu: https://www.cs.unc.edu/~isenburg/lastools/download/lasinfo_README.txt
# lasinfo -i *.las -repair
