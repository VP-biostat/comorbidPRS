#' @title
#' Density Plot from a PRS Association
#'
#' @description
#' `densityplot()` take a distribution of PRS, a Phenotype and eventual Confounders
#' return a plot (ggplot2 object) with density of PRS in x by Categories of the
#' Phenotype
#'
#' @param df a dataframe with individuals on each row, at least one column PRS
#' (continuous variable) and one with phenotype (continuous or categorical)
#' @param prs_col a character specifying the PRS column name
#' @param phenotype_col a character specifying the Phenotype column name
#' @param scale a boolean specifying if scaling of PRS should be done before plotting
#' @param threshold a facultative numeric specifying for continuous Phenotype
#' the Threshold to consider individuals as Cases/Constrols as following:
#' Phenotype > Threshold = Case
#' Phenotype < Threshold = Control
#'
#' @return return a figure of results in the format ggplot2 object
#' @importFrom stats na.omit
#' @import ggplot2
#' @export
densityplot <- function(df = NULL, prs_col = "SCORESUM", phenotype_col =
                          "Phenotype", scale = T, threshold = NA) {
  ## Checking inputs
  col_names <- df_checker(df, prs_col, phenotype_col, scale)
  prs_col <- col_names$prs_col
  phenotype_col <- col_names$phenotype_col

  ## Taking only subset of df
  df <- df[, c(prs_col, phenotype_col)]
  names(df) <- c("PRS", "Phenotype")
  df <- na.omit(df)
  if (scale) {
    df[, "PRS"] <- scale(df[, "PRS"]) # scaling if scale = T
  }

  ## Making plot based on the category of Phenotype
  phenotype_type <- phenotype_type(df = df, phenotype_col = "Phenotype")
  if (phenotype_type %in% c("Cases/Controls", "Categorical")) {
    p <- ggplot(df, aes(PRS, fill = as.factor(Phenotype))) +
      geom_density(alpha = 0.4) +
      labs(x = prs_col, y = "Density", fill = phenotype_col) +
      theme_minimal() +
      theme(
        axis.title.x = element_text(size = 11),
        axis.text.x.bottom = element_text(size = 11),
        axis.title.y = element_text(size = 11),
        axis.text.y.left = element_text(size = 11)
      )
  } else if (!is.na(threshold) & class(threshold) %in% c("integer", "numeric", "double")) {
    df$Categorical_Pheno <- df$Phenotype > threshold
    p <- ggplot(df, aes(PRS, fill = as.factor(Categorical_Pheno))) +
      geom_density(alpha = 0.4) +
      theme_minimal() +
      labs(x = prs_col, y = "Density", fill = phenotype_col) +
      theme(
        axis.title.x = element_text(size = 11),
        axis.text.x.bottom = element_text(size = 11),
        axis.title.y = element_text(size = 11),
        axis.text.y.left = element_text(size = 11)
      )
  } else {
    warning("Phenotype is continuous and 'threshold' is not a number, ignoring the parameter")

    p <- ggplot(df, aes(PRS)) +
      geom_density(alpha = 0.4) +
      theme_minimal() +
      labs(x = prs_col, y = "Density") +
      theme(
        axis.title.x = element_text(size = 11),
        axis.text.x.bottom = element_text(size = 11),
        axis.title.y = element_text(size = 11),
        axis.text.y.left = element_text(size = 11)
      )
  }

  return(p)
}
