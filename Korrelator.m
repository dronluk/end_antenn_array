 function [svnum,SNR]= Korrelator( e,Imput_Signal,hObject, eventdata, handles )

 data=e';

GNSS = 'GPS';                       % GNSS  - 'GPS', 
                                    %         'GLONASS', 
                                    %         'BEIDOU'
                                    
[fc, f_psp] = Type_GNSS(GNSS);      % fc    - ����������� ������� �������
                                    % f_psp - ������� ���������� ����� 
fs=102e6;                           % fs    - ������� �������������
fs=97e6;   
fh=1530e6;                          % fh    - ������� ����������
fh=1518e6;

%svnum=1;
%  svnum=[2 6 12 14];                         % ������ ��������� ��� ������
%svnum=[ 1 4 8 11 14 18 19 22 24 27 28 32];  % ������ ��������� ��������� GPS



ch_adc= [1 ];                  % ����� ������


for channel= ch_adc
data1=(data(:,channel)  -mean(data(:,channel)))';

% %  [I,Q,fs] = Hilbert_Filter(data1, fs);
if(Imput_Signal==1)%��� ������
 svnum=1;
end
if(Imput_Signal==2)%��� ����� � ������
 fs=fs /2;   %���� ������������ �������
 svnum=[2 6 12];
end
if(Imput_Signal==3)%��� ����� ��� ������
 fs=fs /2;
 svnum=[2 6 12];
end
I = real(data1);
Q = imag(data1);
  
ts=1/fs;               %������ �������������
collect_number=10;     %����� ���������
n=fs/1000;             %����� �������� � 1 ��
nn=[0:n-1];            %  total  no.  of  pts
span_dopler = 60;      % ������ ��������� ��� �������


if_freq=abs(fh-fc);
if if_freq > fs 
    if_freq = 2*fs-if_freq ;
end;

Litera_freq = .5625e6;          % ��������� ��� ������ �������
if_freq_GLO = if_freq;
decim_value = f_psp*2;

Fchip=fs/f_psp;               % ������� ���������� ����� GPS
%Fchip=fs/.511e6;                % ������� ���������� ����� �������
%Litera_freq = .5625e6;          % ��������� ��� ������ �������

result =zeros(span_dopler, f_psp/500);
fprintf('-------- %1d --------\n', channel);
fprintf('SV#:');

%  [I,noise]=get_signal(fs,ts,if_freq,0.01,svnum);
% %[I,noise]=ModelSignal(fs,if_freq,f_psp,0.01,svnum,GNSS);
% I=I(1,:);
% data = I;
% data=data(1,:);

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
% Im  =  sine  .*I(k*n+1:n*(k+1));
% Qm  =  cosine.*I(k*n+1:n*(k+1));
   Im  =  cosine.*I(k*n+1:n*(k+1)) +   sine.*Q(k*n+1:n*(k+1));
   Qm  =   -sine.*I(k*n+1:n*(k+1)) + cosine.*Q(k*n+1:n*(k+1));
%  
 I1 = decim(fs,decim_value,Im);
 Q1 = decim(fs,decim_value,Qm);
%  
 IQfreq  =  fft(I1+1i*Q1);
%  IQfreq=fft(data);
 convcodeIQ  =  IQfreq.*codefreq;
 result(l,:)  =  abs(ifft(convcodeIQ));
end;
 
 Z=Z+result;
% figure; H=gca;
% mesh(H,Z);
%   figure
  axes(handles.axes2);
  mesh(Z);

 xlabel('���� ����');ylabel('����� �� �������');zlabel('��������� ������ ���');
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
fprintf('%2.3f, ', SNR(svnum));
fprintf('\n');

end;

% figure(10);
% FftL=1000;
% Fd=fs;
% FftS=abs(fft(data,FftL));% ��������� �������������� ����� �������
%  FftS=2*FftS./FftL;% ���������� ������� �� ���������
% % FftS(1)=FftS(1)/2;% ���������� ���������� ������������ � �������
% F=0:Fd/FftL:Fd/2-1/FftL;% ������ ������ ������������ ������� �����
% plot(F,FftS(1:length(F)));% ���������� ������� ����� �������
% title('������ �������');% ������� �������
% xlabel('������� (��)');% ������� ��� � �������
% plot(fftshift(abs(fft(data,(fs/2)-(fs/FftL)))));grid on

% spector=zeros(fs/500,4); grid on
% 
% for k=1:1
%     m=0;
%     while ((m+1)*fs/500 < length(data(:,1))) 
%      spector(:, k) =  spector(:, k) + abs(fft(data(m*fs/500 +1:(m+1)*fs/500,k)));
%      m=m+1;
%     end
%     spector(:,k) = spector(:,k) / max(spector(:, k) );
%     spector(:,k) = 10*log10(spector(:,k));
% end;
% 
%  plot(spector(:,:)); grid on;


 end

