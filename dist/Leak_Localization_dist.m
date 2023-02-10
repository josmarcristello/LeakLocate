% This function determines the leak location, if it exists.
% Method: Gradient Intersection
% Author: Josmar Cristello
%% Inputs
%    test_path_leak: File path for a test (With a leak)
%    test_path_no_leak: File path for a test (Without a leak)
%    Requirement: Boundary conditions of pressure-pressure 
%       i.e. bc_two_type = 5, bc_one_type = 1.
%    File Structure:   
%       Results.x → distance Vector [m]
%       Results.t_step → time Vector [s]
%       Results.Pressure → Pressure Vector(i,j) [Pa]
%           i → time dimension
%           j → distance dimension
%       Results.Velocity → Velocity Vector(i,j) [m/s*]
%% Outputs
%    dataset_path: Full path for the dataset folder of the project.
%% TODO
%    Currently, I have to generate a datastore. Figure out a way to classify direct from a variable (i.e. memory)
%% Main

clear; close all; clc; format longG;

real_leak_loc_rel = 0.70; % Needed to calculate error in estimative
%% Defining source data
file_path_leak = fullfile('F:\Onedrive\OneDrive - University of Calgary\LeakLocate\dataset\2. Simulated\sim 3\leak.mat');
Results_leak = load(file_path_leak); Results_leak = Results_leak.Results;
file_path_no_leak = fullfile('F:\Onedrive\OneDrive - University of Calgary\LeakLocate\dataset\2. Simulated\sim 3\no_leak.mat');
Results_no_leak = load(file_path_no_leak); Results_no_leak = Results_no_leak.Results;

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

%% Chart visualizations [Flow x Time]

figure;plot(Results_leak.t_step, Results_leak.Velocity(:,end));
hold on;
plot(Results_no_leak.t_step, Results_no_leak.Velocity(:,end));
title("Flow Velocity (Outlet)"); xlabel("Time [s]"); ylabel("Flow Velocity [m/s]");
legend('Leak Behavior','No Leak Behavior');

%% Chart visualizations [Flow x Length]

figure;plot(Results_leak.x, Results_leak.Pressure(end,:), 'k');
hold on;
%plot(Results_no_leak.x, Results_no_leak.Pressure(end,:));

title("Pressure (Leak is the intersection of derivatives)"); xlabel("Distance [km]"); ylabel("Pressure [Pa]");

% First Derivative
y0 = Results_leak.Pressure(end,1);
y1 = Results_leak.Pressure(end,round(leak_loc_rel*253));
x0 = 0;
x1 = leak_loc_abs;

% Second Derivative
y2 = y1;
y3 = Results_leak.Pressure(end,end);
x2 = leak_loc_abs;
x3 = Results_leak.x(end, end);

plot([0 x1],[y0 y1], 'b--')
plot([x2 x3],[y2 y3], 'r--')

%legend('Flow Behavior (Leak)');
lgd = legend('Flow Behavior (Leak)', '$f( VI ) = \frac{\partial p}{\partial x}$', '$f( V_0 ) = \frac{\partial p}{\partial x}$', 'Interpreter','latex')
set(lgd,'FontSize',12);