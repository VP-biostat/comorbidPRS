#' @title
#' Odds Ratio plot from Multiple PRS Associations
#'
#' @description
#' `orplot()` take a data frame of associations (format from assoc()),
#' return a plot (ggplot2 object) of Odds Ratio
#'
#' @param score_table a dataframe with association results with at least
#' PRS	Phenotype  OR	lower_CI	upper_CI	P_value
#' @param axis a character ('horizontal' or 'vertical') specifying the rotation
#' of the plot, 'vertical' by default
#' @param filename a facultative character, specifying the path and file name
#' where to store the plot
#' @param pval a  parameter specifying information on how to display P-value
#' if pval is FALSE, P-value does not appear on the plot
#' if pval is TRUE, P-value always appears next to the signal
#' if pval is a number, P-value will appear if the P-value is inferior to
#' this given number.
#'
#' @return return a figure of results in the format ggplot2 object
#' @import ggplot2
#' @export
orplot <- function(score_table = NULL, axis = "vertical", filename = NA, pval = 0.05) {
  ## Checking inputs
  if (is.null(score_table)) {
    stop("Please provide a data frame (that includes PRS values with at least
         PRS	Phenotype  OR	lower_CI	upper_CI	P_value)")
  } else if (!"PRS" %in% names(score_table)) {
    stop("Please provide a column 'PRS' in the data frame of results")
  } else if (!"Phenotype" %in% names(score_table)) {
    stop("Please provide a column 'Phenotype' in the data frame of results")
  } else if (!"OR" %in% names(score_table)) {
    stop("Please provide a column 'OR' in the data frame of results")
  } else if (!"lower_CI" %in% names(score_table)) {
    stop("Please provide a column 'lower_CI' in the data frame of results")
  } else if (!"upper_CI" %in% names(score_table)) {
    stop("Please provide a column 'upper_CI' in the data frame of results")
  } else if (!"P_value" %in% names(score_table)) {
    stop("Please provide a column 'P_value' in the data frame of results")
  } else if (!axis %in% c('horizontal','vertical')) {
    warning("Axis parameter is not 'horizontal' or 'vertical', changing it to
            the value by default")
    axis <- 'vertical'
  } else if (!class(pval) %in% c("numeric","integer","double","logical")) {
    stop("pval parameter should be either a logical or a numeric")
  }

  ## Making plot
  if (axis == 'vertical') {
    p <- ggplot(score_table, aes(x = Phenotype, y = OR, ymin = lower_CI, ymax = upper_CI, color = PRS)) +
      geom_point(position = position_dodge(0.7), cex = 2) +
      geom_errorbar(lwd = 1.25, width = 0.3, position = position_dodge(1)) +
      geom_hline(yintercept = 1, linetype = "dashed", colour = "grey") +
      geom_text(aes(label = ifelse(P_value <= pval, formatC(P_value, format = "e", digits = 1), ""), group = PRS),
                hjust=-0.1, vjust=-1, colour = 'black', size = 3, position = position_dodge(width = 0.7)) +
      labs(color = "PRS", y = "Odds Ratio", x = "Phenotype") +
      theme_minimal()+
      theme(axis.title.x = element_text(vjust=-0.5, size = 11),
            axis.text.x.bottom = element_text(size = 11, angle = 60),
            axis.title.y = element_text(size = 11),
            axis.text.y.left = element_text(size = 11),
            legend.position = ifelse((length(unique(score_table$PRS)) == 1), "none", "right"))
  } else if (axis == 'horizontal') {
    p <- ggplot(score_table, aes(y = Phenotype, x = OR, xmin = lower_CI, xmax = upper_CI, color = PRS)) +
      geom_point(position = position_dodge(0.7), cex = 2) +
      geom_errorbar(lwd = 1.25, width = 0.3, position = position_dodge(0.7)) +
      geom_hline(yintercept = 1, linetype = "dashed", colour = "grey") +
      geom_text(aes(label = ifelse(P_value <= pval, formatC(P_value, format = "e", digits = 1), ""), group = PRS),
                hjust=-0.1, vjust=-1, colour = 'black', size = 3, position = position_dodge2(width = 1)) +
      labs(color = "PRS", y = "Odds Ratio", x = "Phenotype") +
      theme_minimal()+
      theme(axis.title.x = element_text(vjust=-0.5, size = 11),
            axis.text.x.bottom = element_text(size = 11),
            axis.title.y = element_text(size = 11),
            axis.text.y.left = element_text(size = 11),
            legend.position = ifelse((length(unique(score_table$PRS)) == 1), "none", "bottom"))
  }

  if (!is.na(filename)) {
    ggsave(p, file = filename)
  }

  return(p)
}
