videoSource = VideoReader("testVidCut.MP4");

detector = vision.ForegroundDetector('NumTrainingFrames', 150, 'MinimumBackgroundRatio', 0.1);

blob = vision.BlobAnalysis(...
       'CentroidOutputPort', false, 'AreaOutputPort', false, ...
       'BoundingBoxOutputPort', true, ...
       'MinimumBlobAreaSource', 'Property', 'MinimumBlobArea', 2000, 'MaximumCount', 2);
shapeInserter = vision.ShapeInserter('BorderColor','White');

videoPlayer = vision.VideoPlayer();
while hasFrame(videoSource)
     frame  = readFrame(videoSource);
     fgMask = detector(frame);
     bbox   = blob(fgMask);
     out    = shapeInserter(frame,bbox);
     videoPlayer(out);
     %pause(0.1);
end

release(videoPlayer);