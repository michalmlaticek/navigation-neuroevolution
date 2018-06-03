function pop = myGenPopCb(old_pop, fits, settings, my_state)
    old_pop = old_pop';
    fits = fits';
    M = 1;
    space = [-M*ones(1,150); M*ones(1,150)];  % working space
    sigma = space(2,:)/50; %mutation working space
    best_genome=selbest(old_pop,fits,[1,1,1,1,1]);
    old=seltourn(old_pop,fits,15);
    work1=selsus(old_pop,fits,30);
    work2=seltourn(old_pop,fits,50);
    work3=seltourn(old_pop, fits, 50);
    work1=crossov(work1,1,0);
    work2=muta(work2,0.2,sigma,space);
    work3=mutx(work3,0.2,space);
    pop=[best_genome;old;work1;work2;work3];
    pop = pop';
    
    my_state.pop = pop;
end