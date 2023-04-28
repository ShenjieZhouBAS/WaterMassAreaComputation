clear;clc;
% if 0 % ~exist('time','var') || ~exist('density_class_areas','var') || length(time)~=21
%     load a12_gamma_areas_2020
% elseif 1

load_a12_cruise_info
load a12_new_clean.mat

% dist_grid=0:1127;% 69ºS to 59.1ºS
dist_grid=0:1583;% 69ºS to 55.0ºS
depth_grid=0:2:6000;

load bathymetry_smith_sandwell_20_1

%truncate to the part of the section south of the kink...
% section_lon=section_lon(1:644);
% section_lat=section_lat(1:644);
% section_dist=section_dist(1:644);
% section_botdepth=section_botdepth(1:644);

botdepth=interp1(section_dist,section_botdepth,dist_grid,'linear');
lat_grid=interp1(section_dist,section_lat,dist_grid,'linear');

data_regrid=nan(length(depth_grid),length(dist_grid),length(section_years));
% data1_regrid=nan(length(depth_grid),length(dist_grid),length(section_years));
% data2_regrid=nan(length(depth_grid),length(dist_grid),length(section_years));
limits=nan(length(section_years),2);

bottommask=false(length(depth_grid),length(dist_grid),length(section_years));
for n=1:length(dist_grid)
    bottommask(ceil(botdepth(n)./2):end,n,:,:)=true;
end


