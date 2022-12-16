%% Initialize video
%myVideo = VideoWriter('myVideoFile'); %open video file
%myVideo.FrameRate = 30;  %can adjust this, 5 - 10 works well for me
%open(myVideo)

%% Make some data
%t = 1:0.1:2*pi;
%y = sin(t);
%% Plot in a loop and grab frames
%for i=1:1:length(t)
%    plot(t(1:i), y(1:i), 'LineWidth', 3)
%    ylim([-1, 1])
%    xlim([0, 2*pi])
%    pause(0.01) %Pause and grab frame
%    frame = getframe(gcf); %get frame
%    writeVideo(myVideo, frame);
%end
%close(myVideo)


%% Initialize video - Pressure in the whole pipeline through time
myVideo = VideoWriter('myVideoFile'); %open video file
myVideo.FrameRate = 30;  %can adjust this, 5 - 10 works well for me
v.Quality = 99;
open(myVideo)

close all;
figure;
pressure = Results.Pressure./10^6; % MPa
dist = Results.x./1000; % km
for i=1:1:size(Results.Pressure,1)
    plot(dist, pressure(i,:));
    
    title(strcat('Time = ', num2str(Results.t_step(i))))

    xlim([min(dist), max(dist)]);
    ylim([min(pressure(:)), max(pressure(:))]);

    xlabel("Distance [km]");
    ylabel("Pressure [MPa]");

    pause(0.01) %Pause and grab frame
    frame = getframe(gcf); %get frame
    writeVideo(myVideo, frame);
end
close(myVideo)

%% Initialize video - Velocity in the whole pipeline through time
myVideo = VideoWriter('myVideoFile'); %open video file
myVideo.FrameRate = 30;  %can adjust this, 5 - 10 works well for me
open(myVideo)

close all;
figure;
velocity = Results.Velocity; % ??
dist = Results.x./1000; % km

for i=1:1:size(Results.Pressure,1)
    plot(dist, velocity(i,:));
    
    title(strcat('Time = ', num2str(Results.t_step(i))))

    xlim([min(dist), max(dist)]);
    ylim([min(velocity(:))*0.9, max(velocity(:))]);

    xlabel("Distance [km]");
    ylabel("Velocity");

    pause(0.01) %Pause and grab frame
    frame = getframe(gcf); %get frame
    writeVideo(myVideo, frame);
end
close(myVideo)

%% Initialize video - Pressure in time through the whole pipeline
myVideo = VideoWriter('myVideoFile'); %open video file
myVideo.FrameRate = 30;  %can adjust this, 5 - 10 works well for me
v.Quality = 99;
open(myVideo)

close all;
figure;
pressure = Results.Pressure./10^6; % MPa
dist = Results.x./1000; % km
for i=1:1:size(Results.Pressure,2)
    plot(Results.t_step, pressure(:,i));
    
    title(strcat('Time = ', num2str(Results.t_step(i))))

    xlim([min(Results.t_step), max(Results.t_step)]);
    ylim([min(pressure(:)), max(pressure(:))]);

    xlabel("Time [s]");
    ylabel("Pressure [MPa]");

    pause(0.01) %Pause and grab frame
    frame = getframe(gcf); %get frame
    writeVideo(myVideo, frame);
end
close(myVideo)
