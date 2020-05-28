function Corona(start_date, end_date, country, plotStyle, fitType)

% Run examples: 
%               Corona('01-Mar-2020 00:00:00', '22-May-2020 00:00:00', 'Belgium', 'daily', 'poly3')
%               Corona('01-Mar-2020 00:00:00', '25-May-2020 00:00:00', 'Belgium', 'logcumul')
%
% Use 'help fit' in the Command Window to see fitType possibilities

    % Dissecting data
    opts = detectImportOptions('download.csv'); % Data source: https://www.ecdc.europa.eu/en/publications-data/download-todays-data-geographic-distribution-covid-19-cases-worldwide
    T = readtable('download.csv', opts);
    country_rows = strcmp(T.countriesAndTerritories, country);
    T = T(country_rows, :);
    
    if contains(plotStyle, 'daily')
        
        start_date_rows = (T.dateRep >= start_date);
        T = T(start_date_rows, :);
        end_date_rows = (T.dateRep <= end_date);
        T = T(end_date_rows, :);

        dates = flip(table2array(T(:, 1)));
        cases = flip(table2array(T(:, 5)));
        deaths = flip(table2array(T(:, 6)));

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
    
    elseif contains(plotStyle, 'cumul')
        
        end_date_rows = (T.dateRep <= end_date);
        T = T(end_date_rows, :);
        cases = flip(table2array(T(:, 5)));
        cases(1) = 1;
        deaths = flip(table2array(T(:, 6)));
        deaths(1) = 1;
        
        start_date_rows = (T.dateRep >= start_date);
        T = T(start_date_rows, :);
        dates = flip(table2array(T(:, 1)));
        
        cumulcases = ones(length(cases), 1);
        cumuldeaths = ones(length(deaths), 1);
        
        for i = 1:length(cases)
            cumulcases(i,1) = sum(cases(1:i));
        end
        
        for i = 1:length(deaths)
            cumuldeaths(i,1) = sum(deaths(1:i));
        end
        
        n = length(dates);
        m = length(cumulcases);
        cumulcases = cumulcases(m-n+1: end);
        cumuldeaths = cumuldeaths(m-n+1: end);
        
        if contains(plotStyle, 'log')
            
            figure('Name','COVID-19','NumberTitle','off');
            tiledlayout(2,1);

            nexttile;
            semilogy(dates , cumulcases, 'linewidth', 3);
            xlabel('Date')
            ylabel('Confirmed cases')
            legend('Cumulative ECDC data')
            grid on

            nexttile;
            semilogy(dates, cumuldeaths, 'linewidth', 3);
            xlabel('Date')
            ylabel('Confirmed deaths')
            legend('Cumulative ECDC data')
            grid on

        else
            
            figure('Name','COVID-19','NumberTitle','off');
            tiledlayout(2,1);

            nexttile;
            plot(dates , cumulcases, 'linewidth', 3);
            xlabel('Date')
            ylabel('Confirmed cases')
            legend('Cumulative ECDC data')

            nexttile;
            plot(dates, cumuldeaths, 'linewidth', 3);
            xlabel('Date')
            ylabel('Confirmed deaths')
            legend('Cumulative ECDC data')
            
        end
        
    else
        fprintf('\nEnter valid plotStyle\n');
    end


end
