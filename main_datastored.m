clear all; %clc;

% path='C:/Users/MathServer/Documents/Consumer/soft_receiver/';
path='';
fileID = fopen([path 'no_jamm_20M.txt']);
data1 = textscan(fileID, '%10.1f   %10.1f   %10.1f   %10.1f', 3000000);
fclose(fileID);
data=cell2mat(data1);
clear data1 fileID;

% CKO = [std(data(:,1)) std(data(:,2)) std(data(:,3)) std(data(:,4))];
% fprintf('\n');
% fprintf('CKO:  %4.1f   %4.1f   %4.1f   %4.1f \n\n', CKO);


GNSS = 'GPS';                       % GNSS  - 'GPS', 
                                    %         'GLONASS', 
                                    %         'BEIDOU'
                                    
[fc, f_psp] = Type_GNSS(GNSS);      % fc    - Центральная частота сигнала
                                    % f_psp - Частота следования чипов 
fs=102e6;                           % fs    - Частота дискретизации
fh=1530e6;                          % fh    - Частота гетеродина

svnum=11;                         % номера спутников для поиска
% svnum=[ 1 4 8 11 14 18 19 22 24 27 28 32];  % номера найденных спутников GPS

ch_adc= [1 ];                  % Номер канала


for channel= ch_adc
data1=(data(:,channel)  -mean(data(:,channel)))';

% [I,Q,fs] = Hilbert_Filter(data1, fs);
I = data1;
% 
ts=1/fs;               %период дискретизации
collect_number=10;     %число наколений
n=fs/1000;             %число отсчётов в 1 мс
nn=[0:n-1];            %  total  no.  of  pts
span_dopler = 60;      % полоса просмотра для доплера


if_freq=abs(fh-fc);
if if_freq > fs 
    if_freq = 2*fs-if_freq ;
end;

Litera_freq = .5625e6;          % Частотный шаг литеры Глонасс
if_freq_GLO = if_freq;
decim_value = f_psp*2;
% Fchip=fs/f_psp;               % Частота следования чипов GPS
% Fchip=fs/.511e6;                % Частота следования чипов ГЛОНАСС
% Litera_freq = .5625e6;          % Частотный шаг литеры Глонасс

result =zeros(span_dopler, f_psp/500);
fprintf('-------- %1d --------\n', channel);
fprintf('SV#:');


for i=1:length(svnum)

fprintf(' %2d,', svnum(i));

 Z=0;
 
 switch GNSS
    case 'GPS'
        PSP=cacode(svnum(i),2/1);   
    case 'GLONASS'
        PSP=func_GloSTcode(2/1); 
        if_freq = if_freq_GLO + Litera_freq*(svnum(i)-8);
    case 'BEIDOU'
        PSP=func_BeiDouB1Icode(svnum(i),2/1);
    otherwise
        disp('Error type of GNSS');
        
 end
        
 %  *****  DFT  of  C/A  code  *****
 psp_fft=fft(PSP);
 codefreq=conj(psp_fft);
 
 for  k=0:(collect_number-1)

%
for  l=1:60
 f_dplr  = if_freq  +  0.0005e6*(l-30);
 expfreq=exp(1i*2*pi*f_dplr*ts*nn);
 sine  =  imag(expfreq); %  generate  local  sine
 cosine=  real(expfreq); %  generate  local  cosine
 Im  =  sine  .*I(k*n+1:n*(k+1));
 Qm  =  cosine.*I(k*n+1:n*(k+1));
%  Im  =  cosine.*I(k*n+1:n*(k+1)) +   sine.*Q(k*n+1:n*(k+1));
%  Qm  =   -sine.*I(k*n+1:n*(k+1)) + cosine.*Q(k*n+1:n*(k+1));
 
 I1 = decim(fs,decim_value,Im);
 Q1 = decim(fs,decim_value,Qm);
 
 IQfreq  =  fft(I1+1i*Q1);
 
 convcodeIQ  =  IQfreq.*codefreq;
 result(l,:)  =  abs(ifft(convcodeIQ));
end;
 
 Z=Z+result;
 
mesh(Z);figure(gcf);
 
 end;
 
%   mesh(Z);figure(gcf);
  
  [peak(svnum(i)) codephase]=max(max(Z));
  [peak(svnum(i)) frequency]=max(max(Z'));
%   result_noise=result;
  result_noise=Z;
  result_noise(:,codephase)=[];
  result_noise(frequency,:)=[];
%   meanValue(svnum(i))=std(std(result_noise));
  meanValue(svnum(i))=mean(mean(result_noise));
  meanPeak(svnum(i))=peak(svnum(i))/meanValue(svnum(i));
 

end;

SNR=20*log10(meanPeak);
SNR=SNR+30;

fprintf('\nSNR: ');
fprintf('%2.0f, ', SNR(svnum));
fprintf('\n');

end;

figure(10)
spector=zeros(fs/500,4);

for k=1:4
    m=0;
    while ((m+1)*fs/500 < length(data(:,1))) 
     spector(:, k) =  spector(:, k) + abs(fft(data(m*fs/500 +1:(m+1)*fs/500,k)));
     m=m+1;
    end
    spector(:,k) = spector(:,k) / max(spector(:, k) );
    spector(:,k) = 10*log10(spector(:,k));
end;

% plot(spector(:,:)); grid on;