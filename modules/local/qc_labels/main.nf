process QC_LABELS {
    tag "$meta.id"

    container "avnirlab/avnirpy:latest"

    input:
    tuple val(meta), path(labels), path(volume), path(custom_config)

    output:
    tuple val(meta), path("*__labels.nrrd"), emit: labels_nrrd
    tuple val(meta), path("*__volume.nrrd"), emit: volumes_nrrd
    tuple val(meta), path("*__labels.nii.gz"), emit: labels_nifti
    tuple val(meta), path("*__volume.nii.gz"), emit: volumes_nifti
    path "versions.yml"                      , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def prefix = task.ext.prefix ?: "${meta.id}"
    def config = task.ext.custom_qc_config ? "${custom_config}" : "/avnirpy/data/qc_labels_config.yaml"
    """
    avnir_qc_labels.py ${labels} ${volume} ${config} ${prefix}__labels.nrrd ${prefix}__volume.nrrd
    avnir_nrrd_to_nifti.py ${prefix}__labels.nrrd ${prefix}__labels.nii.gz
    avnir_nrrd_to_nifti.py ${prefix}__volume.nrrd ${prefix}__volume.nii.gz
    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        avnirpy: \$(avnir_qc_labels.py --version)
    END_VERSIONS
    """

    stub:
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    avnir_qc_labels.py -h
    avnir_nrrd_to_nifti.py -h
    touch ${prefix}__labels.nrrd
    touch ${prefix}__volume.nrrd
    touch ${prefix}__labels.nii.gz
    touch ${prefix}__volume.nii.gz

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        avnirpy: \$(avnir_qc_labels.py --version)
    END_VERSIONS
    """
}
