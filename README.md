# The Olympics

This project uses modern Olympics data as a source for running classification and predictive modeling. It also uses the `ProjectTemplate` R package. Details on how to navigate the project are found below. The (work in progress) report is hosted through GitHub pages at https://ryanstraight.github.io/olympics/


## Loading the project

To load your new project, you'll first need to `setwd()` into the directory
where this README file is located or simply run the `olympics.Rproj` file. Then you need to run the following two
lines of R code:

	library('ProjectTemplate')
	load.project()
	
Alternatively, you can navigate to the `src` folder and run `eda.R` as this accomplishes the same thing.

After you enter the second line of code, you'll see a series of automated
messages as ProjectTemplate goes about doing its work. This work involves:
* Reading in the global configuration file contained in `config`.
* Loading any R packages you listed in the configuration file.
* Reading in any datasets stored in `data` or `cache`.
* Preprocessing your data using the files in the `munge` directory.

Statistical tests and models are found in the same `src` folder as the `eda.R` script and can be run after the project has loaded.

The report in a Tufte-style handout can be found in the `docs` folder and is titled `index.rmd` in order for GitHub Pages to work easily.


For more details about ProjectTemplate, see http://projecttemplate.net
