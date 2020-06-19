# CoronaPlotter

Simple MATLAB function for plotting the amount of Corona cases and deaths of any country in the world over time with curve fitting possibility.

Format of the function: `Corona(start_date, end_date, country, plotStyle, fitType)`

Data source: https://www.ecdc.europa.eu/en/publications-data/download-todays-data-geographic-distribution-covid-19-cases-worldwide (Make sure to use the csv 

### Cumulative
##### cumul
Run example: `Corona('01-Mar-2020 00:00:00', '22-May-2020 00:00:00', 'Belgium', 'cumul')` (The fitType can be omitted).

This command will plot the cumulative data.

##### logcumul
Run example: `Corona('01-Mar-2020 00:00:00', '22-May-2020 00:00:00', 'Belgium', 'logcumul')` (The fitType can be omitted).

This command will plot the cumulative data in a semilog plot.


### Not cumulative

Run example: `Corona('01-Mar-2020 00:00:00', '22-May-2020 00:00:00', 'Belgium', 'daily', 'poly3')`
This command will plot the raw data, as well as a cubic polynomial curve fitted to the data, of all the deaths and cases in Belgium between March 1st 2020 and May 22nd 2020.

Possible fit types:

| `fitType`             | Description                      |
| --------------------- |:--------------------------------:|
| `'poly1'`             | Linear polynomial curve          |
| `'poly2'`             | Quadratic polynomial curve       |
| `'poly3'`             | Cubic polynomial curve           |
| `'poly4'`             | 4th order polynomial curve       |
| `'poly5'`             | 5th order polynomial curve       |
| `'linearinterp'`      | Piecewise linear interpolation   |
| `'cubicinterp'`       | Piecewise cubic interpolation    |
| `'smoothingspline'`   | Smoothing spline (curve)         |

