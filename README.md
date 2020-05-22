# Corona

Simple MATLAB function for plotting the amount of Corona cases and deaths over time with curve fitting possibility.

Format of the function: `Corona(start_date, end_date, country, fitType)`

Run example: `Corona('01-Mar-2020 00:00:00', '22-May-2020 00:00:00', 'Belgium', 'poly3')`
This command will plot pure data and cubic polynomial curve fitted to the data of all the deaths and cases in Belgium between March 1st 2020 and May 22nd 2020.

Data source: https://www.ecdc.europa.eu/en/publications-data/download-todays-data-geographic-distribution-covid-19-cases-worldwide

Possible fit types:

| FITTYPE               | DESCRIPTION                      |
| --------------------- |:--------------------------------:|
| `'poly1'`             | Linear polynomial curve          |
| `'poly2'`             | Quadratic polynomial curve       |
| `'poly3'`             | Cubic polynomial curve           |
| `'poly4'`             | 4th order polynomial curve       |
| `'poly5'`             | 5th order polynomial curve       |
| `'linearinterp'`      | Piecewise linear interpolation   |
| `'cubicinterp'`       | Piecewise cubic interpolation    |
| `'smoothingspline'`   | Smoothing spline (curve)         |
