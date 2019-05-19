function [features,count_features]=msop(imgs)
overEight= 1 ./ sqrt(8);
overTwo= 1 ./ sqrt(2);
H=[overEight overEight overEight overEight overEight overEight overEight overEight;
   overEight overEight overEight overEight -overEight -overEight -overEight -overEight;
   0.5 0.5 -0.5 -0.5 0 0 0 0;
   0 0 0 0 0.5 0.5 -0.5 -0.5;
   overTwo -overTwo 0 0 0 0 0 0;
   0 0 overTwo -overTwo 0 0 0 0;
   0 0 0 0 overTwo -overTwo 0 0;
   0 0 0 0 0 0 overTwo -overTwo;];
Height=size(imgs,1);
Width=size(imgs,2);
num=size(imgs,4); %總共照片數
fx=[-1 0 1]; % x 方向的filter
fy=[-1;0;1]; % y 方向的filter

%features=zeros(num,600,66);
count_features=zeros(num);

for count=1:num
	%%imgs(:,:,:,count)現在處理的第"count"張照片
 	Img=rgb2gray(imgs(:,:,:,count)); % turn to gray color
 	for layer=1:4 %use four layer
 		height=size(Img,1);
 		width=size(Img,2);
 		scale=2^(layer-1); %不同大小的pyramid
 		Ix=filter2(fx,Img); %apply fx on Img to get Ix
 		Iy=filter2(fy,Img); %apply fy on Img to get Iy
 		Ixy=Ix .* Iy; %找出Ix, Iy平方, Ixy的乘積
 		Iy_2=Iy .^2;
 		Ix_2=Ix .^2;

 		Sxy=imgaussfilt(Ixy,0.7,'FilterSize',[7,7]);
 		Sy2=imgaussfilt(Iy_2,0.7,'FilterSize',[7,7]);
 		Sx2=imgaussfilt(Ix_2,0.7,'FilterSize',[7,7]);

 		for y =1:height
 			for x=1:width
 				M=[Sx2(y,x) Sxy(y,x);
 				   Sxy(y,x) Sy2(y,x);];
 				R(y,x)=det(M)/trace(M);
 			end
 		end

 		ImgBlur=imgaussfilt(Img,4.5);
 		[Gx,Gy]=imgradientxy(ImgBlur); %return directional gradients
 		[magnitude,direction]=imgradient(Gx,Gy);
 		r=6;
 		for i=1:height
 			for j=1:width
 				if Height<i*scale || Width<j*scale
 					continue;
 				end
 				if R(i,j)>=10.0
 					stop=0;
 					for y=i-r:i+r
 						if stop==1
 							break;
 						end
 						for x=j-r:j+r
 							if stop==1
 								break
 							end
 							if x<1||x>width||y<1||y>height||(x==j&&y==i)
 								continue;
 							elseif R(i,j)<R(y,x)
 								stop=1;
 							end
 						end
 					end
 					for y=i-r*scale:i+r*scale
 						if stop==1 
 							break;
 						end
 						for x=j-r*scale:j+r*scale
 							if stop==1
 								break;
 							end
 							if x<1||x>Width||y<1||y>Height||(x==j&&y==i)
 								continue;
 							end
 							if imgs(y,x,1,count)==255
 								stop=1;
 							end
 						end
 					end
 					window_feature=zeros(40,40); %find a 40*40 feature window_feature
 					if stop==0
 						dy=sin(direction(i,j) ./ 180.0 *pi);
 						sy=int16(i-20*dy);
 						dx=cos(direction(i,j) ./ 180.0 *pi);
 						sx=int16(j-20*dx);
 						for y=1:40
 							if stop==1
 								break
 							end
 							for x=1:40
 								newY=int16(sy+y*dy);
 								newX=int16(sx+x*dx);
 								if newY<1||newY>height||newX<1||newX>width
 									stop=1;
 									break;
 								end
 								window_feature(y,x)=Img(newY,newX);
 							end
 						end
 					end
 					real_window=zeros(8,8);
 					if stop==0
 						for y=1:8
 							for x=1:8
 								mean=0.0;
 								Sy=(y-1)*5;
 								Sx=(x-1)*5;
 								for k=Sy+1:Sy+5
 									for l=Sx+1:Sx+5
 										mean=mean+window_feature(k,l);
 									end
 								end
 								mean=mean ./ 25.0;
 								real_window(y,x)=mean;
 							end
 						end
 						real_window=transpose(H)*real_window*H;
 						imgs(i*scale,j*scale,1,count)=255;
 						imgs(i*scale,j*scale,2,count)=0;
 						imgs(i*scale,j*scale,3,count)=0;
 						count_features(count)=count_features(count)+1;
 						features(count,count_features(count),1)=i*scale;
 						features(count,count_features(count),2)=j*scale;
 						for y=1:8
 							for x=1:8
 								features(count,count_features(count),(y-1)*8+x+2)=real_window(y,x);
 							end
 						end
 					end
 				end
 			end
 		end
 		Img=impyramid(Img,'reduce'); %reduce to 0.5 times
 	end
 	total=0;
 	fil=zeros(Height,Width);
 	for y=1:Height
 		for x=1:Width
 			if imgs(y,x,3,count)==0&&imgs(y,x,2,count)==0&&imgs(y,x,1,count)==255
 				total=total+1; %計算總共有多少個特徵點
 				fil(y,x)=1;
 			end
 		end
 	end
 	for y=1:Height
 		for x=1:Width
 			if fil(y,x)==1
 				for i=y-1:y+1
 					for j=x-1:x+1
 						if j<1||j>Width||i<1||i>Height
 							continue;
 						end
 						imgs(i,j,3,count)=0;
 						imgs(i,j,2,count)=0;
 						imgs(i,j,1,count)=255;
 					end
 				end
 			end
 		end
 	end
end
end
