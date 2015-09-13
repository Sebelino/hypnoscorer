# Hypnoscorer
Hypnoscorer (from "Hypnos" (sleep) and "scorer") is an automated semi-supervised sleep stage classifier under development.

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
* [wfdb-toolbox](https://github.com/ikarosilva/wfdb-app-toolbox)
  * Make sure wfdb-toolbox/mcode/ is in your MATLAB path.
  * Alternatively, place the whole wfdb-toolbox directory in lib/ since lib/wfdb-toolbox/mcode is added to the path automatically.
* [DBNToolbox](http://www.seas.upenn.edu/~wulsin/)
  * Make sure DBNToolbox/lib/ is in your MATLAB path.
  * Alternatively, place the whole DBNToolbox directory in lib/ since lib/DBNToolbox/lib is added
  to the path automatically.

## Usage
Coming soon...
