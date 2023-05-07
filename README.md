# monkey
Monkey Project Repo
for ANTHRO 3656 which aims to sample given video clips of wildlife speicies to produce optimal still-images for continued AI analysis. A short demo of the script can be found at https://youtu.be/z4mLnAX4LlE

How to use: motionDetect.m is the main script. 
1. Enter in the desired video to be analyzed in quotes on line 1, e.g.,
  videoSource = VideoReader("[ENTER VIDEO NAME HERE]");
  Note that you may have to enter in the file path, or just dump the video file into the directory containing the script.
2. Hit run
3. Output will be a vector of frames/times of when a subject is predicted to be in frame, as well as the top 3 area and sharpness images.
 
