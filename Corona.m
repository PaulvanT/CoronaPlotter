function Corona(start_date, end_date, country, fitType)

% Run example: Corona('01-Mar-2020 00:00:00', '22-May-2020 00:00:00', 'Belgium', 'poly3')

    % Dissecting data
    opts = detectImportOptions('download.csv'); % Data source: https://www.ecdc.europa.eu/en/publications-data/download-todays-data-geographic-distribution-covid-19-cases-worldwide
    T = readtable('download.csv', opts);
    
    country_rows = strcmp(T.countriesAndTerritories, country);
    T = T(country_rows, :);
    start_date_rows = (T.dateRep >= start_date);
    T = T(start_date_rows, :);
    end_date_rows = (T.dateRep <= end_date);
    T = T(end_date_rows, :);
    
    dates = table2array(T(:, 1));
    cases = table2array(T(:, 5));
    deaths = table2array(T(:, 6));

    % Curve fitting
    x = linspace(0, length(dates), length(dates))';
    fitcases = feval(fit(x, cases, fitType), x);
    fitdeaths = feval(fit(x, deaths, fitType), x);


    % Plot
    figure('Name','COVID-19','NumberTitle','off');
    tiledlayout(2,1);

    nexttile;
    plot(dates , cases, '+-', 'linewidth', 2);
    hold on
    plot(dates , fitcases, 'linewidth', 3);
    xlabel('Date')
    ylabel('Confirmed cases')
    legend('ECDC data', 'Fitted curve')

    nexttile;
    plot(dates, deaths, '+-', 'linewidth', 2);
    hold on
    plot(dates, fitdeaths, 'linewidth', 3);
    xlabel('Date')
    ylabel('Confirmed deaths')
    legend('ECDC data', 'Fitted curve')

end
