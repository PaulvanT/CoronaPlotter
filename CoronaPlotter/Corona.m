%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Run examples %%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Daily numbers without curve fitting:
%               Corona('01-Mar-2020 00:00:00', '22-May-2020 00:00:00', 'Belgium', 'daily')
%
% Daily numbers with curve fitting:
%               Corona('01-Mar-2020 00:00:00', '22-May-2020 00:00:00', 'Belgium', 'dailyfit', 'poly4')
%
% Cumulative numbers, normal plot:
%               Corona('01-Mar-2020 00:00:00', '25-May-2020 00:00:00', 'Belgium', 'cumul')
%
% Cumulative numbers, log plot:
%               Corona('01-Mar-2020 00:00:00', '25-May-2020 00:00:00', 'Belgium', 'logcumul')
%
%
% Use 'help fit' in the Command Window to see fitType possibilities

function Corona(start_date, end_date, country, plotStyle, fitType)

    % Fetching the newest data from the 'European Centre for Disease
    % Prevention and Control' website
    url = 'https://opendata.ecdc.europa.eu/covid19/casedistribution/csv';
    options = weboptions;
    options.Timeout = 10;
    websave('ecdpc_data.csv', url, options);

    % Dissecting data
    opts = detectImportOptions('ecdpc_data.csv');
    T = readtable('ecdpc_data.csv', opts);
    if contains(country, 'World')
        % TO DO
    else
        country_rows = strcmp(T.countriesAndTerritories, country);
        T = T(country_rows, :);
    end
    
    
    if contains(plotStyle, 'daily')
        
        start_date_rows = (T.dateRep >= start_date);
        T = T(start_date_rows, :);
        end_date_rows = (T.dateRep <= end_date);
        T = T(end_date_rows, :);

        dates = flip(table2array(T(:, 1)));
        cases = flip(table2array(T(:, 3)));
        deaths = flip(table2array(T(:, 4)));
        
        % Apply filter on data to smooth it out
        n = length(dates);
        x = linspace(1, n, n)';
        filtered_cases = cases;
        filtered_deaths = deaths;
        a = 5; % Strongness of the filter
        for k = (a+1):(n-a)
            temp_cases = mean(filtered_cases(k-a:k+a));
            temp_deaths = mean(filtered_deaths(k-a:k+a));
            filtered_cases(k) = temp_cases;
            filtered_deaths(k) = temp_deaths;
        end
        
        if contains(plotStyle, 'fit')
            
            % Apply curvefitting on data
            fitted_casecurve = fit(x, cases, fitType);
            fitted_deathcurve = fit(x, deaths, fitType);
            fitcases = feval(fitted_casecurve, x);
            fitdeaths = feval(fitted_deathcurve, x);

            % Plot
            figure('Name','COVID-19','NumberTitle','off');
            tiledlayout(2,1);

            nexttile;
            plot(dates , cases, '+-', 'linewidth', 1);
            hold on
            plot(dates , filtered_cases, 'linewidth', 2);
            hold on
            plot(dates , fitcases, 'linewidth', 3);
            xlabel('Date')
            ylabel('Confirmed new cases')
            grid on
            grid minor
            legend('Daily ECDPC data','Filtered data', 'Fitted curve')

            nexttile;
            plot(dates, deaths, '+-', 'linewidth', 1);
            hold on
            plot(dates , filtered_deaths, 'linewidth', 2);
            hold on
            plot(dates, fitdeaths, 'linewidth', 3);
            xlabel('Date')
            ylabel('Confirmed new deaths')
            grid on
            grid minor
            legend('Daily ECDPC data','Filtered data', 'Fitted curve')
            
        else
            % Plot
            figure('Name','COVID-19','NumberTitle','off');
            tiledlayout(2,1);

            nexttile;
            plot(dates , cases, '+-', 'linewidth', 1);
            hold on
            plot(dates , filtered_cases, 'linewidth', 3);
            xlabel('Date')
            ylabel('Confirmed new cases')
            grid on
            grid minor
            legend('Daily ECDPC data','Filtered data')

            nexttile;
            plot(dates, deaths, '+-', 'linewidth', 1);
            hold on
            plot(dates , filtered_deaths, 'linewidth', 3);
            xlabel('Date')
            ylabel('Confirmed new deaths')
            grid on
            grid minor
            legend('Daily ECDPC data','Filtered data')
            
        end
    
    elseif contains(plotStyle, 'cumul')
        
        end_date_rows = (T.dateRep <= end_date);
        T = T(end_date_rows, :);
        cases = flip(table2array(T(:, 3)));
        cases(1) = 1;
        deaths = flip(table2array(T(:, 4)));
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
            legend('Cumulative ECDPC data')
            grid on

            nexttile;
            semilogy(dates, cumuldeaths, 'linewidth', 3);
            xlabel('Date')
            ylabel('Confirmed deaths')
            legend('Cumulative ECDPC data')
            grid on

        else
            
            figure('Name','COVID-19','NumberTitle','off');
            tiledlayout(2,1);

            nexttile;
            plot(dates , cumulcases, 'linewidth', 3);
            xlabel('Date')
            ylabel('Confirmed cases')
            grid on
            grid minor
            legend('Cumulative ECDPC data')

            nexttile;
            plot(dates, cumuldeaths, 'linewidth', 3);
            xlabel('Date')
            ylabel('Confirmed deaths')
            grid on
            grid minor
            legend('Cumulative ECDPC data')
            
        end
        
    else
        fprintf('\nEnter valid plotStyle\n');
    end


end
