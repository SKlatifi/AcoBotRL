function trail = PlotTrail(trail, P_List, rep, idx, draw)

    drawing = 1;
    if nargin == 5
        drawing = draw;
    end
    if (idx > 1)
        for i = 1:length(P_List{rep,idx})
            if i > length(trail)
                trail{i} = P_List{rep,idx}(i,:);
            else
                trail{i} = [trail{i}; P_List{rep,idx}(i,:)];
            end
            if drawing
                if isnan(P_List{rep,idx}(i,1))                     
                    plot(trail{i}(:,1),trail{i}(:,2),'m-');hold on;
                else
                    plot(trail{i}(:,1),trail{i}(:,2),'c-'); hold on;
                end
            end
        end
    else  
        for i = 1:length(P_List{rep,idx})
            trail{i} = P_List{rep,idx}(i,:);
        end
    end 
end