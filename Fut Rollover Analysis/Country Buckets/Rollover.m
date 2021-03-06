clear
clc
%% Load data
% load front- and backprices and ticker names separately
austral_data    = readtable('Australian Futs.xlsx');
austral_ticker  = readtable('Australian Futs.xlsx','Sheet','Sheet2');

canad_data      = readtable('Canadian Futures.xlsx');
canad_ticker    = readtable('Canadian Futures.xlsx','Sheet','Sheet2');

french_data     = readtable('FrenchFutures.xlsx');
french_ticker   = readtable('FrenchFutures.xlsx','Sheet','Sheet2');

german_data     = readtable('GermanyFuts.xlsx');
german_ticker   = readtable('GermanyFuts.xlsx','Sheet','Sheet2');

ital_data       = readtable('Italian Futures.xlsx');
ital_ticker     = readtable('Italian Futures.xlsx','Sheet','Sheet2');

spain_data      = readtable('Spain Futures.xlsx');
spain_ticker    = readtable('Spain Futures.xlsx','Sheet','Sheet2');

swiss_data      = readtable('Swiss Futures.xlsx');
swiss_ticker    = readtable('Swiss Futures.xlsx','Sheet','Sheet2');

china_data      = readtable('China Futures.xlsx');
china_ticker    = readtable('China Futures.xlsx','Sheet','Sheet2');

japan_data      = readtable('Japan Futures.xlsx');
japan_ticker    = readtable('Japan Futures.xlsx','Sheet','Sheet2');

korea_data      = readtable('Korea Futures.xlsx');
korea_ticker    = readtable('Korea Futures.xlsx','Sheet','Sheet2');

uk_data         = readtable('UK Futures.xlsx');
uk_ticker       = readtable('UK Futures.xlsx','Sheet','Sheet2');

us_data         = readtable('USFutures.xlsx');
us_ticker       = readtable('USFutures.xlsx','Sheet','Sheet2');

%% Changes To data

% make necessary adjustments
austral_price   = str2double(table2cell(austral_data(6 : end, 2 : end)));
canada_price    = str2double(table2cell(canad_data(6 : end, 2 : end)));
french_price    = str2double(table2cell(french_data(6 : end, 2 : end)));
german_price    = str2double(table2cell(german_data(6 : end, 2 : end)));
ital_price      = str2double(table2cell(ital_data(6 : end, 2 : end)));
spain_price     = str2double(table2cell(spain_data(6 : end, 2 : end)));
swiss_price     = str2double(table2cell(swiss_data(6 : end, 2 : end)));
china_price     = str2double(table2cell(china_data(6 : end, 2 : end)));
japan_price     = str2double(table2cell(japan_data(6 : end, 2 : end)));
korea_price     = str2double(table2cell(korea_data(6 : end, 2 : end)));
uk_price        = str2double(table2cell(uk_data(6 : end, 2 : end)));
us_price        = str2double(table2cell(us_data(6 : end, 2 : end)));

austral_ticker  = table2cell(austral_ticker(6 : end, 2 : end));
canada_ticker   = table2cell(canad_ticker(6 : end, 2 : end));
french_ticker   = table2cell(french_ticker(6 : end, 2 : end));
german_ticker   = table2cell(german_ticker(6 : end, 2 : end));
ital_ticker     = table2cell(ital_ticker(6 : end, 2 : end));
% excludes the other long of spain
spain_ticker    = table2cell(spain_ticker(6 : end, 2 : end - 1));
swiss_ticker    = table2cell(swiss_ticker(6 : end, 2 : end));
china_ticker    = table2cell(china_ticker(6 : end, 2 : end));
japan_ticker    = table2cell(japan_ticker(6 : end, 2 : end));
korea_ticker    = table2cell(korea_ticker(6 : end, 2 : end));
uk_ticker       = table2cell(uk_ticker(6 : end, 2 : end));
us_ticker       = table2cell(us_ticker(6 : end, 2 : end));

%% Adjust front and back prices

austral_front   = austral_price(:, [1 3 5]);
austral_back    = austral_price(:, [2 4 6]);

canada_front    = canada_price(:, [1 3 5 7]);
canada_back     = canada_price(:, [2 4 6 8]);

