function blending_pic=linear(over1,over2)
height=size(over1,1);
width=size(over1,2);
blending_pic=zeros(height,width,3,'uint8');
w1=zeros(1,width);
w2=w1;
begin=1; %相同區域的開頭
Ending=width; %相同區域的結尾

for x=1:width
	black1=1;
	black2=1;
	for y=1:height
		for c=1:3
			if over1(y,x,c)<3
				black1=0;
			end
			if over2(y,x,c)<3 %如果是黑邊
				black2=0;
			end
		end
	end
	if black1==1&&x-1<Ending
		Ending=x-1;
    elseif black2==1&&x+1>begin
		begin=x+1;
	end
end


begin=begin+20;
Ending=Ending-20;

for x=1:width
	if x<begin
		w1(x)=1;
		w2(x)=0;
	elseif x>Ending
		w1(x)=0;
		w2(x)=1;
	else
		w1(x)=(1-(x-begin)./(Ending-begin));
		w2(x)=(x-begin)./(Ending-begin);
	end
	for i=1:3
		if x<size(over2,2)
			blending_pic(:,x,i)=w1(x)*over1(:,x,i)+w2(x)*over2(:,x,i);
		else
			blending_pic(:,x,i)=w1(x)*over1(:,x,i);
		end
	end
end
blending_pic=blending_pic(:,1:width-1,:);
end