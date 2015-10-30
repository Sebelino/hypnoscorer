function multievaler
    records = {
    '200001'
    '200002'
    '200003'
    '200004'
    '200005'
    '200006'
    '200007'
    '200008'
    '200009'
    '200010'
    }';
    runs = 3;
    for i = 1:runs
        for r = records
            evaler(r{:},[r{:},'-',num2str(i),'-lin'],'linear')
            evaler(r{:},[r{:},'-',num2str(i),'-rbf'],'rbf')
        end
    end
end
