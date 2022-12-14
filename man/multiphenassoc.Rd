% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/multiphenassoc.R
\name{multiphenassoc}
\alias{multiphenassoc}
\title{Multiple PRS Associations from different Phenotypes}
\usage{
multiphenassoc(
  df = NULL,
  prs_col = "SCORESUM",
  phenotype_col = "Phenotype",
  scale = TRUE,
  covar_col = NA
)
}
\arguments{
\item{df}{a dataframe with individuals on each row, at least one ID column,
one column PRS (continuous variable) and one with phenotype (continuous or discrete)}

\item{prs_col}{a character specifying the PRS column name}

\item{phenotype_col}{a character vector specifying the Phenotype column names}

\item{scale}{a boolean specifying if scaling of PRS should be done before testing}

\item{covar_col}{a character vector specifying the covariate column names (facultative)}
}
\value{
return a data frame showing the association of the PRS on the Phenotypes
with 'PRS','Phenotype','Covar','N_cases','N_controls','N','OR','SE','lower_CI','upper_CI','P_value'
}
\description{
\code{multiphenassoc()} take a distribution of PRS and multiple Phenotypes and eventual confounders
return a data frame showing the association results
}
