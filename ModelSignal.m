%----------------------------Модель сигнала-------------------------------%
function [s,noise]=ModelSignal(fd,if_freq,f_psp,T,svnum,GNSS)

%if nargin<8
N=10000;
f_dop = randi([-N;N]);                % f_dop - сдвиг по доплеру
shift_psp = randi([0;round(f_psp)]);  % shift_psp - сдвиг по коду 
%end

td=1/fd;                              % td - период дискретизации
t=td:td:T;
step = fd/1000;
Litera_step = .5625e6;
% s = cos(2*pi*(if_freq+f_dop)*t);      % s - сигнал
% Y = zeros(1,length(s));               % Y - результирующий сигнал
 noise(1,:) = randn(1,length(t))+1i*randn(1,length(t));  % некоррелированный собственный шум 1й антены
 noise(2,:) = randn(1,length(t))+1i*randn(1,length(t));  % некоррелированный собственный шум 2й антены
 noise(3,:) = randn(1,length(t))+1i*randn(1,length(t));  % некоррелированный собственный шум 3й антены
 noise(4,:) = randn(1,length(t))+1i*randn(1,length(t));  % некоррелированный собственный шум 4й антены  
switch GNSS
    case 'GPS'
        psp = GpsCode(svnum, fd/f_psp); %ПСП 
        psp = circshift( psp, round(shift_psp*(fd/f_psp)) )'; %сдвиг   
        carr = cos(2*pi*(if_freq+f_dop)*t);      % s - сигнал
        Y = zeros(1,length(carr));               % Y - результирующий сигнал
    case 'GLONASS'
        psp = GlonassCode(fd/f_psp);  
        psp = circshift( psp, round(shift_psp*(fd/f_psp)) )'; 
        carr = cos(2*pi*(if_freq+f_dop+Litera_step)*t);      % s - сигнал
        Y = zeros(1,length(carr));               % Y - результирующий сигнал
    case 'BEIDOU'
        psp = BeiDouCode(svnum, fd/f_psp); 
        psp = circshift( psp, round(shift_psp*(fd/f_psp)) )';
        carr = cos(2*pi*(if_freq+f_dop)*t);      % s - сигнал
        Y = zeros(1,length(carr));               % Y - результирующий сигнал

    otherwise
        disp('Error type of GNSS');     
end

    for i = 1:step:length(carr)
        
      Y(i:i+(step-1))=carr(i:i+(step-1)).*psp;
      
    end
    s=Y;
end