#!/usr/bin/Rscript

library(edgeR)
library(dplyr)

matrix.path <- "05_rsem_counts/GeneExpressionMatrix.tsv"
sample.path <- "others/sample.csv"
group.deg <- read.table("others/group.csv", sep=",")


ReadExpMatrix <- function(INPUT, SAMPLES) {

    df_exp <- read.delim(INPUT, row.names=1, header=F, skip=1)

    sample.metadata <- read.table(SAMPLES, sep=",")
    colnames(df_exp) <- sample.metadata[,2]

    treatment <- factor(as.vector(sample.metadata[,3]))
    return(DGEList(counts=df_exp, group=treatment))
}


RunEdgeRNorm <- function(y) {
    cpm <- cpm(y)
    keep <- rowSums(cpm > 1) >= 2
    y_expressed <- y[keep, ]
    y_norm <- calcNormFactors(y_expressed)  # Normalizing the data
    d_com <- estimateCommonDisp(y_norm)  # Estimating the Dispersion
    d_mod <- estimateTagwiseDisp(d_com)  # for routine differential expresion analysis
    return(d_mod)
}


# 業務には含まれないためskip
plot_basics <- function() {
    plotMDS(d, ,ethof="bcv", col=as.numeric(d$samples$group))
    legend("bottomleft", as.character(unique(d$samples$group)), col=1:3, pch=20)

    p_bcv <- plotBCV(d_mod)
    pdf(out.bcv)
    print(p_bcv)
    dev.off()
}


main <- function() {
    df <- ReadExpMatrix(matrix.path, sample.path)
    d <- RunEdgeRNorm(y=df)

    for (i in 1:dim(group.deg)[1]) {
        grp <- asplit(as.matrix(group.deg), 1)[[i]] %>% as.vector()
        sample1 <- grp[1]
        sample2 <- grp[2]

        BatchName <- paste0(sample1, "_vs_", sample2)
        par.dir <- file.path("06_diff", BatchName)
        dir.create(par.dir, recursive=T)
        table.path <- file.path(par.dir, paste0(BatchName, ".txt"))

        # 実際の処理
        et <- exactTest(d, pair=c(sample1, sample2))
        final <- topTags(et, n=nrow(et$table))

        write.table(final, file=table.path, sep="\t", append=F, quote=F)
    }
}

main()