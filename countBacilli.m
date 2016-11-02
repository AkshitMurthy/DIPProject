function [count1,count2] = countBacilli(folder)

%counting bacilli for each image
cd(folder);
count1=0;
count2=0;
contents = dir('*.jpg'); % or whatever the filename extension is
for i = 1:numel(contents)
  filename = contents(i).name;
  im=imread(filename);
  % Open the file specified in filename, do your processing...
  cd ..
  count1=count1+convexHull(im);
  count2=count2+test(im);
  cd(folder);
end
disp('Number of bacilli:');
disp('According to algo suggested:');
disp(count1);
disp('According our algo:');
disp(count2);

end