for m=1:length(sectionnames)
    
    year=section_years(m);
    data = grid_ctds(eval(sectionnames{m}),'press',0:2:6000);
    [lon,~] = meshgrid(data.lon,data.bin_press(:,1));
    [lat,~] = meshgrid(data.lat,data.bin_press(:,1));
    station_gamma = data.bin_gamma;
    station_gamma_e2 = data.bin_gamma_e2;
    station_gamma_e1 = data.bin_gamma_e1;
    station_gamma_t2 = data.bin_gamma_t2;
    station_gamma_t1 = data.bin_gamma_t1;
    station_gamma_s2 = data.bin_gamma_s2;
    station_gamma_s1 = data.bin_gamma_s1;
    sectiondist=calc_station_distance(data.lon,data.lat);
    stationflag=true(size(sectiondist));
    depth=sw_dpth(data.bin_press,data.lat);

    
    for n=1:length(sectiondist)
        if data.bin_press(find(~isnan(station_gamma(:,n)),1,'last'),n)<=1000 && ...
                data.botdepth(n)>=1000
            stationflag(n)=false;
        else
            firstgood=find(~isnan(station_gamma(:,n)),1,'first');
            station_gamma(1:(firstgood-1),n)=station_gamma(firstgood,n);
            station_gamma_e1(1:(firstgood-1),n) = station_gamma_e1(firstgood,n);
            station_gamma_e2(1:(firstgood-1),n) = station_gamma_e2(firstgood,n);
            station_gamma_t2(1:(firstgood-1),n) = station_gamma_t2(firstgood,n);
            station_gamma_t1(1:(firstgood-1),n) = station_gamma_t1(firstgood,n);
            station_gamma_s2(1:(firstgood-1),n) = station_gamma_s2(firstgood,n);
            station_gamma_s1(1:(firstgood-1),n) = station_gamma_s1(firstgood,n);
            lastgood=find(~isnan(station_gamma(:,n)),1,'last');
            station_gamma(lastgood+1:end,n)=station_gamma(lastgood,n);
            station_gamma_e1(lastgood+1:end,n)=station_gamma_e1(lastgood,n);
            station_gamma_e2(lastgood+1:end,n)=station_gamma_e2(lastgood,n);
            station_gamma_t2(lastgood+1:end,n)=station_gamma_t2(lastgood,n);
            station_gamma_t1(lastgood+1:end,n)=station_gamma_t1(lastgood,n);
            station_gamma_s2(lastgood+1:end,n)=station_gamma_s2(lastgood,n);
            station_gamma_s1(lastgood+1:end,n)=station_gamma_s1(lastgood,n);
        end

    end
    data_regrid(:,:,m)=griddata(sectiondist(stationflag),...
        median(sw_dpth(data.bin_press(:,stationflag),data.lat(stationflag)),2),...
        station_gamma(:,stationflag),dist_grid,depth_grid');
    data_regrid_e1(:,:,m)=griddata(sectiondist(stationflag),...
        median(sw_dpth(data.bin_press(:,stationflag),data.lat(stationflag)),2),...
        station_gamma_e1(:,stationflag),dist_grid,depth_grid');
    data_regrid_e2(:,:,m)=griddata(sectiondist(stationflag),...
        median(sw_dpth(data.bin_press(:,stationflag),data.lat(stationflag)),2),...
        station_gamma_e2(:,stationflag),dist_grid,depth_grid');
    data_regrid_t1(:,:,m)=griddata(sectiondist(stationflag),...
        median(sw_dpth(data.bin_press(:,stationflag),data.lat(stationflag)),2),...
        station_gamma_t1(:,stationflag),dist_grid,depth_grid');
    data_regrid_t2(:,:,m)=griddata(sectiondist(stationflag),...
        median(sw_dpth(data.bin_press(:,stationflag),data.lat(stationflag)),2),...
        station_gamma_t2(:,stationflag),dist_grid,depth_grid');
    data_regrid_s1(:,:,m)=griddata(sectiondist(stationflag),...
        median(sw_dpth(data.bin_press(:,stationflag),data.lat(stationflag)),2),...
        station_gamma_s1(:,stationflag),dist_grid,depth_grid');
    data_regrid_s2(:,:,m)=griddata(sectiondist(stationflag),...
        median(sw_dpth(data.bin_press(:,stationflag),data.lat(stationflag)),2),...
        station_gamma_s2(:,stationflag),dist_grid,depth_grid');


end

distancemask=false(length(depth_grid),length(dist_grid),length(section_years));
% distancemask(:,483:1093,:)=false;
data_regrid(bottommask | distancemask)=nan;
data_regrid_e2(bottommask | distancemask)=nan;
data_regrid_e1(bottommask | distancemask)=nan;
data_regrid_t1(bottommask | distancemask)=nan;
data_regrid_t2(bottommask | distancemask)=nan;
data_regrid_s1(bottommask | distancemask)=nan;
data_regrid_s2(bottommask | distancemask)=nan;


density_classes=27.5:0.01:28.6;
% density_classes=0:1:100;
ndens=length(density_classes);
density_class_areas=zeros(ndens,length(section_years));
density_class_areas_e2=zeros(ndens,length(section_years));
density_class_areas_e1=zeros(ndens,length(section_years));
density_class_areas_t1=zeros(ndens,length(section_years));
density_class_areas_t2=zeros(ndens,length(section_years));
density_class_areas_s1=zeros(ndens,length(section_years));
density_class_areas_s2=zeros(ndens,length(section_years));

for l=1:length(section_years)
    temp_mask=squeeze(double(data_regrid(:,:,l)<density_classes(1)));
    density_class_areas(1,l)=sum(temp_mask(:))*2e3;
    temp_mask=squeeze(double(data_regrid_e2(:,:,l)<density_classes(1)));
    density_class_areas_e2(1,l)=sum(temp_mask(:))*2e3;
    temp_mask=squeeze(double(data_regrid_e1(:,:,l)<density_classes(1)));
    density_class_areas_e1(1,l)=sum(temp_mask(:))*2e3;
    temp_mask=squeeze(double(data_regrid_t1(:,:,l)<density_classes(1)));
    density_class_areas_t1(1,l)=sum(temp_mask(:))*2e3;
    temp_mask=squeeze(double(data_regrid_t2(:,:,l)<density_classes(1)));
    density_class_areas_t2(1,l)=sum(temp_mask(:))*2e3;
    temp_mask=squeeze(double(data_regrid_s1(:,:,l)<density_classes(1)));
    density_class_areas_s1(1,l)=sum(temp_mask(:))*2e3;
    temp_mask=squeeze(double(data_regrid_s2(:,:,l)<density_classes(1)));
    density_class_areas_s2(1,l)=sum(temp_mask(:))*2e3;


    for m=2:ndens
        temp_mask=squeeze(double(data_regrid(:,:,l)>=density_classes(m-1) & ...
            data_regrid(:,:,l)<density_classes(m)));
        density_class_areas(m,l)=sum(temp_mask(:))*2e3;
        temp_mask=squeeze(double(data_regrid_e2(:,:,l)>=density_classes(m-1) & ...
            data_regrid_e2(:,:,l)<density_classes(m)));
        density_class_areas_e2(m,l)=sum(temp_mask(:))*2e3;
        temp_mask=squeeze(double(data_regrid_e1(:,:,l)>=density_classes(m-1) & ...
            data_regrid_e1(:,:,l)<density_classes(m)));
        density_class_areas_e1(m,l)=sum(temp_mask(:))*2e3;
        temp_mask=squeeze(double(data_regrid_t1(:,:,l)>=density_classes(m-1) & ...
            data_regrid_t1(:,:,l)<density_classes(m)));
        density_class_areas_t1(m,l)=sum(temp_mask(:))*2e3;
        temp_mask=squeeze(double(data_regrid_t2(:,:,l)>=density_classes(m-1) & ...
            data_regrid_t2(:,:,l)<density_classes(m)));
        density_class_areas_t2(m,l)=sum(temp_mask(:))*2e3;
        temp_mask=squeeze(double(data_regrid_s1(:,:,l)>=density_classes(m-1) & ...
            data_regrid_s1(:,:,l)<density_classes(m)));
        density_class_areas_s1(m,l)=sum(temp_mask(:))*2e3;
        temp_mask=squeeze(double(data_regrid_s2(:,:,l)>=density_classes(m-1) & ...
            data_regrid_s2(:,:,l)<density_classes(m)));
        density_class_areas_s2(m,l)=sum(temp_mask(:))*2e3;
    end
end

time=sectiondates;

save a12_fullrange_gamma_areas_2020_20_1_revise time density_class_areas* density_classes ndens section_years


%% 
% figure;
% 
maxind=length(density_classes); %find(sum(density_class_areas,2)==0,1); % was 19;
% 
ind2plot=1:length(time);
[~,~,boundary_ind]=intersect([28.26,28.31,28.36,28.40],round(density_classes(1:maxind)*1000)./1000);
boundary_ind=maxind-boundary_ind;
% 
% 
cum_areas=cumsum(density_class_areas(maxind:-1:1,ind2plot))';
cum_areas_e2=cumsum(density_class_areas_e2(maxind:-1:1,ind2plot))';
cum_areas_e1=cumsum(density_class_areas_e1(maxind:-1:1,ind2plot))';
cum_areas_t1=cumsum(density_class_areas_t1(maxind:-1:1,ind2plot))';
cum_areas_t2=cumsum(density_class_areas_t2(maxind:-1:1,ind2plot))';
cum_areas_s1=cumsum(density_class_areas_s1(maxind:-1:1,ind2plot))';
cum_areas_s2=cumsum(density_class_areas_s2(maxind:-1:1,ind2plot))';
% cum_areas_tempupper=cumsum(density_class_areas_tempupper(maxind:-1:1,ind2plot))';
% cum_areas_templower=cumsum(density_class_areas_templower(maxind:-1:1,ind2plot))';
% cum_areas_salupper=cumsum(density_class_areas_salupper(maxind:-1:1,ind2plot))';
% cum_areas_sallower=cumsum(density_class_areas_sallower(maxind:-1:1,ind2plot))';
timea12 = time(ind2plot);
wsbwa12 = cum_areas(:,boundary_ind);
wsbwa12_e2 = cum_areas_e2(:,boundary_ind);
wsbwa12_e1 = cum_areas_e1(:,boundary_ind);
wsbwa12_t1 = cum_areas_t1(:,boundary_ind);
wsbwa12_t2 = cum_areas_t2(:,boundary_ind);
wsbwa12_s1 = cum_areas_s1(:,boundary_ind);
wsbwa12_s2 = cum_areas_s2(:,boundary_ind);

save a12_fullrange_gamma_areas_2020_20_1_revise timea12 wsbwa12* cum_areas* -append
