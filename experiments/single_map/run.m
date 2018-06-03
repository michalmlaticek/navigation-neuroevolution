function run()
    cdHere();
    addpath dist_collis
    runEvolution();
    cdHere()
    rmpath dist_collis
    
    addpath dist_collis_path
    runEvolution();
    cdHere()
    rmpath dist_collis_path
    
    addpath distsum_collis
    runEvolution();
    cdHere()
    rmpath distsum_collis
end

function cdHere()
    file_path = mfilename('fullpath');
    idx = strfind(file_path, '\');
    folder_path = file_path(1:idx(end));
    cd(folder_path);
end
