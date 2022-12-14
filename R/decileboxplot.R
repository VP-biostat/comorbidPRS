#' @title
#' Deciles BoxPlot from a PRS Association with a Continuous Phenotype
#'
#' @description
#' `decileboxplot()` take a distribution of PRS, a Continuous Phenotype
#' return a plot (ggplot2 object) with deciles of PRS in x and Boxplot of
#' the Phenotype in y
#'
#' @param df a dataframe with individuals on each row, at least one column PRS
#' (continuous variable) and one with phenotype (continuous or categorical)
#' @param prs_col a character specifying the PRS column name
#' @param phenotype_col a character specifying the Continuous Phenotype column name
#'
#' @return return a figure of results in the format ggplot2 object
#' @importFrom stats na.omit
#' @import ggplot2
#' @export
decileboxplot <- function(df = NULL, prs_col = "SCORESUM", phenotype_col =
                            "Phenotype") {
  ## Checking inputs
  col_names <- df_checker(df, prs_col, phenotype_col, scale = F)
  prs_col <- col_names$prs_col
  phenotype_col <- col_names$phenotype_col

  ## Taking only subset of df
  df <- df[, c(prs_col, phenotype_col)]
  names(df) <- c("PRS", "Phenotype")
  df <- na.omit(df)
  if (nrow(df) < 1000) {
    warning("The dataset has less than 1,000 individuals, deciles boxplot might not look good!")
  }

  ## Making centiles then deciles, ifelse using phenotype_type
  phenotype_type <- phenotype_type(df = df, phenotype_col = "Phenotype")

  df$centile <- with(df, cut(PRS, breaks = quantile(PRS, probs = seq(0, 1, by = 0.01), na.rm = TRUE), include.lowest = TRUE, dig.lab = 10))
  df$centile <- as.factor(df$centile)
  levels(df$centile) <- seq(1, 100, by = 1)
  df$decile <- cut(as.numeric(df$centile), breaks = seq(0, 100, by = 10))

  if (phenotype_type %in% c("Categorical", "Cases/Controls")) {
    stop("Cannot use a Categorical or a Cases/Controls phenotype for deciles boxplot. Please use Continuous Phenotype")
  } else if (phenotype_type == "Continuous") {
    p <- ggplot(df, aes(
      x = as.factor(decile),
      y = as.numeric(Phenotype),
      fill = mean(as.numeric(Phenotype), na.rm = T)
    )) +
      geom_boxplot(show.legend = F, alpha = 0.4) +
      labs(
        x = paste("Deciles of", prs_col),
        y = phenotype_col
      ) +
      theme_minimal() +
      theme(
        axis.title.x = element_text(size = 11),
        axis.text.x.bottom = element_text(size = 11),
        axis.title.y = element_text(size = 11),
        axis.text.y.left = element_text(size = 11)
      )
  }

  return(p)
}
