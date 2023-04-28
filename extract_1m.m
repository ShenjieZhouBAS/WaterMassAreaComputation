function [depth,lat,lon] = extract_1m(range)

topofn = '/Users/shenjiezhou/SOCHIC/topography/topo_20.1.nc';

lonold = double(ncread(topofn,'lon'));
lonold = mod(lonold+180,360)-180;
latold = double(ncread(topofn,'lat'));
idx = find(lonold>range(3)&lonold<range(4));
idy = find(latold>range(1)&latold<range(2));
[lon,lat] = meshgrid(lonold(idx),latold(idy));
    
depth = double(ncread(topofn,'z',[min(idx),min(idy)],[length(idx) length(idy)]))';
lon = lon;
lat = lat;






