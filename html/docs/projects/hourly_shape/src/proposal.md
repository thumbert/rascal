# Proposal

For an illustration of the issue, below is the hourly shape 
associated with the electricity demand for two different days in 
[ISO New England](https://www.iso-ne.com/).

{{#include assets/two_days.html}}

The dip in the middle of the day is very evident; March 29th was a 
sunny day whereas March 14th was a cloudy day.  Note how for the early 
morning hours and late evening hours the two curves are very similar;
they are simply shifted vertically relative to one another.  The only 
difference appears during the hours when the sun is up, in this case 
between hours 7 and 19.

In order to quantify the effect of the solar generation for an hourly 
shape \\( w(t) \\), between two hours \\(t_i\\) and \\(t_f\\) we introduce 
the measure 

\\[ D =  \frac{1}{t_f - t_i} \int_{t_i}^{t_f} w(t) dt  - \frac{w_i + w_f}{2},\\]
where \\(w_i = w(t_i)\\) and \\(w_f = w(t_f)\\). 

The value of \\(D\\) is the ratio of the difference of the area under the 
weights \\(w(t)\\) and the area of the right-angle trapezoid defined 
by the points \\([t_i, 0]\\), \\([t_i, w_i]\\), \\([t_f, w_f]\\), 
\\([t_f, 0]\\) to the time interval \\(t_f - t_i\\). 

This definition has several nice properties.  It is a dimensionless quantity. 
Its value is signed.  A sunny day, with a dip in the hourly shape 
will have a negative value for \\(D\\), whereas a cloudy day will exhibit a 
positive value.  Indeed, for the two days mentioned in the figure above, 
\\(D=-0.16\\) on March 29th and \\(D=0.02\\) on March 14th.  A day with 
a more pronounced dip in its hourly shape than another day will have a lower 
\\(D\\) value.  Therefore, as solar penetration increases in a region, 
this should be evident by simply plotting the values of \\(D\\) over time. 
The calculation of \\(D\\) is very fast once the integral is written in 
discrete form.  


