# Hypnoscorer
Hypnoscorer (from "Hypnos" (sleep) and "scorer") is an automated semi-supervised sleep stage classifier under development. You can use it to load some EEG signal data including annotations, segment it, extract features from it, apply PCA, plot the feature space, do SVM classification and much more.

## Installation
Clone the repository including the wfdb-toolbox submodule like so:
```bash
git clone --recursive git@github.com:Sebelino/hypnoscorer
```
Or just click *Download ZIP* on this page.

### Dependencies
* MATLAB R2014b
  * Untested with other versions.
* [edfread.m](http://www.mathworks.com/matlabcentral/fileexchange/31900-edfread/content/edfread.m)
  * Make sure this file is in your MATLAB path.
  * Alternatively, simply move the file to lib/ since lib/ is added to the path automatically.
* [WFDB Software package](http://www.physionet.org/physiotools/wfdb.shtml)
* [wfdb-toolbox](https://github.com/ikarosilva/wfdb-app-toolbox)
  * Make sure wfdb-toolbox/mcode/ is in your MATLAB path.
  * Alternatively, place the whole wfdb-toolbox directory in lib/ since lib/wfdb-toolbox/mcode is added to the path automatically.
* [DBNToolbox](http://www.seas.upenn.edu/~wulsin/)
  * Make sure DBNToolbox/lib/ is in your MATLAB path.
  * Alternatively, place the whole DBNToolbox directory in lib/ since lib/DBNToolbox/lib is added
  to the path automatically.

### Download some data
This program is currently capable of reading eleven different, explicitly named records:
* Ten records from the [SHHS1 dataset](https://sleepdata.org/datasets/shhs/files/edfs/shhs1): SHHS1-200001 to SHHS1-200010. You have to fill out a form to access it.
* The slp01a record of the freely accessible [MIT-BIH](https://www.physionet.org/physiobank/database/slpdb/) dataset.
It should be straightforward to add support for reading from other EDF or WFDB files by editing the appropriate lines in *score.m*.

### Load the slp01a record
Start by downloading the three files you will need for the slp01a record from the webpage linked to above:
* slp01a.dat: Signal file containing the EEG, ECG, blood pressure and Resp signals.
* slp01a.st: Sleep stage annotations.
* slp01a.hea: Metadata.
Place these files in a directory, *data/slp01a/*. Now, with the WFDB software package installed, use *wfdb2mat* to generate a *slp01am.mat* and a *slp01am.hea* from your .dat and .hea files:

```bash
$ cd data/slp01a
$ ls
slp01a.dat slp01a.hea slp01a.st
$ wfdb2mat -r slp01a
[...]
$ ls
slp01a.dat slp01a.hea slp01am.hea slp01am.mat slp01a.st
```

Now open up MATLAB and use the program to load the data like so:

```
>> labeledsignal = score('load slp01a')
Reading data/slp01a/slp01a...

labeledsignal = 

       eeg: [1x1 Signal]
    labels: [240x1 char]
```

### Load the shhs1-200001 record
You need a couple of files:
* shhs1-200001.edf: Signal data.
* shhs1-200001-staging.csv: Sleep stage annotations.
Place these files in a directory, *data/shhs/*. Now open up MATLAB and use the program to load the data like so:

```
>> labeledsignal = score('load shhs1-200001')
Reading data/shhs/shhs1-200001...
Step 1 of 2: Reading requested records. (This may take a few minutes.)...
Step 2 of 2: Parsing data...

labeledsignal = 

       eeg: [1x1 Signal]
    labels: [1084x1 char]
```

### Interpreting the output
Now that you have successfully read either the slp01a record or an SHHS record, let us take a look at the output which was stored in the variable aptly named *labeledsignal*:

```
labeledsignal = 
       eeg: [1x1 Signal]
    labels: [240x1 char]
```

This little struct is an EEG signal labeled with R&K sleep stage annotations (Wake, REM, N1, N2, N3, N4), with 30 seconds between each label. As you can see, there are 240 labels for this signal. Here is how you display the first 50 labels:
```
>> labeledsignal.labels(1:50)'

ans =
44444444444433322233333333333444444444433332322222
```
You can easily tell that this signal is 120 minutes long since there are 240 label characters and 240 * 30 seconds = 120 minutes. As shown in the output above, the subject is deemed to start sleeping in N4 during the first 360 seconds, then switches to N3, and so on.

As for the signal itself, you can read the EEG voltage like so:

```
>> labeledsignal.eeg.Graph

ans =
         0   -0.0392
    0.0040   -0.0389
    0.0080   -0.0386
    0.0120   -0.0393
    0.0160   -0.0353
[...]
```

The left column is the time (in seconds) at which the voltage was sampled. The right column is the EEG voltage in millivolts.

### Feature extraction
Now let us extract some features of the signal to create a feature space:

```
>> fs = score('load slp01a | segment 3 | extract')
Reading cache/slp01a.slp01a.mat...

fs = 
  720x1 LabeledFeaturevector array with properties:

    Label
    Vector
```

`load slp01a | segment 3 | extract` should be read as: "first load the slp01a record, then divide it into 30/3 = 10 second uniform segments, then extract seven features from each of the 720 segments". These features are: Mean, variance, skewness, kurtosis, Hjorth mobility, Hjorth complexity and amplitude. This results in a feature space consisting of 720 feature vectors. Find the values of the features of a vector like so:

```
>> fs(1).Vector

ans = 

                Mean: -0.0174
            Variance: 0.0020
            Skewness: 0.2085
            Kurtosis: 5.0548
      HjorthMobility: 18.9681
    HjorthComplexity: 3.7163e+03
           Amplitude: 0.3072
```

### PCA
To reduce the dimensionality using principal component analysis, simply add `pca` to the end of the pipeline:
```
>> fs = score('load slp01a | segment 3 | extract | pca')
Reading cache/slp01a.slp01a.mat...
fs = 
  720x1 LabeledFeaturevector array with properties:
    Label
    Vector

>> fs(1).Vector
ans = 
    PC1: 0.3136
    PC2: -0.0587
```

### Plotting
To make a 2D plot of the feature space including labels, simply add `plot` to the end of the pipeline:

```
>> score('load slp01a | segment 3 | extract | pca | plot')
```

### Partitioning
Coming soon...
### SVM classification
Coming soon...

### Clear cache
This program uses a file cache to significantly speed up the process of loading data from record files (EDF, etc.). For comparison, loading the SHHS-200001 record takes about 70 seconds without a cache and less than a second with one.

Every record is cached in a MAT file in the *cache/* directory, e.g. *./cache/shhs.shhs1-200001.mat*. If you for some reason would like to clear the cache for a record, simply delete the corresponding MAT file for the record.
