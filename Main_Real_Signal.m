clear all;
j=sqrt(-1);
step = 1000;%���.��������
mu = 1/10000000000;%��� ����������
Antenn=4;%���.������
N = 1000; %������ �������
k = 20; %���������� ������� STAP
sv=1;%����� �������� ��� ������ �������
quant_jam=1; %���������� �����
number_jam=2;%1-������������ 2-�������������� 3-���

 data=Model_Signal(sv,quant_jam,number_jam);

% fileID = fopen('wide_75dBm_#2_gn32.txt');%������ �� �����
% % data1 = textscan(fileID, '%10.1f   %10.1f   %10.1f   %10.1f', 3000000);
% data1 = textscan(fileID, '%10.1f   %10.1f   %10.1f   %10.1f', 3000000);
% fclose(fileID);
% data=cell2mat(data1);

% path='';
% fileID = fopen([path 'no_jamm_20M.txt']);
% data1 = textscan(fileID, '%10.1f   %10.1f   %10.1f   %10.1f', 1000000);
% fclose(fileID);
% data=cell2mat(data1);
for k=1:4
data(:,k) = data(:,k) - mean(data(:,k));
end
data = data';
clear data1 fileID;

% signal=My_Hilbert_Filter(data,Antenn);%�������

signal=data;%��� ��������

% % e2=SMI_Filter(signal,N,k,Antenn);%���������� ������
Inter=signal(:,1:N);
d=Inter(1,:);% ��������� ������ �������
d2=signal(1,:);
U=signal(2:4,:);
%������(��������)
U_tap =[];
for i=0:k
    U_tap = [U_tap; circshift(U',i)' ];
end;
%--------
Uinter = U_tap(:,1:N); % ������������ ������� �������
W=ones(length(Uinter(:,1)), 1);   %����������
  [e,W,Y]=SMI_metod(d,Uinter);%SMI �����
% [e,W,Y]=LMS_metod(d,Uinter,mu,step);%LMS �����
  Y=W'*Uinter;
  e=d-Y;
 
  Y2=W'*U_tap;
  e2=d2-Y2; 
  std(e2);
  
   %e2=signal(1,:);%��� ����������� �������
  
fprintf('��� �� ����������: %f \n',std(signal(1,:)));
fprintf('��� �����: %f \n',std(e2));



 Korrelator(e2);
  %Korrelator(signal(1,:));

