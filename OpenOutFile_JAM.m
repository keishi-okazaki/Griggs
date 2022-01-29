%dataset = [Time [s], Load point displacement [mm], 'Axial displacement [mm], Axial strain,
%        Shear displacement [mm],Shear strain, Confinig pressure [MPa], Axial load [MPa],
%        Differential stress [MPa], Effective normal stress [MPa],Shear stress [MPa],Friction coefficient,
%        Temperature [oC], Gouge thickness [mm], Pp [MPa], Pp high [MPa],Pp low [MPa],Pp strain,Pp disp [mm]

xaxis = menu('x axis','Time','Loadpoint D','Axial D','Shear D','Axial S','Shear S');
yaxis = menu('y axis','Axial L','Sigma_d','Tau','Mu');

if isempty(xaxis)==1||isempty(yaxis)==1
    error('Error!!')
end

k = 0;

figure; box on; hold on;
while k == 0
    
    openfile= uigetfile('.csv', 'Pick a File');
    M = dlmread(openfile,',',2,0); % Including Single Header
    
    
    switch xaxis
        case {1}
            x = M(:,1);
            xlabel('Time [s]')
        case {2}
            x = M(:,2);
            xlabel('Loadpoint displacement [mm]')
        case {3}
            x = M(:,3);
            xlabel('Axial displacement [mm]')
        case {4}
            x = M(:,5);
            xlabel('Shear displacement [mm]')
        case {5}
            x = M(:,4);
            xlabel('Axial strain')
        case {6}
            x = M(:,6);
            xlabel('Shear strain')
        otherwise
            error('Error!!')
    end
    
    switch yaxis
        case {1}
            y = M(:,8);
            ylabel('Axial force [kN]')
        case {2}
            y = M(:,9);
            ylabel('Differential stress [MPa]')
        case {3}
            y = M(:,11);
            ylabel('Shear stress [MPa]')
        case {4}
            y = M(:,12);
            ylabel('Friction coefficient')
        otherwise
            error('Error!!')
    end
    
    plot(x,y)
    
    yesno = menu('more data?','Yes','No');
    
    switch yesno
        case {1}
            k = 0;
        case {2}
            k = 1;
    end
end
set(gca,'FontName','Helvetica','FontSize',14);
%figure;plot(dataset(:,1),dataset(:,3));
%xlabel('Time [s]');
%ylabel('Axial load [MPa]');