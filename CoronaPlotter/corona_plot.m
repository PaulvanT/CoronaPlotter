function corona_plot(start_date, end_date, countries, option)
    
    % Fetching the newest data from the 'European Centre for Disease
    % Prevention and Control' website
    url = 'https://opendata.ecdc.europa.eu/covid19/casedistribution/csv';
    options = weboptions;
    options.Timeout = 10;
    websave('ecdpc_data.csv', url, options);
    opts = detectImportOptions('ecdpc_data.csv');
    T = readtable('ecdpc_data.csv', opts);
    
    if nargin < 4
        option = "None";
    end
    
    % Get the dates
    [dates, ~, ~, ~, ~] = ...
            fetch_data(T,start_date, end_date, countries(1), option);
    
    % Fetch COVID data per country
    n = length(countries);
    m = length(dates);
    cases = zeros(m, n);
    deaths = zeros(m, n);
    cumulcases = zeros(m, n);
    cumuldeaths = zeros(m, n);
    for i = 1:n
        [~, casestemp, deathstemp, cumulcasestemp, cumuldeathstemp] = ...
            fetch_data(T,start_date, end_date, countries(i), option);
        
        % Add zeroes for missing data
        if size(casestemp) == size(cases(:,i))
            cases(:, i) = casestemp;
        else
            cases(:, i) = zeros(m,1);
            countries(i)
        end
        
        if size(deathstemp) == size(deaths(:,i))
            deaths(:, i) = deathstemp;
        else
            deaths(:, i) = zeros(m,1);
            countries(i)
        end
        
        if size(cumulcasestemp) == size(cumulcases(:,i))
            cumulcases(:, i) = cumulcasestemp;
        else
            cumulcases(:, i) = zeros(m,1);
            countries(i)
        end
        
        if size(cumuldeathstemp) == size(cumuldeaths(:,i))
            cumuldeaths(:, i) = cumuldeathstemp;
        else
            cumuldeaths(:, i) = zeros(m,1);
            countries(i)
        end
    end
    
    % Format country names containinng underscores
    for i = 1:n
        countries(i) = strrep(countries(i),'_',' ');
    end
    
    % Plot
    main_title = sprintf('COVID-19 Data');
    figure('Name',main_title,'NumberTitle','off');
    tl = tiledlayout(2,2);
    title(tl, 'COVID-19 data comparison (Data source: European Centre for Disease Prevention and Control (ECDPC))')
    nexttile;
    for i = 1:n
        hold on
        plot(dates , cases(:, i), '+-', 'linewidth', 3);
    end
    xlabel('Date')
    text = sprintf('Confirmed cases (%s)', option);
    ylabel(text)
    grid on
    grid minor
    legendstrings = cell(1, n);
    for k = 1:n  
        legendstrings{k} = sprintf('%s', countries(k));
    end
    legend(legendstrings,'Location', 'NorthWest');
    title(sprintf('Weekly ECDPC data (%s)', option))

    nexttile;
    for i = 1:n
        hold on
        plot(dates, deaths(:, i), '+-', 'linewidth', 3);
    end
    xlabel('Date')
    text = sprintf('Confirmed deaths (%s)', option);
    ylabel(text)
    grid on
    grid minor
    legendstrings = cell(1, n);
    for k = 1:n  
        legendstrings{k} = sprintf('%s', countries(k));
    end
    legend(legendstrings,'Location', 'NorthWest');
    title(sprintf('Weekly ECDPC data (%s)', option))

    nexttile;
    for i = 1:n
        hold on
        plot(dates , cumulcases(:, i), 'linewidth', 3);
    end
    xlabel('Date')
    text = sprintf('Confirmed cases (%s)', option);
    ylabel(text)
    grid on
    grid minor
    legendstrings = cell(1, n);
    for k = 1:n  
        legendstrings{k} = sprintf('%s', countries(k));
    end
    legend(legendstrings,'Location', 'NorthWest');
    title(sprintf('Cumulative ECDPC data (%s)', option))

    nexttile;
    for i = 1:n
        hold on
        plot(dates, cumuldeaths(:, i), 'linewidth', 3);
    end
    xlabel('Date')
    text = sprintf('Confirmed deaths (%s)', option);
    ylabel(text)
    grid on
    grid minor
    legendstrings = cell(1, n);
    for k = 1:n  
        legendstrings{k} = sprintf('%s', countries(k));
    end
    legend(legendstrings,'Location', 'NorthWest');
    title(sprintf('Cumulative ECDPC data (%s)', option))

end