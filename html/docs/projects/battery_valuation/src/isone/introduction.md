# Introduction

ISONE models a battery (continuous storage facility) as 3 interrelated assets.  A generator asset, a demand asset, and a regulation resource.  The participant is responsible for developing daily DA bids and offers such that the battery does not get a DA obligation to charge and discharge at the same time.  

This note will focus on revenues from the **energy market only**.  A battery will also receive revenues and incur charges from the capacity market if it has a capacity supply obligation.  This capacity revenue stream is independent, relatively fixed, and can be added later.  Also, a battery can participate in the Regulation market or other ancillaries markets (e.g. Reserves.)  The revenues from the ancillary markets are smaller and overlapping with the energy market, that is the asset receives either one or the other (not both) revenue stream.  While ISO will 'optimize' the asset for you by choosing the product with the best economics, we believe the optimization benefit to be small, and for simplicity it's best to restrict ourselves to the energy market.  

In the following, we'll focus on a **four hour battery** as it's the typical/preferred installation at this time.  The valuation presented here incorporates several constraints and data sheet parameters as shown below

| Constraint                    |   Value    |
|-------------------------------|------------|
| Number of cycles per day      |     1      |
| Number of cycles per year     |   365      |
| Yearly degradation            |     5%     |
| Round-trip efficiency rating  |    85%     |

## Operations

There are several ways to operate a battery.  In the following, we'll focus on three distinct ones.  

### DA fixed

The operator preselects the hours to charge and discharge the battery and structures the bids and offers in such a way to get a DA schedule that he wants.  The selection of *best* hours to charge/discharge can be determined from history.  Then in the RT market, the operator self-schedules the unit to match the DA schedule exactly.  This way, they are insulated from any RT deviations and charges, but fail to capture any higher RT price spreads if they materialize.

### RT fixed

The operator structures his bids/offers in such a way as to disincentivize getting a DA obligation (high energy offers, low demand bids.)  It can then self-schedule the battery in RT to charge and discharge in certain predetermined blocks of hours.  This allows the operator to capture potentially higher volatility and price spreads that exist in the RT market.  At the same time, there are also downsides because price spreads between discharging and charging hours may end up being even lower than in the DA market, or that the preselected blocks of hours miss the lowest/highest priced hours of the day.

### Flex strategy

A combination of the previous two strategies that combines the best of **DA fixed** and **RT fixed**.  In the DA market, let the ISO optimize for the best hours to charge and discharge only imposing the restriction that charging should be done by a given hour, say hour beginning 15.  Now charging and discharging can take place over non-contiguous hours.  In the RT market, the operator can decide to deviate from the DA schedule based on a simple rule


<div>
{{#include ../../assets/isone/table_flex_strategy.html}}
</div> 
 
where \\(P_{RT}\\) is the last RT price print (5-min interval), \\(\overline P_{DA}^c\\) is the average DA price of charging hours, \\(\overline P _{DA}^d\\) is the average 
DA price of discharging hours, and \\(f\\) is a fraction, say \\(f=0.3\\).


This **flex strategy** is able to capture more optionality, both in the DA market and in the RT market, but it needs significant monitoring throughout the operating day.  Once the battery becomes fully charged, which could be before what was expected in the DAM, it needs to be made available for  discharge to capture any price spikes above \\((1 + f) \overline P_{DA}^d\\).  

Note that because the battery has a DAM commitment to fully charge and discharge during the day, it will never be ending the day in a partially charged state.    




