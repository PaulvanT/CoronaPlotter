
function [dates, cases, deaths, cumulcases, cumuldeaths] = ...
          fetch_data(T,start_date, end_date, country, option)

    % Select the rows of the country input
    country_rows = strcmp(T.countriesAndTerritories, country);
    T = T(country_rows, :);
    
    % Select the rows of the specified period    
    start_date_rows = (T.dateRep >= start_date);
    T = T(start_date_rows, :);
    end_date_rows = (T.dateRep <= end_date);
    T = T(end_date_rows, :);
    
    % Extract the data
    dates = flip(table2array(T(:, 1)));
    cases = flip(table2array(T(:, 3)));
    deaths = flip(table2array(T(:, 4)));
    
    % Per capita option
    if contains(option, 'per capita')
        population = unique(flip(table2array(T(:, 8))));
        cases = cases/population;
        deaths = deaths/population;
    end
    
    % Cumulative data
    cumulcases = zeros(length(cases), 1);
    if ~isempty(cases)
        cumulcases(1) = cases(1);
    end
    for i = 2:length(cases)
        cumulcases(i) = cumulcases(i-1) + cases(i);
    end
    
    cumuldeaths = zeros(length(deaths), 1);
    if ~isempty(cases)
        cumuldeaths(1) = deaths(1);
    end
    for i = 2:length(deaths)
        cumuldeaths(i) = cumuldeaths(i-1) + deaths(i);
    end

end
