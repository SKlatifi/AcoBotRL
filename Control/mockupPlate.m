function ret = mockupPlate(numParticles)
    ret = struct('play',@play,'findParticles',@findParticles,'getClicks',@getClicks,'visualize',@visualize);        
    p = rand(numParticles,2) * 0.8 + 0.1;
    
    function visualize(p,phat,t)
        figure(1);                        
        hold off;        
        plot(p(:,1),p(:,2),'kd');
        hold on;        
        plot([p(:,1) phat(:,1)]',[p(:,2) phat(:,2)]','b-');        
        plot(t(:,1),t(:,2),'g*');
        hold off;        
        axis([0 1 0 1]);
    end
    
    function play(params)      
        freq = params(1) / 1000;
        amplitude = params(2);
        duration = params(3) / 2;
        d = sin(freq * p) .* cos(freq * p); 
        p = p + 0.03 * d * amplitude * duration + randn(size(p)) * 0.005;        
        pause(1e-6);
    end

    function ret = findParticles()
        ret = p;
    end

    function ret = getClicks()
        ret = p;
    end
end