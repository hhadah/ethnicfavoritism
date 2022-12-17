#######################################################################
# Master script
#######################################################################

## Clear out existing environment
gc()
rm(list = ls()) 
## Set master directory where all sub-directories are located

### GiT directories
mdir <- "~/Documents/GiT/ethnicfavoritism"
datasets <- paste0(mdir,"/data/datasets")
raw <- paste0(mdir,"/data/raw")
tables_wd <- paste0(mdir,"/output/tables")
figures_wd <- paste0(mdir,"/output/figures")
programs <- paste0(mdir,"/programs")
thesis_tabs <- paste0(mdir,"/my_paper/tables")
thesis_plots <- paste0(mdir,"/my_paper/figure")

### run do files and scripts

source(file.path(programs,"00-packages-wds.r")) # set up package
# stata(file.path(programs,"01-directories.do")) # set directories
# stata(file.path(programs,"02-ExportingVarNames.do")) # make sure var names are similiar
# stata(file.path(programs,"03-AppendMenWomenDHS.do")) # append men and women data
# stata(file.path(programs,"04-MergingDataSets.do")) # merge datasets
# stata(file.path(programs,"05-AppendAllDataSets.do")) # append all data
stata(file.path(programs,"06-summarystats-skin-iat.R")) # summary stats
# stata(file.path(programs,"07-Regressions_PrimComp.do")) # regression primary school
# stata(file.path(programs,"08-Regressions_infmort.do")) # regression infant mort
# stata(file.path(programs,"09-Regressions_elec_wat.do")) # regression electricity and water
# stata(file.path(programs,"10-Regressions_Wealth.do")) # regression wealth
# stata(file.path(programs,"11-Regression_tables_graphs.do")) # regression tables and graphs
# stata(file.path(programs,"12-RegressionsMasterDoFile.do")) # master file

# open data
DHS_PrimSchl                   <- read_dta(file.path(datasets,"DHS_PrimSchl.dta")) |> 
  mutate(Democracy_dem_dic = (democracy_13 + democracy_12 + democracy_11 + democracy_10 + democracy_9 + democracy_8 + democracy_7)/7)
DHS_Infantdata_polity_coethnic <- read_dta(file.path(datasets,"DHS_Infantdata_polity_coethnic.dta")) |> 
  mutate(Democracy_dem_dic = (democracy))
DHS_ElectrificationWater       <- read_dta(file.path(datasets,"DHS_ElectrificationWater.dta")) |> 
  mutate(PipedWater = ifelse(AccessToWater == 4, 1, 0))
DHS_Wealth                     <- read_dta(file.path(datasets,"DHS_Wealth.dta")) |> 
  mutate(Democracy_dem_dic = (democracy_4 + democracy_3 + democracy_2 + democracy_1)/4)

### summary stats

# Send Message

textme(message = "👹 Back to work! You're not paid to run around and drink ☕ all day!")