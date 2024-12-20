include { QC_LABELS } from '../../../modules/local/qc_labels/main.nf'
include { VOLUMETRY_LABELS } from '../../../modules/local/volumetry_labels/main.nf'
include { MERGE_JSONS } from '../../../modules/local/merge_jsons/main.nf'


workflow LABELS_VOLUMETRY {

    take:
    volumes         // path
    labels          // path
    brain_masks     // path

    main:

    ch_versions = Channel.empty()
    ch_labels = labels
        .join(volumes)
        .map{ it -> [it[0], it[1], it[2], params.custom_qc_config ? file(params.custom_qc_config) : []]}
    QC_LABELS( ch_labels )
    ch_versions = ch_versions.mix(QC_LABELS.out.versions.first())

    ch_volumetry = QC_LABELS.out.labels_nifti
        .join(brain_masks, remainder: true)
        .map{it -> [it[0], it[1], it[2] != null ? it[2] : []]}
    VOLUMETRY_LABELS( ch_volumetry )
    ch_versions = ch_versions.mix(VOLUMETRY_LABELS.out.versions.first())

    MERGE_JSONS( VOLUMETRY_LABELS.out.volumetry_report.map{it[1]}.collect() )
    ch_versions = ch_versions.mix(MERGE_JSONS.out.versions)

    emit:
    versions = ch_versions          // channel: [ versions.yml ]
}
