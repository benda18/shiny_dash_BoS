# NC Balance of State CoC HMIS Dashboard - PROJECT DOCUMENTATION #
### Project Understanding ###
My understanding of the overall project is that the dashboard was created by ICA some time ago and is live.  However, it requires regular maintenance in the form of data pulls from HMIS monthly, processing through a tableau flow and pushes to tableau server, which have not been completed in some time.  Additionally, there are some tecnical bugs in the dashboard that prevent it from functioning properly, which is the reason it hasn't been maintained.  

My job is to resolve these issues and get it back up and working by the end of April for the use of our project members for an upcoming project.  
## PLAN OF ATTACK (inc. Status Updates) ## 
* ~~Eyes on Tableau~~ (complete)
* ~~Demonstrate Understanding of Problem~~ (complete)
* Create Timeline to Completion; calendar blocking
* Run Dashboard Update as-is and witness problems
* Attack smartsheet tasks 1-at-a-time; proceed when previous task is complete and no longer issue in dash (unless issue is dependent on another downstream task)
* QA complete and working dash 
* Provide link and status to Andrea when complete
## RISKS/OBSTACLES ##
* TIMELINE RISKS
<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Missed deadlines are our biggest risk.  Time is short and meeting the deadline is crucial. 
* KNOWLEDGE OF SOFTWARE RISKS
<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Not knowing how tableau works, combined with short timeline, will lead to a missed deadline
<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;As a backup plan, I spent most of the weekend learning shiny.  I have built a Minimum Viable Product (MVP) proof-of-concept dashboard that demonstrates the minimum data, ui, interactive, and deployment criteria necessary to re-create our dashboard in shiny if necesary ([link](https://timbender-ncceh.shinyapps.io/proof_of_concept_app/?_ga=2.250851525.27973912.1680540594-1081900499.1680540594) )
* DATA RISKS
<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;There could be bugs in ica's work, changes in data ouptput standards, or other incompatibilites in the project that compound the challenges and slow progress, leading to missed deadlines.  
## TIMELINE ##
[TBD]
## APPENDIX ##
### TABLEAU Resources ###
* NCCEH existing Tableau Dashboard: https://public.tableau.com/app/profile/nccehdatacenter/viz/NCBalanceofStateCoCHMISDashboard/BoS
### SHINY Resources ###
* The Bible: https://mastering-shiny.org/index.html
#### Example Dashboards ####
* Swim Team Finder (shiny dash): https://shiny.rstudio.com/gallery/ncaa-swim-team-finder.html
* Swim Team Finder (github): https://github.com/gpilgrim2670/SwimMap
* COVID-19 Tracker: https://shiny.rstudio.com/gallery/covid19-tracker.html
* ZIPCODE Demographics: https://shiny.rstudio.com/gallery/superzip-example.html
#### Tools, Features, Tutorials, Etc ####
##### Using Tabs / Navbar #####
* Using Tabs: https://shiny.rstudio.com/gallery/tabsets.html
* Using NavBars: https://shiny.rstudio.com/gallery/navbar-example.html
##### Layouts #####
* Plot plus 3 columns: https://shiny.rstudio.com/gallery/plot-plus-three-columns.html
* Vertical layout: https://shiny.rstudio.com/gallery/vertical-layout.html
* Theme selector: https://shiny.rstudio.com/gallery/shiny-theme-selector.html
##### Including Text, HTML, Markdown #####
* HTML, text, and md: https://shiny.rstudio.com/gallery/including-html-text-and-markdown-files.html
* Inline output: https://shiny.rstudio.com/gallery/inline-output.html
##### Checkbox / Select Box / Radio Buttions #####
* Single checkbox: https://gallery.shinyapps.io/070-widget-checkbox/
* Single select box: https://gallery.shinyapps.io/076-widget-select/
* Single radio button: https://gallery.shinyapps.io/075-widget-radio/
* Multiple checkbox: https://gallery.shinyapps.io/069-widget-check-group/
##### Date Range #####
* Date Ranges: https://gallery.shinyapps.io/072-widget-date-range/
##### Sliders #####
* Slider single value: https://gallery.shinyapps.io/077-widget-slider/
* Slider range: https://gallery.shinyapps.io/077-widget-slider/
* Gallery of slider examples: https://shiny.rstudio.com/gallery/sliders.html
##### Tables #####
* Basic table examples: https://shiny.rstudio.com/gallery/basic-datatable.html
* Table Demos: https://shiny.rstudio.com/gallery/datatables-demo.html
* Table Options: https://shiny.rstudio.com/gallery/datatables-options.html
##### Plots #####
* Basic plot interaction: https://shiny.rstudio.com/gallery/plot-interaction-basic.html
* Advanced plot interaction: https://shiny.rstudio.com/gallery/plot-interaction-advanced.html
* Selecting points: https://shiny.rstudio.com/gallery/plot-interaction-selecting-points.html
* Plot Zooming: https://shiny.rstudio.com/gallery/plot-interaction-zoom.html
* Exclusions: https://shiny.rstudio.com/gallery/plot-interaction-exclude.html
* Basic Image interaction: https://shiny.rstudio.com/gallery/image-interaction-basic.html
##### Deployment #####
* Deploy locally without a server via a standalone desktop app: https://github.com/georgemirandajr/Desktop-Shiny-Apps-for-LAC

