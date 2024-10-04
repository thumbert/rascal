<p style="text-align: center">Adrian A. Drăgulescu<br>January 22, 2024</p>


# Introduction

Electricity demand as a timeseries has various interesting characteristics.  In 
general, it depends on external factors like temperature, day of 
the week, time of the day, on wether the day is a holiday or not, on 
the customer type, etc. 

If we denote by \\( L_i \\) the electric load for hour \\(i\\), then the 
weight of hour \\(i\\) relative to the other hours of the day is by definition 
\\[ w_i =  \frac{L_i}{\langle L\rangle} \\]
where \\( \langle L\rangle \\) is the average load for that day.  The intraday pattern 
of electricity consumption as reflected by \\( w_i \\), is called the *hourly load shape*. 

Over many years, the hourly load shapes have been relatively stable for "similar" days, 
that is for days falling around the same time of the year and with close enough 
temperature after adjusting for day of the week patterns.  This has started to change 
in recent years as more and more solar panels have been installed across the US. 
On most regions of the country on sunny days the electricity demand now shows a 
pronounced dip in the middle of the day due to solar generation that 
offsets native customer demand. 

This change in hourly long shape has been popularized by the California Independent 
System Operator in 2012 with the catchy phrase [duck curve](https://en.wikipedia.org/wiki/Duck_curve). While
the mid-day dip in electricity demand on sunny days is evident in the data, 
is it not directly obvious how to quantify or compare qualitatively the strength 
of this effect between different days and electric regions. 

The increase in solar penetration is only expected to increase over the next few years, 
making the need for such a measure even more important.  This document proposes such a 
measure and shows several examples its use.  
