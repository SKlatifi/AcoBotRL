function PlotTail(P_List, mark)
    for j = 1 : length(P_List{mark})
        X = []; Y = []; X1 = []; Y1 = [];
        lostP = 0;
        for k = mark:-1:2
            if j > size(P_List{k-1},1)
                break;
            end

            if ~isnan(P_List{k}(j,1)) && ~isnan(P_List{k-1}(j,1))
               if ~lostP 
                    X = [X; P_List{k-1}(j,1), P_List{k}(j,1)];
                    Y = [Y; P_List{k-1}(j,2), P_List{k}(j,2)];   
               else
                    X1 = [X1; P_List{k-1}(j,1), P_List{k}(j,1)];
                    Y1 = [Y1; P_List{k-1}(j,2), P_List{k}(j,2)];  
               end
            else
                lostP = 1;
            end
        end
        if ~isempty(X)
            plot(X,Y,'b:');
        end
        if ~isempty(X1)
            plot(X1,Y1,'r:');
        end
    end
end

