# Using generalized additive models to analyze biomedical non-linear longitudinal data
[![License: CC BY 4.0](https://img.shields.io/badge/License%20All-CC%20BY%204.0-lightgrey)](https://creativecommons.org/licenses/by/4.0/) [![License: CC0-1.0](https://img.shields.io/badge/License%20Parts-CC0%201.0-lightgrey)](http://creativecommons.org/publicdomain/zero/1.0/)



This repository contains all the code and data used for the paper, which is available here. In this paper we explore the use of generalized additive models (GAMs) in biomedical research.

# Important information

All the required libraries to run the code can be found in `Full_document.Rmd`. If individual sections of code are desired to be run the best way to do it is to load the required libraries and set seed (both can be found in the same code chunk in `Full_document.Rmd`) and run the desired chunks that can be found in each of:

- `02-Challenges.Rmd` which contains code to: 
    - Simulate linear and non-linear data
    - Create a plot  that visualizes the fits of rm-ANOVA and LMEMs for the simulatd data (linear and non-linear).
- `03-GAM Theory.Rmd `, which contains code to create a plot that explains how smooths are created in GAMs.
- `04-Longitudinal analysis with GAMs`, which contains code to:
    - Generate simulated data that follows the trends reported in Figure 3, C in Vishwanath, Karthik, et al. "Using optical spectroscopy to longitudinally monitor physiological changes within solid tumors." Neoplasia 11.9 (2009): 889-900. [(Link)](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC2735810/)
    - Fit a GAM and a rm-ANOVA model to the simulated data.
    - Create missing observations in the simulated data.
    - Generate a plot of the raw data and the model fits (full and missing data cases)
    - Do pairwise comparisons between smooths for the GAM (full and missing data cases)

The workflow to fit a GAM can be found in `07-Appendix.Rmd`

Note that although the code in each of the aforementioned files is independent from code in other files, certain sections of code _in each file_ may depend on other code chunks _within_ the same file. 

# License

This entire repository is licensed under a CC BY 4.0 License, which allows reuse with attribution. However, certain files are released under the CC0 1.0 public domain dedication. The files indicated below are dual licensed under CC BY 4.0 and CC0 1.0:

- `02-Challenges.Rmd`
- `03-GAM Theory.Rmd`
- `04-Longitudinal analysis with GAMs`
- `07-Appendix.Rmd`

All other files are under CC BY 4.0.

# Contact
If you have questions or comments please contact Ariel Mundo (aimundo AT uark.edu)
