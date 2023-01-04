#######################################################################
# Master script
#######################################################################

## Clear out existing environment.
gc()
rm(list = ls()) 
## Set master directory where all sub-directories are located

### GiT directories
# set the main directory
mdir <- "~/Documents/Git/ethnicfavoritism"

# set the directory for the datasets
datasets <- paste0(mdir,"/data/datasets")

# set the directory for the raw data
raw <- paste0(mdir,"/data/raw")

# set the directory for the tables
tables_wd <- paste0(mdir,"/output/tables")

# set the working directory for figures
figures_wd <- paste0(mdir,"/output/figures")
# set the working directory for programs
programs <- paste0(mdir,"/programs")
# set the working directory for tables
thesis_tabs <- paste0(mdir,"/my_paper/tables")
# set the working directory for plots
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

source(file.path(programs,"13-table-2-ethnic-favoritism.R"))            # table 2
source(file.path(programs,"14-figure-2-ethnic-favoritism.R"))           # figure 2
source(file.path(programs,"15-tab-3-dem-ethnic-favoritism.R"))          # table 3
source(file.path(programs,"16-figure-3-dem-ethnic-favoritism.R"))       # figure 3
source(file.path(programs,"17-figure-four-demdic-ethnic-favoritism.R")) # figure 4
source(file.path(programs,"18-tab-4-dem-ethnic-favoritism.R"))          # table 5
source(file.path(programs,"19-tab-5-dem-ethnic-favoritism.R"))          # table 6

### summary stats

# Send Message

textme(message = "👹 Back to work! You're not paid to run around and drink ☕ all day!")