french_front    = french_price(:, [1 3]);
french_back     = french_price(:, [2 4]);

german_front    = german_price(:, [1 3 5 7]);
german_back     = german_price(:, [2 4 6 8]);

ital_front      = ital_price(:, [1 3 5]);
ital_back       = ital_price(:, [2 4 6]);

% for the spain long one could also take instead of 5 and 6 , 7 and 8
spain_front     = spain_price(:, [1 3 5]);
spain_back      = spain_price(:, [2 4 6]);

swiss_front     = swiss_price(:, [1 3]);
swiss_back      = swiss_price(:, [2 4]);

china_front     = china_price(:, 1);
china_back      = china_price(:, 2);

japan_front     = japan_price(:, [1 3 5]);
japan_back      = japan_price(:, [2 4 6]);

korea_front     = korea_price(:, [1 3 5]);
korea_back      = korea_price(:, [2 4 6]);

uk_front        = uk_price(:, [1 3 5 7]);
uk_back         = uk_price(:, [2 4 6 8]);

us_front        = us_price(:, [2 4 7 10]);
us_back         = us_price(:, [3 5 8 11]);

% load risk-free rate
rf_data         = readtable('FutPrices in Eur.xlsx');
eur_rf          = str2double(table2cell(rf_data(6 : end, 2))) / 100;
us_rf           = str2double(table2cell(rf_data(6 : end, 3))) / 100;
rf_dates        = yyyymmdd(datetime(table2cell(rf_data(6 : end, 1))));


%% Adjust rf

for i = 1 : length(eur_rf)
    if isnan(eur_rf(i))
        eur_rf(i) = us_rf(i);
    end
end

daycount    = diff(datenum(datetime(rf_dates, "ConvertFrom", "yyyymmdd")));
daycount    = [daycount; 1];
eur_rf      = eur_rf / 360 .* daycount;

%% Get first and last days of the month
[first, last]   = getFirstAndLastDayInPeriod(rf_dates, 2);

%% Futures rollover
austral_xs      = rolloverFutures(austral_front, austral_back, austral_ticker);
canada_xs       = rolloverFutures(canada_front, canada_back, canada_ticker);
french_xs       = rolloverFutures(french_front, french_back, french_ticker);
german_xs       = rolloverFutures(german_front, german_back, german_ticker);
ital_xs         = rolloverFutures(ital_front, ital_back, ital_ticker);
spain_xs        = rolloverFutures(spain_front, spain_back, spain_ticker);
swiss_xs        = rolloverFutures(swiss_front, swiss_back, swiss_ticker);
china_xs        = rolloverFutures(china_front, china_back, china_ticker);
japan_xs        = rolloverFutures(japan_front, japan_back, japan_ticker);
korea_xs        = rolloverFutures(korea_front, korea_back, korea_ticker);
uk_xs           = rolloverFutures(uk_front, uk_back, uk_ticker);
us_xs           = rolloverFutures(us_front, us_back, us_ticker);

%% Aggregate daily futures returns to monthly
[austral_mon_tr, austral_mon_xs, cumRf] = aggregateFutXsReturns(austral_xs, eur_rf, rf_dates, 2);
[canada_mon_tr, canada_mon_xs, cumRf]   = aggregateFutXsReturns(canada_xs, eur_rf, rf_dates, 2);
[french_mon_tr, french_mon_xs, cumRf]   = aggregateFutXsReturns(french_xs, eur_rf, rf_dates, 2);
[german_mon_tr, german_mon_xs, cumRf]   = aggregateFutXsReturns(german_xs, eur_rf, rf_dates, 2);
[ital_mon_tr, ital_mon_xs, cumRf]       = aggregateFutXsReturns(ital_xs, eur_rf, rf_dates, 2);
[spain_mon_tr, spain_mon_xs, cumRf]     = aggregateFutXsReturns(spain_xs, eur_rf, rf_dates, 2);
[swiss_mon_tr, swiss_mon_xs, cumRf]     = aggregateFutXsReturns(swiss_xs, eur_rf, rf_dates, 2);
[china_mon_tr, china_mon_xs, cumRf]     = aggregateFutXsReturns(china_xs, eur_rf, rf_dates, 2);
[japan_mon_tr, japan_mon_xs, cumRf]     = aggregateFutXsReturns(japan_xs, eur_rf, rf_dates, 2);
[korea_mon_tr, korea_mon_xs, cumRf]     = aggregateFutXsReturns(korea_xs, eur_rf, rf_dates, 2);
[uk_mon_tr, uk_mon_xs, cumRf]           = aggregateFutXsReturns(uk_xs, eur_rf, rf_dates, 2);
[us_mon_tr, us_mon_xs, cumRf]           = aggregateFutXsReturns(us_xs, eur_rf, rf_dates, 2);

