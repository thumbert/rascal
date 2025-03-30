# PnL

The profitability of the battery using the four different strategies is summarized by year in the following table.

{{#include ../../assets/isone/annual_value.html}}

Somehow surprisingly at first, the **Flex** strategy does not provide any meaningful improvement over the **ISO DA optim** strategy.  Because charging usually happens early in the day, there simply aren't enough days where the battery could be charged before the DA schedule.  Similarly, there are only a handful of days when the RT prices spiked after the battery was charged to trigger a discharge outside of the optimal DA schedule.  The higher value obtained in year 2022 is likely due to higher realized spot prices.  

In the following figures, to simplify the presentation, I have removed the **Flex** strategy given that it provides similar values to the **ISO DA optim** strategy.

{{#include ../../assets/isone/monthly_pnl_jan21aug24.html}}

From the chart above one can see that the RT volatility can at times produce higher realized values, however in most cases the opposite is true, as the RT spreads are lower than the spreads in the DAM or the battery may miss the best RT hours.  This is even more evident when looking on a daily granularity.  Shown below is the battery profitability during 2023.  

{{#include ../../assets/isone/daily_pnl_cal23.html}}

As a next step, I plan to calculate the profitability of the battery assuming a perfect look-back, that is every day use the best 4 hours in RT to charge and discharge.   This will provide the upper limit of the historical payoff, and is not something that can be realistically achieved.   


