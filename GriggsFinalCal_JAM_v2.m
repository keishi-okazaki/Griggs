%% Final calculation for Griggs experiments
% Written by Keishi Okazaki @ Brown, JAMSTEC & Hiroshima Univ. 2014.05.10
% Need to run "hitpointcal_disp_2lines" before runing this script.
% 01/04/2018; use the boundary slip for area correction.
% ??/??/2020: Pp data (Pp top, Pp low, Pp strain) were also saved in the out file.
% 05/06/2021: the method for the area correction was sightly modified.
% ori = "time","Vessel T","Temperature","Sigma1 (1/4")","Sigma3 (1")","Pp high","Pp low","Pp strain","Disp f","Disp Pp"

%% Sample dimensions, etc. 
% Pp_sample = ori(:,6); % GPA0026
% Pp_sample = 36.969*ori(:,7) - 59.48; %GPA0030
% Pp_sample = 33.79.*ori(:,7) - 45.387; %GPA0029
% Pp_sample = 35.382.*ori(:,7) - 42.332; %GPA0022
% Pp_sample = 35.382*(0.0902*ori(:,8)+2.3335)-42.332; %GPA0021 Pp strain‚©‚çŒvŽZ
% Pp_sample = 30.928*(0.0751*ori(:,8)+6.2955)-13.434; %GPA0021 Pp strain‚©‚çŒvŽZ
% Pp_sample = 33.138.*ori(:,7) - 14.151; %GPA0021
% Pp_sample = 31.427.*ori(:,7) - 12.921; %GPA0004
Pp_sample = 0;
P_shift = 0; % pressure correction from the load cycle
P_factor = 0.955; %Pc factor from the friction of sigma3 piston estimated from the load cycle

Sl = 12.25; %Sample length for axial compression, mm
Sd = 6.00; %Sample diameter, mm
Pd = 6.35; %Sigma1 piston diameter, mm
Th0 = 1.1; %Initial sample gouge/wafer thickness for general shear, mm 1.097 for lawsonite
Thf = 0.626; %Final sample gouge/wafer thickness for general shear measured from the thin section, mm 0.997
uB = 0; %Boundary slip between the sample and shear pistons measured from the thin section, mm 
Theta = 45; %Precut angle, Degree

%SamplRate = 1; % Sampling rate, s 
%Adr = 0.000183; %10^-5 gear, Axial displacement rate, mm/s
%Adr = 0.0000183; %10^-6 gear
Sa = Sd^2*pi/4; % Sample area, mm^2
Psa = Sd^2*pi/4/sin(Theta/180*pi); % Shear area, mm^2
Sap = Pd^2*pi/4; % Sigma1 piston area, mm^2
Stff =100.48/Sa*1000; %Machine static stiffness in MPa/mm. 
% k = 118kN/mm for Brown rigs, 35.6 kN/mm with spring for Brown rig, 100.48 for the Jamstec rig
HitPoint = -(A(2,2)-A(1,2))/(A(2,1)-A(1,1));% Disp. at the hit point from hitpointcal.m

%% Row data
M = dataset2; 
% Time [s], Load point disp [mm], Load [MPa], Pc [MPa], Temp [oC], Corrected load1 [MPa],Corrected load2 [MPa], Disp [mm]
Lm = length(dataset2);

%% Choose Data Reduction
DataReduction = menu('Data Reduction?','Yes','No','Yes, by decimate');
%'Yes';% Data reduction and averaging
%'No'; % Raw data
%'Decimate'; % Use dacimate function in Matlab

switch DataReduction
        case {1} % Moving average for data reduction, use below. 
           AmongX = inputdlg('data is reduced to 1/X, X =');

        case {2} % Using raw data 
            
        case {3} % Use decimate data resampling 
            AmongX = inputdlg('data is reduced to 1/X, X =');
            
        otherwise
        error('Error!! Select Data Reduction')
end


%% Correction the overlap of the shear piston 
ShearAreaCorr = menu ('Correction for general shear?','Thinning of sample','Thinning & area change','No','Constant volume');

%% Calculations
% M = [Time [s], Load point disp [mm], Load [MPa], Pc [MPa], Temp [oC], Corrected load1 [MPa], Corrected load2 [MPa], Axial disp [mm]];
% AAA = [Time [s], Load point displacement [mm], Axial displacement [mm], Axial strain, Shear displacement [mm],
%        Shear strain, Confinig pressure [MPa], Axial load [MPa], Differential stress [MPa], Effective normal stress [MPa],
%        Shear stress [MPa],Frictional coefficient, Temperature [oC]]

AAA = []; %empty matrix
AAA(:,1) = M(:,1); %Time
AAA(:,2) = M(:,2); % Load point disp
AAA(:,3) = M(:,2)-HitPoint-M(:,7)/Stff; % Axial disp
AAA(:,4) = AAA(:,3)/Sl; % Axial strain
AAA(:,5) = AAA(:,3)/(sin ((90-Theta)/180*pi)); % Shear displacement
AAA(:,6) = ((AAA(:,3))/(sin ((90-Theta)/180*pi)))/Th0; % Shear strain
AAA(:,7) = M(:,4)*P_factor + P_shift; %Confining pressure
AAA(:,8) = M(:,3)*Sap/Sa; % Axial load
AAA(:,9) = M(:,7)*Sap/Sa; % Differential stress
%AAA(:,8) = M(:,3); % Axial load
%AAA(:,9) = M(:,7); % Differential stress
AAA(:,10) = AAA(:,9)*(sin (Theta/180*pi))^2 + M(:,4) - Pp_sample; % Effective normal stress
AAA(:,11) = AAA(:,9)* sin (Theta/180*pi)*cos (Theta/180*pi); % Shear stress
AAA(:,12) = AAA(:,11)./AAA(:,10); % Nominal frictional coefficient 
AAA(:,13) = M(:,5); % Temperature
AAA(:,14) = Th0;
AAA(:,15) = Pp_sample;
AAA(:,16) = ori(:,6); % Pp up
AAA(:,17) = ori(:,7); % Pp low
AAA(:,18) = ori(:,8); % Pp strain
AAA(:,19) = ori(:,10); % Pp disp

switch ShearAreaCorr
    case {2} % Thinning & area
        dz1total=(Th0-Thf)/sin(Theta/180*pi); %total shortening
        proportion=dz1total/max(AAA(:,3)); %proportion of shortening to total virtical displacement
        dx1=proportion.*AAA(:,3);%vertical displacment resulting in shortening assuming constant rate
        dx2=AAA(:,3)-dx1;%vertical displacment resolved in simple shear
        Th=Th0-dx1.*sin(Theta/180*pi);%instantaneous thickness assuming constant shortening rate
        AAA(:,5) = dx2/(sin ((90-Theta)/180*pi)); % Shear displacement
        uuu = uB*dx2/max(dx2); %- Th/tan(Theta); %Shear disp for area correction        
        uuu(uuu<0)=0; %treat negative value as 0
        SapOverlap = 2^0.5*Sd*Sd/2*acos(uuu/(2^0.5*Sd))-Sd/2*uuu.*sin(acos(uuu/(2^0.5*Sd)));
        AAA(:,6) = AAA(:,5)./Th; % Shear strain
        AAA(:,10) = AAA(:,10).*Psa./SapOverlap; % Effective normal stress
        AAA(:,11) = AAA(:,11).*Psa./SapOverlap; % Shear stress
        AAA(:,9) = AAA(:,11)*3^0.5;  % Equivalent stress
        AAA(:,14) = Th;
        AAA(:,15) = Pp_sample;
        
    case {3} % No
        
    case {1} % Thinning of the sample layer
        dz1total=(Th0-Thf)/sin(Theta/180*pi); %total shortening
        proportion=dz1total/max(AAA(:,3)); %proportion of shortening to total virtical displacement
        dx1=proportion.*AAA(:,3); %vertical displacment resulting in shortening assuming constant rate
        dx2=AAA(:,3)-dx1; %vertical displacment resolved in simple shear
        Th=Th0-dx1.*sin(Theta/180*pi); %instantaneous thickness assuming constant shortening rate
        
        AAA(:,5) = dx2/(sin ((90-Theta)/180*pi)); % Shear displacement
        AAA(:,6) = AAA(:,5)./Th; % Shear strain
        AAA(:,10) = AAA(:,10); % Effective normal stress
        AAA(:,11) = AAA(:,11); % Shear stress
        AAA(:,9) = AAA(:,11)*3^0.5;  % Equivalent stress
        AAA(:,14) = Th;
        AAA(:,15) = Pp_sample;
        
    case {4} % constant volume
        AAA(:,9) = AAA(:,9).*(1-AAA(:,3)./Sl); % Differential stress with area change assuming a const volume
        
    otherwise
        error('Error!! Select ShearAreaCorr')
end

%% Data Reduction
MMM = [];
switch DataReduction
        case {1} % Moving average for data reduction, use below. 
           MM = ones(size(AAA));
           ReSumplRate = str2double(AmongX);
           a = ReSumplRate; %average among 'a' data
           b = ones(1,a);
           S = a; %data reduced to 1/S
           n = 1:S:Lm; 
           MM(:,1) = AAA(:,1);
           MM(:,2:end) = filter(b,a,AAA(:,2:end));
           MMM = MM(n,:);

        case {2} % Using raw data 
            MMM = AAA;
            
        case {3} % Use decimate data resampling 
            ReSumplRate = str2double(AmongX);
            S =  ReSumplRate;
            for i=1:length(AAA(1,:)) 
            MMM(:,i)=decimate(AAA(:,i),S); 
            end
            
        otherwise
        error('Error!! Select Data Reduction')
end

M = []; %empty matrix
MM = []; %empty matrix

%% Plot
QuickPlot = menu('Quick Plot','Differential stress','Shear stress','No plot');
switch QuickPlot
        case {1} %Axial stress 
           [AX, H1, H2] = plotyy(MMM(:,3), MMM(:,8),MMM(:,3), MMM(:,9)); 
           xlabel('Axial displacement [mm]')
           set(get(AX(1),'Ylabel'),'String','Axial stress [MPa]') 
           set(get(AX(2),'Ylabel'),'String','Differential stress [MPa]')
           legend([H1, H2], 'Axial stress [MPa]', 'Differential stress [MPa]')
           
        case {2} % Shear stress 
           [AX, H1, H2] = plotyy(MMM(:,3), MMM(:,8),MMM(:,3), MMM(:,11)); 
           xlabel('Axial displacement [mm]')
           set(get(AX(1),'Ylabel'),'String','Axial stress [MPa]') 
           set(get(AX(2),'Ylabel'),'String','Shear stress [MPa]')
           legend([H1, H2], 'Axial stress [MPa]', 'Shear stress [MPa]')
        
        case {3} % No plot 
 
        otherwise

end


%% File Export as .csv file
switch ShearAreaCorr
    case {1,2} % General shear
        str = {'Time [s]', 'Load point displacement [mm]', 'Axial displacement [mm]', 'Axial strain', 'Shear displacement [mm]',...
            'Shear strain', 'Confinig pressure [MPa]', 'Axial load [MPa]','Equivalent stress [MPa]', 'Effective normal stress [MPa]',...
            'Shear stress [MPa]','Friction coefficient', 'Temperature [oC]','Gouge/wafer thickness [mm]','Pore pressure [MPa]',...
            'Pp high [MPa]','Pp low [MPa]','Pp strain','Pp disp [mm]'};
        
    otherwise % Axial compression
        str = {'Time [s]', 'Load point displacement [mm]', 'Axial displacement [mm]', 'Axial strain', 'Shear displacement [mm]',...
            'Shear strain', 'Confinig pressure [MPa]', 'Axial load [MPa]','Differential stress [MPa]', 'Effective normal stress [MPa]',...
            'Shear stress [MPa]','Friction coefficient', 'Temperature [oC]','Gouge/wafer thickness [mm]','Pore pressure [MPa]'...
             'Pp high [MPa]','Pp low [MPa]','Pp strain','Pp disp [mm]'};
end

savefile= uiputfile('GPA00out07162021.csv', 'Save a File');
fid = fopen(savefile, 'wt');
csvFun = @(x)sprintf('%s,',x);
xchar = cellfun(csvFun, str, 'UniformOutput', false);
xchar = strcat(xchar{:});
xchar = strcat(xchar(1:end-1),'\n');
fprintf(fid,xchar);
dlmwrite(savefile, MMM, '-append','precision', 7); 
%% END