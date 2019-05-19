function [pair,total]=match(imgs,features,points)

Height=size(imgs,1);
Width=size(imgs,2);
num=size(imgs,4);
pair=zeros(num,num,600,4); %第a張照片對第b張的pair
total=zeros(num,num);
for count=1:num-1
	nowFeatures=features(count,:,:);
	nowSize=points(count); %size(nowFeatures,2);
	
	%% 窮舉每一張圖來找最合適的配對
	for pic=count+1:num
		nextFeature=features(pic,:,:);
		nextSize=points(pic); %size(nextFeature,2);
		%total=0;
		for p =1:nowSize
			bestN=-1;
			MinerrN=10^15; %最小err值
			for n=1:nextSize
				%加入restriction term, 如果距離>15就直接不處理
				if abs(nowFeatures(1,p,1)-nextFeature(1,n,1))>15
					continue;
				end
				
				tmp=sum((nowFeatures(1,p,3:66)-nextFeature(1,n,3:66)) .^2);
				if MinerrN>tmp %如果最小err比現今err大，更新最小err
					bestN=n;
					MinerrN=tmp;
				end
			end
			
			if bestN==-1 %沒有更新到Minerr,跳過此次處理
				continue;
			end
			bestP=-1;
			MinerrP=10^15;
			for pp=1:nowSize   %double check,要兩邊都符合標準才能算合理的pair
				if abs(nowFeatures(1,pp,1)-nextFeature(1,bestN,1))>15
					continue;
				end
				
				tmp=sum((nowFeatures(1,pp,3:66)-nextFeature(1,bestN,3:66)) .^2);
				if MinerrP>tmp
					bestP=pp;
					MinerrP=tmp;
				end
			end
			if bestP==p
				total(count,pic)=total(count,pic)+1;
				pair(count,pic,total(count,pic),1)=nowFeatures(1,bestP,1);
				pair(count,pic,total(count,pic),2)=nowFeatures(1,bestP,2);
				pair(count,pic,total(count,pic),3)=nextFeature(1,bestN,1);
				pair(count,pic,total(count,pic),4)=nextFeature(1,bestN,2);
			end
			
		end
		%total %總共match的數量
	end
end
end
