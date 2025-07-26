% Read and clean the data
weather = readtable('cities.csv');
weather.date = datetime(weather.date, 'InputFormat', 'yyyy-MM-dd');

% Filter data for a specific city
city = 'Adana';
city_data = weather(strcmp(weather.city_name, city), :);

% Remove rows with missing temperature or date
valid_idx = ~ismissing(city_data.daily_avg_temp) & ~ismissing(city_data.date);
city_data = city_data(valid_idx, :);

% Compute 7-day moving average
city_data.temp_smooth = movmean(city_data.daily_avg_temp, 7);

% Plot raw data and smoothed data
figure
plot(city_data.date, city_data.daily_avg_temp, '.-', 'DisplayName', 'Daily Avg Temp')
hold on
plot(city_data.date, city_data.temp_smooth, '-', 'LineWidth', 2, 'DisplayName', '7-day Moving Avg')
hold off

xlabel('Date')
ylabel('Temperature (°C)')
title(['Daily Avg Temp - ' city])
legend
grid on
