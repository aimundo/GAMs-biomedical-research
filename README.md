Generalized additive models to analyze non-linear trends in biomedical longitudinal data using R: Beyond repeated measures ANOVA and Linear Mixed Models
====================================================================================================================================

[![License: CC BY 4.0](https://img.shields.io/badge/License%20All-CC%20BY%204.0-lightgrey)](https://creativecommons.org/licenses/by/4.0/) [![License: CC0-1.0](https://img.shields.io/badge/License%20Parts-CC0%201.0-lightgrey)](http://creativecommons.org/publicdomain/zero/1.0/)
[![License: MIT](https://img.shields.io/badge/License%20Parts-MIT-lightgrey)](https://opensource.org/licenses/MIT)


This repository contains all the code and data used for the paper, which is available [in bioRxiv](https://www.biorxiv.org/content/10.1101/2021.06.10.447970v2). In this paper we explore the use of generalized additive models (GAMs) in biomedical research.

# How to use this repository

The best way to reproduce the paper and its results is to fork this repository and follow the instructions below.

# Instructions

This work was created using R. Therefore, you need to install the latest version of R. Additionally, it is recommended that and IDE such as RStudio is installed as well. Directions to install R and RStudio can be found [here](https://rstudio-education.github.io/hopr/starting.html). <br>

After installing R and RStudio, you need to install the {bookdown} and {tinytex} (a LaTeX distribution) packages in order to be able to create the PDF output. To install `bookdown`, you only need to run the following command in the Console in RStudio: `install.packages("bookdown")`. <br>
Instructions to install {tinytex} can be found [here](https://yihui.org/tinytex/). Note that you have to install the package and then run the command `install_tinytex()` to make it work.

All the required libraries to run the code and create the manuscript can be found in the first code chunk in `Main_manuscript.Rmd` (which calls all the files in `sections` to generate the main manuscript). If using RStudio, the first time you open `Main_manuscript.Rmd` you should automatically receive a warning about the missing packages that need to be installed; you can choose to install all the missing packages then.

Although individual code chunks can be run, it is advised to first generate a document by knitting `Main_manuscript.Rmd`. If individual chunks of code want to be examined, it is best to open the `.Rmd` file of interest from `sections`, and see the code structure to the different functions and code found in `scripts` (see below).

The different manuscript sections can be found in the `sections` directory, which contains:

- `01-Background.Rmd`: first part of the manuscript.
- `02-Challenges.Rmd` which contains code to: 
    - Simulate linear and non-linear data
    - Create a plot  that visualizes the fits of rm-ANOVA and LMEMs for the simulatd data (linear and non-linear).
- `03-GAM Theory.Rmd `, which contains the theory of LMs, GLMs and GLMMs as the foundation to understand GAMs. Also contains code to create a plot that explains how smooths are created in GAMs.
- `04-Longitudinal analysis with GAMs`, which contains:
    - Generation of simulated data that follows the trends reported in Figure 3, C in Vishwanath, Karthik, et al. "Using optical spectroscopy to longitudinally monitor physiological changes within solid tumors." Neoplasia 11.9 (2009): 889-900. [(Link)](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC2735810/)
    - Fit a GAM and a rm-ANOVA model to the simulated data.
    - Create incomplete observations in the simulated data.
    - Generate a plot of the raw data and the model fits (full and incomplete data cases)
    - Theory behind empirical Bayesian simultaneous confidence intervals
    - Do pairwise comparisons between smooths for the GAM (full and incomplete data cases)
- `05-Discussion.Rmd`: Discussion
- `06-Conclusion.Rmd`: Conclusion, acknowledgements.

This work has two appendices, which can be found in the directory `appendices`: 

- Appendix A: Contains the workflow to fit a GAM using simulated data.
- Appendix B: Contains code for functions used through the main manuscript and Appendix A.

Each Appendix `.Rmd` file (either `Appendix_A` or `Appendix_B`) is a stand-alone document that can be compiled independently from each other and the main manuscript. In this way, the reader chooses the section of interest and can examine and run the code independently.

The directory `scripts` contains the following:

- `example.R`: Script that simulated linear and quadratic longitudinal data and fits a LMEM and rm-ANOVA.
- `plot_example.R`: Uses the data from `example.R` to generate a composite plot showing data and fits.
- `basis_functions.R`: Simulates longitudinal data with quadratic trend, fits a GAM and extracts the basis functions. Creates combined plot that appears in Figure 2 in the main manuscript.
code in R used to generate plots, simulate data, and for obtaining confidence intervals (both across the function and simultaneous) for the fitted smooths.
- `simulate_data.R`: Simulates normally distributed longitudinal data using the trends found in Vishwanath, Karthik, et al. "Using optical spectroscopy to longitudinally monitor physiological changes within solid tumors." Neoplasia 11.9 (2009): 889-900. [(Link)](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC2735810/)
- `pointwise_comparisons.R`: When a GAM is fitted to the simulated data from `simulate_data.R`, this function estimates both the difference between the different smooths and a pointwise (across the function) confidence interval.
- `difference_smooths.R`: Uses the output from `pointwise_comparisons.R` to generate a simultaneous confidence interval for the difference. This script is based on the function [`confint`](https://gavinsimpson.github.io/gratia/reference/confint.gam.html) from Gavin Simpson's package _gratia_.
- `pairwise_limits.R`: Estimates the regions of significance from the smooth comparisons to add rectangles that highlight the significant time intervals.

- `gam_diagnostics.R`: Function that uses the source code of `gam.check` to only generate numerical diagnostics.


The repository also contains directories `bibliography` for references used in the main manuscript, `latex_docs` for LaTeX compilation and `html_docs` if HTML output is desired. Only the LaTeX output is guaranteed to work at this stage.

# License

This entire repository is licensed under a CC BY 4.0 License, which allows reuse with attribution. However, certain files are released under the CC0 1.0 public domain dedication. The files indicated below are dual licensed under CC BY 4.0 and CC0 1.0:

- `02-Challenges.Rmd`
- `03-GAM Theory.Rmd`
- `04-Longitudinal analysis with GAMs`
- `07-Appendix.Rmd`

All other files are under CC BY 4.0.

# Contact

If you have questions or comments please contact Ariel Mundo (aimundo AT uark.edu)
