function [P_List, V_List, maxX, maxY] = field_analysis(path, filePrefix, info, threshold, debug, pauseDuration, brightParticle)
    % debug = 1, show location and analysis
    % debug = 2, also show trail and label
    % resulted data structure
    %  P0 {}
    %  P1 V1
    %  ...
    %  PN V1
    %
    % the vector field should be P(i) + V(i+1)
    % If particles are bright and plate is dark --> brightParticle = 1
    % If particles are dark and plate is bright --> brightParticle = 0
    addpath(path);
    
    numberOfRep = 1;
    found = 1;
    while found
        framePrefix = strcat(path, filePrefix, num2str(numberOfRep), '_');
        fileList = strcat(framePrefix, '*');
        fileInfo = dir(fileList);
        if isempty(fileInfo)
           found = 0;
        else
            numberOfRep = numberOfRep + 1;
        end
    end
    
    P_List = {}; % list of positions of each frame
    V_List = {}; % list of velocity vector of particles
    %threshold = 50;
    
    if info tic; end;

    if (numberOfRep > 1)
        for k = 1:numberOfRep

            framePrefix = strcat(path, filePrefix, num2str(k), '_');
            fileList = strcat(framePrefix, '*');
            fileInfo = dir(fileList);
            numberOfFrames = length(fileInfo);

            prevP = [];  % previous positions of particles

            trail = {};
            label = [];
            prevFrame = [];

            if info fprintf('\n calculating frame '); end;
            for i = 1:numberOfFrames

                if info fprintf('%d ', i); end;
                s = strcat(framePrefix, num2str(i-1), '.bmp');

                currentFrame = rgb2gray(imread(s));
                [maxX, maxY] = size(currentFrame);
                objP = calculateblobs(currentFrame,brightParticle);

                if debug 
                    currentFrame = imadjust(currentFrame, [0.2 1], []);
                    if ~isempty(prevFrame)
                        I = uint8([]);
                        I(:,:,1) = prevFrame;
                        I(:,:,2) = currentFrame;
                        I(:,:,3) = currentFrame;
                        imshow(I); 
                    else
                        imshow(currentFrame);
                    end
                    hold on; 
                    prevFrame = currentFrame;
                end;

                if (~isempty(prevP))

                    [P, V] = calculateMovement(prevP,objP,threshold, debug);
                    V_List{k,i} = V;
                    P_List{k,i} = P;
                    prevP = P;
                else
                    P_List{k,i} = objP;
                    prevP = objP;
                end

                if debug 
                    if debug == 2 trail = PlotTrail(trail, P_List{k,:}, i); end;
                    if debug == 2 label = DrawLabel(label, P_List{k,:}, i); end;
                    pause(pauseDuration); 
                end;
            end
        end
    else
        error(['no data found for ' framePrefix '*']);
    end

    if info fprintf('\n'); end;
    if info disp(toc); end;
end 

function trail = PlotTrail(trail, P_List, idx)
    if (idx > 1)
        for i = 1:length(P_List{idx})
            if i > length(trail)
                trail{i} = P_List{idx}(i,:);
            else
                trail{i} = [trail{i}; P_List{idx}(i,:)];
            end
            if isnan(P_List{idx}(i,1))                     
                plot(trail{i}(:,1),trail{i}(:,2),'r-');
            else
                plot(trail{i}(:,1),trail{i}(:,2),'b-'); 
            end
        end
    else  
        for i = 1:length(P_List{idx})
            trail{i} = P_List{idx}(i,:);
        end
    end 
end

function label = DrawLabel(label, P_List,idx)
    currentP = P_List{idx};
    if idx == 1
        label = currentP;
    else
        nanList = find(isnan(currentP(:,1)));
        if ~isempty(nanList)
           currentP(nanList, :) = label(nanList, :);
        end
        label = currentP;
    end
    for j = 1:length(currentP)               
        text(currentP(j,1)+5,currentP(j,2)-10, num2str(j));
    end
end
