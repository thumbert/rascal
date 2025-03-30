# Introduction

ISONE models a battery (continuous storage facility) as 3 interrelated assets.  A generator asset, a demand asset, and a regulation resource.  The participant is responsible for developing daily DA bids and offers such that the battery does not get a DA obligation to charge and discharge at the same time.  

This note will focus on revenues from the **energy market only**.  A battery will also receive revenues and incur charges from the capacity market if it has a capacity supply obligation.  This capacity revenue stream is independent, relatively fixed, and can be added later.  Also, a battery can participate in the Regulation market or other ancillaries markets (e.g. Reserves.)  The revenues from the ancillary markets are smaller and overlapping with the energy market, that is the asset receives either one or the other (not both) revenue stream.  While ISO will 'optimize' the asset for you by choosing the product with the best economics, we believe the optimization benefit to be small, and for simplicity it's best to restrict ourselves to the energy market.  

In the following, we'll focus on a **four hour battery** as it's the typical/preferred installation at this time.  The valuation presented here incorporates several constraints and data sheet parameters as shown below

| Constraint                    |   Value    |
|-------------------------------|------------|
| Number of cycles per day      |     1      |
| Number of cycles per year     |   365      |
| Yearly degradation            |     5%     |
| Round-trip efficiency rating  |    87.5%   |



