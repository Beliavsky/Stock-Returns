# Downloads stock prices, computes returns and stats, optionally saves to CSV.

# Load required library quietly
suppressPackageStartupMessages(library(quantmod))
# Load moments package for skew and kurtosis
suppressPackageStartupMessages(library(moments))

get_prices <- function(symbols, start_date, end_date, verbose = TRUE) {
  # Function to download adjusted closing prices  
  # Create empty list to store prices
  price_list <- list()
  
  # Download data for each symbol
  for (symbol in symbols) {
    tryCatch({
      # Get stock data
      stock_data <- getSymbols(symbol, from = start_date, to = end_date, 
                              auto.assign = FALSE)
      
      # Store adjusted closing prices
      prices <- Ad(stock_data)
      colnames(prices) <- symbol
      price_list[[symbol]] <- prices
      
      # Print download status if verbose is TRUE
      if (verbose) {
        cat("Successfully downloaded data for", symbol, "\n")
      }
    }, error = function(e) {
      cat("Error downloading", symbol, ":", conditionMessage(e), "\n")
    })
  }
  
  # Merge all prices into a dataframe
  price_df <- do.call(merge, price_list)
  
  # Always print date range and number of dates
  date_range <- range(index(price_df))
  num_dates <- nrow(price_df)
  cat("\n", num_dates, "dates of prices from", 
      as.character(date_range[1]), "to", 
      as.character(date_range[2]), "\n")
  
  return(price_df)
}

analyze_returns <- function(price_df, trading_days_per_year = 252, 
                           risk_free_rate = 0.0, verbose = TRUE,
                           output_prices_file = "stock_prices.csv",
                           print_correlation = TRUE) {
# Function to analyze returns and compute statistics
#   Args: price_df (dataframe), trading_days_per_year (int), risk_free_rate (float),
#         verbose (logical), output_prices_file (string), print_correlation (logical)
#   Returns: List of prices, returns, stats"
  
  # Get symbol names from price dataframe
  symbols <- colnames(price_df)
  
  # Calculate daily returns for each symbol, preserving symbol names
  return_list <- lapply(seq_along(symbols), function(i) {
    returns <- dailyReturn(price_df[, i], type = "log")
    colnames(returns) <- symbols[i]
    returns
  })
  
  # Merge returns into a dataframe
  return_df <- do.call(merge, return_list)
  
  # Remove NA values from returns for calculations
  return_df_clean <- na.omit(return_df)
  
  # Calculate metrics
  annualized_returns <- apply(return_df_clean, 2, function(x) 
    mean(x) * trading_days_per_year)
  
  annualized_vol <- apply(return_df_clean, 2, function(x) 
    sd(x) * sqrt(trading_days_per_year))
  
  rf_annualized <- risk_free_rate
  sharpe_ratios <- (annualized_returns - rf_annualized) / annualized_vol
  skew_vals <- apply(return_df_clean, 2, skewness)
  kurt_vals <- apply(return_df_clean, 2, kurtosis)
  min_vals <- apply(return_df_clean, 2, min)
  max_vals <- apply(return_df_clean, 2, max)
  
  # Correlation matrix
  cor_matrix <- cor(return_df_clean)
  
  # Combine metrics into a single table
  results_table <- rbind(
    Annualized_Returns = annualized_returns,
    Annualized_Volatility = annualized_vol,
    Sharpe_Ratio = sharpe_ratios,
    Skewness = skew_vals,
    Kurtosis = kurt_vals,
    Minimum = min_vals,
    Maximum = max_vals
  )
  
  # Print results as a single table
  cat("\nPerformance Metrics (Risk-Free Rate =", rf_annualized, "):\n")
  print(round(results_table, 4))
  
  # Print correlation matrix if print_correlation is TRUE
  if (print_correlation) {
    cat("\nCorrelation Matrix of Returns:\n")
    print(round(cor_matrix, 4))
  }
  
  # Prepare price data for writing without quotes
  price_df_formatted <- as.data.frame(price_df)
  price_df_formatted <- cbind(Date = index(price_df), price_df_formatted)
  
  # Write prices to CSV if output_prices_file is not empty
  if (output_prices_file != "") {
    write.table(price_df_formatted, output_prices_file, 
                sep = ",", 
                quote = FALSE, 
                row.names = FALSE,
                col.names = c("Date", symbols))
    if (verbose) {
      cat("\nPrices written to", output_prices_file, "\n")
    }
  }
  
  # Return results as a list
  return(list(
    prices = price_df,
    returns = return_df,
    annualized_returns = annualized_returns,
    volatility = annualized_vol,
    sharpe_ratios = sharpe_ratios,
    skewness = skew_vals,
    kurtosis = kurt_vals,
    minimum = min_vals,
    maximum = max_vals,
    correlation = cor_matrix
  ))
}

# Example usage
symbols <- c("SPY", "TLT", "LQD", "FALN", "LQD", "HYG")
start_date <- "2017-01-01"
end_date <- "2025-02-21"  # Using current date from system
trading_days <- 252       # Standard number of trading days in a year
rf_rate <- 0.03          # 3% annual risk-free rate
verbose <- FALSE
output_prices_file <- "temp.csv"

# Get prices
prices <- get_prices(symbols, start_date, end_date, verbose = verbose)

# Analyze returns with correlation matrix
results_with_corr <- analyze_returns(prices, trading_days, rf_rate, 
                                    verbose = verbose, 
                                    output_prices_file = output_prices_file,
                                    print_correlation = TRUE)
