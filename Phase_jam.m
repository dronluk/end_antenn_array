function [PH] = Phase_jam(F,TD,Time,a,az,zen,lambda)
angles=[zen az]';
A=a;
f=F;
td=TD;%������ ������������� 
T=Time;%����� ������������� � ��������
Nms=T*1000; %���������� ����������� ������������� ( Nms = T*1000 ),
t=td:td:T; % �������� ���
N=1:length(t);
%angles=[40 160]';              % ������� ����� ������� ������
%lambda = 0.187;                % ������ ����� (� ������) = �������� ����� / ������� ������ (1 600 ���)
L = lambda/2;                  % ���������� ����� ��������� ����������
EA = angles';
% ������� ������� ��������� 4� �������� ���������
Pa(1,:)=[ 0, 0, 0];      % 1 ������� � ������������ x=0, y=0, z=0
Pa(2,:)=[ 0, L, 0];      % 2 ������� � ������������ x=0, y=�������� ������ �����, z=0
Pa(3,:)=[ L, 0, 0];      % 3 ������� � ������������ x=�������� ������ �����, y=0, z=0
Pa(4,:)=[ L, L, 0];      % 4 ������� � ������������ x=�������� ������ �����, y=�������� ������ �����, z=0
% ������� �� �������� � �������
ea=pi/180*EA;  
% ������� � 3� ������ ����������
R = [cos(ea(1))*sin(ea(2)),cos(ea(1))*cos(ea(2)),sin(ea(1)) ];  % R - ������ ������� ������ x,y,z: [0,0,0] - [R(1),R(2),R(3)]
% ������� ��������� ������������ (�������� ����������� ������)
PaR=Pa*R';
% ������� � ������� � ���� �� ���� ����
PaR=(pi*PaR)/lambda;
% ������� � ���������������� �������������
PH = exp(1i*PaR); 
% %----������������ ������----------
% jam1=A*exp(1i*2*pi*f*td*N);  % ������ ��������������� �����
% jam=PH*jam1*A;
% %------------------
% % x=randn(1,length(t));  
% % [b,a] = butter(10,[0.2 0.7]); 
% % Y = filter(b,a,x); 
% % jam=PH*Y*A;
% %-----��� ������-----
% k=5;
% for i=1:length(t)
% jam2(i)=sin(2*pi*(f+k/2*N(i))*td*N(i));
% end
% jam2=PH*jam2*A;

end

