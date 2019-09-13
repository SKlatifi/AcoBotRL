
tempDataPath = getTempDataPath();  
videoPath = strcat(tempDataPath,'video_analysis\');
vidObj = VideoReader(strcat(videoPath,'double_10000.wmv'));
numFrames = 0;
while hasFrame(vidObj)
    readFrame(vidObj);
    numFrames = numFrames + 1
end