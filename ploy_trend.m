% Read and clean the data
weather = readtable('cities.csv');
weather.date = datetime(weather.date, 'InputFormat', 'yyyy-MM-dd');

% Filter data for a specific city
city = 'Adana';
city_data = weather(strcmp(weather.city_name, city), :);

% Remove rows with missing temperature or date
valid_idx = ~ismissing(city_data.daily_avg_temp) & ~ismissing(city_data.date);
city_data = city_data(valid_idx, :);

% Prepare X and Y for polyfit
x = datenum(city_data.date);             % convert dates to numbers
x_centered = x - mean(x);                % center x to avoid numerical instability
y = double(city_data.daily_avg_temp);    % ensure y is numeric

% Fit a 3rd-degree polynomial and evaluate
p = polyfit(x_centered, y, 3);
y_fit = polyval(p, x_centered);

% Plot original data and fitted trendline
figure
plot(city_data.date, y, '.-', 'DisplayName', 'Daily Avg Temp')
hold on
plot(city_data.date, y_fit, '--r', 'LineWidth', 2, 'DisplayName', 'Trendline')
hold off

xlabel('Date')
ylabel('Temperature (°C)')
title(['Daily Avg Temp with Trendline - ' city])
legend
grid on