%% Group futures into categories

short_futures = [german_mon_xs(:, 1), ital_mon_xs(:, 1), NaN(length(german_mon_xs), 1), spain_mon_xs(:, 1), ...
    NaN(length(german_mon_xs), 1), uk_mon_xs(:, 1), NaN(length(german_mon_xs), 1), NaN(length(german_mon_xs), 1), ...
    korea_mon_xs(:, 1), austral_mon_xs(:, 1), us_mon_xs(:, 1),  canada_mon_xs(:, 1)];
medium_futures = [german_mon_xs(:, 2), ital_mon_xs(:, 2), french_mon_xs(:, 1), spain_mon_xs(:, 2), ...
    swiss_mon_xs(:, 1), uk_mon_xs(:, 2), NaN(length(german_mon_xs), 1), japan_mon_xs(:, 1), ...
    korea_mon_xs(:, 2), NaN(length(german_mon_xs), 1), us_mon_xs(:, 2),  canada_mon_xs(:, 2)];
long_futures = [german_mon_xs(:, 3), ital_mon_xs(:, 3), french_mon_xs(:, 2), spain_mon_xs(:, 3), ...
    swiss_mon_xs(:, 2), uk_mon_xs(:, 3), china_mon_xs(:, 1), japan_mon_xs(:, 2), ...
    korea_mon_xs(:, 3), austral_mon_xs(:, 2), us_mon_xs(:, 3),  canada_mon_xs(:, 3)];
ultra_futures = [german_mon_xs(:, 4), NaN(length(german_mon_xs), 1), NaN(length(german_mon_xs), 1), NaN(length(german_mon_xs), 1), ...
    NaN(length(german_mon_xs), 1), uk_mon_xs(:, 4), NaN(length(german_mon_xs), 1), japan_mon_xs(:, 3), ...
    NaN(length(german_mon_xs), 1), austral_mon_xs(:, 3), us_mon_xs(:, 4),  canada_mon_xs(:, 4)];

%% Plot graphs
% kill nans
short_futures(isnan(short_futures)) = 0;
medium_futures(isnan(medium_futures)) = 0;
long_futures(isnan(long_futures)) = 0;
ultra_futures(isnan(ultra_futures)) = 0;

short_nav_xs = cumprod(1 + short_futures);
short_nav_tr = cumprod(1 + short_futures + cumRf);
medium_nav_xs = cumprod(1 + medium_futures);
medium_nav_tr = cumprod(1 + medium_futures + cumRf);
long_nav_xs = cumprod(1 + long_futures);
long_nav_tr = cumprod(1 + long_futures + cumRf);
ultra_nav_xs = cumprod(1 + ultra_futures);
ultra_nav_tr = cumprod(1 + ultra_futures + cumRf);

%% Plot Graphs
monthly_dates = rf_dates(first);

figure(1)
plot(short_nav_xs)
legend('Germany', 'Italy', 'France', 'Spain', 'Switzerland', 'UK', 'China', 'Japan', 'Korea', 'Australia', 'US', 'Canada')

figure(2)
plot(medium_nav_xs)
legend('Germany', 'Italy', 'France', 'Spain', 'Switzerland', 'UK', 'China', 'Japan', 'Korea', 'Australia', 'US', 'Canada')

figure(3)
plot(long_nav_xs)
legend('Germany', 'Italy', 'France', 'Spain', 'Switzerland', 'UK', 'China', 'Japan', 'Korea', 'Australia', 'US', 'Canada')

figure(4)
plot(ultra_nav_xs)
legend('Germany', 'Italy', 'France', 'Spain', 'Switzerland', 'UK', 'China', 'Japan', 'Korea', 'Australia', 'US', 'Canada')



