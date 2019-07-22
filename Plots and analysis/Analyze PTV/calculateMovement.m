function [sortedP,velField] = calculateMovement(T,P, threshold, debug)

    DEBUG = 0;
    if nargin >3
        DEBUG = debug;
    end
   
    if (~isempty(T))
        
        iPr = 1:1:size(P,1);
        iTr = find(~isnan(T(:,1)));
        TP_Map = zeros(size(T,1),1);
        Dist = zeros(size(T,1),1);
                
        while ~isempty(iTr) && ~isempty(iPr)
            [TP_Map2, Dist2, iiPr, iiTr] = FindMapping(P(iPr,:), T(iTr,:), debug);
            
            iiT = setdiff(1:1:size(iTr,1),iiTr);% get the index of iT in iTr
            
            if ~isempty(iiT)            
                iT = iTr(iiT);
                TP_Map(iT) = iPr(TP_Map2(iiT)); % copy the found results in the
                Dist(iT) = Dist2(iiT);          % subset search to the full results
                
                iTr(iiT) = [];                  % removed the found T indecies
                
                if ~isempty(iiPr) %&& (max(iiPr) <= length(iPr))
                    iPr = iPr(iiPr);            % remove the matched indecies of P
                else
                    iPr = [];
                end
            end
        end
            
        velField = [];
        sortedP = [];
        
        for i = 1:size(T,1)         
             if (Dist(i) < threshold) && TP_Map(i) ~= 0                
                sortedP(i,:) = P(TP_Map(i),:);
                velField(i,:) = P(TP_Map(i),:) - T(i,:);
             else
                sortedP(i,:) = [nan, nan];
                velField(i,:) = [0, 0];
                if TP_Map(i) ~= 0
                    if DEBUG plot ((P(TP_Map(i),1)+T(i,1))/2,(P(TP_Map(i),2)+T(i,2))/2,'rX'); hold on; end; % indicate a link is not accepted                       
                    iPr = [iPr TP_Map(i)];                                    
                end
                if DEBUG plot(T(i,1),T(i,2),'mO'); hold on; end;
             end
        end
        
        if ~isempty(iPr) % more objects in the current frame
            sortedP = [sortedP; P(iPr,:)];
            if DEBUG plot(P(iPr,1),P(iPr,2),'cO'); hold on; end;
        end
    else
        display('Error: empty previous frame')
    end   
end


function [uniqueIDX, dupIDX, dupBin] = SeperateMapping(Mapping)
% return the index of Mapping that are unique, duplicated, and a cell array of binned index of
% duplication of IDX
    dupBin = [];
    [n, bin] = histc(Mapping, unique(Mapping));
    uniques = find(n == 1);
    uniqueIDX  = find(ismember(bin, uniques));
    %dupIDX = setdiff(1:1:length(IDX),uniqueIDX); 
    multiple = find(n > 1);
    dupIDX = find(ismember(bin, multiple));
    for i=1:size(multiple,1)
        dupBin{i}  = find(ismember(bin, multiple(i)));
    end
end

function m = RemoveByValue(m, v)
    if ~isempty(v)
        x = find(m == v);
        m(x) = [];
    end
end

function [rIdx, remain] = GetRest(A, idx)
    rIdx = setdiff(1:1:size(A,1),idx);
    remain = A(rIdx);
end

function plotpairs(x1, y1, x2, y2, c1, c2)
    plot(x1,y1,c1); hold on;
    plot(x2,y2,c2); hold on;
    for i=1:size(x1,1)
        line([x1(i,:); x2(i,:)],[y1(i,:); y2(i,:)]); hold on;
    end
end

function [TP_Map, Dist, iPr, iTr] = FindMapping(P, T, debug)
    
    DEBUG = 0;
    if nargin >2
        DEBUG = debug;
    end
    
    iPr = [];
    iTr = [];
    
    [TP_Map, Dist] = knnsearch(P, T);

    [iUnique, iDup, dupBin] = SeperateMapping(TP_Map); % return value are index of P_Map

    if DEBUG x1 = T(iUnique,1); y1 = T(iUnique,2); end;
    if DEBUG x2 = P(TP_Map(iUnique),1); y2 = P(TP_Map(iUnique),2); end;
    if DEBUG plotpairs(x1,y1, x2,y2,'bx','g+'); hold on; end;
    
    if (~isempty(iDup))
        % remove the unique blobs from P, we get the remain index
        % of those values in the P
        iPr = GetRest(P, TP_Map(iUnique));
        
        % find the blob with the nearest distance for each duplicated case
        for i = 1:size(dupBin,1)
            [v, idx] = min(Dist(dupBin{i}));  %find the index of the point with smallest distance
            
            iMin = dupBin{i}(idx);
            
            if DEBUG x1 = T(iMin,1); y1 = T(iMin,2); end;
            if DEBUG x2 = P(TP_Map(iMin),1); y2 = P(TP_Map(iMin),2); end;
            if DEBUG plotpairs(x1,y1, x2,y2,'bx','g+'); hold on; end;

            iPr = RemoveByValue(iPr, TP_Map(iMin)); % remove the iP corresponding to idxMin
            
            dupBin{i}(idx) = [];
        end
        
        iTr = vertcat(dupBin{:})';
        
        TP_Map(iTr) = 0;
    end
end
