% Written by Keishi Okazaki @ KCC/JAMSTEC, Brown U. and Hiroshima U. 2014.05.10

%published under CC licence 4.0
%free to share and modify as long as source is cited.
%https://creativecommons.org/licenses/by/4.0/ 

clear

addpath('/Users/okazakikeishi/Desktop/‹¤“¯Œ¤‹†‚È‚Æ?/•àV‚³‚ñ“Œcalcite/GPA0019')
addpath('/Users/okazakikeishi/Desktop/‹¤“¯Œ¤‹†‚È‚Æ?/•àV‚³‚ñ“Œcalcite/GPA0020')

f = 0.1; % Sampling rate [s]
openfile= uigetfile('.csv', 'Pick a File','MultiSelect','on');
dataset =[];
rawdata = [];

for i = 1:length(openfile)
rawdata = dlmread(openfile{i},',',14,0); % Skip Headers
%dataset = "time","Vessel T","Temperature","Sigma1 (1/4")","Sigma3 (1")","Pp high","Pp low","Disp c","Disp f","Disp Pp"
dataset =[dataset;rawdata];
rawdata =[];
end

%%
figure;plot(dataset(:,1),dataset(:,4));
xlabel('Time [s]');
ylabel('Axial load [MPa]');
figure;plot(dataset(:,9),dataset(:,4));
xlabel('Axial disp [mm]');
ylabel('Axial load [MPa]');
