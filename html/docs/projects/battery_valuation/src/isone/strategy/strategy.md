## Strategies

There are several ways to operate the battery resulting in different valuations and risk profiles.  In the following, we'll analyze four possible strategies.  

#### DA fixed strategy

The operator preselects the hours to charge and discharge the battery and structures the bids and offers in such a way to get a DA schedule that they want.  The selection of *best* hours to charge/discharge is predetermined from history.  Then in the RT market, the operator self-schedules the unit to match the DA schedule exactly.  This way, they are insulated from any RT deviations, but fail to capture any higher RT price spreads if they materialize.


#### RT fixed strategy

The operator structures his bids/offers in such a way as to disincentivize getting a DA obligation (high energy offers, low demand bids.)  It can then self-schedule the battery in RT to charge and discharge in certain predetermined blocks of hours.  This allows the operator to capture potentially higher volatility and price spreads that exist in the RT market.  At the same time, there are also downsides because price spreads between discharging and charging hours may end up being even lower than in the DA market, or that the preselected blocks of hours miss the lowest/highest priced hours of the day.

#### ISO DA optimization strategy

An improvement over the **DA fixed** strategy is to let the ISO decide every day during the DAM model the best hours to charge and discharge for the battery.  To ensure that the ISO doesn't pick up hours to charge and discharge that overlap or even reverse, impose a constraint that charging should be done by a given hour, say hour beginning 15:00.  Then, discharging to empty takes place from 15:00 to midnight.  

The benefit of this strategy is that charging and discharging can take place over non-contiguous hours, for example taking advantage of unexpected low prices in the middle of the day to charge before starting the discharge. 

This strategy still enforces one full cycle per day.  There is no a priori guarantee that the cycle will be profitable although the history suggests that it is, except for a handful of days.

#### Flex strategy

Even though we expect the **ISO DA optimization** strategy to do better than the **DA fixed** strategy, we should also devise a strategy that tries to capture price spikes in RT.  In some days, RT prices may get to a level that may justify discharging ahead of the DA schedule.  However, without look-ahead knowledge of RT price path bal-day, there is no guarantee that deviating from the DA schedule to capture a RT price spike results in better economics.    

For this **flex strategy**, we let the ISO optimize for the best hours to charge and discharge in the DAM, in the same way as in the **ISO DA optimization** strategy.  But in the RT market, the operator can decide to deviate from the DA schedule based on a simple rule  

<div>
{{#include ../../../assets/isone/table_flex_strategy.html}}
</div> 
 
where \\(P_{RT}\\) is the last RT price print (5-min interval), \\(\overline P_{DA}^c\\) is the average DA price of charging hours, \\(\overline P _{DA}^d\\) is the average 
DA price of discharging hours, and \\(f\\) is a fraction, say \\(f=0.3\\).


The **flex strategy** is able to capture more RT optionality potentially increasing the PnL.  However, it needs significant monitoring throughout the operating day.  Once the battery becomes fully charged, which could be before what was expected in the DAM, it needs to be made available for  discharge right away to capture any price spikes above \\((1 + f) \overline P_{DA}^d\\).  

Note that because the battery has a DAM commitment to fully charge and discharge during the day, it will never be ending the day in a partially charged state.    


