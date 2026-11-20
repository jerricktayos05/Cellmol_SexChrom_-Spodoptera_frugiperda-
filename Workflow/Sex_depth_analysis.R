# Sex-chromosome dosage from whole-genome DNA read depth
# Input: Samtools coverage TSV + student chromosome labels
cov <- read.delim("chromosome
coverage.tsv"
, comment.char = ""
,
_
check.names = FALSE, stringsAsFactors = FALSE)
names(cov)[1] <-
"rname" # Accepts the '#rname' header
if (!"meandepth" %in% names(cov)) stop("Missing meandepth column")
key <- read.csv("chromosome
groups.csv"
, stringsAsFactors = FALSE)
_
if (!all(c("rname"
,
"group") %in% names(key))) stop("Bad key columns")
key$rname <- trimws(key$rname)
key$group <- toupper(trimws(key$group))
if (anyDuplicated(key$rname)) stop("Repeated rname in key file")
if (!all(key$group %in% c("A"
,
"X"
,
"Y"
,
"Z"
,
"W")))
stop("Use only A, X, Y, Z or W in the group column")
x <- merge(key, cov[, c("rname"
,
"meandepth")],
by = "rname"
, all.x = TRUE, sort = FALSE)
x$meandepth <- suppressWarnings(as.numeric(x$meandepth))
if (anyNA(x$meandepth)) stop("Missing depths: check rname matches")
if (any(x$meandepth < 0)) stop("Negative depth is not valid")
if (sum(x$group == "A") < 5) stop("Label at least 5 autosomes")
if ("X" %in% x$group && "Z" %in% x$group)
stop("Choose either an XY or a ZW species, not both")
if (sum(x$group == "X") == 1 && !any(x$group == "Z")) {
target <-
"X"
one
copy <-
"XY-like"
  two
copies <-
"XX-like"
_
} else if (sum(x$group == "Z") == 1 && !any(x$group == "X")) {
target <-
"Z"
one
copy <-
_
two
copies <-
"ZW-like"
"ZZ-like"
_
} else stop("Label exactly one X or exactly one Z chromosome")
A <- median(x$meandepth[x$group == "A"])
if (!is.finite(A) || A <= 0) stop("No usable autosomal coverage")
x$relative
depth <- x$meandepth / A
_
ratio <- x$relative
depth[x$group == target]
_
call <- if (ratio >= 0.80) two
copies else if (ratio <= 0.65)
_
one
copy else "Ambiguous"
_
if (A < 1) call <-
"Inconclusive: very low autosomal depth"
# Additional Y or W evidence can support, but not prove, a call
partner <- if (target == "X") "Y" else "W"
partner
ratio <- if (partner %in% x$group)
_
x$relative
depth[x$group == partner][1] else NA
real
_
_
_
# Export results and a simple, reproducible figure
dir.create("results"
, showWarnings = FALSE)
write.csv(x,
"results/chromosome
relative
depth.csv"
, row.names = FALSE)
_
_
png("results/chromosome
depth.png"
, width = 1000, height = 580)
_
par(mar = c(8, 4, 3, 1))
barplot(x$relative
depth, names.arg = x$rname, las = 2,
_
ylab = "Depth relative to median autosome"
,
main = "Autosomal and sex-chromosome depth"
, cex.names = 0.75)
abline(h = c(0.5, 1.0), lty = 2)
dev.off()
summary <- c(paste("Median autosome depth:"
, round(A, 3)),
paste(target,
"/ A ratio:"
, round(ratio, 3)),
paste(partner,
"/ A ratio:"
, round(partner
ratio, 3)),
_
paste("Dosage interpretation:"
, call),
"Compare with BioSample sex and discuss limitations.
")
writeLines(summary,
"results/sex
inference.txt")
_
cat(paste(summary, collapse = "\n"),
"\n")
