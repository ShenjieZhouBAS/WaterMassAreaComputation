function [section_dist,section_botdepth]=calc_station_bathymetry
load ant_x_4_new

m_proj('mercator','lon',[-60 -54],'lat',[-61.15 -51.5]);

[station_x,station_y]=m_ll2xy([ant_x_4.lon],[ant_x_4.lat],'clip','off');

npoints=1100;

section_x=linspace(station_x(end),station_x(1),npoints);
section_y=linspace(station_y(end),station_y(1),npoints);

[section_lon,section_lat]=m_xy2ll(section_x,section_y);
idlat = find(section_lat<=-55);
section_lon=section_lon(idlat);
section_lat=section_lat(idlat);
section_dist=[0; cumsum(m_lldist(section_lon,section_lat))]';

% pushd 'c:\povl\bathymetry\smith & sandwell
[depth,lat,lon]=extract_1m([minmax(section_lat),minmax(section_lon)]+[-1 1 -1 1]*.1);
% popd;

% lon=mod(lon+180,360)-180;

section_botdepth=interp2(lon,lat,-depth,section_lon,section_lat);

save bathymetry_smith_sandwell_20_1 section_dist section_botdepth section_lon section_lat

return;