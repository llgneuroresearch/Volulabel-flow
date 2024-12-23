process VOLUMETRY_LABELS {
    tag "$meta.id"

    container "avnirlab/avnirpy:latest"

    input:
    tuple val(meta), path(labels), path(brain_mask)

    output:
    tuple val(meta), path("*__volumetry.json"), emit: volumetry_report
    path "versions.yml"                       , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def prefix = task.ext.prefix ?: "${meta.id}"
    def mask = brain_mask ? "--brain_mask ${brain_mask}" : ""
    """
    avnir_compute_volume_per_label.py ${labels} volumetry.json ${mask}
    jq 'map(.id = "${prefix}")' volumetry.json > ${prefix}__volumetry.json
    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        avnirpy: \$(avnir_compute_volume_per_label.py --version)
    END_VERSIONS
    """

    stub:
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    avnir_compute_volume_per_label.py -h
    touch ${prefix}__volumetry.json

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        avnirpy: \$(avnir_compute_volume_per_label.py --version)
    END_VERSIONS
    """
}