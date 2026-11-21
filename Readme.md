# Sex-Chromosome Dosage Analysis – Fall Armyworm

**Course:** Cell and Molecular Biology  
**Activity:** Sex-Chromosome Dosage in a Selected Animal Nuclear Genome Using NCBI, Galaxy, and R  
**Name:** Jerrick Paul T Tayos  
**Section:** B  
**Species:** Fall Armyworm (*Spodoptera frugiperda*)  
**Genome Assembly:** AGI-APGP_CSIRO_Sfru_2.0 (GCF_023101765.2)  
**WGS Run:** SRR12044614  
**Assembly BioSample:** SAMN26179013  
**WGS BioSample:** To be confirmed  
**Sex System:** ZW (female ZW; male ZZ)  
**Same Donor:** Not yet established  

## Project Overview

This study aims to determine the possible sex-chromosome composition of a selected fall armyworm (*Spodoptera frugiperda*) individual through the analysis of whole-genome sequencing (WGS) data.

The procedure involves obtaining a chromosome-level reference genome from NCBI, aligning the sequencing reads and determining chromosome coverage using Galaxy, and processing and visualizing the resulting data through R.

The analysis focuses on evaluating the read depth of the Z chromosome relative to the median coverage of selected autosomes. The W chromosome is also considered to provide supplementary evidence in interpreting the animal's sex-chromosome complement.

### Study Question

Based on the chromosome read-depth measurements of the selected *Spodoptera frugiperda* sample, can its sex-chromosome composition be classified as ZW-like or ZZ-like, and is this interpretation consistent with the sex information available in its NCBI BioSample record?

## Species/Sex-Chromosome System

The species selected is the fall armyworm (*Spodoptera frugiperda*).

Fall armyworm has a ZW sex-determination system, in which:

- Females typically possess one Z chromosome and one W chromosome (ZW).
- Males typically possess two Z chromosomes (ZZ).

The chromosome-level reference genome, AGI-APGP_CSIRO_Sfru_2.0 (GCF_023101765.2), contains assembled chromosome sequences. Chromosome 25 (NC_064236.1) is identified as the Z chromosome in the chromosome grouping used for this activity.

The Z chromosome will be examined in comparison with selected autosomes to estimate the sex-chromosome complement of the WGS sample. The W chromosome may provide additional evidence if its sequence is represented in the reference assembly.

## 3. NCBI Data Sources

### Reference Genome

- Species: *Spodoptera frugiperda* (Fall Armyworm)
- Assembly name: AGI-APGP_CSIRO_Sfru_2.0
- Assembly accession: GCF_023101765.2
- Assembly BioSample: SAMN26179013
- Assembly level: Chromosome

