close all;

%% Pressure Analysis
data1 = Results.Pressure(:,100);
data2 = Results.Pressure(:,200);

figure;plot(Results.t_step, Results.Pressure(:,100)); 
xlabel("Time [s]"); ylabel("Pressure [MPa]"); title("Pressure x Time (Pos 100)");
xlim([min(Results.t_step), max(Results.t_step)]); ylim([min(Results.Pressure(:)), max(Results.Pressure(:))]);

figure;plot(Results.t_step, Results.Pressure(:,200)); 
xlabel("Time [s]"); ylabel("Pressure [MPa]"); title("Pressure x Time (Pos 200)");
xlim([min(Results.t_step), max(Results.t_step)]); ylim([min(Results.Pressure(:)), max(Results.Pressure(:))]);

distance = Results.x(200)-Results.x(100); % Distance btween two sensors

rel_time = 0.99; % Percentual
time_index = round(rel_time * size(Results.t_step,2));

figure;plot(Results.x, Results.Pressure(time_index,:)); 
xlabel("Distance [km]"); ylabel("Pressure [MPa]"); title("Pressure x Distance (time = index 1k)");

%% Velocity Analysis
data1 = Results.Velocity(:,100);
data2 = Results.Velocity(:,200);

figure;plot(Results.t_step, data1); 
xlabel("Time [s]"); ylabel("Velocity []"); title("Pressure x Time (Pos 100)");
xlim([min(Results.t_step), max(Results.t_step)]); ylim([min(Results.Velocity(:)), max(Results.Velocity(:))]);

figure;plot(Results.t_step, data2); 
xlabel("Time [s]"); ylabel("Velocity []"); title("Pressure x Time (Pos 200)");
xlim([min(Results.t_step), max(Results.t_step)]); ylim([min(Results.Velocity(:)), max(Results.Velocity(:))]);

distance = Results.x(200)-Results.x(100); % Distance between two sensors

figure;plot(Results.x, Results.Velocity(1000,:)); 
xlabel("Distance [km]"); ylabel("Velocity [MPa]"); title("Pressure x Distance (time = index 1k)");
%xlim([min(dist), max(dist)]);
%ylim([min(pressure(:)), max(pressure(:))]);

%[c_1,lags_1] = xcorr(data1,data2,'normalized');

%%
v_no_leak_inlet = 2.7485;
v_no_leak_outlet = 2.7572;

v_leak_inlet = 3.0227;
v_leak_outlet = 2.3434;

dist = Results.Length/1000;


(v_no_leak_inlet^2 - v_leak_outlet^2)/(v_leak_inlet^2-v_leak_outlet^2)*100