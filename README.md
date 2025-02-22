# Stock-Returns
Get historical daily prices from Yahoo Finance for specified stock symbols, compute returns, and analyze them.
Sample output from `xget_prices_compute_returns.r`:

```
 2045 dates of prices from 2017-01-03 to 2025-02-20 

Performance Metrics (Risk-Free Rate = 0.03 ):
                          SPY     TLT     LQD    FALN     HYG
Annualized_Returns     0.1392 -0.0117  0.0232  0.0553  0.0419
Annualized_Volatility  0.1834  0.1550  0.0917  0.0932  0.0871
Sharpe_Ratio           0.5953 -0.2688 -0.0738  0.2715  0.1368
Skewness              -0.8477  0.0809  0.3403 -2.4754 -0.1291
Kurtosis              17.2119  8.0177 30.0884 56.5442 29.4554
Minimum               -0.1159 -0.0690 -0.0513 -0.0800 -0.0565
Maximum                0.0867  0.0725  0.0713  0.0581  0.0634

Correlation Matrix of Returns:
         SPY     TLT    LQD   FALN    HYG
SPY   1.0000 -0.1767 0.3092 0.7014 0.7832
TLT  -0.1767  1.0000 0.6741 0.1285 0.0592
LQD   0.3092  0.6741 1.0000 0.6186 0.5726
FALN  0.7014  0.1285 0.6186 1.0000 0.8888
HYG   0.7832  0.0592 0.5726 0.8888 1.0000
```
