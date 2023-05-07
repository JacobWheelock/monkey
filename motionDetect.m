videoSource = VideoReader("testVidCut.MP4");
edgeMask = [0 -1 0; -1 4 -1; 0 -1 0];
tic
detector = vision.ForegroundDetector('NumTrainingFrames', 15, ... 
           'MinimumBackgroundRatio', 0.40, 'LearningRate', 0.005, ...
           'NumGaussians', 4);

blob = vision.BlobAnalysis(...
       'CentroidOutputPort', false, 'AreaOutputPort', true, ...
       'BoundingBoxOutputPort', true, ...
       'MinimumBlobAreaSource', 'Property', 'MinimumBlobArea', 2000, ...
       'MaximumCount', 1);
shapeInserter = vision.ShapeInserter('BorderColor','White');

frameCount = 0;

totalFrames = ceil(videoSource.Duration * 30);
areaScoreVec = zeros(videoSource.NumFrames, 1);
hasArea = zeros(totalFrames,1);
intervals = zeros(ceil(totalFrames/2));
lengths = zeros(totalFrames,1);
i = 0; j = 0; inter = false;

videoPlayer = vision.VideoPlayer('Position', get(0,'screensize'));
while hasFrame(videoSource)
     frameCount = frameCount + 1;
     frame  = readFrame(videoSource);
     fgMask = detector(frame);
     [area, bbox]   = blob(fgMask);
    
  
     hasArea(frameCount) = ~isempty(area);
     if (hasArea(frameCount)) 
        areaScoreVec(frameCount) = area;
     end
     if (~isempty(area))
         if (inter == false && hasArea(frameCount -1) == 1)
            i = i + 1; j = j + 2;
            lengthCounter = 2;
            intervals(i,j) = frameCount;
            intervals(i,j-1) = frameCount - 1;
            inter = true;
         elseif (inter == true && hasArea(frameCount -1) == 1)
            j = j + 1;
            lengthCounter = lengthCounter + 1;
            intervals(i,j) = frameCount;
         end
     else
         if (inter == true)
            inter = false;
            lengths(i) = lengthCounter;
            j = 0;
         end
     end
     out = shapeInserter(frame,bbox);
     videoPlayer(out);

end
lengths(i) = lengthCounter;
release(videoPlayer);
toc
%%
t = (1:560)' * (1/30);
intervals(i+1:end,:) = [];

startEnd = zeros(i,2);

for k = 1:i
    startEnd(k,1) = intervals(k,1);
    startEnd(k,2) = intervals(k,lengths(k));
end

startEndComb = zeros(1, 2*i);
counter = 1;
for k = 1:height(startEnd)
    startEndComb(1,counter:counter+1) = startEnd(k,:);
    counter = counter+2;
end
k = 2;
while k < length(startEndComb) 
    if (startEndComb(k+1) - startEndComb(k) <= 60)
        startEndComb(k:k+1) = [];
    end
    k = k+2; 
end

scoreMat = zeros(videoSource.NumFrames, 1);

    
for k = startEndComb(1):startEndComb(end)
    frameTemp = rgb2gray(read(videoSource, k));
    scoreMat(k) = sum(sum(conv2(frameTemp, edgeMask, 'same')));
end
startEndSecs = startEndComb * (1/30);

[topSharpVal, topSharpInd] = sort(scoreMat, 'descend');
[topAreaVal, topAreaInd] = sort(areaScoreVec, 'descend');

figure;
imshow(read(videoSource, topSharpInd(1)));
figure;
imshow(read(videoSource, topSharpInd(2)));
figure;
imshow(read(videoSource, topSharpInd(3)));
figure;
imshow(read(videoSource, topAreaInd(1)));
figure;
imshow(read(videoSource, topAreaInd(2)));
figure;
imshow(read(videoSource, topAreaInd(3)));
display(startEndSecs);