Links:
- [NCBI Genome Assembly](https://www.ncbi.nlm.nih.gov/datasets/genome/GCF_023101765.2/)
- [NCBI Assembly Report](https://www.ncbi.nlm.nih.gov/assembly/GCF_023101765.2/)

### Whole-Genome Sequencing (WGS) Data

- Species: *Spodoptera frugiperda*
- WGS Run accession: SRR12044614
- WGS BioSample: To be confirmed
- BioProject: PRJNA640063
- Sequencing strategy: WGS
- Sequencing platform: Illumina HiSeq X Ten
- Library layout: Paired-end
- Read configuration: 2 × 150 bp
- Same donor: Not yet established

Links:
- [NCBI SRA Run SRR12044614](https://www.ncbi.nlm.nih.gov/sra/SRR12044614)
- [NCBI BioProject PRJNA640063](https://www.ncbi.nlm.nih.gov/bioproject/PRJNA640063)

### Galaxy Workflow Procedure

1. Galaxy History created and named Sex_Dosage_Spodoptera_frugiperda.

2. Imported  *Spodoptera frugiperda* reference genome FASTA
<img width="957" height="506" alt="image" src="https://github.com/user-attachments/assets/1155bd49-aca7-4046-a0ba-d0bb57914def" />


3. Imported WGS reads with SRR12044614
<img width="959" height="506" alt="image" src="https://github.com/user-attachments/assets/5fb378d9-b257-462a-acfb-e4b29d06eaae" />


4. Performed FASTQC in order to examine the read quality
<img width="959" height="505" alt="image" src="https://github.com/user-attachments/assets/aae739b8-2671-4f18-8786-c02ad6520b26" />


5. Used BWA-MEM to align the reads against the reference assembly.
<img width="958" height="503" alt="image" src="https://github.com/user-attachments/assets/07d75a83-ab19-4c00-9f51-9be636deca43" />

- Mapped reads were coordinate-sorted;BAM index was generated to support chromosome coverage analysis.

6. Used Samtools coverage to calculate chromosome coverage;Set minimum mapping quality to 20 and minimum base quality to 20.
<img width="958" height="502" alt="image" src="https://github.com/user-attachments/assets/6941f090-8fec-441b-9d3c-04a4a3c316c0" />


### Galaxy History

- [https://usegalaxy.org/histories/view?id=bbd44e69cb8906b5c9a94a13910546b2](https://usegalaxy.org/u/jerrick_tayos/h/sex-dosage-spodoptera-frugiperda)

## Chromosome Identification and Grouping

Chromosome identifiers were obtained from the NCBI assembly report for *Spodoptera frugiperda* (GCF_023101765.2) and matched with the reference sequence names in the chromosome coverage output.

Five autosomes were selected together with the identified Z chromosome.

| Reference sequence | Group |
|---|---|
| NC_064212.1 | A |
| NC_064213.1 | A |
| NC_064214.1 | A |
| NC_064215.1 | A |
| NC_064216.1 | A |
| NC_064236.1 | Z |

The five selected autosomes were used to calculate the median autosomal read depth. The Z chromosome was used to calculate the Z:A coverage ratio to help assess the possible sex-chromosome composition of the selected individual.

The W chromosome was not included because a corresponding W chromosome reference sequence has not been confidently established in the selected reference sequence set.

Mitochondrial DNA and unplaced scaffolds were excluded from chromosome grouping.

The chromosome labels were saved in `chromosome_groups.csv`, using the exact reference sequence identifiers from the Samtools coverage output.

### R Analysis

R was used to analyze the Samtools coverage output and chromosome grouping file. The script calculated the median autosomal depth, relative chromosome depth, and Z:A ratio. The W:A ratio was included only if a W chromosome was identified.

It also generated a CSV file, a bar graph, and a text summary to present the results and provide a preliminary dosage interpretation.

### R code
```r
# Sex-chromosome dosage from whole-genome DNA read depth
# Input: Samtools coverage TSV + student chromosome labels

cov <- read.delim("chromosome_coverage.tsv", comment.char = "",
                  check.names = FALSE, stringsAsFactors = FALSE)

names(cov)[1] <- "rname" # Accepts the '#rname' header

if (!"meandepth" %in% names(cov)) stop("Missing meandepth column")

key <- read.csv("chromosome_groups.csv", stringsAsFactors = FALSE)

if (!all(c("rname", "group") %in% names(key))) stop("Bad key columns")

key$rname <- trimws(key$rname)
key$group <- toupper(trimws(key$group))

if (anyDuplicated(key$rname)) stop("Repeated rname in key file")

if (!all(key$group %in% c("A", "X", "Y", "Z", "W")))
  stop("Use only A, X, Y, Z or W in the group column")

x <- merge(key, cov[, c("rname", "meandepth")],
           by = "rname", all.x = TRUE, sort = FALSE)

x$meandepth <- suppressWarnings(as.numeric(x$meandepth))

if (anyNA(x$meandepth)) stop("Missing depths: check rname matches")
if (any(x$meandepth < 0)) stop("Negative depth is not valid")
if (sum(x$group == "A") < 5) stop("Label at least 5 autosomes")

if ("X" %in% x$group && "Z" %in% x$group)
  stop("Choose either an XY or a ZW species, not both")

if (sum(x$group == "X") == 1 && !any(x$group == "Z")) {
  target <- "X"
  one_copy <- "XY-like"
  two_copies <- "XX-like"
} else if (sum(x$group == "Z") == 1 && !any(x$group == "X")) {
  target <- "Z"
  one_copy <- "ZW-like"
  two_copies <- "ZZ-like"
} else stop("Label exactly one X or exactly one Z chromosome")

A <- median(x$meandepth[x$group == "A"])

if (!is.finite(A) || A <= 0) stop("No usable autosomal coverage")

x$relative_depth <- x$meandepth / A

ratio <- x$relative_depth[x$group == target]

call <- if (ratio >= 0.80) two_copies else if (ratio <= 0.65)
  one_copy else "Ambiguous"

if (A < 1) call <- "Inconclusive: very low autosomal depth"

# Additional Y or W evidence can support, but not prove, a call
partner <- if (target == "X") "Y" else "W"

partner_ratio <- if (partner %in% x$group)
  x$relative_depth[x$group == partner][1] else NA_real_

# Export results and a simple, reproducible figure
dir.create("results", showWarnings = FALSE)

write.csv(x, "results/chromosome_relative_depth.csv",
          row.names = FALSE)

png("results/chromosome_depth.png", width = 1000, height = 580)

par(mar = c(8, 4, 3, 1))

barplot(x$relative_depth, names.arg = x$rname, las = 2,
        ylab = "Depth relative to median autosome",
        main = "Autosomal and sex-chromosome depth",
        cex.names = 0.75)

abline(h = c(0.5, 1.0), lty = 2)

dev.off()

summary <- c(
  paste("Median autosome depth:", round(A, 3)),
  paste(target, "/ A ratio:", round(ratio, 3)),
  paste(partner, "/ A ratio:", round(partner_ratio, 3)),
  paste("Dosage interpretation:", call),
  "Compare with BioSample sex and discuss limitations."
)

writeLines(summary, "results/sex_inference.txt")

cat(paste(summary, collapse = "\n"), "\n")
```

### Results

### Chromosome Coverage

| rname | group | meandepth | relative_depth |
|---|---|---:|---:|
| NC_064212.1 | A | 2.34135 | 1.06439 |
| NC_064213.1 | A | 2.20523 | 1.00250 |
| NC_064214.1 | A | 2.19421 | 0.99750 |
| NC_064215.1 | A | 2.29302 | 1.04241 |
| NC_064216.1 | A | 2.18554 | 0.99355 |
| NC_064217.1 | A | 2.17164 | 0.98723 |
| NC_064236.1 | Z | 1.76639 | 0.80301 |

### Calculated Results
### Dosage Analysis and Interpretation

- **Median autosomal depth:** 2.2
- **Z/A ratio:** 0.803
- **W/A ratio:** NA
- **Dosage interpretation:** ZZ-like

### Chromosome Relative Depth Graph
  <img width="1000" height="580" alt="image" src="https://github.com/user-attachments/assets/86cd331a-d1dd-473b-9a24-8be165a103dd" />

### *Figure 1*.
The graph shows that most chromosome sequences of *Spodoptera frugiperda* exhibit a relative sequencing depth close to 1.0, indicating coverage comparable to the median autosomal depth. However, the seventh chromosome sequence has a comparatively lower relative depth of approximately 0.80. Although a relative depth of approximately 0.5 is generally expected for single-copy sex chromosomes in male specimens, none of the analyzed sequences shows this value. Therefore, the results do not clearly demonstrate the expected sex-chromosome dosage pattern. Further identification of the chromosome accession numbers is necessary to determine which sequences correspond to the autosomes and sex chromosomes.

### Questions

# Cell and Molecular Biology – Individual Practical Exercise
## Sex-Chromosome Dosage in a Selected Animal Nuclear Genome Using NCBI, Galaxy, and R

**Name:** Jerrick Paul T Tayos  
**Section:** B  
**Selected Animal Species:** *Spodoptera frugiperda* (Fall Armyworm)

---

### 1. What species did you choose, and what evidence supports a diploid XX/XY or ZZ/ZW system?

I selected *Spodoptera frugiperda*, commonly known as the fall armyworm. It is a lepidopteran insect, and moths generally have a ZW sex-determination system, in which females are ZW and males are ZZ. Therefore, the expected sex-chromosome system for this species is ZW. The chromosome-level reference assembly provides the genomic sequences needed to investigate sex-linked read depth. However, the species' sex system alone does not establish the sex of the sequenced individual.

### 2. What are your assembly accession, WGS run, and both BioSample accessions? Are the donors the same?

| Information | Accession |
|---|---|
| Assembly accession | `GCF_023101765.2` |
| Assembly BioSample | `SAMN26179013` |
| WGS run accession | `SRR12044614` |
| WGS BioSample | SAMN15298087 |
| BioProject | `PRJNA640063` |
| Same donor? | Not established |

TThe reference genome used in this study is assembly `GCF_023101765.2`, associated with BioSample `SAMN26179013`. The WGS reads were obtained from run `SRR12044614`, associated with BioSample `SAMN15298087`, under BioProject `PRJNA640063`.

The two BioSample accessions are different, indicating that the reference assembly and WGS dataset are associated with different sample records. Therefore, the donors are considered different individuals based on the available accession records. The reference genome serves as the mapping reference, while the WGS reads provide the sequencing data used for chromosome-depth analysis.

### 3. Which sequences were used as autosomes and as X or Z? How did you verify their identities?

The Samtools coverage output contained 31 nuclear chromosome sequences, from `NC_064212.1` to `NC_064242.1`, as well as mitochondrial DNA and unplaced scaffolds.

For chromosome-based analysis, the mitochondrial sequence (`NC_027836.1`) and unplaced scaffolds (`NW_...`) were excluded.

The chromosome identities should be checked against the NCBI chromosome report for assembly `GCF_023101765.2`. This is important because chromosome accession numbers alone do not identify which chromosome is Z.

The provisional grouping used in the RStudio analysis was:

| Sequence accession | Group |
|---|---|
| `NC_064212.1` | A |
| `NC_064213.1` | A |
| `NC_064214.1` | A |
| `NC_064215.1` | A |
| `NC_064216.1` | A |
| `NC_064217.1` | A |
| `NC_064236.1` | Z |

**Note:** The assignment of `NC_064236.1` as the Z chromosome still requires confirmation from the matching NCBI assembly chromosome report.

### 4. What are the median autosomal depth, X:A or Z:A ratio, and inferred sex-chromosome complement?

The median autosomal depth obtained from RStudio was **2.20×**, while the mean depth of the provisionally assigned Z chromosome (`NC_064236.1`) was 1.76639×. The calculated Z:A ratio was **0.803**.

The expected Z:A ratio for a ZZ individual is approximately 1.0, while a ZW individual is expected to have a ratio near 0.5 because females possess only one Z chromosome.

The observed ratio of 0.803 falls between these expected values and is closer to the ZZ expectation. Therefore, the result is provisionally interpreted as **ZZ-like**, but it does not conclusively establish the sex-chromosome complement.

**RStudio results:**

- Median autosomal depth: 2.20×
- Z chromosome mean depth: 1.76639×
- Z:A ratio: 0.803
- W:A ratio: NA
- Dosage interpretation: ZZ-like

### 5. Does your result agree with the recorded sex of the WGS donor, if reported? Explain any discrepancy or uncertainty.

The inferred result is provisionally ZZ-like based on the observed Z:A ratio of 0.803. However, the recorded sex of the WGS donor has not yet been confirmed from its BioSample metadata. Therefore, agreement between the inferred complement and recorded sex cannot yet be established.

The intermediate ratio may be influenced by differences in sequencing coverage, mapping quality, genomic variation, or the accuracy of the chromosome assignment. These factors should be considered before drawing a definitive conclusion.

### 6. Why is a chromosome-level assembly alone insufficient for a reliable read-depth sex inference?

A chromosome-level assembly provides organized chromosome sequences, but it does not automatically establish the sex of the individual used for sequencing. It is also necessary to identify the sex chromosome correctly, obtain WGS reads from a specimen with known sex, and ensure that the reads map reliably to the reference.

Differences in sequencing depth, repetitive regions, incomplete chromosome sequences, and mapping errors can affect the observed read-depth ratios. Therefore, chromosome-level assembly information must be combined with reliable sample metadata and read-depth analysis to infer sex chromosomes accurately.


## Limitations of the Study

This study has several limitations that may affect the interpretation of the chromosome-depth results.

1. **Different BioSample Accessions**  
   The reference genome assembly (`GCF_023101765.2`) and the WGS dataset (`SRR12044614`) are associated with different BioSample accessions (`SAMN26179013` and `SAMN15298087`, respectively). Therefore, it cannot be confirmed from these accession records alone whether the reference genome and WGS reads came from the same individual.

2. **Verification of Z Chromosome Identification**  
   The identification of the Z chromosome must be verified using the official chromosome annotations for the selected assembly. Incorrect classification of a chromosome as Z may affect the relative-depth calculation and chromosome dosage interpretation.

3. **Sequencing Coverage and Mapping Quality**  
   The analysis may be affected by sequencing coverage and mapping quality. Low read depth, repetitive DNA regions, sequence differences between the sample and reference genome, and mapping errors may cause some chromosomes to exhibit lower or higher coverage than expected.

4. **Interpretation of the Z-to-Autosome Depth Ratio**  
   The calculated Z-to-autosome depth ratio of **0.803** provides only a preliminary indication of chromosome dosage. Although it is closer to the expected ZZ pattern than the expected ZW pattern, it does not conclusively determine the biological sex of the sequenced sample. Furthermore, the absence of a W chromosome measurement limits the ability to distinguish between the two possible sex-chromosome complements.

   Additional confirmation through BioSample sex metadata, verified chromosome annotations, and more reliable sequencing data is necessary to support a more definitive interpretation.



### References

- National Center for Biotechnology Information (NCBI). *Spodoptera frugiperda* AGI-APGP_CSIRO_Sfru_2.0 genome assembly, GCF_023101765.2. [https://www.ncbi.nlm.nih.gov/datasets/genome/GCF_023101765.2/](https://www.ncbi.nlm.nih.gov/datasets/genome/GCF_023101765.2/)

- National Center for Biotechnology Information (NCBI). Sequence Read Archive (SRA), WGS dataset SRR12044614. [https://www.ncbi.nlm.nih.gov/sra/SRR12044614](https://www.ncbi.nlm.nih.gov/sra/SRR12044614)

- Galaxy Project. Galaxy NGS Data Management Tutorial. [https://training.galaxyproject.org/training-material/topics/introduction/tutorials/galaxy-intro-ngs-data-management/tutorial.html](https://training.galaxyproject.org/training-material/topics/introduction/tutorials/galaxy-intro-ngs-data-management/tutorial.html)

- SAMtools. Samtools Coverage Documentation. [https://www.htslib.org/doc/samtools-coverage.html](https://www.htslib.org/doc/samtools-coverage.html)

- National Center for Biotechnology Information (NCBI). Sex chromosome coverage review. [https://pmc.ncbi.nlm.nih.gov/articles/PMC6900093/](https://pmc.ncbi.nlm.nih.gov/articles/PMC6900093/)




