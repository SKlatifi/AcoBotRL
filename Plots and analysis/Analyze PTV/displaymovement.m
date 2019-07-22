function displaymovement(imgPath, filePath, filePrefix, LABEL, TRAIL,pauseDuration)
    addpath(imgPath);
    
    filename = strcat([filePath, filePrefix], '.mat');
    load(filename);
    %LABEL = 1;
    %TAIL = 1;
    %pauseDuration = 0;
    
    numberOfReps = size(V_List,1);
    numberOfFrames = size(V_List,2);
    
    for i = 1:numberOfReps
        trail = {};
        label = [];
        
        f = figure(i);
        set(f, 'Position', [100, 100, 700, 700]);                
        
        for j = 1 : numberOfFrames
            clf;
            axes('position', [0 0 1 1]);
            set(gca, 'YDir', 'reverse');
            set(gca,'xtick',[])
            set(gca,'xticklabel',[])
            set(gca,'ytick',[])
            set(gca,'yticklabel',[])            
            axis([0 maxX 0 maxY] + 0.5);
            box off;
            set(gca,'linewidth',2);
            
            s = strcat(filePrefix, num2str(i), '_', num2str(j-1), '.bmp');
            imshow(255 - imread(s)); hold on;
            title(strrep([filePrefix num2str(i) '_', num2str(j-1)], 'd_', ', ')); hold on;            
            hold on;
            
            if TRAIL
                trail = PlotTrail(trail, P_List, i, j);
            end
            
            %h1 = plot(P_List{i,1}(:,1),P_List{i,1}(:,2),'bs','MarkerSize',4),hold on;
            %h2 = plot(P_List{i,j}(:,1),P_List{i,j}(:,2),'r+','MarkerSize',12,'LineWidth',1.3);
            hold on;

            %legend([h1,h2],{'Start','End'},'Location','NorthWest');
            %legend('boxoff');
            
            if LABEL
                label = DrawLabel(label, P_List, i, j);
            end            
            hold off
            pause(pauseDuration);
        end       
        savefig([filePath filePrefix num2str(i) '.fig']);
        export_fig([filePath filePrefix num2str(i) '.pdf']);
    end
end 

function trail = PlotTrail(trail, P_List, rep, idx)
    if (idx > 1)
        for i = 1:length(P_List{rep,idx})
            if i > length(trail)
                trail{i} = P_List{rep,idx}(i,:);
            else
                trail{i} = [trail{i}; P_List{rep,idx}(i,:)];
            end
            %if isnan(P_List{rep,idx}(i,1))                     
            %    plot(trail{i}(:,1),trail{i}(:,2),'r-');
            %else
            
            % from http://www.mathworks.com/matlabcentral/answers/5042-how-do-i-vary-color-along-a-2d-line
            a = any(isnan(trail{i}),2);
            x = trail{i}(~a,1)';
            y = trail{i}(~a,2)';
            if (isempty(x) || isempty(y) || size(x,2) < 2)
                continue;
            end                       
            %z = zeros(size(x));
            %col = linspace(0,1,size(x,2));  % This is the color, vary with x in this case.                        
            %cline(x,y,col,'hot');
            plot(x,y,'b-','LineWidth',1.3); 
            %end
        end
        colormap hot;
    else  
        for i = 1:length(P_List{rep,idx})
            trail{i} = P_List{rep,idx}(i,:);
        end
    end 
end

function label = DrawLabel(label, P_List, rep, idx)
    currentP = P_List{rep,idx};
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
