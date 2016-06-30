function [s,noise] = get_signal( FD,TD,FC,Time,sv )

fd=FD; % ������� �������������
td=TD;%������ ������������� 
fc=FC;% ������� ������� (������� ��������� ������� carr(t) ),
T=Time;%����� ������������� � ��������
Nms=T*1000; %���������� ����������� ������������� ( Nms = T*1000 ),
t=td:td:T; % �������� ���
N=1:length(t);
%f_psp=fd/1023000;
f_psp=1023000;
if_freq=39580000;
 noise(1,:) = randn(1,length(t))+1i*randn(1,length(t));  % ����������������� ����������� ��� 1� ������
 noise(2,:) = randn(1,length(t))+1i*randn(1,length(t));  % ����������������� ����������� ��� 2� ������
 noise(3,:) = randn(1,length(t))+1i*randn(1,length(t));  % ����������������� ����������� ��� 3� ������
 noise(4,:) = randn(1,length(t))+1i*randn(1,length(t));  % ����������������� ����������� ��� 4� ������  
 
 N=10000;
f_dop = randi([-N;N]);                % f_dop - ����� �� �������
shift_psp = randi([0;round(f_psp)]);  % shift_psp - ����� �� ���� 
step = fd/1000;
 carr = cos(2*pi*(if_freq+f_dop)*t);      % s - ������

        psp = GpsCode(sv, fd/f_psp); %��� 
        psp = circshift( psp, round(shift_psp*(fd/f_psp)) )'; %�����   
        carr = cos(2*pi*(if_freq+f_dop)*t);      % s - ������
        Y = zeros(1,length(carr));               % Y - �������������� ������

    for i = 1:step:length(carr)
        
      Y(i:i+(step-1))=carr(i:i+(step-1)).*psp;
      
    end
 s = [Y; Y; Y; Y];
% carr=sin(2*pi*fc*td*N);%�������
% psp = cacode(sv,fd/f_psp);%���
% 
% % figure(1);
% % plot(carr); hold on;xlim([1 500]);ylim([-2 2]);
% % plot(psp);
% % m=1;
% % for k=1:length(t)
% %     psp2(k)=psp(m);
% %     m=m+1;
% %     if m>length(psp)
% %         m=1;
% %     end
% % end
% % psp=psp2;
% 
% Y = zeros(1,length(carr));   
% step = fd/1000;
% 
% for i = 1:step:length(carr)
%   Y(i:i+(step-1))=carr(i:i+(step-1)).*psp;
% end
%     
% %s=(psp.*carr);
% %S=fft(s);
%  s = [Y; Y; Y; Y];
% CARR=fft(carr);
% PSP=fft(psp);
% figure(2);
% plot(abs(CARR)); 
% hold on 
% plot(abs(S),'r');
% title('������ ������� ��� ������');
% figure(2);
% plot(s);xlim([1 500]);ylim([-2 2]);
% hold on; plot(noise,'r');

end

