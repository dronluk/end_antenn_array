function [ signal ] = Model_signal( sv,quant_jam,number_jam,az,zen,A )
fd=97e6; % частота дискретизации
td=1/fd; %период дискретизации 
% fc=10e6; % частота несущей (частота синусойды сигнала carr(t) ),
fc=39580000;
T=0.01; %время моделирования в секундах
f=3e6;%частота помехи
t=td:td:T;%Время
N=1:length(t);%длинна сигнала
lambda=3e8/f;%длинна волны помехи
 az=az-10;%Азимут
 zen=zen-10;%Угол места
%A=2000;   %Амплитуда помехи 
Q=45;   %Отношение сигнал-шум
B=fd;   %Полоса приемника

SN_level = 10^(-Q/20)*sqrt(B);    % Уровень собственных шумов

[s,noise]=get_signal(fd,td,fc,T,sv);%сигнал ((с/а код* несущая),шум)

signal= sqrt(2)*s + SN_level*noise;

switch number_jam
    case 1 %----Узкополосная помеха----------
        jam=A*exp(1i*2*pi*f*td*N);
    case 2%----Широкополосная помеха------
        x=randn(1,length(t));
        [b,a] = butter(10,[0.2 0.7]);
        Y = filter(b,a,x);
        jam=Y*A;
    case 3%-----ЛЧМ помеха--------
       k=5;
       for i=1:length(t)
       jam(1,i)=sin(2*pi*(f+k/2*N(i))*td*N(i));
       end
       jam=jam*A; 
end
if quant_jam~=0
    for i=1:quant_jam
        az(i)=az+10*i;
        zen(i)=zen+10*i;
        [PH]=Phase_jam(f,td,T,A,az(i),zen(i),lambda);%фаза помехи
        tmp_jam=PH*jam;
        signal=signal+tmp_jam;
    end
end
signal=signal';

end

