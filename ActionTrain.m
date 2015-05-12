 clear,clc;
 disp('---------start train-----------')
 disp('train......')
 train_files = {  'D:/Database/run/daria_run.avi'...
                 'D:/Database/run/denis_run.avi'...
                 'D:/Database/run/eli_run.avi'...
                'D:/Database/walk/daria_walk.avi'...
                 'D:/Database/walk/denis_walk.avi'...
                 'D:/Database/walk/eli_walk.avi'...
                'D:/Database/jump/daria_jump.avi'...
                 'D:/Database/jump/denis_jump.avi'...
                 'D:/Database/jump/eli_jump.avi'...
                'D:/Database/bend/daria_bend.avi'...
                 'D:/Database/bend/denis_bend.avi'...
                 'D:/Database/bend/eli_bend.avi'...
                 };
        
trans = [1];
emis = zeros(1, 11) + 1/11;

for i = 1 : length(train_files)
   video = read_avi_data(cell2mat(train_files(i)));
   x = tracking(video);
   [m, n] = size(x);
   for j = 1 : m
        [~, tmpEstE] = hmmtrain(x(j, :), trans, emis);
        estE(i, j, :) = tmpEstE;
   end
end
 
 save mat estE;
 
 disp('---------train over-----------')