function getPerformanceProfiles_invokeCubic(time,iters,status,inCubic)

mask = inCubic(:,1) == 1 & inCubic(:,2) == 1;
if sum(mask) == 0
    return
else
    ratios_time = getRatio(time(mask,1:2),status); %compute ratio for performance profile
    ratios_iters = getRatio(iters(mask,1:2),status);%exclude admm from iterations pp
    
    
    ppIters_cgNoCubic = performanceProf(ratios_iters(:,1));
    ppIters_cgCubic = performanceProf(ratios_iters(:,2));
    
    ppTime_cgNoCubic = performanceProf(ratios_time(:,1));
    ppTime_cgCubic = performanceProf(ratios_time(:,2));
    
    figure
    title("Performance Profile: Time - Invoked Cubic",'fontsize',18)
    xlabel("Tau",'fontsize',16)
    ylabel("Probability",'fontsize',16)
    hold on
    plot(ppTime_cgNoCubic(:,1),ppTime_cgNoCubic(:,2),'*-','markersize',8,'LineWidth',2)
    plot(ppTime_cgCubic(:,1),ppTime_cgCubic(:,2),'*-','markersize',8,'LineWidth',2)
    legend({'CG without Cubic Reg','CG with Cubic Reg'},'location','southeast','fontsize',14)
    
    ylim([0,1])
    
    
    figure
    title("Performance Profile: Iterations - Invoked Cubic",'fontsize',18)
    xlabel("Tau",'fontsize',16)
    ylabel("Probability",'fontsize',16)
    hold on
    plot(ppIters_cgNoCubic(:,1),ppIters_cgNoCubic(:,2),'*-','markersize',8,'LineWidth',2)
    plot(ppIters_cgCubic(:,1),ppIters_cgCubic(:,2),'*-','markersize',8,'LineWidth',2)
    legend({'CG without Cubic Reg','CG with Cubic Reg'},'location','southeast','fontsize',14)
    ylim([0,1.05])
    
end
end

function ratios = getRatio(vec, status)
best = min(vec,[],2);
ratios = vec./best; %compute ratios
ratios(status ~= 0) = NaN; %if it doesn't solve, set ratio to nan

end

function performanceData = performanceProf(ratios) %compute performance prof
ratio = sort(ratios);
uniqueVals = unique(ratio);
counts=[];
for i=1:length(uniqueVals)
    counts(i) = sum(ratio == uniqueVals(i));
end
probs = [];
taus = [];
prob = 0;
for j=1:length(counts)
    prob = prob + counts(j)/length(ratio);
    probs(j) = prob;
    taus(j) = uniqueVals(j);
end
performanceData = [taus;probs]';
end

