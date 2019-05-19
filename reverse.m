function []=reverse()
path =num2str(input('input desire folder(0~5):'));
Img=dir(fullfile(path,'*.jpg'));

Image=readImg(Img,path,1);
num=size(Image,4);
for i=1:num
	imwrite(Image(:,:,:,i),[num2str(path) '/' num2str(path) '/' num2str(num-i) '.jpg']);
end