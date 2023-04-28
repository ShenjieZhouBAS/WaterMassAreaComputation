section_years=[1992,1996,1998,1999,2000,2002,2005,2008,2010,2012:2014,2016,2018];
sectiondates=[1992 6 10; 1996 4 14; 1998 5 6; 1999 1 18; 2000 12 20; ...
    2002 12 5; 2005 2 3; 2008 2 23; 2010 12 10; 2012 12 9; 2013 6 15;...
    2014 12 12; 2016 12 28; 2018 12 26];
% 2005 12 14;
cruisenames={'ant_x_4','ant_xiii_4','ant_xv_4', 'ant_xvi_2','ant_xviii_3','ant_xx_2',...
    'ant_xxii_3','ant_xxiv_3','ant_xxvii_2','ant_xxix_2','ant_xxix_6',...
    'ant_xxx_2','ant_xxxii_2','ps117'};
% ,'ant_xxiii_2','ant_xxiv_2'

% section_years(section_years==2010)=[]; %temporarily remove - problems with year!!!

sectionnames=cell(1,length(section_years));

for n=1:length(section_years)
    sectionnames{n}=cruisenames{n};
end
m=1;

[sectiondates,sortind]=sort(datenum(sectiondates));

section_years=section_years(sortind);
sectionnames=sectionnames(sortind);
cruisenames=cruisenames(sortind);

clear m n
