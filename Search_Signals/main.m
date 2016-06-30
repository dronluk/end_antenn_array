clear all; 
close all;
clc;
%-------------------------��������� ������--------------------------------%

fd = 50e6;                         % fd - ������� �������������
fh = 1530e6;                       % ������� ��������(������� ����������) 
span_dop = 60;                     % span_dop - ������ ��������� �������
T = 0.01;
td = 1/fd;                         % td - ������ �������������
t = td:td:T;
collect_number = 10;               % collect_number - ����� ����������
GNSS = 'GLONASS';                      % GNSS -  'GPS',
                                   %         'GLONASS', 
                                   %         'BEIDOU'
                         
[fc, f_psp] = Type_GNSS(GNSS);     % f_psp - ������� ���������� �����  
                                   % fc - ������� �������                                
decim_value = f_psp*2;             % decim_value - �������� ��������� 
mn = (fd/1000);                    % mn - ���������� �������� � ������������
result=zeros(span_dop,f_psp/500);  % result - ��������� ���������
Z = zeros(span_dop,f_psp/500);     % Z - ���������� ����������
svnum = 2;                         % svnum - ����� �������� ��� ������ 
noise = randn(1,length(t));        % noise - ����������� ���
Q = 45;                            % Q - �������� �������� ���
B = fd;                            % B - ������ ��������
Noise_Level = 10^(-Q/20)*sqrt(B);  % Noise_Level - ������������ ����
if_freq = abs(fh-fc);              % if_freq - ������������� �������
Litera_step = .5625e6;             % ��������� ��� ������ �������


%---------------------------����� �������---------------------------------%

%������� �� ������ �������
    if if_freq > fd
        if_freq = 2*fd-if_freq ;
    end;
    
 if_freq_GLO = if_freq;
 
%������������ �������
    X=sqrt(2)*ModelSignal(fd,if_freq,f_psp,T,svnum,GNSS);  % ������� + ���
    
    X=X+noise*Noise_Level;                             % X - ������ �������

    X1 = zeros(1,mn);

    
    %���� �������� ���������
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

        fftPSP = fft(psp);                    % �������������� �����   
        conjPSP = conj(fftPSP);               % ����� ����� 
        fprintf('%d,\n', sv);                 % ����� �� ����� ������ ��������

        % ���� ���������� ���������� ��������� ����������
        for  c=0:(collect_number-1)

        X1 = X(mn*c +1 : mn*(c+1));
        t=td:td:0.001;

            % ���� �������� ������� �������
            for k = -29:1:30


            sine = sin(2*pi*t*(if_freq+500*k) );   % ��������� ���������� sin
            cosine = cos(2*pi*t*(if_freq+500*k) ); % ��������� ���������� cos

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
    %-------------------------------��������� ������--------------------------%

     [C,Indx1] = max(max(Z'));
     %fprintf('\nIndex ������� = %d \n', Indx1)
     [C,Indx2] = max(max(Z));
     %fprintf('Index ���� = %d \n', Indx2)

     Smax = max(max(Z));    % Smax - ������������ �������� �������

     Z(Indx1,:) = [];
     Z(:,Indx2) = [];
     CKO  = mean(mean(Z));  % CKO - ������� �������� ����
     SNR = Smax/CKO;        % SNR - ��������� ������/���
     SNR = 20*log10(SNR);
     SNR = 30+SNR;           
     fprintf('SNR = %4.0f  \n', SNR)
     
      end
  