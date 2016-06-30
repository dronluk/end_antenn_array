function [s,noise] = get_signal( FD,TD,FC,Time,sv )

fd=FD; % частота дискретизации
td=TD;%период дискретизации 
fc=FC;% частота несущей (частота синусойды сигнала carr(t) ),
T=Time;%время моделирования в секундах
Nms=T*1000; %количество миллисекунд моделирования ( Nms = T*1000 ),
t=td:td:T; % интервал мод
N=1:length(t);
%f_psp=fd/1023000;
f_psp=1023000;
if_freq=39580000;
 noise(1,:) = randn(1,length(t))+1i*randn(1,length(t));  % некоррелированный собственный шум 1й антены
 noise(2,:) = randn(1,length(t))+1i*randn(1,length(t));  % некоррелированный собственный шум 2й антены
 noise(3,:) = randn(1,length(t))+1i*randn(1,length(t));  % некоррелированный собственный шум 3й антены
 noise(4,:) = randn(1,length(t))+1i*randn(1,length(t));  % некоррелированный собственный шум 4й антены  
 
 N=10000;
f_dop = randi([-N;N]);                % f_dop - сдвиг по доплеру
shift_psp = randi([0;round(f_psp)]);  % shift_psp - сдвиг по коду 
step = fd/1000;
 carr = cos(2*pi*(if_freq+f_dop)*t);      % s - сигнал

        psp = GpsCode(sv, fd/f_psp); %ПСП 
        psp = circshift( psp, round(shift_psp*(fd/f_psp)) )'; %сдвиг   
        carr = cos(2*pi*(if_freq+f_dop)*t);      % s - сигнал
        Y = zeros(1,length(carr));               % Y - результирующий сигнал

    for i = 1:step:length(carr)
        
      Y(i:i+(step-1))=carr(i:i+(step-1)).*psp;
      
    end
 s = [Y; Y; Y; Y];
% carr=sin(2*pi*fc*td*N);%Несущая
% psp = cacode(sv,fd/f_psp);%ПСП
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
% title('Спектр сигнала без помехи');
% figure(2);
% plot(s);xlim([1 500]);ylim([-2 2]);
% hold on; plot(noise,'r');

end

