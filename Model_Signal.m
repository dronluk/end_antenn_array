function [ signal ] = Model_signal( sv,quant_jam,number_jam,az,zen,A )
fd=97e6; % ������� �������������
td=1/fd; %������ ������������� 
% fc=10e6; % ������� ������� (������� ��������� ������� carr(t) ),
fc=39580000;
T=0.01; %����� ������������� � ��������
f=3e6;%������� ������
t=td:td:T;%�����
N=1:length(t);%������ �������
lambda=3e8/f;%������ ����� ������
 az=az-10;%������
 zen=zen-10;%���� �����
%A=2000;   %��������� ������ 
Q=45;   %��������� ������-���
B=fd;   %������ ���������

SN_level = 10^(-Q/20)*sqrt(B);    % ������� ����������� �����

[s,noise]=get_signal(fd,td,fc,T,sv);%������ ((�/� ���* �������),���)

signal= sqrt(2)*s + SN_level*noise;

switch number_jam
    case 1 %----������������ ������----------
        jam=A*exp(1i*2*pi*f*td*N);
    case 2%----�������������� ������------
        x=randn(1,length(t));
        [b,a] = butter(10,[0.2 0.7]);
        Y = filter(b,a,x);
        jam=Y*A;
    case 3%-----��� ������--------
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
        [PH]=Phase_jam(f,td,T,A,az(i),zen(i),lambda);%���� ������
        tmp_jam=PH*jam;
        signal=signal+tmp_jam;
    end
end
signal=signal';

end

