function ca_code = get_cacode( sv, fs )
% sv:satellite number
% fs: fd/1023000
% table of C/A Code Tap Selection

tap=[2 6;
    3 7;
    4 8;
    5 9;
    1 9;
    2 10;
    1 8;
    2 9;
    3 10;
    2 3;
    3 4;
    5 6;
    6 7;
    7 8;
    8 9;
    9 10;
    1 4;
    2 5;
    3 6;
    4 7;
    5 8;
    6 9;
    1 3;
    4 6;
    5 7;
    6 8;
    7 9;
    8 10;
    1 6;
    2 7;
    3 8;
    4 9
    5 10
    4 10
    1 7
    2 8
    4 10];
k1 = tap(sv,1) ;
k2 = tap(sv,2) ;
% G1 LFSR: x^10+x^3+1
g1 = ones(10,1) ;
% G2j LFSR: x^10+x^9+x^8+x^6+x^3+x^2+1
g2 = ones(10,1) ;
ca_code = [] ;
n=10;
L=2^n-1;
for k=1:L
    ca_code = [ca_code; mod(g1(10)+mod(g2(k1)+g2(k2),2),2)] ;
    g11 = mod(g1(10)+g1(3),2) ;
    g21 = mod(g2(2)+g2(3)+g2(6)+g2(8)+g2(9)+g2(10),2) ;
    g1(2:end) = g1(1:end-1) ;
    g2(2:end) = g2(1:end-1) ;
    g1(1) = g11 ;
    g2(1) = g21 ;
end

 for num=1:L
      if ca_code(num)==0
          ca_code(num)=-1;
      end;
  end;
  
  if fs~=1
	%fractional upsampling with zero order hold
	index=0;
	for cnt = 1/fs:1/fs:L
		index=index+1;
		if ceil(cnt) > L   %traps a floating point error in index
			gfs(:,index)=ca_code(L,:);
		else
			gfs(:,index)=ca_code(ceil(cnt),:);
		end
	end 
	ca_code=gfs;
  end
  
end

