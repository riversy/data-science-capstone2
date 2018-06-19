
list_of_libs_to_ensure <- c(
  'loggit',  # this package is used for logging and debuging
  'purrr',   # this package allows to use piping to wotk with large datasets 
  'dplyr',   # this package allows to filter and transform large datasets (also with piping)
  'ngram',   # this is a tool for fast tokenizing
  'ggplot2', # this is a great tool for plots drawing
  'pander',  # this is table printer for Rmd
  'brewer'   # this is a color pallet. I will use it to get more beautiful plots
)

installed_packages = installed.packages()
for (package in list_of_libs_to_ensure){
  
  if(!(package %in% rownames(installed_packages))){
    install.packages(package)
  }
}
