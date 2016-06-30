clear all; 
close all;
clc;
%-------------------------Параметры модели--------------------------------%

fd = 50e6;                         % fd - частота дискретизации
fh = 1530e6;                       % частота переноса(частота гетеродина) 
span_dop = 60;                     % span_dop - полоса просмотра доплера
T = 0.01;
td = 1/fd;                         % td - период дискретизации
t = td:td:T;
collect_number = 10;               % collect_number - число накоплений
GNSS = 'GLONASS';                      % GNSS -  'GPS',
                                   %         'GLONASS', 
                                   %         'BEIDOU'
                         
[fc, f_psp] = Type_GNSS(GNSS);     % f_psp - частота следования чипов  
                                   % fc - частота несущей                                
decim_value = f_psp*2;             % decim_value - значение доцемации 
mn = (fd/1000);                    % mn - количество отсчетов в миллисекунде
result=zeros(span_dop,f_psp/500);  % result - локальный результат
Z = zeros(span_dop,f_psp/500);     % Z - накопитель результата
svnum = 2;                         % svnum - номер спутника для поиска 
noise = randn(1,length(t));        % noise - собственный шум
Q = 45;                            % Q - заданное значение ОСШ
B = fd;                            % B - полоса приёмника
Noise_Level = 10^(-Q/20)*sqrt(B);  % Noise_Level - нормирование шума
if_freq = abs(fh-fc);              % if_freq - промежуточная частота
Litera_step = .5625e6;             % Частотный шаг литеры Глонасс


%---------------------------Поиск сигнала---------------------------------%

%Переход на низкие частоты
    if if_freq > fd
        if_freq = 2*fd-if_freq ;
    end;
    
 if_freq_GLO = if_freq;
 
%Формирование сигнала
    X=sqrt(2)*ModelSignal(fd,if_freq,f_psp,T,svnum,GNSS);  % Несущая + ПСП
    
    X=X+noise*Noise_Level;                             % X - модель сигнала

    X1 = zeros(1,mn);

    
    %Цикл перебора спутников
      for sv = 1:3
          
         Z = zeros(span_dop,f_psp/500);  

    switch GNSS
        case 'GPS'
            psp=GpsCode(sv,2/1)';
        case 'GLONASS'
            psp=GlonassCode(2/1)';
            if_freq = if_freq_GLO + Litera_step;%*(sv-8);
        case 'BEIDOU'
             psp=BeiDouCode(sv,2/1)';
        otherwise
            disp('Error type of GNSS');     
    end

        fftPSP = fft(psp);                    % преобразование фурье   
        conjPSP = conj(fftPSP);               % смена знака 
        fprintf('%d,\n', sv);                 % вывод на экран номера спутника

        % Цикл количества накоплений итогового результата
        for  c=0:(collect_number-1)

        X1 = X(mn*c +1 : mn*(c+1));
        t=td:td:0.001;

            % Цикл перебора частоты Доплера
            for k = -29:1:30


            sine = sin(2*pi*t*(if_freq+500*k) );   % генерация локального sin
            cosine = cos(2*pi*t*(if_freq+500*k) ); % генерация локального cos

            Im = sine .* X1;
            Qm = cosine .* X1;

            I1 = decim(fd,decim_value,Im);
            Q1 = decim(fd,decim_value,Qm);

            IQ = I1 + 1i*Q1;

            Y=fft(conj(IQ));

            OUT = Y.*conjPSP;
            y=abs(ifft(OUT));
            result(k+30,:) = y;

            end;

              Z=Z+result;  
              figure(gcf);
              mesh(Z);

        end
    %-------------------------------Результат поиска--------------------------%

     [C,Indx1] = max(max(Z'));
     %fprintf('\nIndex частоты = %d \n', Indx1)
     [C,Indx2] = max(max(Z));
     %fprintf('Index кода = %d \n', Indx2)

     Smax = max(max(Z));    % Smax - максимальное значение сигнала

     Z(Indx1,:) = [];
     Z(:,Indx2) = [];
     CKO  = mean(mean(Z));  % CKO - среднее значение шума
     SNR = Smax/CKO;        % SNR - отношение сигнал/шум
     SNR = 20*log10(SNR);
     SNR = 30+SNR;           
     fprintf('SNR = %4.0f  \n', SNR)
     
      end
  