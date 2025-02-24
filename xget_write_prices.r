# Downloads OHLCV(OI) data for stocks and saves to individual CSV files in an output directory."

source("price_utils.r") # download_stock_data()

# Example usage
start_date <- "2000-01-01"
end_date <- "2100-01-01"
verbose <- TRUE
output_dir <- "etfs" # stock_data"   # Output directory
ticker_file <- "tickers.txt" # Set to "" for no file, or e.g., "tickers.txt"
summary_df <- TRUE           # Set to TRUE to print summary dataframe
include_symbol_in_colnames <- FALSE  # Set to FALSE to exclude symbol from column names
max_sym = 4

# Determine symbols based on ticker_file
if (ticker_file != "" && file.exists(ticker_file)) {
  symbols <- readLines(ticker_file)
  symbols <- trimws(symbols)  # Remove any leading/trailing whitespace
  if (length(symbols) == 0) stop("Ticker file is empty")
} else {
  # Default symbols if no ticker file is specified or exists
  symbols <- c("SPY", "EFA", "EEM")
}
if (length(symbols) > max_sym) symbols <- symbols[1:max_sym]

# Download data and save to files
download_stock_data(symbols, start_date, end_date, output_dir, 
                    verbose = verbose, summary_df = summary_df,
                    include_symbol_in_colnames = include_symbol_in_colnames)
