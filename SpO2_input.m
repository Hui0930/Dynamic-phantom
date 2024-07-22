original=importdata("original signal.xlsx");
datapoint=1:1:300;
detrenddata=detrend(original,2);
newdata=detrenddata+mean(original);
normalised=newdata./max(newdata);

[nmax,nposmax]=findpeaks(normalised,'MinPeakDistance',30);
[nmin,nposmin]=findpeaks(-normalised,'MinPeakDistance',30);


r100=0.5549; % R rate at 100% SpO2
R100=nmax./(-nmin);
lnR100=log(R100);
lnIref=lnR100./r100;
Iref=exp(lnIref);

r95=0.7559; % R rate at 95% SpO2
lnR95=r95*lnIref;
R95=exp(lnR95);

r90=0.9570; % R rate at 90% SpO2
lnR90=r90*lnIref;
R90=exp(lnR90);

r86=1.1178; % R rate at 86% SpO2
lnR86=r86*lnIref;
R86=exp(lnR86);

m100=1./R100; % Modification rate
m95=1./R95;
m90=1./R90;
m86=1./R86;
mI=1./Iref;

dyn=normalised-min(normalised); % AC signal

cr95=(1-m95(7))/(1-m100(7));
dyn95=dyn*cr95;

cr90=(1-m90(7))/(1-m100(7));
dyn90=dyn*cr90;

cr86=(1-m86(7))/(1-m100(7));
dyn86=dyn*cr86;

crI=(1-mI(7))/(1-m100(7));
dynI=dyn*crI;

signal95=dyn95+1-max(dyn95);
signal90=dyn90+1-max(dyn90);
signal86=dyn86+1-max(dyn86);
signalIref=dynI+1-max(dynI);



%%
Rs=importdata("R.txt");
volR=1.5:0.05:2;
RLUT=Rs(21:31);
RLUTn=RLUT./max(RLUT);

inputcalR100=interp1(RLUTn,volR,normalised);
up1R100=inputcalR100(1)*ones(20,1);
up2R100=inputcalR100(end)*ones(20,1);
Rinput100=[up2R100; up1R100;inputcalR100;up2R100; up1R100];

inputcalR95=interp1(RLUTn,volR,signal95);
up1R95=inputcalR95(1)*ones(20,1);
up2R95=inputcalR95(end)*ones(20,1);
Rinput95=[up2R95; up1R95;inputcalR95;up2R95; up1R95];

inputcalR90=interp1(RLUTn,volR,signal90);
up1R90=inputcalR90(1)*ones(20,1);
up2R90=inputcalR90(end)*ones(20,1);
Rinput90=[up2R90; up1R90;inputcalR90;up2R90; up1R90];

inputcalR86=interp1(RLUTn,volR,signal86);
up1R86=inputcalR86(1)*ones(20,1);
up2R86=inputcalR86(end)*ones(20,1);
Rinput86=[up2R86; up1R86;inputcalR86;up2R86; up1R86];

Is=importdata("I.txt");
volI=1.25:0.05:1.95;
ILUT=Is(16:30);
ILUTn=ILUT./max(ILUT);
plot(ILUTn)
inputcalI=interp1(ILUTn,volI,signalIref);
up1NIR=inputcalI(1)*ones(20,1);
up2NIR=inputcalI(end)*ones(20,1);
NIRinput=[up2NIR; up1NIR;inputcalI;up2NIR; up1NIR];

t=linspace(0,7.6,76001);
fs=10000;

xR100=(1:length(Rinput100))/50;
modulatedsignalR100=interp1(xR100,Rinput100,t);
removenanR100=modulatedsignalR100(~isnan(modulatedsignalR100))';
txR100=t(1:length(removenanR100));
yR100=square(400*txR100*pi);
inputsignalR100=removenanR100'.*yR100;

xR95=(1:length(Rinput95))/50;
modulatedsignalR95=interp1(xR95,Rinput95,t);
removenanR95=modulatedsignalR95(~isnan(modulatedsignalR95))';
txR95=t(1:length(removenanR95));
yR95=square(400*txR95*pi);
inputsignalR95=removenanR'.*yR95;

xR90=(1:length(Rinput90))/50;
modulatedsignalR90=interp1(xR90,Rinput90,t);
removenanR90=modulatedsignalR90(~isnan(modulatedsignalR90))';
txR90=t(1:length(removenanR90));
yR90=square(400*txR90*pi);
inputsignalR90=removenanR90'.*yR90;

xR86=(1:length(Rinput86))/50;
modulatedsignalR86=interp1(xR86,Rinput86,t);
removenanR86=modulatedsignalR86(~isnan(modulatedsignalR86))';
txR86=t(1:length(removenanR86));
yR86=square(400*txR86*pi);
inputsignalR86=removenanR86'.*yR86;

xI=(1:length(NIRinput))/50;
modulatedsignalI=interp1(xI,NIRinput,t);
removenanI=modulatedsignalI(~isnan(modulatedsignalI))';
txI=t(1:length(removenanI));
yI=square(400*txI*pi);
inputsignalI1=removenanI'.*yI;

writematrix(inputsignalR100,'R100.txt','Delimiter','tab')
writematrix(inputsignalR95,'R95.txt','Delimiter','tab')
writematrix(inputsignalR90,'R90.txt','Delimiter','tab')
writematrix(inputsignalR86,'R86.txt','Delimiter','tab')
writematrix(inputsignalI,'Iref.txt','Delimiter','tab')