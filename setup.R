# setup

if(length(ls(pattern="^SongEvo_release$"))==0)
  SongEvo_release=NULL
if(length(ls(pattern="^user_path$"))==0)
  user_path=.libPaths()
print(user_path)
library(parallel,lib.loc = user_path)
library(devtools,lib.loc = user_path)
setup_SongEvo_for_profiling <- function(ref="4f9e2c1"){
  if(!is.null(SongEvo_release)){
    ref=SongEvo_release
  } else {
    SongEvo_release <<- ref
  }
  print(SongEvo_release)
  library(parallel)
  local_path<-file.path(getwd(),
                        R.Version()$platform,
                        paste0(R.Version()$major,
                               ".",
                               strsplit(R.Version()$minor,".",fixed = T)[[1]][1]),"common");
  ref_path <- file.path(getwd(),
                        R.Version()$platform,
                        paste0(R.Version()$major,
                               ".",
                               strsplit(R.Version()$minor,".",fixed = T)[[1]][1]),
                        paste0("SongEvo_",ref));
  
  if(!dir.exists(ref_path))
    dir.create(ref_path,recursive = T,mode = "0755")
  if(!dir.exists(local_path))
    dir.create(local_path,recursive = T,mode = "0755")
  
  .libPaths(c(local_path,ref_path))
  
  if(! "SongEvo" %in% installed.packages()[,"Package"]){
    cat("\nSongEvo not found, installing.\n\n")
    library(parallel,lib.loc = user_path)
    library(devtools,lib.loc = user_path)
    library(httr,lib.loc = user_path)
    library(curl,lib.loc = user_path)
    need_packs=c("expm", "MASS", "phangorn", "seqinr", "statmod", 
                 "zoo", "RColorBrewer","ape","deSolve","nloptr","deSolve","nnet")
    if(any(!need_packs %in% installed.packages()[,"Package"] )){
      
      .libPaths(c(local_path))
      install.packages(c(need_packs)[!need_packs %in% installed.packages()[,"Package"]],
      type="source", INSTALL_opts="--with-keep.source")
    }
    .libPaths(c(ref_path,local_path))
    install_github("GrahamDB/SongEvo",ref=ref, args="--with-keep.source")
    if(!"SongEvo" %in% installed.packages()[,"Package"])
      stop("Failed to install SongEvo")
  }
  library(SongEvo)
}
