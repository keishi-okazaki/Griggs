clear

f = 1; % Sampling rate [s]
openfile= uigetfile('.csv', 'Pick a File');
%ori = dlmread(openfile,',',1,3); % No Header
dataset = dlmread(openfile,',',14,0); % Including Single Line Header
%ori = dlmread(openfile,',',22,3); % Including Header
%dataset = (Time [s],Load point displacement [mm],Axial load [MPa],Pc [MPa],Temperature [oC])

figure;plot(dataset(:,1),dataset(:,4)-(0.955 * dataset(:,5)));
xlabel('Time [s]');
ylabel('Axial load - Pc [MPa]');
figure;plot(dataset(:,9),dataset(:,4)-(0.955 * dataset(:,5)));
xlabel('Axial disp [mm]');
ylabel('Axial load - Pc [MPa]');
