function [ e,W,Y ] = SMI_metod(  D,UINTER)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
d=D;            % ��������� ������ �������
Uinter=UINTER;  % ������������ ������� �������

L=length(Uinter);
    R=1/L*(Uinter*Uinter');
    r=1/L*(d*Uinter');
    W=pinv(R)*r';
    Y = W'*Uinter;     %������� � ������������ ������ ����������� � ����������
    e = d - Y;
 std(e)%������� ���������� ����������
end

