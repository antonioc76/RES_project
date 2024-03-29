clear;

OCV_data = readtable('10_16_2015_Initial capacity_SP20-1 (1).csv');

% voltage by time
voltages = OCV_data{:, 'Voltage_V_'};
times = OCV_data{:, 'Test_Time_s_'};

% state of charge (charging)
x_charging = OCV_data{1:12970, 'SOC_sum_A__As_'};
x_charging = x_charging(1:12970/7121:12970, 1);

% state of charge (discharging)
x_discharging = OCV_data{12970:20090, 'SOC_sum_A__As_'};

% voltage (charging)
y_charging = OCV_data{1:12970, 'Voltage_V__1'};
y_charging = y_charging(1:12970/7121:12970, 1);

% voltage (discharging)
y_discharging = OCV_data{12970:20090, 'Voltage_V__1'};
y_discharing = flip(y_discharging);

% averaging
x = x_charging;
y = (y_charging + flip(y_discharging)) / 2;

number_of_terms = 6;

A = zeros(number_of_terms, number_of_terms);
b = zeros(number_of_terms, 1);
[rows, columns] = size(x);

% plotting stress-strain diagram
figure(1)
hold on
plot(x_charging, y_charging, '-o', 'MarkerFaceColor', 'g', 'linewidth', 1, 'color', 'g');
plot(x_discharging, y_discharging, '-o', 'MarkerFaceColor', 'r', 'linewidth', 1, 'color', 'r');
plot(x, y, '-o', 'MarkerFaceColor', 'b', 'linewidth', 1, 'color', 'b');
grid

title('OCV vs. SOC')
xlabel('SOC')
ylabel('OCV (V)')
legend('charging', 'discharging', 'averaged');
set(gca, 'fontsiz', 16)

figure(2)
plot(times, voltages, '-o', 'MarkerFaceColor', 'b', 'linewidth', 1, 'color', 'b');
xlabel('time (sec)');
ylabel('voltage (V)');
hold on

% create the A matrix and b vector for a number_of_terms degree polynomial
for i = 1:number_of_terms
    for j = 1:number_of_terms
        A(i,j) = sum(x.^(i+j-2));
    end

    %A(1,1) = columns; % this is only for when you want to force the first point through zero

    b_element = sum(y .* x.^(i-1));
    b(i) = b_element;
    b(1) = sum(y);
end

z = A \ b;
z = flip(z); % descending order

Sample_Domain = linspace(0, 1.0, 100);

Y = polyval(z, Sample_Domain);

% plotting OCV curve
figure(3)
hold on
plot(x, y, '-o', 'MarkerFaceColor', 'r', 'linewidth', 2, 'color', 'r')
plot(Sample_Domain, Y, '--', 'linewidth', 2, 'color', [0 0 0])
grid

legend('data', 'polynomial of best fit', 'Location', 'southeast')
title('OCV(SOC) polynomial')
xlabel('SOC')
ylabel('OCV (V)')
set(gca, 'fontsiz', 16)