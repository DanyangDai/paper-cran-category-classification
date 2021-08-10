
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Manuscript for *“R package downloads: what does it mean?”*

<!-- badges: start -->
<!-- badges: end -->

This manuscript is written using R Markdown. In order to make the change
to the manuscript, **please make these changes to `paper/index.Rmd`
only**. If you need to add extra references, please add these to
`paper/paper.bib`.

If you would like a preview of the work as you work, open
`paper/index.Rmd` in RStudio IDE and in the console, use the command
`xaringan::inf_mr()`. This will knit the `index.Rmd` every time you save
and you can see the preview in the Viewer pane.

If you would like to see how it looks like as a PDF, there are two
version provided: `arxiv` and `rjournal`. Knit the file
`paper/arxiv/arxiv.Rmd` to get the PDF and tex file ready for submission
to arxiv. Knit the file `paper/rjournal/paper-rjournal.Rmd` to get the
PDF ready for submission to R Journal.

The data explored in this sample analysis are randomly selected. From
2012-10-01 to 2021-07-31, there are in total 159 cranlog file selected
for this analysis. In order to provide a representative sample, there is
one date being randomly selected for every month of the year and then
every two months of the year. Thus, there are 18 days selected in each
year (from 2013 to 2020). The random dates generation process can be
find in the `analysis/a01-cranlog-downloads.R` scrip. As the data file
can be quite large, the data files are not uploaded in this Github
repository. If you are interested in the data and results, feel free to
use the `analysis/a01-cranlog-downloads.R` for the selecting and
downloading the data from <http://cran-logs.rstudio.com>.
