%% Import data
%Written by Keishi Okazaki @ KCC, JAMSTEC, 09/15/2019

%published under CC licence 4.0
%free to share and modify as long as source is cited.
%https://creativecommons.org/licenses/by/4.0/

%% File import
clear
ori = []; % Make an empty matrix
ori = [];
t = [];

openfile = uigetfile('.CSV', 'Select files','MultiSelect','off') 
[mm,nn] = size(openfile);
ori = dlmread(char(openfile),',',14,0);
%"time","Vessel T","Temperature","Sigma1 (1/4")","Sigma3 (1")","Pp high","Pp low","Pp strain","Disp f","Disp Pp"

%%
figure;plot(ori(:,1),ori(:,4));
xlabel('time [s]');
ylabel('axial load [MPa]');
figure;plot(ori(:,9),ori(:,4));
xlabel('axial disp [mm]');
ylabel('axial load [MPa]');

disp('the data is saved in the current folder and workspace')
disp('dataset = [Time [s] Displacement [mm] Load [MPa] Press [MPa] Temperature [oC]')
%clear openfile f t ori

%% ‚¨‚í‚è