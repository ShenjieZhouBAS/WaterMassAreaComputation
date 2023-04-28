function z=calc_station_distance(lon,lat,varargin)

if length(lon)>1
    z=zeros(size(lon));
    for n=1:numel(lon)
        z(n)=calc_station_distance(lon(n),lat(n),varargin{:});
    end
    return
end

load bathymetry_smith_sandwell_20_1

m_proj('mercator','lon',[-60 -54],'lat',[-61.15 -51.5]);

[section_x,section_y]=m_ll2xy(section_lon,section_lat,'clip','off');

section_params=polyfit(section_x,section_y,1);
    
a=section_params(1);
b=section_params(2);
%on section, y=ax+b
    
[x,y]=m_ll2xy(lon,lat,'clip','off');
a2=-1/a;
b2=y+x/a;
%perpendicular to section
x1=(b2-b)./(a-a2);
y1=a*x1+b;
section_err=sqrt((x1-x)^2+(y1-y)^2);

% [newlon,newlat]=m_xy2ll(x1,y1);

if section_err>3e-1 %approx. 10 km
    z=nan;
    warning('Station off main section...');
    
else
    z=interp1(section_y,section_dist,y1,'linear','extrap');
end
