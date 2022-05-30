coins = imread('c1.jpg'); % Read the input image
I = coins;
%figure,imshow(I), title('input image');

gray = im2gray(coins); % Convert color image to grayscale
ThresholdValue = 140; % Certain threshold value
bw = gray > ThresholdValue; 
%figure, imshow(bw), title('after threshold');

canny = edge(bw, 'canny',0.3); % Canny edge detection to get binary edges
%figure, imshow(canny), title('after canny');   

se = strel('disk',2);
dilate = imdilate(canny,se);
%figure, imshow(dilate), title('after imdilate');

fill = imfill(dilate, 'holes'); % Dilate the edges information
%figure, imshow(fill), title('after imfill');



% Get properties
prop = regionprops(fill, {'Area', 'Centroid','MajorAxisLength','MinorAxisLength'});

% Return the properties in a table
prop = struct2table(prop);

figure;imshow(coins);
Ten = 0;
Five = 0;
Other = 0;
for i=1:numel(prop.Area(:,1))
   diameter = mean([prop.MajorAxisLength prop.MinorAxisLength],2);
   radius = diameter/2;
   if prop.Area(i)<1000;
       continue;
   elseif prop.Area(i)>350000;
       coins = insertShape(coins,'circle',[prop.Centroid(i,1) prop.Centroid(i,2) radius(i)],'LineWidth',40,'color','yellow');
       coins = insertText(coins, [prop.Centroid(i,1)-30 prop.Centroid(i,2)-20],'10','BoxOpacity',0.0,'TextColor','green','FontSize',150);
       Ten = Ten+1;
   elseif prop.Area(i)>290000;
       coins = insertShape(coins,'circle',[prop.Centroid(i,1) prop.Centroid(i,2) radius(i)],'LineWidth',35,'color','blue');
       coins = insertText(coins, [prop.Centroid(i,1)-30 prop.Centroid(i,2)-20],'5','BoxOpacity',0.0,'TextColor','green','FontSize',150);
       Five = Five+1;
   else
       coins = insertShape(coins,'circle',[prop.Centroid(i,1) prop.Centroid(i,2) radius(i)],'LineWidth',30,'color','magenta');
       coins = insertText(coins, [prop.Centroid(i,1)-30 prop.Centroid(i,2)-20],'O','BoxOpacity',0.0,'TextColor','green','FontSize',145);
       Other = Other+1;
   end
   imshow(coins);
   title(['10 Baht = ',num2str(Ten), ',  5 Baht = ', num2str(Five), ',  Other = ', num2str(Other)]);
   pause(1);
end

% Show all results of each step together
figure;
subplot(231),imshow(I), title('input image');
subplot(232), imshow(bw), title('after threshold');
subplot(233), imshow(canny), title('after canny');
subplot(234), imshow(dilate), title('after imdilate');
subplot(235), imshow(fill), title('after imfill');
subplot(236), imshow(coins), title('result');
