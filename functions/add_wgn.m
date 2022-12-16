function [results_noise] = add_wgn(data, snr)
    % Default value → snr = 50
    if nargin < 2
        snr = 50;
    end
    % Load the results object.
    Results = load(data);
    Results = Results.Results;

    Results.Pressure = awgn(Results.Pressure, snr, 'measured');
    Results.Velocity = awgn(Results.Velocity, snr, 'measured');
    %figure;
    %plot(t,[x y]);
    %legend('Original Signal','Signal with AWGN');
    results_noise = Results;
end

