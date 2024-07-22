original=importdata("original signal.xlsx");
datapoint=1:1:300;
detrenddata=detrend(original,2);
maxmin=(detrenddata-min(detrenddata))./(max(detrenddata)-min(detrenddata));
newdata=detrenddata+mean(original);
normalised=newdata./max(newdata);

Rs=importdata("R.txt"); %characterisation result file at 660 nm
volR=1.5:0.05:2; %functional range, depend on the LCD
RLUT=Rs(21:31); %response in functional range
RLUTn=RLUT./max(RLUT);
inputcalR=interp1(RLUTn,volR,normalised);

up1R=inputcalR(1)*ones(20,1);
up2R=inputcalR(end)*ones(20,1);
Rinput=[up2R; up1R;inputcalR;up2R; up1R]; %add start and end signal
% 
t=linspace(0,7.6,76001);
fs=10000;

xR=(1:length(NIRinput))/50;
modulatedsignalR=interp1(xR,Rinput,t);
removenanR=modulatedsignalR(~isnan(modulatedsignalR))';
txR=t(1:length(removenanR));
yR=square(400*txR*pi); % modulate the signal on a 200 Hz square wave carrier signal
inputsignalR=removenanR'.*yR;
% % % 

Is=importdata("I.txt"); %characterisation result file at 940 nm
volI=1.25:0.05:1.95; %functional range, depend on the LCD
ILUT=Is(16:30);  %response in functional range
ILUTn=ILUT./max(ILUT);

inputcalI=interp1(ILUTn,volI,normalised);
up1NIR=inputcalI(1)*ones(20,1);
up2NIR=inputcalI(end)*ones(20,1);
NIRinput=[up2NIR; up1NIR;inputcalI;up2NIR; up1NIR];

xI=(1:length(NIRinput))/50;
modulatedsignalI=interp1(xI,NIRinput,t);
removenanI=modulatedsignalI(~isnan(modulatedsignalI))';
txI=t(1:length(removenanI));
yI1=square(400*txI*pi);
inputsignalI1=removenanI'.*yI1;


Gs=importdata("G.txt");  %characterisation result file at 530 nm
volG=1.65:0.05:2.05;
GLUT=Gs(24:32);
GLUTn=(GLUT-min(GLUT))./(max(GLUT)-min(GLUT));
inputcalG=interp1(GLUTn,volG,normalised);
up1G=inputcalG(1)*ones(20,1);
up2G=inputcalG(end)*ones(20,1);
Ginput=[up2G; up1G;inputcalG;up2G; up1G];

xG=(1:length(Ginput))/50;
modulatedsignalG=interp1(xG,Ginput,t);
removenanG=modulatedsignalG(~isnan(modulatedsignalG))';
txG=t(1:length(removenanG));
yG=square(400*txG*pi);
inputsignalG=removenanG'.*yG;

Bs=importdata("B.txt");
volB=1.7:0.05:2.15;
BLUT=Bs(25:34);
BLUTn=(BLUT-min(BLUT))./(max(BLUT)-min(BLUT));
inputcalB=interp1(BLUTn,volB,normalised);
up1B=inputcalB(1)*ones(20,1);
up2B=inputcalB(end)*ones(20,1);
Binput=[up2B; up1B;inputcalB;up2B; up1B];

xB=(1:length(Binput))/50;
modulatedsignalB=interp1(xB,Binput,t);
removenanB=modulatedsignalB(~isnan(modulatedsignalB))';
txB=t(1:length(removenanB));
yB=square(400*txB*pi);
inputsignalB=removenanB'.*yB;

writematrix(inputsignalI,'Ii.txt','Delimiter','tab')
writematrix(inputsignalR,'Ri.txt','Delimiter','tab')
writematrix(inputsignalG,'Gi.txt','Delimiter','tab')
writematrix(inputsignalB,'Bi.txt','Delimiter','tab')