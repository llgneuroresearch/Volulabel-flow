# Volulabel-flow
![GitHub Release](https://img.shields.io/github/v/release/llgneuroresearch/Volulabel-flow)
[![Documentation Status](https://readthedocs.org/projects/avnir-documentation/badge/?version=latest)](https://avnir-documentation.readthedocs.io/en/latest/tools/pipelines.html#volulabel-flow)

Volumetric pipeline for CT scan volumes in Nextflow

## Installation

Install Nextflow by following the instructions on the [Nextflow website](https://www.nextflow.io/).
```sh
# Install Nextflow
curl -s https://get.nextflow.io | bash
mv nextflow /usr/local/bin/

# Verify installation
nextflow -v
```

## Usage

To run the pipeline, use the following example:

```sh
nextflow pull llgneuroresearch/Volulabel-flow -r main
nextflow run llgneuroresearch/Volulabel-flow -r main --input input -with-profile docker
```

### Description

- `--input=/path/to/[root]`: Root folder containing multiple subjects
    ```
    [root]
    ├── S1
    │   ├── *labels.nrrd
    │   ├── *volume.nrrd
    │   └── *brain_mask.nii.gz (optional)
    └── S2
        ├── *labels.nrrd
        ├── *volume.nrrd
        └── *brain_mask.nii.gz (optional)
    ```

### Optional Arguments

- `--run_volumetry_labels`: Run volumetry on labels. By default, true
- `--run_ct_bet`: Run CT BET. By default, true. If true, the pipeline will run CT-BET on the volumes except if a brain_mask.nii.gz image is available in the subject input foler.
- `--custom_qc_config`: YAML config file to perform quality controls on labels. By default, use the yaml in the container.
- `--output_dir`: Directory where to write the final results. By default, will be in "./results".

### Available Profiles

- `docker`: Use Docker containers.
- `apptainer`: Use Apptainer containers.
- `singularity`: Use Singularity containers.
- `slurm`: Use Slurm executor.