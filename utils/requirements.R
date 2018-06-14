
list_of_libs_to_ensure <- c(
  'loggit',
  'purrr',
  'dplyr'
)

installed_packages = installed.packages()
for (package in list_of_libs_to_ensure){
  
  if(!(package %in% rownames(installed_packages))){
    install.packages(package)
  }
}
