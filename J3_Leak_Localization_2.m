close all; format longG;
% This Leak Localization (Gradient Intersection) Technique expects:
% - Data at inlet and outlet

real_leak_loc_rel = 0.70; % Needed to calculate error in estimative

%% Defining source data
% Expects file loaded with Results:
% Results.x → distance Vector [m]
% Results.t_step → time Vector [s]
% Results.Pressure → Pressure Vector(i,j) [Pa]
%   i → time dimension
%   j → distance dimension
% Results.Velocity → Velocity Vector(i,j) [m/s*]

%% Apply the Gradient Intersection Method
v_no_leak_inlet = Results_no_leak.Velocity(end, 1);
v_no_leak_outlet = Results_no_leak.Velocity(end, end);

v_leak_inlet = Results_leak.Velocity(end, 1);
v_leak_outlet = Results_leak.Velocity(end, end);

dist = Results_leak.Length/1000;


x0 = (v_no_leak_inlet^2 - v_leak_outlet^2)/(v_leak_inlet^2-v_leak_outlet^2);

%% Calculate the error

leak_loc_rel = x0;
leak_loc_abs = x0*max(Results_leak.Length);
disp(['Leak detected in ', num2str(round(leak_loc_abs)), 'm', ' (', num2str(round(100*leak_loc_rel,1)), '%).']);


leak_loc_error_rel = leak_loc_rel - real_leak_loc_rel;
leak_loc_error_rel_abs = leak_loc_error_rel*max(Results_leak.Length);

disp(['The error in this measurement was ', num2str(round(leak_loc_error_rel_abs)), 'm', ' (', num2str(round(leak_loc_error_rel*100,1)), '%).']);
