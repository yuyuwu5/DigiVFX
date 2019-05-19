function []=main()
path =num2str(input('input desire folder(0~5):'));
Img=dir(fullfile(path,'*.jpg'));

%scale=input('desired scale to smaller pictures to fast up read image');
scale=1;

Image=readImg(Img,path,scale);


newPhoto=warp(Image); %將xy座標投影到圓柱座標
[features,points]=msop(newPhoto);
[pair,pair_num]=match(newPhoto,features,points);


[offset,matching,outlier]=ransac(newPhoto,pair,pair_num);

[new_orderImg,corrOff]=recognize(newPhoto,offset,matching,outlier);


%corrOff

blending(new_orderImg,corrOff);

end
