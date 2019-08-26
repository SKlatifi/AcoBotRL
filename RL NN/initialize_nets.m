function nets = initialize_nets(num_of_notes)
    
    for note = 1:num_of_notes
        % Create a Fitting Network
        hiddenLayerSize = 7;    
        net = fitnet(hiddenLayerSize);

        % Set up Division of Data for Training, Validation, Testing
        net.divideParam.trainRatio = 1;
        net.divideParam.valRatio = 0;
        net.divideParam.testRatio = 0;

        % Don't pop up NN window
        net.trainParam.showWindow = 0;
        nets(note).net = net;
    end

end