function ga_performance()
    fgga = @()gga();
    fga_stu = @()stu_ga();
    
    timeit(fgga)
    
    timeit(fga_stu)
end


function gga()
sumx = @(x)sum(x); % objective
initpop = randn(150, 35);
opts = optimoptions('ga','InitialPopulationMatrix',initpop,...
    'MaxGenerations', 2000, ...
    'SelectionFcn',{@selectiontournament,30}, ...
    'EliteCount', 5);
[xga,fga,flga,oga] = ga(sumx,35,[],[],[],[],[],[],[],opts);
end


function stu_ga()
    M = 1;
    space=[-M*ones(1,35); M*ones(1,35)];  % working space
    sigma=space(2,:)/50; %mutation working space
    Pop = randn(150, 35);
    for i = 1:2000
       Fit = sum(Pop, 2);
       BestGenome=selbest(Pop,Fit',[1,1,1,1,1]);
       Old=seltourn(Pop,Fit',15);
       Work1=selsus(Pop,Fit',30);
       Work2=seltourn(Pop,Fit',50);
       Work3=seltourn(Pop,Fit',50);
       Work1=crossov(Work1,1,0);
       Work2=muta(Work2,0.2,sigma,space);
       Work3=mutx(Work3,0.2,space);
       Pop=[BestGenome;Old;Work1;Work2;Work3];
    end
end

