% Adapted from Martin Längkvist's code: http://aass.oru.se/~mlt/sleep.zip

% layersize: List containing the number of hidden nodes in each hidden layer, arranged from the one
% closest to the visible layer to the one farthest away.
function newfeaturespace = dbnify(featurespace,layersizes)
    addpath('lib/DBNToolbox/lib/')

    data = featurespace.matrix();
    data = data-repmat(min(data),size(data,1),1);
    data = data./repmat(max(data),size(data,1),1);

    % Partition feature space into training and validation subspaces
    k = randperm(size(data,1));
    traindata = data(k(1:floor(size(data,1)*5/6)),:);
    valdata = data(k(floor(size(data,1)*5/6)+1:end),:);

    rbmParams.numEpochs = 50;
    rbmParams.verbosity = 1;
    rbmParams.miniBatchSize = 1000;
    rbmParams.attemptLoad = 0;
    dbnParams.numEpochs = 20;
    dbnParams.verbosity = 1;
    dbnParams.miniBatchSize = 1000;
    dbnParams.attemptLoad = 0;

    disp('Unsupervised pre-training...');
    nnLayers = GreedyLayerTrain(traindata, valdata, layersizes, 'RBM', rbmParams);
    dnn = DeepNN(nnLayers, dbnParams);
    disp('Unsupervised backprop...');
    dnn.Train(traindata, valdata);
    disp('DBN training finished.');

    % Inference on train data
    [~,layerActivs] = dnn.PropLayerActivs(data);
    topLayerActivs = layerActivs{numel(layerSize)};
    topLayerActivs = layerActivs{numel(layersizes)};

    % This garbage appears after using the DBNToolbox functions
    delete dnn.dnn_obj.mat nnl.*.rbm_obj.mat

    newfeaturespace = featurespace;
    for i = 1:size(topLayerActivs,2)
        featurename = ['F',num2str(i)];
        newfeaturespace = newfeaturespace.extend(featurename,topLayerActivs(:,i));
    end
end


