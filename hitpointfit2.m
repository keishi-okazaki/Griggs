% Written by Keishi Okazaki @ KCC/JAMSTEC, Brown U. and Hiroshima U. 2014.05.10

%published under CC licence 4.0
%free to share and modify as long as source is cited.
%https://creativecommons.org/licenses/by/4.0/ 

function  [const hitpointxy] = hitpointfit2(x,y,const0)
const = lsqcurvefit(@linear2,const0,x,y);

if const(1,1)>const(2,1)
    const = flipud(const);
else
end

modely = linear2(const,x);
hitpointxy =[-const(1,1) 1;-const(2,1) 1]\[const(1,2);const(2,2)];
plot(x,y,x,modely);
