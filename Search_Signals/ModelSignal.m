%----------------------------������ �������-------------------------------%
function Y=ModelSignal(fd,if_freq,f_psp,T,svnum,GNSS)

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

switch GNSS
    case 'GPS'
        psp = GpsCode(svnum, fd/f_psp); %��� 
        psp = circshift( psp, round(shift_psp*(fd/f_psp)) )'; %�����   
        s = cos(2*pi*(if_freq+f_dop)*t);      % s - ������
        Y = zeros(1,length(s));               % Y - �������������� ������
    case 'GLONASS'
        psp = GlonassCode(fd/f_psp);  
        psp = circshift( psp, round(shift_psp*(fd/f_psp)) )'; 
        s = cos(2*pi*(if_freq+f_dop+Litera_step)*t);      % s - ������
        Y = zeros(1,length(s));               % Y - �������������� ������
    case 'BEIDOU'
        psp = BeiDouCode(svnum, fd/f_psp); 
        psp = circshift( psp, round(shift_psp*(fd/f_psp)) )';
        s = cos(2*pi*(if_freq+f_dop)*t);      % s - ������
        Y = zeros(1,length(s));               % Y - �������������� ������

    otherwise
        disp('Error type of GNSS');     
end

    for i = 1:step:length(s)
        
      Y(i:i+(step-1))=s(i:i+(step-1)).*psp;
      
    end
end