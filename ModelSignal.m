%----------------------------������ �������-------------------------------%
function [s,noise]=ModelSignal(fd,if_freq,f_psp,T,svnum,GNSS)

%if nargin<8
N=10000;
f_dop = randi([-N;N]);                % f_dop - ����� �� �������
shift_psp = randi([0;round(f_psp)]);  % shift_psp - ����� �� ���� 
%end

td=1/fd;                              % td - ������ �������������
t=td:td:T;
step = fd/1000;
Litera_step = .5625e6;
% s = cos(2*pi*(if_freq+f_dop)*t);      % s - ������
% Y = zeros(1,length(s));               % Y - �������������� ������
 noise(1,:) = randn(1,length(t))+1i*randn(1,length(t));  % ����������������� ����������� ��� 1� ������
 noise(2,:) = randn(1,length(t))+1i*randn(1,length(t));  % ����������������� ����������� ��� 2� ������
 noise(3,:) = randn(1,length(t))+1i*randn(1,length(t));  % ����������������� ����������� ��� 3� ������
 noise(4,:) = randn(1,length(t))+1i*randn(1,length(t));  % ����������������� ����������� ��� 4� ������  
switch GNSS
    case 'GPS'
        psp = GpsCode(svnum, fd/f_psp); %��� 
        psp = circshift( psp, round(shift_psp*(fd/f_psp)) )'; %�����   
        carr = cos(2*pi*(if_freq+f_dop)*t);      % s - ������
        Y = zeros(1,length(carr));               % Y - �������������� ������
    case 'GLONASS'
        psp = GlonassCode(fd/f_psp);  
        psp = circshift( psp, round(shift_psp*(fd/f_psp)) )'; 
        carr = cos(2*pi*(if_freq+f_dop+Litera_step)*t);      % s - ������
        Y = zeros(1,length(carr));               % Y - �������������� ������
    case 'BEIDOU'
        psp = BeiDouCode(svnum, fd/f_psp); 
        psp = circshift( psp, round(shift_psp*(fd/f_psp)) )';
        carr = cos(2*pi*(if_freq+f_dop)*t);      % s - ������
        Y = zeros(1,length(carr));               % Y - �������������� ������

    otherwise
        disp('Error type of GNSS');     
end

    for i = 1:step:length(carr)
        
      Y(i:i+(step-1))=carr(i:i+(step-1)).*psp;
      
    end
    s=Y;
end