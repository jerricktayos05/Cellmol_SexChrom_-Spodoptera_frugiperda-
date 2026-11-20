# Sex-Chromosome Dosage Analysis - Domestic Cattle

**Course:** Cell and Molecular Biology  
**Activity:** Sex-Chromosome Dosage in a Selected Animal Nuclear Genome Using NCBI, Galaxy, and R  
**Species:** Domestic Cattle (*Bos taurus*)  
**Genome Assembly:** ARS-UCD2.0 (GCF_002263795.3)  
**WGS Run:** SRR5753432  
**Assembly BioSample:** SAMN03145444  
**WGS BioSample:** SAMN03145444  
**Sex System:** XX/XY  
**Same Donor:** Yes

## Project Overview

This study aims to determine the possible sex-chromosome composition of a selected domestic cattle (*Bos taurus*) individual through the analysis of whole-genome sequencing (WGS) data.

The procedure involves obtaining a chromosome-level reference genome from NCBI, aligning the sequencing reads and determining chromosome coverage using Galaxy, and processing and visualizing the resulting data through R.

The analysis focuses on evaluating the read depth of the X chromosome relative to the median coverage of selected autosomes. The Y chromosome is also considered to provide supplementary evidence in interpreting the animal's sex-chromosome complement.

### Study Question

Based on the chromosome read-depth measurements of the selected *Bos taurus* sample, can its sex-chromosome composition be classified as XX-like or XY-like, and is this interpretation consistent with the sex information available in its NCBI BioSample record?

## Species/Sex-Chromosome System

The species selected is domestic cattle (*Bos taurus*).

Cattle - XX/XY sex-determination system, in which:
- Females typically possess two X chromosomes (XX).
- Males typically possess one X chromosome and one Y chromosome (XY).

The chromosome-level reference genome, ARS-UCD2.0 (GCF_002263795.3), includes an identified X chromosome. The X chromosome will be examined in comparison with selected autosomes to estimate the sex-chromosome complement of the WGS sample.

## 3. NCBI Data Sources

### Reference Genome

- Species: *Bos taurus* (Domestic cattle)
- Assembly name: ARS-UCD2.0
- Assembly accession: GCF_002263795.3
- Assembly BioSample: SAMN03145444
- Assembly level: Chromosome

Links:
- [NCBI Genome Assembly](https://www.ncbi.nlm.nih.gov/datasets/genome/GCF_002263795.3/)
- [NCBI Assembly Report](https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/002/263/795/GCF_002263795.3_ARS-UCD2.0/GCF_002263795.3_ARS-UCD2.0_assembly_report.txt)

### Whole-Genome Sequencing (WGS) Data

- Species: *Bos taurus*
- WGS Run accession: SRR5753432
- WGS BioSample: SAMN03145444
- Sequencing strategy: WGS
- Sequencing platform: PacBio RS II
- Library layout: Single-end
- Same donor: Yes

Links:
- [NCBI SRA Run](https://www.ncbi.nlm.nih.gov/sra/SRR5753432)
- [NCBI BioSample](https://www.ncbi.nlm.nih.gov/biosample/SAMN03145444)

### Galaxy Workflow Procedure

1. Galaxy History created and named Sex_Dosage_Bos_taurus.

2. Imported Bos taurus reference genome FASTA
<img width="2160" height="1462" alt="image" src="https://github.com/user-attachments/assets/c79ac2fe-1d24-49f2-803b-ca26b7f3301a" />


3. Imported WGS reads with SRR5753432
<img width="2160" height="1460" alt="image" src="https://github.com/user-attachments/assets/bba00481-1f3d-4079-a0aa-351a9b2f8de4" />


4. Performed FASTQC in order to examine the read quality
<img width="2160" height="1462" alt="image" src="https://github.com/user-attachments/assets/be8e5783-e1c5-425f-ae64-47cb431b5ba1" />


5. Used BWA-MEM to align the reads against the reference assembly.
<img width="2160" height="1462" alt="image" src="https://github.com/user-attachments/assets/0b616bb8-91cf-42fd-981d-d433076f70f5" />
- Mapped reads were coordinate-sorted;BAM index was generated to support chromosome coverage analysis.

6. Used Samtools coverage to calculate chromosome coverage;Set minimum mapping quality to 20 and minimum base quality to 20.
<img width="2160" height="1455" alt="image" src="https://github.com/user-attachments/assets/e3588a11-dae2-4c45-ac0b-1a12846d8110" />


### Galaxy History

- https://usegalaxy.org/histories/view?id=bbd44e69cb8906b5c9a94a13910546b2
   








