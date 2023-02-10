close all; format longG;
% This Leak Localization (Gradient Intersection) Technique expects:
% - Measurement at inlet and Outlet
% - Two sensors

real_leak_loc_rel = 0.80*100; % Needed to calculate error in estimative

%% Defining source data
% Expects file loaded with Results:
% Results.x → distance Vector [m]
% Results.t_step → time Vector [s]
% Results.Pressure → Pressure Vector(i,j) [Pa]
%   i → time dimension
%   j → distance dimension
% Results.Velocity → Velocity Vector(i,j) [m/s*]


% Sensor Location Definition
inlet_loc = 2;
sensor1_loc = 30;
outlet_loc = size(Results.x,1);
sensor2_loc = outlet_loc - 30;

% Time index definition (Should be after leak starts)

rel_time = 0.99; % Percentual
time_index = round(rel_time * size(Results.t_step,2));


%% Finding Slope and Intersection
% Linear Function → y = a*x + b
% a = slope
% b = intersection

coefficients = polyfit([Results.x(inlet_loc), Results.x(sensor1_loc)], [Results.Pressure(1000,inlet_loc), Results.Pressure(1000,sensor1_loc)], 1);
a1 = coefficients (1);
b1 = coefficients (2);

coefficients = polyfit([Results.x(outlet_loc), Results.x(sensor2_loc)], [Results.Pressure(1000,outlet_loc), Results.Pressure(1000,sensor2_loc)], 1);
a2 = coefficients (1);
b2 = coefficients (2);

%% Extrapolating curves from the slopes
figure;
y1 = a1.*Results.x+b1;
plot(Results.x, y1, 'DisplayName','Inlet Pressure Line'); hold on;

y2 = a2.*Results.x+b2;
plot(Results.x, y2, 'DisplayName','Outlet Pressure Line'); hold on;

legend; title("Gradient Intersection Method"); xlabel("Pipeline ROW [m]"); ylabel("Pressure [Pa]");
xlim([min(Results.x), max(Results.x)]); ylim([min(Results.Pressure(:)), max(Results.Pressure(:))]);

%% Finding intersection of the two gradient
[x0,y0] = intersections(Results.x, y1, Results.x, y2);
% x0 → Leak position (m)
% y0 → Pressure at the moment of the leak (Pa)

plot(x0,y0, 'ro', 'DisplayName', 'Leak Point');

leak_loc_abs = x0;
leak_loc_rel = x0/max(Results.x)*100;
disp(['Leak detected in ', num2str(round(leak_loc_abs)), 'm', ' (', num2str(round(leak_loc_rel,1)), '%).']);


leak_loc_error_rel = leak_loc_rel - real_leak_loc_rel;
leak_loc_error_rel_abs = leak_loc_error_rel*max(Results.x)/100;

disp(['The error in this measurement was ', num2str(round(leak_loc_error_rel_abs)), 'm', ' (', num2str(round(leak_loc_error_rel,1)), '%).']);



%%
%y1 = Results.Pressure(1000,:);
%x = Results.x;

%dydx = gradient(y1) ./ gradient(x);

%figure;plot(dydx)


