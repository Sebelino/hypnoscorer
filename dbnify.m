% Adapted from Martin Längkvist's code: http://aass.oru.se/~mlt/sleep.zip

function newfeaturespace = dbnify(featurespace)
    addpath('lib/DBNToolbox/lib/')

    data = featurespace.matrix();
    data = data-repmat(min(data),size(data,1),1);
    data = data./repmat(max(data),size(data,1),1);

    % Partition feature space into training and validation subspaces
    k = randperm(size(data,1));
    traindata = data(k(1:floor(size(data,1)*5/6)),:);
    valdata = data(k(floor(size(data,1)*5/6)+1:end),:);

    layerSize = [5]; % Hidden layer sizes

    rbmParams.numEpochs = 50;
    rbmParams.verbosity = 1;
    rbmParams.miniBatchSize = 1000;
    rbmParams.attemptLoad = 0;
    dbnParams.numEpochs = 10;
    dbnParams.verbosity = 1;
    dbnParams.miniBatchSize = 1000;
    dbnParams.attemptLoad = 0;

    disp('Unsupervised pre-training...');
    nnLayers = GreedyLayerTrain(traindata, valdata, layerSize, 'RBM', rbmParams);
    dnn = DeepNN(nnLayers, dbnParams);
    disp('Unsupervised backprop...');
    dnn.Train(traindata, valdata);
    disp('DBN training finished.');

    % Inference on train data
    [~,layerActivs] = dnn.PropLayerActivs(data);
    topLayerActivs = layerActivs{numel(layerSize)};

    % This garbage appears after using the DBNToolbox functions
    delete dnn.dnn_obj.mat nnl.*.rbm_obj.mat

    newfeaturespace = featurespace.change(topLayerActivs);
end


