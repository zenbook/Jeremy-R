#------------Require packages, if not installed, install it--------------
loadpkg <- function(pkg, url=NULL, repo='cran'){
    # repo accepts cran, github, bioconductor, omegahat
    if (! tolower(repo) %in% c('cran', 'github', 'bioconductor', 'bioc', 'omegahat'))
        stop ('repo only accepts cran, github, bioc(onductor), omegahat!')
    pkg=gsub("\"","",deparse(substitute(pkg)))
    if (! pkg %in% rownames(installed.packages())){
        if (tolower(repo)=='cran'){
            install.packages(pkg,repos=getOption("repos"))
        }else if (tolower(repo)=='github') {
            if (length(unlist(strsplit(url,split="/")))==1) 
                url<-paste(url,pkg,collapse="/")
            if (! 'devtools' %in% rownames(installed.packages()))
                install.packages('devtools')
            require(devtools)
            install_github(url)
        }else if (tolower(repo) %in% c('bioconductor','bioc')){
            source('http://bioconductor.org/biocLite.R')
            biocLite()
            biocLite('pkg')
        }else if (tolower(repo)=='omegahat'){
            if (! 'RCurl' %in% rownames(installed.packages()))
                install.packages('RCurl')
            install.packages(pkg, repos = "http://www.omegahat.org/R", 
                             type = "source")
        }
    }
    require(package=pkg,character.only = TRUE)
}

##----------pre-resiquite functions---------
evalFormula = function(x, data) { # by yihui xie
    if (!inherits(x, 'formula')) return(x)
    if (length(x) != 2) stop('The formula must be one-sided: ', deparse(x))
    eval(x[[2]], data, environment(x))
}
mergeList = function(x, y) { # by yihui xie
    if (!is.list(y) || length(y) == 0) return(x)
    yn = names(y)
    if (length(yn) == 0 || any(yn == '')) {
        warning('The second list to be merged into the first must be named')
        return(x)
    }
    for (i in yn) {
        xi = x[[i]]
        yi = y[[i]]
        if (is.list(xi)) {
            if (is.list(yi)) x[[i]] = mergeList(xi, yi)
        } else x[[i]] = yi
    }
    return(x)
}
isDate <- function(x,format=NULL){
    if (!is.null(format)){
        if (!is(try(as.Date(x),TRUE),"try-error")) TRUE else FALSE
    }else{
        if (!is(try(as.Date(x,format=format),TRUE),"try-error")) TRUE else FALSE
    }
}
isTime <- function(x,origin=NULL,tz='CST'){
    if (is.null(origin)){
        return(FALSE)
    }else{
        if (!is(try(as.POSIXct,T),"try-error")) T else F
    }
}
isLatin <- function(x){
    if (is.factor(x)) x <- as.character(x)
    return(all(grepl("^[[:alnum:][:space:][:punct:]]+$",x,perl=TRUE)))
}
#-----Palettes and others---------
aetnaPal <- function(palname,n=6){
    brewer <- c('BrBG','PiYG','PRGn','PuOr','RdBu','RdGy','RdYlBu',
                'RdYlGn','Spectral','Accent','Dark2','Paired','Pastel1',
                'Pastel2','Set1','Set2','Set3','Blues','BuGn','BuPu',
                'GnBu','Greens','Greys','Oranges','OrRd','PuBu','PuBuGn',
                'PuRd','Purples','RdPu','Reds','YlGn','YlGnBu','YlOrBr',
                'YlOrRd')
    tableau <- data.frame(
        nick=c('tableau20','tableau10medium','tableaugray', 'tableauprgy',
               'tableaublrd','tableaugnor','tableaucyclic','tableau10light', 
               'tableaublrd12','tableauprgy12','tableaugnor12','tableau',
               'tableaucolorblind','trafficlight'),
        pal=c('tableau20','tableau10medium','gray5', 'purplegray6',
              'bluered6','greenorange6','cyclic','tableau10light', 
              'bluered12','purplegray12','greenorange12','tableau10',
              'colorblind10','trafficlight'))
    if (!is.null(palname)) palname <- tolower(palname)
    if (is.null(palname)){
        return(c( '#ff7f50', '#87cefa', '#da70d6', '#32cd32', '#6495ed', 
                  '#ff69b4', '#ba55d3', '#cd5c5c', '#ffa500', '#40e0d0', 
                  '#1e90ff', '#ff6347', '#7b68ee', '#00fa9a', '#ffd700', 
                  '#6b8e23', '#ff00ff', '#3cb371', '#b8860b', '#30e0e0' ))
    }else if (palname %in% paste0("aetna",
                                  c('green','blue','teal','cranberry','orange','violet'))){
        switch(palname,
               aetnagreen=c("#7AC143","#7D3F98","#F47721","#D20962","#00A78E",
                            "#00BCE4","#B8D936","#EE3D94","#FDB933","#F58F9F",
                            "#60C3AE","#5F78BB","#5E9732","#CEA979","#EF4135",
                            "#7090A5"),
               aetnablue=c("#00BCE4","#D20962","#7AC143","#F47721","#7D3F98",
                           "#00A78E","#F58F9F","#B8D936","#60C3AE","#FDB933",
                           "#EE3D94","#5E9732","#5F78BB","#CEA979","#EF4135",
                           "#7090A5"),
               aetnateal=c("#00A78E","#F47721","#7AC143","#00BCE4","#D20962",
                           "#7D3F98","#60C3AE","#FDB933","#B8D936","#5F78BB",
                           "#F58F9F","#EE3D94","#5E9732","#CEA979","#EF4135",
                           "#7090A5"),
               aetnacranberry=c("#D20962","#00BCE4","#7D3F98","#7AC143","#F47721",
                                "#00A78E","#F58F9F","#60C3AE","#EE3D94","#B8D936",
                                "#FDB933","#5E9732","#5F78BB","#CEA979","#EF4135",
                                "#7090A5"),
               aetnaorange=c("#F47721","#7AC143","#00A78E","#D20962","#00BCE4",
                             "#7D3F98","#FDB933","#B8D936","#60C3AE","#F58F9F",
                             "#5F78BB","#EE3D94","#5E9732","#CEA979","#EF4135",
                             "#7090A5"),
               aetnaviolet=c("#7D3F98","#7AC143","#F47721","#00A78E","#00BCE4",
                             "#D20962","#F58F9F","#B8D936","#FDB933","#60C3AE",
                             "#5F78BB","#EE3D94","#5E9732","#CEA979","#EF4135",
                             "#7090A5")
        )
    }else if (palname %in% tolower(brewer)){
        Palname <- brewer[which(tolower(brewer)==palname)]
        loadpkg("RColorBrewer")
        maxcolors <- brewer.pal.info[row.names(brewer.pal.info)==Palname,
                                     "maxcolors"]
        return(brewer.pal(maxcolors,Palname))
    }else{
        if (palname %in% c('rainbow','terrain','topo','heat','cm')){
            switch(palname,
                   rainbow=substr(rainbow(n),1,7),
                   terrain=substr(terrain.colors(n),1,7),
                   heat=substr(heat.colors(n),1,7),
                   topo=substr(topo.colors(n),1,7),
                   cm=substr(cm.colors(n),1,7)
            )
        }else{
            loadpkg("ggthemes")
            loadpkg("scales")
            if (palname %in% c('pander')){
                colObj <- palette_pander(100)
                return(colObj[!is.na(colObj)])
            }else if (palname %in% c('excel',"excel_fill","excel_old","excel_new")){
                palname <- unlist(strsplit(palname,"excel_"))
                colObj <- eval(parse(text=paste0("excel_pal('",
                                                 ifelse(is.na(palname[2]),"line",palname[2]),
                                                 "')(100)")))
                return(colObj[!is.na(colObj)])
            }else if (palname %in% c('economist','economist_white','economist_stata')){
                palname <- unlist(strsplit(palname,"economist_"))
                colObj <- eval(parse(text=paste0("economist_pal(stata=",
                                                 ifelse(palname[2]=='stata',T,F),
                                                 ",fill=",ifelse(palname[2]=='white',F,T),
                                                 ")(100)")))
                return(colObj[!is.na(colObj)])
            }else if (palname %in% c('darkunica')){
                colObj <- eval(parse(text=paste0("hc_pal('",palname,"')(100)")))
                return(colObj[!is.na(colObj)])
            }else if (palname %in% c('wsj','wsj_rgby','wsj_red_green','wsj_black_green',
                                     'wsj_dem_rep')){
                palname <- unlist(strsplit(palname,"wsj_"))
                colObj <- eval(parse(text=paste0("wsj_pal('",
                                                 ifelse(is.na(palname[2]),'colors6',
                                                        palname[2]),"')(100)")))
                return(colObj[!is.na(colObj)])
            }else if (palname %in% c('stata','stata1','stata1r','statamono')){
                palname <- switch(palname, stata='s2color', stata1='s1color',
                                  stata1r='s1rcolor',statamono='mono')
                colObj <- eval(parse(text=paste0("stata_pal('",palname,"')(100)")))
                return(colObj[!is.na(colObj)])
            }else if (palname %in% 
                      c('calc', 'few','fivethirtyeight','gdocs',
                        'stata','hc','colorblind')){
                colObj <- eval(parse(text=paste0(palname,"_pal()(100)")))
                return(colObj[!is.na(colObj)])
            }else if (palname %in% 
                      c('tableau20','tableau10medium','tableaugray', 'tableauprgy',
                        'tableaublrd','tableaugnor','tableaucyclic','tableau10light', 
                        'tableaublrd12','tableauprgy12','tableaugnor12','tableau',
                        'tableaucolorblind','trafficlight')){
                palname <- tableau[tableau$nick==palname,"pal"]
                colObj <- eval(parse(text=paste0("tableau_color_pal(palette='",
                                                 palname,"')(100)")))
                return(colObj[!is.na(colObj)])
            }else if (palname %in% 
                      c('solarized','solarized_red','solarized_yellow',
                        'solarized_orange','solarized_magenta','solarized_violet',
                        'solarized_blue','solarized_cyan','solarized_green')){
                palname <- unlist(strsplit(palname,"solarized_"))
                colObj <- eval(parse(text=paste0("solarized_pal('",
                                                 ifelse(is.null(palname[2]),'blue',palname[2]),
                                                 "')(100)")))
                return(colObj[!is.na(colObj)])
            }
        }
    }
}
rgba <- function(vecrgb){
    if (is.list(vecrgb)) rgb <- as.vector(unlist(vecrgb))
    if (!is.vector(vecrgb)) stop("Must be a vector!")
    if (min(vecrgb,na.rm=TRUE)<0 | max(vecrgb,na.rm=TRUE)>255) {
        stop("All elements should be numeric 0-255!")
    }
    if (length(vecrgb[!is.na(vecrgb)])==3){
        return(rgb(red=vecrgb[1],green=vecrgb[2],blue=vecrgb[3],max=255))
    }else if (length(vecrgb[!is.na(vecrgb)])==4){
        #return(rgb(red=vecrgb[1],green=vecrgb[2],blue=vecrgb[3],alpha=vecrgb[4],
        #           max=255))
        return(paste0('rgba(',vecrgb[1],',',vecrgb[2],',',vecrgb[3],',',
                      as.numeric(vecrgb[4])/255,')'))
    }else{
        stop("Must be of length 3 or 4!")
    }
}
funcPal <- function(palette){ # build a function to extract palette info
    if (length(palette)==1) {
        if (substr(palette,1,1)=="#"){
            if (nchar(palette)==7){
                return(palette)
            }else{
                palette <- paste0('0x',substring(palette,seq(2,8,2),seq(3,9,2)))
                palette <- strtoi(palette)
                return(rgba(palette))
            }
        }else{
            palettes <- unlist(strsplit(palette,"[\\(\\)]",perl=TRUE))
            if (length(palettes)==1){
                return(aetnaPal(palettes[1]))
            }else{
                aetPal <- aetnaPal(palettes[1],as.numeric(palettes[2]))
                if (as.numeric(palettes[2])<length(aetPal)){
                    return(sample(aetPal,as.numeric(palettes[2])))
                }else{
                    return(aetPal)
                }
            }
        }
    }else if(length(palette)>1){
        aetPal <- vector()
        for (i in 1:length(palette)){
            if (!is(try(col2rgb(palette[i]),T),"try-error")){
                if (substr(palette[i],1,1)=="#"){
                    aetPal <- c(aetPal,toupper(palette[i]))
                }else{
                    VecCol <- as.vector(col2rgb(palette[i]))
                    aetPal <- c(aetPal,rgba(VecCol))
                }
            }
        }
        return(aetPal)
    }else{
        return(aetnaPal(NULL))
    }
}
vecPos <- function(pos){
    TblPos=as.data.frame(rbind(c("right","top","horizontal"),
                               c("right","top","vertical"),
                               c("right","center","vertical"),
                               c("right","bottom","vertical"),
                               c("right","bottom","horizontal"),
                               c("center","bottom","horizontal"),
                               c("left","bottom","horizontal"),
                               c("left","bottom","vertical"),
                               c("left","center","vertical"),
                               c("left","top","vertical"),
                               c("left","top","horizontal"),
                               c("center","top","horizontal")),
                         stringsAsFactors=FALSE)
    names(TblPos) <- c("x","y","z")
    return(as.vector(unlist(TblPos[pos,])))
}
#-------table format-----------
tableReheading <- function(dataset, # the dataset to draw table
                           heading, # the heading you want to input
                           # '|' indicates colspan, '=' indicates rowspan
                           footRows=0, # the last several rows as <tfoot>
                           align=c('left',rep('center',ncol-1)), # alignment of columns
                           concatCol=NULL, # index of columns to concatenate
                                           # to make the table look hierachical
                           caption=NULL, # table caption
                           tableWidth='100%'){
    if ((!is.null(dataset) & !is.data.frame(dataset)) | 
        !(is.data.frame(heading) | is.matrix(heading) | is.vector(heading))){
        stop(paste0('`dataset` must be a data.frame, while you gave a ',class(dataset),
                    '\n`heading` must be a vector/matrix/data.frame, while you gave a ',
                    class(heading),"."))
    }else{
        if (is.vector(heading)) heading <- t(matrix(heading))
        if (!is.null(dataset)){
            ncol <- ncol(dataset)
            if (ncol!=ncol(heading)) stop(paste("Not equal counts of columns! Dataset has",
                                          ncol,"cols, while heading has",ncol(heading),'.'))
        }else{
            ncol <- sub('(^[dhr]+?)[^dhr].+$','\\1',gsub('.+?<t([dhr]).+?','\\1',htmltable))
            ncol <- table(strsplit(ncol,"")[[1]])
            ncol <- floor((ncol[['h']]+ncol[['d']])/ncol[['r']])
        }
        align_simp <- substr(tolower(align),1,1)
        if (!all(align_simp %in% c('l','c','r'))){
            stop('`align` only accepts values of "l(eft)", "c(enter)" and "r(ight)".')
        }else{
            align[align_simp=="l"] <- "left"
            align[align_simp=="c"] <- "center"
            align[align_simp=="r"] <- "right"
        }
        if (length(align) > ncol(heading)){
            align <- align[1:ncol(heading)]
        }else if (length(align)<ncol(heading)){
            align <- c(align[1:length(align)],
                       rep(align[length(align)],ncol(heading)-length(align)))
        }
        align_simp <- substr(tolower(align),1,1)
        loadpkg('knitr')
        
        dataset <- as.data.frame(dataset)
        if (!is.null(concatCol)){
            for (icol in concatCol){
                col <- as.character(dataset[,icol])
                lag <- c(NA,as.character(dataset[1:(nrow(dataset)-1),icol]))
                col[col==lag] <- ""
                dataset[,icol] <- col
            }
        }
        
        if (!(is.null(footRows) | footRows==0)){
            if (footRows>=nrow(dataset))
                stop("footRows cannot be >= number of datatable rows!")
            htmlBody <- knitr::kable(dataset[1:(nrow(dataset)-footRows),],
                                     format='html',align=align_simp,row.names=FALSE)
            htmlFoot <- knitr::kable(dataset[(nrow(dataset)-footRows+1):
                                                      nrow(dataset),],
                                     format='html',align=align_simp,row.names=FALSE)
            htmlBody <- gsub("(^.+</tbody>).+$","\\1",htmlBody)
            htmlFoot <- gsub("^.+<tbody>(.+)</tbody>.+$","<tfoot>\\1</tfoot>",htmlFoot)
            htmltable <- paste0(htmlBody,"\n",htmlFoot,"\n</table>")
        }else{
            htmltable <- knitr::kable(dataset,format='html',
                                      align=align_simp,row.names=FALSE)
        }
        
        if (!is.null(caption)){
            htmltable <- gsub("<table>",paste0("<table>\n<caption>",caption,"</caption>"),
                              htmltable)
        }
        class(htmltable) <- 'knitr_kable'
        attributes(htmltable) <- list(format='html',class='knitr_kable')
        rehead <- '<thead>'
        for (j in 1:ncol(heading)){
            if (all(is.na(heading[,j]))){
                heading[1,j] <- '$'
                if (nrow(heading)>1) heading[2:nrow(heading),j] <- "|"
            }
        }
        heading[1,][is.na(heading[1,])] <- "="
        if (nrow(heading)>1){
            heading[2:nrow(heading),][is.na(heading[2:nrow(heading),])] <- "|"
        }
        dthead <- heading
        for (i in 1:nrow(heading)){
            for (j in 1:ncol(heading)){
                dthead[i,j] <- ifelse(heading[i,j] %in% c('|','='),"",
                                      paste0('<th style="text-align:',align[j],';"> ',
                                             heading[i,j],' </th>'))
                if (! heading[i,j] %in% c("|","=")){
                    if (i==1 & heading[i,j]=="$"){
                        dthead[i,j] <- paste0('<th rowspan="',nrow(heading),
                                              '" style="text-align:',align[j],
                                              ';">&nbsp;&nbsp;&nbsp;</th>')
                    }
                    if (j<ncol(heading)) {
                        if (heading[i,j+1] == "="){
                            colspan <- paste0(heading[i,(j+1):ncol(heading)],
                                              collapse="")
                            ncolspan <- nchar(sub("^(=+).*$","\\1",colspan))+1
                            dthead[i,j] <- sub('<th ',paste0('<th colspan="', 
                                                             ncolspan,'" '),
                                               dthead[i,j])
                            dthead[i,j] <- sub('align: *?(left|right)',
                                               paste0('align:center'),
                                               dthead[i,j])
                        }
                    }
                    if (i<nrow(heading)){
                        if (heading[i+1,j] == "|"){
                            rowspan <- paste0(heading[(i+1):nrow(heading),j],
                                              collapse="")
                            nrowspan <- nchar(sub("^(\\|+).*$","\\1",rowspan))+1
                            if (grepl("colspan",dthead[i,j])){
                                if (sum(!heading[i:(i+nrowspan-1),j:(j+ncolspan-1)] 
                                        %in% c('=','|'))==1){
                                    dthead[i,j] <- sub('<th ',paste0('<th rowspan="',
                                                                     nrowspan,'" '),
                                                       dthead[i,j])
                                }else{
                                    dthead[i,j] <- sub('colspan.+?style',
                                                       paste0('rowspan="',
                                                              nrowspan,'" style'),
                                                       dthead[i,j])
                                }
                            }else{
                                dthead[i,j] <- sub('<th ',paste0('<th rowspan="',
                                                                 nrowspan,'" '),
                                                   dthead[i,j])
                            }
                        }
                    }
                }
            }
        }
        for (i in 1:nrow(heading)){
            rehead <- paste0(rehead,'<tr>',paste0(dthead[i,],collapse=""),'</tr>',
                             collapse="")
        }
        rehead <- paste0(rehead,'</thead>')
        rehead <- gsub('<thead>.+</thead>',rehead,htmltable)
        class(rehead) <- class(htmltable)
        attributes(rehead) <- attributes(htmltable)
        return(sub('<table',paste0('<table width=',as.character(tableWidth)),rehead))
    }
}
#------------percent format---------------
pct <- function(vector,digits=0){
    if (is.na(digits)) digits=0
    if (is.numeric(vector)){
        vec <- vector
        vec[which(!vec %in% c(NaN,Inf))] <- 
            sprintf(paste0("%.",digits,"f%%"),100*vector[which(!vec %in% c(NaN,Inf))])
        return(vec)
    }else{
        return(vector)
    }
}
de_pct <- function(vector){
    if (any(grepl("[:space:]*((^\\d+[\\d\\.]\\d+)|\\d+)%$",vector))){
        vec <- vector
        which <- which(grepl("[:space:]*((^\\d+[\\d\\.]\\d+)|\\d+)%$",vector))
        vec[which] <- as.numeric(gsub("[:space:]*(.+)%$","\\1",vector[which]))/100
        vec[!seq_len(length(vec)) %in% which] <- NA
        return(as.numeric(vec))
    }else{
        return(rep(NA,length(vector)))
    }
}
initCap <- function(x) {
    if (is.factor(x)) x <- as.character(x)
    s <- strsplit(x, " ")[[1]]
    paste(toupper(substring(s, 1, 1)), substring(s, 2),
          sep = "", collapse = " ")
}
##-------echartR function---------------
tooltipJS <- function(type){
    switch(type,
           time='function (params) {
           var date = new Date(params.value[0]);
           data = date.getFullYear() + "-"
           + (date.getMonth() + 1) + "-"
           + date.getDate() + " "
           + date.getHours() + ":"
           + date.getMinutes();
           if (param.value.length > 2) {
           return data + "<br/>"
           + params.value[1] + ", "
           + params.value[2];
           } else {
           return data + "<br/>"
           + params.value[1];
           }
}',
           scatter='function (params) {
           if (params.value.length > 1) {
           return params.seriesName + " :<br/>"
           + params.value[0] + " ,    " +
           + params.value[1];
           } else {
           return params.seriesName + " :<br/>"
           + params.name + " : "
           + params.value;
           }
           }',
           chord_mono='function (params) {
           if (params.name && params.name.indexOf("-") != -1) {
           return params.name.replace("-", " " + params.seriesName + " ")
           }
           else {
           return params.name ? params.name : params.data.id
           }
           }',
           chord_multi='function (params) {
           if (params.indicator2) {    // is edge
           return params.indicator2 + " " + 
           params.name + " " + params.indicator + " : " +
           params.value.weight;
           } else {    // is node
           return params.name
           }
           }',
           pie = '{a} <br/>{b} : {c} ({d}%)',
           k='function (params) {
           var res = params[0].name;
           res += "<br/>  Open : " + params[0].value[0] + 
           "  High : " + params[0].value[3];
           res += "<br/>  Close : " + params[0].value[1] + 
           "  Low : " + params[0].value[2];
           return res;
           }',
           hist='function (params){
           return params.value[2] + "<br/>Count:" + 
           params.value[1];
           }'
           )
    }
echartR<-function(data, x=NULL, y, z=NULL, series=NULL, weight=NULL, 
                  xcoord=NULL, ycoord=NULL, x1=NULL, xcoord1=NULL, ycoord1=NULL,
                  type="scatter", stack=FALSE,
                  title=NULL, subtitle=NULL, title_url=NULL, subtitle_url=NULL,
                  symbolList=NULL, dataZoom=NULL, 
                  dataRange=NULL, splitNumber=NULL, dataRangePalette=NULL,
                  xlab=NULL,xAxis=list(lab=xlab,color=NULL,splitLine=TRUE,banded=FALSE,rotate=0), 
                  ylab=NULL,yAxis=list(lab=ylab,color=NULL,splitLine=TRUE,banded=FALSE,rotate=0), 
                  xlab1=NULL, xAxis1=list(lab=xlab1,series=NULL,reverse=FALSE,color=NULL,splitLine=TRUE,
                              banded=FALSE,rotate=0), 
                  ylab1=NULL,yAxis1=list(lab=ylab1,series=NULL,reverse=FALSE,color=NULL,splitLine=TRUE,
                              banded=FALSE,rotate=0), 
                  xyflip=FALSE, AxisAtZero=c(FALSE,TRUE), scale=TRUE,
                  palette='aetnagreen', tooltip=TRUE, legend=TRUE, toolbox=c(TRUE,'cn'), 
                  pos=list(title=6, legend=11, toolbox=1, dataZoom=6, 
                           dataRange=8, roam=2),
                  calculable=TRUE, asImage=FALSE,
                  markLine=NULL, markLinesmooth=NULL, markPoint=NULL, 
                  theme=list(backgroundColor=NULL, borderColor=NULL, 
                             borderWidth=1,width=NULL,height=NULL), ...){
    type <- tolower(type)
    supportedTypes <- c('scatter', 'bar', 'line', 'linesmooth', 'map', 'k', 'pie',
                        'ring', 'rose', 'chordribbon', 'chord', 'area', 'areasmooth', 
                        'force', 'bubble', 'funnel', 'pyramid', 'tree','treemap',
                        'wordcloud', 'heatmap', 'histogram', 'radar', 'radarfill',
                        'gauge'
    )
    if (!type[1] %in% supportedTypes){
        stop("The chart type is not supported! ",
             "we now only support the following charts:\n",
             supportedTypes)
    }
    loadpkg("Hmisc")
    loadpkg("plyr")
    loadpkg("reshape2")
    loadpkg("recharts","yihui/recharts")

    #-----transform var to class(name)-----------
    x <- substitute(x); y <- substitute(y); z <- substitute(z); x1<- substitute(x1)
    series <- substitute(series); weight <- substitute(weight)
    xcoord <- substitute(xcoord); ycoord <- substitute(ycoord)
    xcoord1 <- substitute(xcoord1); ycoord1 <- substitute(ycoord1)
    vArgs <- list(x=x,y=y,z=z,x1=x1,series=series,weight=weight,xcoord=xcoord,
                    ycoord=ycoord,xcoord1=xcoord1,ycoord1=ycoord1)
    for (v in names(vArgs)){
        if (inherits(vArgs[[v]],"name")) vArgs[[v]] <- deparse(vArgs[[v]])
        else if (inherits(vArgs[[v]],"call")) 
            vArgs[[v]] <- gsub("^.*~(.+)$","\\1",deparse(vArgs[[v]]))
    }
    
    #-------if there is timeline, loop over z---------
    Data <- data
    MarkLine <- markLine
    MarkPoint <- markPoint
    if (!is.null(substitute(z))) {
        #zvar <- substr(deparse(z),2,nchar(deparse(z)))
        zvar <- vArgs[['z']]
        z <- Data[,zvar]
        timeslice <- unique(z)
    }
    #----data preProcess-----------
    if (!is.null(substitute(y))) yvar <- vArgs[['y']]
        #yvar <- substr(deparse(y),2,nchar(deparse(y)))
    if (!is.null(substitute(x))) {
        #xvar <- substr(deparse(x),2,nchar(deparse(x)))
        xvar <- vArgs[['x']]
        if (is.factor(data[,xvar])) {
            lvlx <- levels(data[,xvar])
        }else if (is.character(data[,xvar])){
            lvlx <- unique(data[,xvar])
        }
    }
    if (!is.null(substitute(series))) {
        #svar <- substr(deparse(series),2,nchar(deparse(series)))
        svar <- vArgs[['series']]
        if (is.factor(data[,svar])){
            lvlseries <- levels(data[,svar])
        }else{
            lvlseries <- unique(data[,svar])
        }
    }else{
        lvlseries <- NULL
    }
    for (var in names(Data)){  # transform all factors to char
        if (is.factor(Data[,var])) Data[,var]<-as.character(Data[,var])
    }
    if (!is.null(substitute(weight))) #wvar <- substr(deparse(weight),2,nchar(deparse(weight)))
        wvar <- vArgs[['weight']]
    if (!is.null(substitute(xcoord))) #xcoordvar <- substr(deparse(xcoord),2,nchar(deparse(xcoord)))
        xcoordvar <- vArgs[['xcoord']]
    if (!is.null(substitute(x1))) #xvar1 <- substr(deparse(x1),2,nchar(deparse(x1)))
        xvar1 <- vArgs[['x1']]
    if (!is.null(substitute(xcoord1))) #xcoordvar1 <- substr(deparse(xcoord1),2,nchar(deparse(xcoord1)))
        xcoordvar1 <- vArgs[['xcoord1']]
    if (!is.null(substitute(ycoord))) #ycoordvar <- substr(deparse(ycoord),2,nchar(deparse(ycoord)))
        ycoordvar <- vArgs[['ycoord']]
    if (!is.null(substitute(ycoord1))) #ycoordvar1 <- substr(deparse(ycoord1),2,nchar(deparse(ycoord1)))
        ycoordvar1 <- vArgs[['ycoord1']]
    if (!is.null(markLinesmooth)) markLine <- markLinesmooth
    
    if (type[1] %in% c('line','linesmooth','scatter','bubble','area','areasmooth',
                       'bar')){       # only these charts can use double axes
        xAxis1 <- mergeList(list(lab=xlab1,series=NULL,reverse=FALSE,color=NULL,
                                 splitLine=TRUE,banded=FALSE,rotate=0), xAxis1) 
        yAxis1 <- mergeList(list(lab=ylab1,series=NULL,reverse=FALSE,color=NULL,
                                 splitLine=TRUE,banded=FALSE,rotate=0), yAxis1) 
        
        for (lstName in c("xAxis1","yAxis1")){
            objAxis <- eval(parse(text=lstName))
            if (!is.null(lvlseries)){
                if (is.null(objAxis[['series']])){
                    objAxis <- NULL
                }else{
                    for (i in 1:length(objAxis[['series']])){
                        if (!is.na(as.numeric(objAxis[['series']][i]))){ # numeric
                            if (as.numeric(objAxis[['series']][i])>length(lvlseries)){
                                objAxis[['series']][i]<-NA
                            }else{
                                objAxis[['series']][i]<-
                                    lvlseries[as.numeric(objAxis[['series']][i])]
                            }
                        }else{
                            if ((!objAxis[['series']][i] %in% lvlseries)){ # char
                                objAxis[['series']][i]<-NA
                            }
                        }
                    }
                    objAxis[['series']] <- objAxis[['series']][!is.na(objAxis[['series']])]
                }
            }else{
                objAxis <- NULL
            }
            if (lstName=='xAxis1') {
                xAxis1 <- objAxis
                if (is.null(objAxis[['series']]) | 
                    length(objAxis[['series']])==0) xAxis1 <- NULL
            }
            if (lstName=='yAxis1') {
                yAxis1 <- objAxis
                if (is.null(objAxis[['series']]) | 
                    length(objAxis[['series']])==0) yAxis1 <- NULL
            }
        }
    }else{
        xAxis1 <- NULL
        yAxis1 <- NULL
    }
    if (!is.null(xAxis1)) {
        if (xAxis1[['reverse']]){
            if (is.numeric(data[,xvar])) {
                data[data[,svar] %in% xAxis1[['series']],xvar] <- 
                    -data[data[,svar] %in% xAxis1[['series']],xvar]
            }
        }
    }
    if (!is.null(yAxis1)){
        if (yAxis1[['reverse']]){
            if (is.numeric(data[,yvar])) {
                data[data[,svar] %in% yAxis1[['series']],yvar] <- 
                    -data[data[,svar] %in% yAxis1[['series']],yvar]
            }
        }
    }
    #---------------------------------------------------------#
    #                       Loop over Z                       |
    #---------------------------------------------------------#
    for (t in 1:ifelse(is.null(z),1,length(timeslice)))  { 
        
        #-------pre-process of data-----------
        if (!is.null(z)) data <- Data[Data[,zvar]==timeslice[t],]
        if (!is.null(y)) y <- data[,yvar]
        if (!is.null(x)) x <- data[,xvar]
        if (!is.null(series)) series <- data[,svar]
        if (!is.null(weight)) weight <- data[,wvar]
        if (!is.null(xcoord)) xcoord <- data[,xcoordvar]
        if (!is.null(x1)) x1 <- data[,xvar1]
        if (!is.null(xcoord1)) xcoord1 <- data[,xcoordvar1]
        if (!is.null(ycoord)) ycoord <- data[,ycoordvar]
        if (!is.null(ycoord1)) ycoord1 <- data[,ycoordvar1]
        if (type[1] %in% c('bubble') & is.null(weight)){
            wvar <- yvar
            weight <- y
        }
        
        if (type[1] %in% c('pie','ring','rose','funnel','pyramid')){
            if (is.null(series) & !is.null(x)){
                svar <- xvar
                data[,svar] <- x
                series <- x
            }
            series <- as.factor(series)
            lvlseries <- levels(series)
            data <- data[,c(svar,yvar)]
            if (is.factor(y) | is.character(y)){
                data <- dcast(data,data[,1]~.,value.var=yvar,length)
            }else{
                data <- dcast(data,data[,1]~.,value.var=yvar,sum)
            }
            names(data) <- c(svar,yvar)
        }else if (type[1] %in% c("histogram")){
            if (is.null(splitNumber)){
                nbreaks=10
            }else{
                nbreaks=ifelse(splitNumber[1]==1,10,splitNumber[1]+1)
            }
            interval <- (max(y)-min(y)) / (nbreaks-1)
            cut <- seq(from=min(y),to=max(y),length.out=nbreaks)
            cut <- round(cut,ifelse(interval>1,1,1+ceiling(log10(1/interval))))
            hist <- hist(data[,yvar],breaks=cut,plot=FALSE)
            hist_def <- hist(y,breaks=nbreaks-1,plot=FALSE)
            valRange <- max(hist_def$breaks)-min(hist_def$breaks)
            x1 <- vector()
            for (i in 1:length(hist$breaks)-1){
                x1[i] <- paste(hist$breaks[i],hist$breaks[i+1],sep="-")
            }
            data <- data.frame(x=hist$mids,y=hist$counts,x1=x1)
            xvar <- yvar; yvar <- "Freq"; xvar1 <- "Breaks"
            names(data) <- c(xvar,yvar,xvar1)
            x <- data[,xvar]; y <- data[,yvar]
        }else if (type[1] %in% c('line','linesmooth')){
            if (is.numeric(x)) {
                data[,xvar] <- x <- as.character(x)
            }
        }else if (type[1] %in% c('force')){
            dtlink <- as.data.frame(matrix(unlist(strsplit(x,"/")),
                                           byrow=TRUE,nrow=nrow(data)),stringsAsFactors=FALSE)
            dtnodeval <- as.data.frame(matrix(unlist(strsplit(x1,"/")),
                                              byrow=TRUE,nrow=nrow(data)),stringsAsFactors=FALSE)
            dtcatg <- as.data.frame(matrix(unlist(strsplit(series,"/")),
                                           byrow=TRUE,nrow=nrow(data)),stringsAsFactors=FALSE)
            dtlink <- cbind(dtlink,y)
            names(dtlink) <- c("from","to","relation","y")
            names(dtnodeval) <- c("value1","value2")
            names(dtcatg) <- c("catg1","catg2")
            lvlseries <- unique(c(unique(dtcatg[,1]),unique(dtcatg[,2])))
            dtnode <- cbind(dtlink,dtnodeval,dtcatg)
            dtnode <- rbind(as.matrix(dtnode[,c('from','value1','catg1')]),
                            as.matrix(dtnode[,c('to','value2','catg2')]))
            dtnode <- unique(as.data.frame(dtnode))
            names(dtnode) <- c("name","value","category")
            rm(dtnodeval,dtcatg)
        }
        #-------check invalid input---------
        if (!all(as.numeric(pos) %in% 1:12)) stop("list pos must be all integers 1-12")
        pos <- mergeList(list(title=6, legend=11, toolbox=1, dataZoom=6, dataRange=8, 
                              roam=2),pos)
        
        #---------timeline--------------
        if (!is.null(z)){
            lstTimeline <- list(data=timeslice,autoPlay=TRUE,playInterval=2000)
            if (!is.null(title) & pos[['title']] %in% 5:7) lstTimeline[['y2']] <- 50
            if (!is.null(dataZoom) & pos[['dataZoom']] %in% 5:7) {
                lstTimeline[['y2']] <- ifelse(is.null(lstTimeline[['y2']]),0,
                                              lstTimeline[['y2']])+ 30
            }
        }
        
        # -----Color--------
        if (is.null(palette)){
            lstColor <- as.list(funcPal(NULL))
        }else{
            nColor <- as.numeric(unlist(strsplit(palette,"[\\(\\)]",perl=TRUE))[2])
            if (!is.na(nColor) & nColor < ifelse(is.null(series),1,length(lvlseries))){
                palette <- unlist(strsplit(palette,"[\\(\\)]",perl=TRUE))[1]
            }
            lstColor <- as.list(funcPal(palette))
        }
        
        #--------Title and subtitle--------
        lstTitle=list()
        lstTitle <- list(text=ifelse(is.null(title),"",title),
                         subtext=ifelse(is.null(subtitle),"",subtitle))
        lstTitle[['x']] <- vecPos(pos[['title']])[1]
        lstTitle[['y']] <- vecPos(pos[['title']])[2]
        lstTitle[['orient']] <- vecPos(pos[['title']])[3]
        if (!is.null(title_url)) lstTitle[['link']] <- title_url
        if (!is.null(subtitle_url)) lstTitle[['sublink']] <- subtitle_url
        if (!is.null(z)) lstTitle[['text']] <- 
            paste0(lstTitle[['text']], " (",zvar," = ",timeslice[t],")")
        
        #-------Tooltip--------------
        if (tooltip){
            lstTooltip <- list(
                trigger = ifelse(type[1] %in% c('pie','ring','funnel','pyramid','map',
                                              'rose','wordcloud','radar','radarfill',
                                              'chord','chordribbon','force','gauge'),
                               'item','axis'),
                axisPointer = list(
                    show = TRUE,lineStyle = list(type = 'dashed',width = 1)
                )
            )
            if (inherits(x,c('POSIXlt','POSIXct','Date'))){
                lstTooltip[['trigger']] <- 'item'
                lstTooltip[['formatter']] <- JS(tooltipJS('time'))
            }
            if (type[1] %in% c('scatter','bubble')){
                if (!is.null(series)){
                    lstTooltip[['formatter']] <- JS(tooltipJS('scatter'))
                }
                lstTooltip[['axisPointer']] <- list(
                    show= T,type='cross',lineStyle= list(type= 'dashed',width= 1)
                )
            }else if (type[1] %in% c('ring','pie')){
                lstTooltip[['formatter']] <- tooltipJS('pie')
            }else if (type[1] %in% c('chord','chordribbon','force')){
                if (!is.null(series)){
                    lstTooltip[['formatter']] <- JS(tooltipJS('chord_mono'))
                }else{
                    lstTooltip[['formatter']] <- JS(tooltipJS('chord_multi'))
                }
            }else if (type[1]=='k'){
                lstTooltip[['formatter']] <- JS(tooltipJS('k'))
            }else if (type[1]=='histogram'){
                lstTooltip[['formatter']] <- JS(tooltipJS('hist'))
            }
        }else{
            lstTooltip = list(show=FALSE)
        }
        
        #-------------Toolbox----------------
        if (toolbox[1]){
            lstToolbox= list(
                show = TRUE,
                feature = list(
                    mark =list(show= TRUE),
                    dataZoom = list(show=TRUE),
                    dataView = list(show= TRUE, readOnly= FALSE),
                    magicType = list(show=FALSE),
                    restore = list(show= TRUE),
                    saveAsImage = list(show= TRUE)
                )
            )
            if (tolower(toolbox[2]!='cn')){
                lstToolbox$feature <- list(
                    mark =list(show= TRUE,
                               title=list(mark="Apply Auxiliary Conductor",
                                          markUndo="Undo Auxiliary Conductor",
                                          markClear="Clear Auxiliary Conductor")),
                    dataZoom = list(show=TRUE, title=
                                        list(dataZoom="Data Zoom",
                                             dataZoomReset="Reset Data Zoom")),
                    dataView = list(show= TRUE, readOnly= FALSE,
                                    title="Data View"),
                    magicType = list(show=FALSE),
                    restore = list(show= TRUE,title="Restore"),
                    saveAsImage = list(show= TRUE,title="Save As Image")
                )
            }
            
            lstToolbox[['x']] <- vecPos(pos[['toolbox']])[1]
            lstToolbox[['y']] <- vecPos(pos[['toolbox']])[2]
            lstToolbox[['orient']] <- vecPos(pos[['toolbox']])[3]
            
            if (type[1] %in% c('line','linesmooth','bar','area','areasmooth','k',
                               'histogram')){
                lstToolbox[['feature']][['magicType']] <- 
                    list(show=TRUE, type= c('line','bar','tiled','stack'))
            }else if (type[1] %in% c('ring','pie','rose')){
                lstToolbox[['feature']][['magicType']] <- 
                    list(show=TRUE, type= c('pie','funnel'),
                         option=list(funnel=list(x='25%',width='80%',
                                                 funnelAlign='center')))
            }else if (type[1] %in% c('force','chord','chordribbon')){
                lstToolbox[['feature']][['magicType']] <- 
                    list(show=TRUE, type= c('force','chord'))
                lstToolbox[['feature']][['dataView']]<-list(show=FALSE)
                lstToolbox[['feature']][['dataZoom']]<-list(show=FALSE)
            }
            if (lstToolbox[['feature']][['magicType']][['show']]){
                if (tolower(toolbox[2]!='cn')){
                    lstToolbox[['feature']][['magicType']][['title']] <- list(
                        line="Switch to Line Chart",
                        bar="Switch to Bar Chart",
                        stack="Stack", 
                        tiled="Tiled",
                        force="Switch to Force Chart",
                        chord="Switch to Chord Chart",
                        pie="Switch to Pie Chart",
                        funnel="Switch to Funnel Chart"
                    )
                }
            }
        }else{
            lstToolbox=list(show=FALSE)
        }
        
        #----------dataZoom----------
        lstdataZoom <- NULL
        
        if (!is.null(dataZoom)) {
            lstdataZoom <- list(show=TRUE)
            if (pos[['dataZoom']] %in% c(8:10)){
                lstdataZoom[['x']] <- 0
            }else if (pos[['dataZoom']] %in% c(11:12,1,5:7)){
                lstdataZoom[['x']] <- 80
            }else if (pos[['dataZoom']] %in% c(2:4)){
                lstdataZoom[['x']] <- dev.size('px')[1]-80
            }
            if (pos[['dataZoom']] %in% c(8:10,2:4)){
                lstdataZoom[['y']] <- 60
            }else if (pos[['dataZoom']] %in% c(11:12,1)){
                lstdataZoom[['y']] <- 30
            }else if (pos[['dataZoom']] %in% 5:7){
                if (!is.null(title) & pos[['title']] %in% 5:7){
                    lstdataZoom[['y']] <- dev.size('px')[2]-60
                }
            }
            lstdataZoom[['orient']] <- vecPos(pos[['dataZoom']])[3]
            if (all(is.numeric(dataZoom))){
                if (any(!dataZoom>=0 | !dataZoom<=100)){
                    stop("dataZoom should be between 0 and 100")
                }else{
                    lstdataZoom[['start']] <- min(dataZoom[1],dataZoom[2])
                    lstdataZoom[['end']] <- max(dataZoom[1],dataZoom[2])
                }
            }
        }
        
        
        #--------dataRange-----------
        lstdataRange <- NULL
        if (!is.null(dataRange)) {
            if (!all(is.na(y))) {
                dRange <- dcast(data,data[,xvar]~., value.var=yvar, sum)
            }else{
                dRange <- matrix(rep(NA,2),ncol=2)
            }
            if (!is.null(markLine)) {
                dRange1 <- range(as.numeric(markLine[,3]))
            }else{
                dRange1 <- range(dRange[,2])
            }
            if (!is.null(markPoint)) {
                dRange2 <- range(as.numeric(markPoint[,3]))
            }else{
                dRange2 <- range(dRange[,2])
            }
            dmin <- min(dRange[,2],dRange1[1],dRange2[1],na.rm=TRUE)
            dmax <- max(dRange[,2],dRange1[2],dRange2[2],na.rm=TRUE)
            if (!is.null(dataRangePalette)){
                lstdataRangePalette <- funcPal(dataRangePalette)
            }
            rangeminpoint <- rangemaxpoint <- NULL
            if (length(dataRange)==2){
                if (!is.logical(dataRange[1]) && !is.na(as.numeric(dataRange[1]))) {
                    rangemaxpoint=as.numeric(dataRange[1])
                    dataRange <- c("",dataRange[2])
                }
                if (!is.logical(dataRange[2]) &&!is.na(as.numeric(dataRange[2]))) {
                    rangeminpoint=as.numeric(dataRange[2])
                    dataRange <- c(dataRange[1],"")
                }
            }else{
                if (!is.logical(dataRange) && !is.na(as.numeric(dataRange)))  {
                    rangemaxpoint=as.numeric(dataRange)
                    dataRange=c("","")
                }else{
                    dataRange=c(dataRange,"")
                }
            }
            
            lstdataRange <- list(
                show=TRUE, calculable=ifelse(as.numeric(splitNumber[1])==0 | 
                                                 is.null(splitNumber),calculable,FALSE),
                text=as.vector(dataRange), itemGap=5,
                min= ifelse(dmin>=0 && (dmin-ceiling((dmax-dmin)/10)<0),
                            0, dmin-ceiling((dmax-dmin)/10)),
                max=dmax+ceiling((dmax-dmin)/10),
                color=lstdataRangePalette,
                splitNumber=ifelse(is.null(splitNumber),0,
                                   as.numeric(splitNumber[1])),
                x= vecPos(pos[['dataRange']])[1],
                y= vecPos(pos[['dataRange']])[2],
                orient= vecPos(pos[['dataRange']])[3]
            )
            if (!is.null(rangeminpoint) | !is.null(rangemaxpoint)){
                lstdataRange[['range']] <- list(start=0,end=100)
                lstdataRange[['calculable']] <- TRUE
                if (!is.null(rangeminpoint)) {
                    lstdataRange[['range']][['start']] <- 
                        100*(rangeminpoint-lstdataRange[['min']])/
                        (lstdataRange[['max']]-lstdataRange[['min']])
                }
                if (!is.null(rangemaxpoint)) {
                    lstdataRange[['range']][['end']] <- 
                        100*(rangemaxpoint-lstdataRange[['min']])/
                        (lstdataRange[['max']]-lstdataRange[['min']])
                }
            }
            if (length(splitNumber)>1){ # split List
                splitNumber <- splitNumber[order(splitNumber,decreasing=TRUE)]
                splitList <- list(list(start=splitNumber[1]))
                for (rank in 1:(length(splitNumber)-1)){
                    splitList[[rank+1]] <- list(start=splitNumber[rank+1],
                                                end=splitNumber[rank])
                }
                splitList[[length(splitNumber)+1]] <- 
                    list(end=splitNumber[length(splitNumber)])
                lstdataRange[['calculable']] <- lstdataRange[['splitNumber']] <- NULL
                lstdataRange[['min']] <- lstdataRange[['max']] <- NULL
                lstdataRange[['text']] <- NULL
                lstdataRange[['splitList']] <- splitList
            }
        }
        
        #---------Grid------------------
        lstGrid <- NULL
        bottomSpace <- 20
        if (pos[['title']] %in% 5:7) {
            bottomSpace <- 60
            if (!is.null(subtitle)) bottomSpace <- bottomSpace+20
        }
        if (!is.null(z)) bottomSpace <- bottomSpace + 50
        if (!is.null(dataZoom) && pos[['dataZoom']] %in% 5:7){
            bottomSpace <- bottomSpace + 30
        }
        lstGrid <- list(y2=ifelse(bottomSpace<60,60,bottomSpace))
        if (type[1] %in% c('pie','ring','rose','funnel','pyramid','map','chord','force',
                           'chordribbon','radar','radarfill','wordcloud','gauge')){
            lstGrid <- NULL
        }
        
        #------------Axis-------------
        if (length(AxisAtZero)==1) AxisAtZero <- rep(AxisAtZero,2)
        AxisAtZero <- as.logical(AxisAtZero)
        for (i in 1:2) if(is.na(AxisAtZero[i])) AxisAtZero[i] <- switch(i,FALSE,TRUE)
        xAxis <- mergeList(list(lab=xlab,color=NULL,splitLine=TRUE,banded=FALSE,rotate=0),
                           xAxis)
        yAxis <- mergeList(list(lab=ylab,color=NULL,splitLine=TRUE,banded=FALSE,rotate=0),
                           yAxis)
#         if (!is.null(xlab)) xAxis[['lab']]<-xlab
#         if (!is.null(ylab)) yAxis[['lab']]<-ylab
        if (!is.null(xlab1) & !is.null(xAxis1)) xAxis1[['lab']]<-xlab1
        if (!is.null(ylab1) & !is.null(yAxis1)) yAxis1[['lab']]<-ylab1
        
        for (i in 1:ifelse(is.null(xAxis1),1,2)){  # xAxises
            if (i==1) {
                varXAxis <- xAxis
            }else if (i==2){
                varXAxis <- xAxis1
            }
            tmpXAxis = list(
                name = ifelse(is.null(varXAxis[['lab']]),xvar,varXAxis[['lab']]),
                type = ifelse(inherits(x,c('POSIXct','POSIXlt','Date')),'time',
                              ifelse(!is.numeric(x),'category','value')),
                scale = scale)
            if (tmpXAxis[['type']]=='category'){
                if (length(unique(as.character(x)))==1){
                    tmpXAxis[['data']] <- list(unique(as.character(x)))
                }else{
                    tmpXAxis[['data']] <- unique(as.character(x))
                }
            }else{
                if (min(x,na.rm=TRUE)>0 & AxisAtZero[1]) tmpXAxis[['min']] <- 0
            }
            if (type[1] %in% c('line','linesmooth','area','areasmooth')){
                tmpXAxis[['boundaryGap']] <- FALSE
            }else if (type[1] %in% c('k')){
                tmpXAxis[['axisTick']] <- list(onGap=FALSE)
            }else if (type[1]=='histogram'){
                tmpXAxis[['min']] <- min(hist_def$breaks)
                tmpXAxis[['max']] <- max(hist_def$breaks)
            }
            tmpXAxis[['axisLabel']] <- list(interval=0)
            if (!is.null(varXAxis[['reverse']])){
                if (varXAxis[['reverse']]) {
                    tmpXAxis[['axisLabel']][['formatter']] <- JS('function(v){return -v;}')
                }
            }
            if (is.null(varXAxis[['color']])) {
                varXAxis[['color']] <- '#4488bb'
                tmpXAxis[['axisLine']] <- list(
                    show=TRUE, onZero=AxisAtZero[1], 
                    lineStyle=list(color=varXAxis[['color']]))
            }else {
                if (varXAxis[['color']]=='none'){
                    tmpXAxis[['axisLine']] <- list(show=FALSE)
                    if (!is.null(lstGrid)) lstGrid[['borderWidth']] <- 0
                }else if (!is(try(col2rgb(varXAxis[['color']])),'try-error')){
                    tmpXAxis[['axisLine']] <- list(
                        show=TRUE, onZero=AxisAtZero[1],
                        lineStyle=list(color=varXAxis[['color']]))
                }
            }
            tmpXAxis[['splitArea']]<-list(show=ifelse(varXAxis[['banded']],TRUE,FALSE))
            if (abs(as.numeric(varXAxis[['rotate']]))<=90){
                if (is.null(tmpXAxis[['axisLabel']])) tmpXAxis[['axisLabel']]<-list()
                tmpXAxis[['axisLabel']][['rotate']] <- varXAxis[['rotate']]
            }
            if (is.null(xAxis1)) {
                lstXAxis <- tmpXAxis
            }else{
                if (i==1) lstXAxis <- list(list())
                lstXAxis[[i]] <- tmpXAxis
            }
        }
        
        for (i in 1:ifelse(is.null(yAxis1),1,2)){ # yAxises
            if (i==1) {
                varYAxis <- yAxis
            }else if (i==2){
                varYAxis <- yAxis1
            }
            tmpYAxis = list(
                name = ifelse(is.null(varYAxis[['lab']]),yvar,varYAxis[['lab']]),
                type = 'value',
                scale = scale
            )
            if (min(y,na.rm=TRUE)>0 && AxisAtZero[2]) tmpYAxis[['min']] <- 0
            if (max(y,na.rm=TRUE)==1 && min(y,na.rm=TRUE)>=0) {
                tmpYAxis[['max']] <- 1
                tmpYAxis[['min']] <- 0
            }
            
            if (!is.null(varYAxis[['reverse']])){
                if (varYAxis[['reverse']]) {
                    if (is.null(tmpYAxis[['axisLabel']])) tmpYAxis[['axisLabel']] <- list()
                    tmpYAxis[['axisLabel']][['formatter']] <- JS('function(v){return -v;}')
                }
            }
            if (is.null(varYAxis[['color']])) {
                varYAxis[['color']] <- '#4488bb'
                tmpYAxis[['axisLine']] <- list(
                    show=TRUE, onZero=AxisAtZero[2],
                    lineStyle=list(color=varYAxis[['color']]))
            }else {
                if (varYAxis[['color']]=='none'){
                    tmpYAxis[['axisLine']] <- list(show=FALSE)
                    if (is.null(xAxis1)) {
                        lstXAxis[['splitLine']]<-list(show=FALSE)
                    }else{
                        lstXAxis[[i]][['splitLine']]<-list(show=FALSE)
                    }
                    if (!is.null(lstGrid)) lstGrid[['borderWidth']] <- 0
                }else if (!is(try(col2rgb(varYAxis[['color']])),'try-error')){
                    tmpYAxis[['axisLine']] <- list(
                        show=TRUE, onZero=AxisAtZero[2], 
                        lineStyle=list(color=varYAxis[['color']]))
                    if (is.null(xAxis1)) {
                        lstXAxis[['splitLine']]<-list(show=ifelse(varYAxis[['splitLine']],TRUE,FALSE))
                    }else{
                        lstXAxis[[i]][['splitLine']]<-list(show=ifelse(varYAxis[['splitLine']],TRUE,FALSE))
                    }
                }
            }
            tmpYAxis[['splitArea']]<-list(show=ifelse(varYAxis[['banded']],TRUE,FALSE))
            
            if (abs(as.numeric(varYAxis[['rotate']]))<=90){
                if (is.null(tmpYAxis[['axisLabel']])) tmpYAxis[['axisLabel']]<-list()
                tmpYAxis[['axisLabel']][['rotate']] <- varYAxis[['rotate']]
            }
            if (is.null(yAxis1)) {
                lstYAxis <- tmpYAxis
            }else{
                if (i==1) lstYAxis <- list(list())
                lstYAxis[[i]] <- tmpYAxis
            }
        }
        
        for (i in 1:ifelse(is.null(xAxis1),1,2)){  # Continue to revise yAxis
            if (i==1) {
                varXAxis <- xAxis
            }else if (i==2){
                varXAxis <- xAxis1
            }
            if (!is.null(varXAxis[['color']])){
                if (varXAxis[['color']]=='none'){
                    if (is.null(yAxis1)) {
                        lstYAxis[['splitLine']]<-list(show=FALSE)
                    }else{
                        lstYAxis[[i]][['splitLine']]<-list(show=FALSE)
                    }
                }else if (!is(try(col2rgb(varXAxis[['color']])),'try-error')){
                    if (is.null(yAxis1)) {
                        if (is.null(lstYAxis)) lstYAxis <- list()
                        lstYAxis[['splitLine']]<-list(show=ifelse(varXAxis[['splitLine']],T,F))
                    }else{
                        if (is.null(lstYAxis)) lstYAxis <- list(list(),list())
                        lstYAxis[[i]][['splitLine']]<-list(show=ifelse(varXAxis[['splitLine']],T,F))
                    }
                }
            }
        }
        if (!is.null(xAxis1)) lstYAxis[['axisLine']][['onZero']] <- FALSE
        else lstYAxis[['axisLine']][['onZero']] <- AxisAtZero[2]
        if (!is.null(yAxis1)) lstXAxis[['axisLine']][['onZero']] <- FALSE
        else lstXAxis[['axisLine']][['onZero']] <- AxisAtZero[1]
        
        if (xyflip){ #exchange settings of xAxis and yAxis
            tmp <- lstYAxis
            lstYAxis <- lstXAxis
            lstXAxis <- tmp
            rm(tmp)
        }
        
        #if (lstXAxis[['type']]=='time' | lstYAxis[['type']]=='time'){
        #    lstToolbox[['feature']][['magicType']] <- list(show=FALSE)
        #    if (lstXAxis[['type']]=='time') {
        #        lstXAxis[['boundaryGap']] <- NULL
        #    }
        #    if (lstYAxis[['type']]=='time') {
        #        lstYAxis[['boundaryGap']] <- NULL
        #    }
        #}
        
        #------Legend 1------------
        if (is.null(series)){
            lstLegend= list(show=TRUE, data=as.list(ifelse(is.null(xAxis$lab),
                                                           xvar,xAxis$lab)))
        }else{
            lstLegend= list(show=TRUE, data=lvlseries)
        }
        if (length(legend)==1){
            if (legend==FALSE){
                lstLegend[['show']] <- FALSE
            }
        }
        lstLegend[['x']] <- vecPos(pos[['legend']])[1]
        lstLegend[['y']] <- vecPos(pos[['legend']])[2]
        lstLegend[['orient']] <- vecPos(pos[['legend']])[3]
        
        #----------polar---------------
        if (type[1] %in% c('radar','radarfill')){
            x <- factor(x,levels=unique(x))
            indicator <- levels(x)
            lstPolar <- list(list(radius='70%', indicator=list()))
            for (i in 1:length(indicator)){
                lstPolar[[1]][['indicator']][[i]] <- list(
                    text = as.character(indicator[i]),
                    max = max(data[data[,xvar]==indicator[i],yvar]) * 1.25
                )
            }
        }
        
        #------------Series---------------
        lstSeries <- list()
        if (inherits(x,c('POSIXct','POSIXlt','Date'))) {
            x<- data[,xvar] <- format(data[,xvar],tz="GMT+8",format=
                                          "%a %b %d %Y %H:%M:%S GMT+0800 (China Standard Time)")
        }
        y[is.na(y)] <- data[is.na(data[,yvar]),yvar] <- '-'  
        if (is.null(weight)){
            symbolSizeFold <- 1
        }else{
            symbolSizeFold <- ifelse(max(weight)>50,1/ceiling(max(weight)/50),
                                     ceiling(2/min(weight)))
        }
        
        if (type[1] %in% c('scatter','bubble')){
            if (is.null(series)){
                lstSeries[[1]] <- list(
                    type='scatter', name=ifelse(is.null(xAxis$lab),xvar,xAxis$lab),
                    data=as.matrix(data[,c(xvar,yvar)]),
                    large=ifelse(nrow(data)>2000,TRUE,FALSE)
                )
                if (type[1]=='bubble'){
                    lstSeries[[1]][['data']] <-
                        as.matrix(data[,c(xvar,yvar,wvar)])
                    lstSeries[[1]][['symbolSize']] <- 
                        JS('function (value){
                           return Math.round(value[2]*',symbolSizeFold,');}')
            }
                }else{
                    for (i in 1:ifelse(is.null(series),1,length(lvlseries))){
                        lstSeries[[i]] <- list(
                            type='scatter',name=lvlseries[i],
                            data=as.matrix(data[data[,svar]==
                                                    lvlseries[i],
                                                c(xvar,yvar)]),
                            large=ifelse(nrow(data)>2000,TRUE,FALSE)
                        )
                        if (length(lvlseries)>1){
                            #lstSeries[[i]][['name']] <- as.vector(lvlseries[i])
                            if (lvlseries[i] %in% xAxis1[['series']]){
                                lstSeries[[i]][['xAxisIndex']] <-1
                            }
                            if (lvlseries[i] %in% yAxis1[['series']]){
                                lstSeries[[i]][['yAxisIndex']] <-1
                            }
                        }
                        if (type[1]=='bubble'){
                            lstSeries[[i]][['data']] <-
                                as.matrix(data[data[,svar]==
                                                   lvlseries[i],
                                               c(xvar,yvar,wvar)])
                            lstSeries[[i]][['symbolSize']] <- 
                                JS('function (value){
                                   return Math.round(value[2]*',symbolSizeFold,');}')
                    }
                        }
                    }
            }else if (type[1] %in% c('ring','pie','rose')){
                lstSeries[[1]] <- list(
                    name=svar,
                    type='pie',
                    data=list()
                )
                if (type[1]=='ring'){
                    lstSeries[[1]][['radius']] <- c('50%','70%')
                    if (!is.null(z)) {
                        lstSeries[[1]][['center']] <- c('50%','45%')
                        lstSeries[[1]][['radius']] <- c('40%','60%')
                    }
                    lstSeries[[1]][['itemStyle']] <- list(
                        emphasis = list(
                            label=list(
                                show=TRUE, position='center',
                                textStyle=list(fontSize='30',fontWeight='bold')
                            )
                        )
                    )
                }else{
                    lstSeries[[1]][['radius']] <- '70%'
                    lstSeries[[1]][['center']] <- c('50%','50%')
                    if (!is.null(z)) {
                        lstSeries[[1]][['center']] <- c('50%','45%')
                        lstSeries[[1]][['radius']] <- '60%'
                    }
                    if (type[1]=='rose'){
                        lstSeries[[1]][['roseType']] <- 'radius'
                    }
                }
                for (i in 1:nrow(data)){
                    lstSeries[[1]][['data']][[i]]<- list(
                        value=data[i,yvar],name=as.character(data[i,svar])
                    )
                }
    }else if (type[1] %in% c('funnel','pyramid')){
        lstSeries[[1]] <- list(
            name=svar,
            type='funnel',
            data=list()
        )
        if (type[1]=='funnel'){
            lstSeries[[1]][['x']] <- '10%'
        }else{
            lstSeries[[1]][['x']] <- '25%'
            lstSeries[[1]][['sort']] <- 'ascending'
        }
        for (i in 1:nrow(data)){
            lstSeries[[1]][['data']][[i]]<- list(
                value=data[i,yvar],name=as.character(data[i,svar])
            )
        }
    }else if (type[1] %in% c('wordcloud')){
        lstSeries[[1]] <- list(
            name=ifelse(is.null(xAxis$lab),xvar,xAxis$lab),
            type='wordCloud',
            size=c('80%','80%'),
            textRotation=c(0,45,90,-45),
            textPadding=0,
            autoSize=list(enable=TRUE,minSize=10),
            data=list()
        )
        for (i in 1:nrow(data)){
            lstSeries[[1]][['data']][[i]]<- list(
                value=data[i,yvar],name=as.character(data[i,xvar]),
                itemStyle=list(normal=list(color=sample(unlist(lstColor),1)))
            )
        }
    }else if (type[1] %in% c('line','area','linesmooth','areasmooth')){
        #---------reformat missing value----------
        #y[is.na(y)] <- data[is.na(data[,yvar]),yvar] <- '-'  
        #print(yvar)
        #print(t)
        #print(data[,yvar])
        if (is.null(series)){ # single serie
            lstSeries[[1]] <- list(
                type='line',name=ifelse(is.null(xAxis$lab),xvar,xAxis$lab),
                data=data[,yvar]
            )
            if (type[1] %in% c("area",'areasmooth')){
                lstSeries[[1]][['itemStyle']] <-
                    list(normal=list(areaStyle=list(type='default')))
            }
            if (type[1] %in% c('linesmooth','areasmooth')){
                lstSeries[[1]][['smooth']] <- TRUE
            }
            #if (lstXAxis[['type']]=='time' || lstYAxis[['type']]=='time'){
            #    lstSeries[[1]][['name']] <- yvar
            #    #lstSeries[[1]][['showAllSymbol']] <- T
            #    lstSeries[[1]][['data']] <- as.matrix(data[,c(xvar,yvar)])
            #}
        }else{  # multiple series
            for (i in 1:ifelse(is.null(series),1,length(lvlseries))){
                lstSeries[[i]] <- list(
                    name=as.vector(lvlseries[i]),
                    type='line',
                    data= data[data[,svar]==lvlseries[i],yvar]
                )
                if (lvlseries[i] %in% xAxis1[['series']]){
                    lstSeries[[i]][['xAxisIndex']] <-1
                }
                if (lvlseries[i] %in% yAxis1[['series']]){
                    lstSeries[[i]][['yAxisIndex']] <-1
                }
                if (stack) lstSeries[[i]][['stack']] <- 'Stack'
                if (type[1] %in% c("area",'areasmooth')){
                    lstSeries[[i]][['itemStyle']] <-
                        list(normal=list(areaStyle=list(type='default')))
                }
                if (type[1] %in% c('linesmooth','areasmooth')) {
                    lstSeries[[i]][['smooth']] <- TRUE
                }
                #if (lstXAxis[['type']]=='time' || lstYAxis[['type']]=='time'){
                #    lstSeries[[i]][['name']] <- lvlseries[i]
                #    #lstSeries[[i]][['showAllSymbol']] <- T
                #    lstSeries[[i]][['data']] <- as.matrix(
                #        data[data[,svar]==lvlseries[i],
                #             c(xvar,yvar)])
                #}
            }
        }
    }else if (type[1] =='k'){
        for (i in 1:ifelse(is.null(series),1,length(lvlseries))){
            if (is.null(series)){
                dset <- data
            }else{
                dset <- data[data[,svar]==lvlseries[i],]
            }
            # dset <- dcast(dset,as.formula(paste(xvar,"~",xvar1)),sum,value.var=yvar)
            dset <- dcast(dset,as.formula(paste(xvar,"~",xvar1)),value.var=yvar)
            dset[,xvar] <- factor(as.character(dset[,xvar]),levels=lvlx)
            dset <- dset[order(dset[,xvar]),]
            lstSeries[[i]] <- 
                list(type='k',name=ifelse(is.null(series),yvar,lvlseries[i]),
                     data=as.matrix(dset[,2:5]))
        }
    }else if (type[1] =='gauge'){
        for (i in 1:ifelse(is.null(series),1,length(lvlseries))){
            if (is.null(series)){
                dset <- data[data[,xvar]!='axisStyle',]
            }else{
                dset <- data[data[,svar]==lvlseries[i] & data[,xvar]!='axisStyle',]
            }
            axisStyle <- data[data[,xvar]=='axisStyle',]
            lstSeries[[i]] <- 
                list(type='gauge',name=ifelse(is.null(series),yvar,lvlseries[i]),
                     title=list(show=TRUE,offsetCenter=c(0,'-40%'),
                                textStyle=list(fontWeight='bolder')),
                     pointer=list(width=5),axisLine=list(lineStyle=list(width=8)),
                     detail=list(textStyle=list(fontWeight='bolder'),color='auto'),
                     axisTick=list(length=12,lineStyle=list(color='auto')),
                     splitLine=list(show=TRUE,length=30,lineStyle=list(color='auto')))
            if (!is.null(splitNumber)) {
                lstSeries[[i]][['splitNumber']] <- splitNumber
                lstSeries[[i]][['axisTick']][['splitNumber']] <- splitNumber
            }
            if (!is.null(dset[,xvar1])){
                lstSeries[[i]][['detail']][['formatter']] <- 
                    paste0("{value}", dset[1,xvar1])
            }
            for (j in 1:nrow(dset)){
                lstSeries[[i]][['data']][[j]] <- list(value=dset[j,yvar],
                                                      name=as.character(dset[j,xvar]))
            }
        }
        # axis Style
        if (nrow(axisStyle)>0){
            axisStyle[,xvar1] <- as.character(axisStyle[,xvar1])
            for (j in 1:nrow(axisStyle)){
                if (substr(col2rgb(axisStyle[j,xvar1]),1,1)!="#"){
                    colvec <- as.vector(col2rgb(axisStyle[j,xvar1]))
                    axisStyle[j,xvar1] <- rgba(colvec)
                }
            }
            lstSeries[[1]][['axisLine']][['lineStyle']][['color']] <- 
                as.matrix(axisStyle[,c(yvar,xvar1)])
        }
    }else if (type[1] %in% c('radar','radarfill')){
        if (is.null(series)){
            lstSeries[[1]] <- list(
                name=ifelse(is.null(xAxis$lab),xvar,xAxis$lab),
                type='radar',
                data=list(value=data[,yvar],
                          name=yvar)
            )
            if (type[1]=='radarfill'){
                lstSeries[[1]][['itemStyle']] <- list(
                    normal=list(areaStyle=list(type='default'))
                )
            }else{
                lstSeries[[1]][['itemStyle']] <- list(
                    emphasis=list(areaStyle=list(color='rgba(0,250,0,0.3)'))
                )
            }
        }else{
            lstSeries[[1]] <- list(
                name=ifelse(is.null(xAxis$lab),xvar,xAxis$lab),
                type='radar',
                data=list()
            )
            if (type[1]=='radarfill'){
                lstSeries[[1]][['itemStyle']] <- list(
                    normal=list(areaStyle=list(type='default'))
                )
            }else{
                lstSeries[[1]][['itemStyle']] <- list(
                    emphasis=list(areaStyle=list(color='rgba(0,250,0,0.3)'))
                )
            }
            for (i in 1:length(lvlseries)){
                lstSeries[[1]][['data']][[i]]<-list(
                    value = data[data[,svar]==lvlseries[i],yvar],
                    name = as.vector(lvlseries[i])
                )
            }
        }
    }else if (type[1] %in% c('map')){
        mapType <- ifelse(is.null(type[2]),'china',tolower(type[2]))
        mapMode <- ifelse(is.null(type[3]),'area',tolower(type[3]))
        for (i in 1:ifelse(is.null(series),1,length(lvlseries))){
            lstSeries[[i]] <- list(
                type='map',
                mapType=mapType,
                roam=TRUE,
                data=list()
            )
            if (is.null(series) | length(lvlseries)==1){
                dset <- data
                lstSeries[[i]][['name']] <- yvar
            }else{
                dset <- data[data[,svar]==lvlseries[i],]
                lstSeries[[i]][['name']] <- lvlseries[i]
            }
            
            if (mapMode=='area'){  #area mode
                lstSeries[[i]][['itemStyle']]=list(
                    normal=list(label=list(show=FALSE)),
                    emphasis=list(label=list(show=TRUE))
                )
                for (j in 1:nrow(dset)){
                    lstSeries[[i]][['data']][[j]]<- list(
                        value=dset[j,yvar],name=as.character(dset[j,xvar])
                    )
                }
            }else if (mapMode=='point'){             #point mode
                lstSeries[[i]][['data']] <- vector(mode='numeric')
                lstSeries[[i]][['hoverable']] <- FALSE
                lstSeries[[i]][['markPoint']] <- list(
                    symbolSize=ceiling(10/log10(nrow(dset))),
                    itemStyle=list(
                        normal=list(borderColor='#87cefa',
                                    borderWidth=1,
                                    label=list(show=FALSE)),
                        emphasis=list(borderColor='#1e90ff',
                                      borderWidth=3,
                                      label=list(show=FALSE))
                    )
                )
                for (j in 1:nrow(dset)){
                    lstSeries[[i]][['markPoint']][['data']][[j]] <- list(
                        value=dset[j,yvar],name=as.character(dset[j,xvar])
                    )
                    lstSeries[[1]][['geoCoord']][[dset[j,xvar]]] <-
                        c(dset[j,ycoordvar],dset[j,xcoordvar])
                } # all geoCoord append to series 1
            }else if (mapMode=='line'){ #line mode
                lstSeries[[i]][['data']] <- vector(mode='numeric')
                lstSeries[[i]][['hoverable']] <- FALSE
                lstSeries[[i]][['markLine']] <- list(
                    itemStyle=list(normal=list(borderWidth=1))
                )
                if (!is.null(markLinesmooth)){
                    lstSeries[[i]][['markLine']][['smooth']] <- T
                }
                for (j in 1:nrow(dset)){
                    lstSeries[[i]][['markLine']][['data']][[j]] <- list(
                        list(name=as.character(dset[j,xvar])),
                        list(name=as.character(dset[j,xvar1]))
                    )
                    if (!is.na(dset[j,yvar])){
                        lstSeries[[i]][['markLine']][['data']][[j]][[2]][['value']] <-
                            dset[j,yvar]
                    }
                    lstSeries[[1]][['geoCoord']][[dset[j,xvar]]] <-
                        c(dset[j,ycoordvar],dset[j,xcoordvar])
                    lstSeries[[1]][['geoCoord']][[dset[j,xvar1]]] <-
                        c(dset[j,ycoordvar1],dset[j,xcoordvar1])
                }
            }
        }
    }else if (type[1] %in% c('chord','chordribbon')){
        # data must be ordered
        data[,xvar1] <- factor(data[,xvar1],levels=unique(data[,xvar1]))
        data <- data[order(data[,xvar1]),]
        data[,xvar1] <-as.character(data[,xvar1])
        
        for (i in 1:ifelse(is.null(series),1,length(lvlseries))){
            lstSeries[[i]] <- list(
                type='chord',sort='ascending',sortSub='descending',
                itemStyle=list(normal=list(label=list(
                    rotate=ifelse(xAxis[['rotate']]!=0,TRUE,FALSE))))
            )
            if (!is.null(series)){ 
                lstSeries[[i]][['name']] <- lvlseries[i]
            }
            if (i>1){
                lstSeries[[i]][['insertToSerie']] <- lstSeries[[1]][['name']]
            }
            if (type[1]=='chord'){ # no ribbons
                lstSeries[[i]][['ribbonType']] <- F
                lstSeries[[i]][['radius']] <- '60%'
            }
            # matrix || node/link mode
            if (identical(levels(as.factor(data[,xvar])),
                          levels(as.factor(data[,xvar1])))){ # is a squared matrix
                for (j in 1:length(unique(data[,xvar1]))){
                    lstSeries[[i]][['data']][[j]] <- list(
                        name=unique(data[,xvar1])[j])
                }
                tmpD <- data
                #tmpD <- tmpD[order(tmpD[,xvar],tmpD[,xvar1]),]
                #tmpD[is.na(tmpD[,yvar]),yvar] <- 0
                if (!is.null(series)){
                    tmpD[is.na(tmpD[,svar]) | tmpD[,svar]!=lvlseries[i],yvar] <- 0
                }
                
                tmpD[,xvar] <- factor(tmpD[,xvar],levels=unique(data[,xvar1]))
                tmpD[,xvar1] <- factor(tmpD[,xvar1],levels=unique(data[,xvar1]))
                tmpM <- dcast(tmpD,eval(parse(text=paste(xvar,'~',xvar1))),
                              value.var=yvar,sum)
                row.names(tmpM) <- tmpM[,1]
                tmpM <- tmpM[,2:ncol(tmpM)]
                tmpM <- tmpM[unique(x1),unique(x1)]
                tmpM <- as.matrix(tmpM)
                #dimnames(tmpM) <- list(unique(x1),unique(x1))
                #print(lvlseries[i])
                #print(tmpD)
                #print(matrix(tmpD[,yvar],nrow=sqrt(nrow(tmpD))))
                #lstSeries[[i]][['matrix']] <-matrix(tmpD[,yvar],
                #                                   nrow=sqrt(nrow(tmpD)))
                lstSeries[[i]][['matrix']] <- tmpM
            }else{ # nodes and links
                for (j in 1:length(c(unique(data[,xvar]),
                                     unique(data[,xvar1])))){
                    lstSeries[[i]][['nodes']][[j]] <- list(
                        name=c(unique(data[,xvar]),unique(data[,xvar1]))[j])
                }
                dset <- data
                if (!is.null(series)){
                    dset[is.na(dset[,svar]) | dset[,svar]!=lvlseries[i],yvar] <- 0
                }
                for (j in 1:nrow(dset)){
                    lstSeries[[i]][['links']][[j]] <- list(
                        source=dset[j,xvar1],target=dset[j,xvar],
                        weight=dset[j,yvar], 
                        name=ifelse(is.null(series),xvar1,lvlseries[i])
                    )
                }
                if (type[1]=='chordribbon'){#chordribbon: must be mutual links
                    for (j in 1:nrow(dset)){ 
                        lstSeries[[i]][['links']][[nrow(dset)+j]] <- list(
                            target=dset[j,xvar1],source=dset[j,xvar],
                            weight=dset[j,yvar]
                        )
                    }
                }
            }
            if (length(levels(as.factor(data[,yvar])))>nrow(data)/2){
                lstSeries[[i]][['showScale']]<-T
                lstSeries[[i]][['showScaleText']]<-T
            }else{
                lstSeries[[i]][['showScale']]<-F
            }
        } 
        lstLegend <- list(show=TRUE,
                          x=vecPos(pos[['legend']])[1],
                          y=vecPos(pos[['legend']])[2],
                          orient=vecPos(pos[['legend']])[3])
        if (is.null(series)){
            lvlseries <- as.vector(unique(x1))
            lstLegend[['data']] <- list(unique(x1))
        }else{
            lstLegend[['data']] <- c(as.vector(unique(x1)),'',lvlseries)
        }
    }else if (type[1]=='force'){  # force chart
        lstSeries <- list()
        lstSeries[[1]] <- list(type='force',ribbonType=FALSE,roam='move')
        for (i in 1:length(lvlseries)){
            lstSeries[[1]][['categories']][[i]] <- list(name=lvlseries[i])
        }
        lstSeries[[1]][['itemStyle']] <- 
            list(normal=list(label=list(textStyle=list(color='#333')),
                             nodeStyle=list(brushType='both'),
                             linkStyle=list(type='curve')))
        if (nlevels(as.factor((dtnode[,'name'])))>=nrow(dtnode)/2){
            lstSeries[[1]][['itemStyle']][['normal']][['label']][['show']] <- T
        }
        for (i in 1:nrow(dtnode)){
            lstSeries[[1]][['nodes']][[i]] <- list(
                category=which(lvlseries==dtnode[i,'category'])-1,
                name=as.character(dtnode[i,'name']),
                value=as.numeric(as.character(dtnode[i,'value']))
            )
        }
        for (i in 1:nrow(dtlink)){
            lstSeries[[1]][['links']][[i]] <- list(
                source=dtlink[i,'from'],target=dtlink[i,'to'],
                weight=dtlink[i,'y'],name=dtlink[i,'relation']
            )
        }
    }else{              # the rest charts: bar, column, scatter, hist
        if (is.null(series)){
            lstSeries[[1]] <- list(
                type=type[1],name=ifelse(is.null(xAxis$lab),xvar,xAxis$lab),
                data=as.vector(data[,yvar])
            )
            if (length(data[,yvar])==1){
                lstSeries[[1]][['data']] <- list(data[,yvar])
            }else{
                lstSeries[[1]][['data']] <- data[,yvar]
            }
            if (type[1]=='histogram'){
                lstSeries[[1]][['type']] <- 'bar'
                lstSeries[[1]][['data']] <- as.matrix(data[,c(xvar,yvar,xvar1)])
                lstSeries[[1]][['barGap']] <- 1
                lstSeries[[1]][['barWidth']] <- 
                    ((dev.size('px')[1]-160)*
                         (max(x)-min(x))/valRange)/nrow(data) 
                lstSeries[[1]][['itemStyle']]<-list(
                    normal=list(barBorderWidth=1))
            }
        }else{
            for (i in 1:ifelse(is.null(series),1,length(lvlseries))){
                lstSeries[[i]] <- list(
                    name=as.vector(lvlseries[i]),
                    type=type[1]
                )
                if (length(data[data[,svar]==lvlseries[i],yvar])==1){
                    lstSeries[[i]]$data <- list(data[data[,svar]==lvlseries[i],yvar])
                }else{
                    lstSeries[[i]]$data <- data[data[,svar]==lvlseries[i],yvar]
                }
                if (stack){
                    lstSeries[[i]][['stack']] <- 'Stack'
                }
                if (type[1]=='histogram'){
                    lstSeries[[i]][['type']] <- 'bar'
                    lstSeries[[i]][['data']] <- 
                        data[data[,svar]==lvlseries[i],c(xvar,yvar,xvar1)]
                    lstSeries[[i]][['barGap']] <- 1
                    lstSeries[[i]][['barWidth']] <- 
                        ((dev.size('px')[1]-160)*
                             (max(x)-min(x))/valRange)/nrow(data) 
                    lstSeries[[i]][['itemStyle']]<-list(
                        normal=list(barBorderWidth=1))
                }
            }
        }
    }
        
    #-------markLine-----------------
    if (!is.null(MarkLine)){
        if (!is.null(z)) if (ncol(MarkLine) %in% c(5,9))
            markLine <- matrix(MarkLine[which(as.character(MarkLine[,ncol(MarkLine)]) 
                                           == as.character(timeslice[t])),
                                 1:(ncol(MarkLine)-1)],ncol=ncol(MarkLine)-1)
        if (! is.data.frame(markLine) & ! is.matrix(markLine)){
            stop("markLine should be a data.frame or a matrix.")
            if (!ncol(markLine) %in% c(4,8)) {
                stop("markLine should be of 4 or 8 columns")
            }
        }
        markLine <- as.data.frame(markLine,stringsAsFactors=FALSE)
        if (nrow(markLine)>0){
            if (ncol(markLine)==8){
                markLine[,6] <- gsub("^[Mm][Aa][Xx].*$",
                                     ifelse(is.numeric(x),max(Data[,xvar]*2,na.rm=TRUE),
                                            length(unique(Data[,xvar]))+1),
                                     markLine[,6])
                for (col in 3:7) markLine[,col]<-as.numeric(markLine[,col])
            }
            sermarkLine <- data.frame(name=unique(markLine[,1]),
                                      ser=NA)
            names(sermarkLine) <- c(names(markLine)[1],'ser')
            for (i in 1:nrow(sermarkLine)){
                # locate the index of lstseries to update markline
                if (!is.na(as.numeric(as.character(sermarkLine[i,1])))){ # series is index
                    if (as.numeric(as.character(sermarkLine[i,1])) <= 
                        ifelse(is.null(series),1,length(lvlseries))){
                        sermarkLine[i,2] <- 
                            ifelse(is.null(series),1,as.numeric(as.character(sermarkLine[i,1])))
                    }
                }else{ #series is char
                    if (!is.null(lvlseries)){
                        if (sermarkLine[i,1] %in% lvlseries){
                            sermarkLine[i,2] <- which(lvlseries==sermarkLine[i,1])
                        }
                    }
                    for (hor in 1:length(lstSeries)){
                        if (sermarkLine[i,1]==ifelse(is.null(lstSeries[[hor]][['name']]),
                                                     "",lstSeries[[hor]][['name']])){
                            sermarkLine[i,2] <- hor
                        }
                    }
                }
                if (is.na(sermarkLine[i,2])){ # new markLine series
                    sermarkLine[i,2] <- length(lstSeries)+1
                    lstSeries[[sermarkLine[i,2]]] <- list(
                        name=as.character(sermarkLine[i,1]),
                        type="line",symbol='none',
                        itemStyle=list(normal=list(lineStyle=list(type='none'))),
                        data=vector(mode='numeric')
                    )
                    if (ncol(markLine)==8){
                        if (lstXAxis[['type']] == 'category'){
                            lstSeries[[sermarkLine[i,2]]][['data']]<-
                                rep(markLine[markLine[,1]==
                                                 sermarkLine[i,1],3],
                                    ifelse(length(lstXAxis[['data']])==1,2,
                                           length(lstXAxis[['data']])))
                        }else{
                            lstSeries[[sermarkLine[i,2]]][['data']]<-
                                as.matrix(markLine[markLine[,1]==
                                                       sermarkLine[i,1],c(5,7)],
                                          dimnames=FALSE)
                        }
                    }
                    lstLegend[['data']][[sermarkLine[i,2]]] <- markLine[i,1]
                    if (type[1]=='map'){
                        lstSeries[[sermarkLine[i,2]]][['hoverable']] <- FALSE
                        lstSeries[[sermarkLine[i,2]]][['type']] <- type[1]
                        lstSeries[[sermarkLine[i,2]]][['mapType']] <- type[2]
                    }
                }
            }
            markLine <- plyr::join(markLine,sermarkLine,by=names(markLine)[1])
            for (i in 1:nrow(sermarkLine)){
                if (type[1]=='map'){
                    lstSeries[[sermarkLine[i,2]]][['markLine']] <- list(
                        data=list(),
                        itemStyle=list(normal=list(borderWidth=1,
                                                   lineStyle=list(type='solid',shadowBlur=10))
                        )
                    )
                }
                if (!is.null(markLinesmooth)){
                    lstSeries[[sermarkLine[i,2]]][['markLine']][['smooth']] <- TRUE
                }
            }
            for (i in 1:nrow(markLine)){  # loop over markLine
                if (ncol(markLine) %in% c(9)){ # full form
                    serIdx <- markLine[i,9]
                    if (serIdx==1 || serIdx<=length(lstSeries)){
                        nLines <- length(lstSeries[[serIdx]][['markLine']][['data']])
                        lstSeries[[serIdx]][['markLine']][['data']][[nLines+1]] <-
                            list(list(name=ifelse(is.na(markLine[i,2]),
                                                  paste("P(",round(markLine[i,4],2),",",
                                                        round(markLine[i,5],2),")"),
                                                  markLine[i,2]),
                                      value=ifelse(is.na(markLine[i,3]),"-",markLine[i,3]),
                                      x=markLine[i,4],
                                      y=markLine[i,5]),
                                 list(name=ifelse(is.na(markLine[i,2]),
                                                  paste("P(",round(markLine[i,6],2),",",
                                                        round(markLine[i,7],2),")"),
                                                  ""),
                                      x=markLine[i,6],
                                      y=markLine[i,7]))
                        if (type[1] %in% c('line','linesmooth','bar','k','scatter','bubble')){
                            lstSeries[[serIdx]][['markLine']][['data']][[nLines+1]] <-
                                list(list(name=ifelse(is.na(markLine[i,2]),
                                                      paste("P(",round(markLine[i,4],2),",",
                                                            round(markLine[i,5],2),")"),
                                                      markLine[i,2]),
                                          value=markLine[i,3],
                                          xAxis=markLine[i,4],
                                          yAxis=markLine[i,5]),
                                     list(name=ifelse(is.na(markLine[i,2]),
                                                      paste("P(",round(markLine[i,6],2),",",
                                                            round(markLine[i,7],2),")"),
                                                      ""),
                                          xAxis=markLine[i,6],
                                          yAxis=markLine[i,7]))
                        }else if (type[1]=='map'){ 
                            geoFrom <- unlist(strsplit(as.character(markLine[i,2]),"[/|]",perl=TRUE))[1]
                            geoTo <- unlist(strsplit(as.character(markLine[i,2]),"[/|]",perl=TRUE))[2]
                            lstSeries[[serIdx]][['markLine']][['data']][[nLines+1]] <- list(
                                list(name=geoFrom),
                                list(name=geoTo)
                            )
                            if (!is.na(markLine[i,3])){
                                lstSeries[[serIdx]][['markLine']][['data']][[nLines+1]][[2]][['value']]<-
                                    markLine[i,3]
                            }
                            lstSeries[[serIdx]][['geoCoord']][[geoFrom]] <-
                                c(markLine[i,5],markLine[i,4])
                            lstSeries[[serIdx]][['geoCoord']][[geoTo]]<-
                                c(markLine[i,7],markLine[i,6])
                        }else{
                            
                        }
                    }
                    if (markLine[i,8]==TRUE) { # effect
                        lstSeries[[serIdx]][['markLine']][['effect']] <- 
                            list(show=TRUE, period=30, shadowBlur=10)
                    }
                }else if (ncol(markLine) %in% c(5)){  # short form
                    serIdx <- markLine[i,5]
                    if (type[1] %in% c('line','linesmooth','bar','scatter','bubble')){
                        if (tolower(markLine[i,3]) %in% c('min','max','average')){
                            if (serIdx==1 | serIdx<=length(lvlseries)){
                                nLines <- length(lstSeries[[serIdx]][['markLine']][['data']])
                                lstSeries[[serIdx]][['markLine']][['data']][[nLines+1]] <-
                                    list(name=ifelse(is.na(markLine[i,2]),
                                                     tolower(as.character(markLine[i,3])),
                                                     as.character(markLine[i,2])),
                                         type=tolower(as.character(markLine[i,3])))
                            }
                        }else if (type[1] %in% c('bubble','scatter') & 
                                  tolower(markLine[i,3]) == 'lm'){
                            nLines <- length(lstSeries[[serIdx]][['markLine']][['data']])
                            
                            if (is.null(series)){
                                lmfit <- lm(as.formula(paste(yvar,'~',xvar)),data)
                            }else{
                                dset <- subset(data,data[,svar]==lvlseries[serIdx])
                                lmfit <- lm(as.formula(paste(yvar,'~',xvar)),dset)
                            }
                            x1 <- min(data[,xvar])
                            x2 <- max(data[,xvar])
                            xhat <- data.frame(x=c(x1,x2))
                            names(xhat) <- xvar
                            yhat <- predict(lmfit,newdata=xhat)
                            k <- lmfit$coefficients[[2]]
                            lstSeries[[serIdx]][['markLine']][['data']][[nLines+1]] <-
                                list(list(name=ifelse(is.na(markLine[i,2]),
                                                      paste("P(",round(x1,2),",",
                                                            round(yhat[[1]],2),")"),
                                                      markLine[i,2]),
                                          value=ifelse(is.na(k),"-",round(k,2)),
                                          xAxis=x1,
                                          yAxis=yhat[[1]]),
                                     list(name=ifelse(is.na(markLine[i,2]),
                                                      paste("P(",round(x2,2),",",
                                                            round(yhat[[2]],2),"), slope"),
                                                      ""),
                                          xAxis=x2,
                                          yAxis=yhat[[2]]))
                        }
                        if (markLine[i,4]==TRUE) { # effect
                            lstSeries[[serIdx]][['markLine']][['effect']] <- 
                                list(show=TRUE, period=30)
                        }
                    }
                }
            }
        }
    }
        
        #-------markPoint-----------------
        if (!is.null(markPoint)){
            if (!is.null(z)) if (ncol(markPoint) %in% c(5,7))
                markPoint <- as.matrix(MarkPoint[which(as.character(MarkPoint[,ncol(MarkPoint)]) 
                                                 == as.character(timeslice[t])),
                                       1:(ncol(MarkPoint)-1)],ncol=ncol(MarkPoint)-1)
                
            if (! is.data.frame(markPoint) & ! is.matrix(markPoint)){
                stop("markPoint should be a data.frame or a matrix.")
                if (!ncol(markPoint) %in% c(4,6)) {
                    stop("markPoint should be of 4 or 6 columns")
                }else if(ncol(markPoint)==6){
                    for (col in 3:5) markPoint[,col]<-as.numeric(markPoint[,col])
                }
            }
            markPoint <- as.data.frame(markPoint,stringsAsFactors=FALSE)
            sermarkPoint <- data.frame(name=levels(as.factor(markPoint[,1])),
                                       ser=NA)
            names(sermarkPoint) <- c(names(markPoint)[1],'ser')
            for (i in 1:nrow(sermarkPoint)){
                # locate the index of lstseries to update markPoint
                if (!is.na(as.numeric(as.character(sermarkPoint[i,1])))){  # series index
                    if (as.numeric(as.character(sermarkPoint[i,1])) <= 
                        ifelse(is.null(series),1,length(lvlseries))){
                        sermarkPoint[i,2] <- 
                            ifelse(is.null(series),1,as.numeric(as.character(sermarkPoint[i,1])))
                    }
                }else{
                    if (!is.null(lvlseries)){
                        if (sermarkPoint[i,1] %in% lvlseries){
                            sermarkPoint[i,2] <- which(lvlseries==sermarkPoint[i,1])
                        }
                    }
                    for (hor in 1:length(lstSeries)){
                        if (sermarkPoint[i,1]==ifelse(is.null(lstSeries[[hor]][['name']]),
                                                      "",lstSeries[[hor]][['name']])){
                            sermarkPoint[i,2] <- hor
                        }
                    }
                }
                if (is.na(sermarkPoint[i,2])){ #new markPoint series
                    sermarkPoint[i,2] <- length(lstSeries)+1
                    lstSeries[[sermarkPoint[i,2]]] <- list(
                        name=as.character(sermarkPoint[i,1]),
                        type="scatter", 
                        data=vector(mode="numeric")
                    )
                    lstLegend[['data']][[sermarkPoint[i,2]]] <- markPoint[i,1]
                }
                if (type[1]=='map'){
                    lstSeries[[sermarkPoint[i,2]]][['type']] <- "map"
                    lstSeries[[sermarkPoint[i,2]]][['mapType']] <- type[2]
                    lstSeries[[sermarkPoint[i,2]]][['markPoint']] <- list(
                        symbol='emptyCircle',
                        itemStyle=list(normal=list(label=list(show=FALSE))),
                        data=list()
                    )
                }
            }
            markPoint <- plyr::join(markPoint,sermarkPoint,by=names(markPoint)[1])
            
            for (i in 1:nrow(markPoint)){  # loop over markPoint
                if (ncol(markPoint) %in% c(7)){ # full form
                    serIdx <- markPoint[i,7]
                    if (serIdx==1 | serIdx<=length(lstSeries)){
                        nPoints <- length(lstSeries[[serIdx]][['markPoint']][['data']])
                        if (!is.na(markPoint[i,3])){
                            lstSeries[[serIdx]][['markPoint']][['data']][[nPoints+1]] <-
                                list(name=ifelse(is.na(markPoint[i,2]),
                                                 paste("P(",round(markPoint[i,4],2),",",
                                                       round(markPoint[i,5],2),")"),
                                                 markPoint[i,2]),
                                     value=ifelse(is.numeric(markPoint[i,3]),
                                                  round(as.numeric(markPoint[i,3]),2),
                                                  markPoint[i,3]),
                                     x=markPoint[i,4],
                                     y=markPoint[i,5])
                        }
                        if (type[1] %in% c('line','linesmooth','bar','k','scatter')){
                            lstSeries[[serIdx]][['markPoint']][['data']][[nPoints+1]] <-
                                list(name=ifelse(is.na(markPoint[i,2]),
                                                 paste("P(",round(markPoint[i,4],2),",",
                                                       round(markPoint[i,5],2),")"),
                                                 markPoint[i,2]),
                                     value=ifelse(is.na(markPoint[i,3]),"-",
                                                  round(as.numeric(markPoint[i,3]),2)),
                                     xAxis=markPoint[i,4],
                                     yAxis=markPoint[i,5])
                        }else if (type[1] =='map'){
                            if (!is.na(markPoint[i,3])){
                                lstSeries[[serIdx]][['markPoint']][['data']][[nPoints+1]] <-
                                    list(name=markPoint[i,2],
                                         value=ifelse(is.numeric(markPoint[i,3]),
                                                      round(as.numeric(markPoint[i,3]),2),
                                                      markPoint[i,3]))
                            }
                            if (!any(is.na(markPoint[i,4:5]))){
                                lstSeries[[1]][['geoCoord']][[markPoint[i,2]]] <-
                                    c(markPoint[i,5],markPoint[i,4])
                            }  # all geoCoords append to series 1
                        }
                    }
                    
                    if (markPoint[i,6]==TRUE) { # effect
                        lstSeries[[serIdx]][['markPoint']][['effect']] <- 
                            list(show=TRUE, shadowBlur=0)
                    }
                    
                }else if (ncol(markPoint) %in% c(5)){  # short form
                    serIdx <- markPoint[i,5]
                    if (type[1] %in% c('line','linesmooth','bar','scatter','bubble')){
                        if (tolower(markPoint[i,2]) %in% c('min','max')){
                            if (serIdx==1 | serIdx<=length(lvlseries)){
                                nPoints <- length(lstSeries[[serIdx]][['markPoint']][['data']])
                                lstSeries[[serIdx]][['markPoint']][['data']][[nPoints+1]] <-
                                    list(name=ifelse(is.na(markPoint[i,2]),
                                                     tolower(markPoint[i,3]),
                                                     markPoint[i,2]),
                                         type=tolower(markPoint[i,3]))
                            }
                        }
                        if (markPoint[i,4]==TRUE) { # effect
                            lstSeries[[serIdx]][['markPoint']][['effect']] <- list(show=TRUE)
                        }
                    }
                }
                if (length(markPoint)>1000) {
                    lstSeries[[serIdx]][['markPoint']][['large']] <- T
                }
            }
            if (ncol(markPoint)==7) { #JS func symbolSize, max 20, min 10
                sizeFold <- 10/(1+diff(range(markPoint[,3])))
                for (i in 1:nrow(sermarkPoint)){
                    lstSeries[[sermarkPoint[i,2]]][['markPoint']][['symbolSize']] <-
                        JS('function (value) {
                           return 10+(value-',min(markPoint[,3]),')*',
                           sizeFold,'}')
                }
        }
            }
        
        #----------Legend 2--------
        if (length(legend)==2){
            if (legend[[1]]=='single' & length(legend[[2]])==1){
                lstLegend[['selectedMode']]<-'single'
            }
            if (!is.null(lvlseries) & !is.null(legend[[2]])){
                legendShow <- vector()
                for (i in 1:length(legend[[2]])){
                    if (is.numeric(legend[[2]][i])){
                        legendShow <- c(legendShow,legend[[2]][i])
                    }else{
                        legendShow <- c(legendShow,which(lstLegend[['data']]==legend[[2]][i]))
                    }
                }
                if (length(lstLegend[['data']][-legendShow]) >0){
                    lstLegend[['selected']] <- list()
                    for (legName in lstLegend[['data']][-legendShow]){
                        lstLegend[['selected']][[legName]] <- FALSE
                    }
                }
            }
            #}else if (length(lvlseries) ==1){ 
            #    lstLegend= list(show=TRUE, data=levels(as.factor(x)))
            #}
        }
        
        #-------SymbolList----------
        if (!is.null(lvlseries)){
            if (length(symbolList)<length(lvlseries)){
                symbolList <- c(symbolList,
                                rep(symbolList[length(symbolList)],
                                    length(lvlseries)-length(symbolList)))
            }
        }
        lstSymbol <- symbolList
        
        #----------Theme--------------
        theme <- mergeList(list(backgroundColor=NULL, borderColor=NULL, borderWidth=1),
                           theme)
        lstbackgroundColor <- NULL
        if (!is.null(theme[['backgroundColor']]) & 
            !is(try(col2rgb(theme[['backgroundColor']])),"try-error")){
            lstbackgroundColor <- theme[['backgroundColor']]
            if (substr(theme[['backgroundColor']],1,1)!="#"){
                bgColor <- as.vector(col2rgb(theme[['backgroundColor']]))
                vecColor <- c(255,255,255)-bgColor
            }else{
                bgColor <- paste0("0x",substring(theme[['backgroundColor']],
                                                 seq(2,8,2),seq(3,9,2)))
                bgColor <- strtoi(bgColor)
                vecColor <- rep(255,4) - bgColor
            }
            backColor <- rgba(bgColor)
            textColor <- rgba(vecColor)
            if (!is.null(lstTitle)) lstTitle[['textStyle']][['color']] <- textColor
            if (!is.null(lstLegend)) lstLegend[['textStyle']][['color']] <- textColor
            if (!is.null(lstdataRange)) lstdataRange[['textStyle']][['color']] <- textColor
            for (ser in 1:length(lstSeries)){
                if (length(lstSeries[[ser]][['data']])==0){
                    if (is.null(lstSeries[[ser]][['itemStyle']][['normal']][['areaStyle']])){
                        if (is.null(lstSeries[[ser]][['itemStyle']][['normal']])){
                            lstSeries[[ser]][['itemStyle']][['normal']] <- list()
                        }
                    }
                    lstSeries[[ser]][['itemStyle']][['normal']][['areaStyle']]<-
                        list(color=backColor)
                }
            }
        }
        if (!is.null(theme[['borderColor']]) & 
            !is(try(col2rgb(theme[['borderColor']])),"try-error")){
            borderColor <- rgba(as.vector(col2rgb(theme[['borderColor']])))
            for (ser in 1:length(lstSeries)){
                if (length(lstSeries[[ser]][['data']])==0){
                    if (is.null(lstSeries[[ser]][['itemStyle']][['normal']])) {
                        lstSeries[[ser]][['itemStyle']][['normal']] <- 
                            list(borderColor=borderColor)
                    }else{
                        lstSeries[[ser]][['itemStyle']][['normal']][['borderColor']] <-
                            borderColor
                    }
                }
            }
        }
        if (theme[['borderWidth']]!=1){
            for (ser in 1:length(lstSeries)){
                if (length(lstSeries[[ser]][['data']])==0){
                    if (is.null(lstSeries[[ser]][['itemStyle']][['normal']])) {
                        lstSeries[[ser]][['itemStyle']][['normal']] <- 
                            list(borderWidth=theme[['borderWidth']])
                    }else{
                        lstSeries[[ser]][['itemStyle']][['normal']][['borderWidth']] <-
                            theme[['borderWidth']]
                    }
                }
            }
        }
        
        
        #-------Make plot-------------
        if (is.null(z)){
            chartobj <- list(
                title=lstTitle,  tooltip=lstTooltip,
                toolbox=lstToolbox,
                calculable=calculable,
                series=lstSeries
            )
            
            if (!is.null(asImage)) chartobj[['renderAsImage']] <- asImage
            if (!is.null(lstbackgroundColor)) chartobj[['backgroundColor']] <- lstbackgroundColor
            if (!is.null(lstColor)) chartobj[['color']] <- lstColor
            if (try(exists("lstGrid"),T)) chartobj[['grid']] <- lstGrid
            if (!is.null(lstSymbol)) chartobj[['symbolList']] <- lstSymbol
            if (!is.null(lstdataZoom)) chartobj[['dataZoom']] <- lstdataZoom
            if (!is.null(lstdataRange)) chartobj[['dataRange']] <- lstdataRange
            #if (!is.null(lstSeries[[1]][['name']]))   chartobj[['legend']] <- lstLegend
            if (!is.null(lstLegend))   chartobj[['legend']] <- lstLegend
            if (type[1] %in% c('scatter','bubble','line','bar','linesmooth','histogram',
                               'area','areasmooth','k')){
                chartobj[['xAxis']] <- lstXAxis
                chartobj[['yAxis']] <- lstYAxis
            }else if(type[1] %in% c('map')){
                chartobj[['roamController']] <- list(show=TRUE,
                                                     mapTypeControl=list(),
                                                     width=60, height=90,
                                                     x=vecPos(pos[['roam']])[1],
                                                     y=vecPos(pos[['roam']])[2]
                )
                chartobj[['roamController']][['mapTypeControl']][[mapType]] <- T
            }else if (type[1] %in% c('radar','radarfill')){
                chartobj[['polar']] <- lstPolar
            }           
        }else{
            if (t==1){ # the 1st timeslice
                chartobj <- list(list(
                    title=lstTitle,  tooltip=lstTooltip,
                    toolbox=lstToolbox,
                    calculable=calculable,
                    series=lstSeries
                ))
                
                if (!is.null(asImage)) chartobj[[t]][['renderAsImage']] <- asImage
                if (!is.null(lstbackgroundColor)) chartobj[[t]][['backgroundColor']] <- 
                        lstbackgroundColor
                if (!is.null(lstColor)) chartobj[[t]][['color']] <- lstColor
                if (try(exists("lstGrid"),TRUE)) chartobj[[t]][['grid']] <- lstGrid
                if (!is.null(lstSymbol)) chartobj[[t]][['symbolList']] <- lstSymbol
                if (!is.null(lstdataZoom)) chartobj[[t]][['dataZoom']] <- lstdataZoom
                if (!is.null(lstdataRange)) chartobj[[t]][['dataRange']] <- lstdataRange
                #if (!is.null(lstSeries[[1]][['name']]))   chartobj[['legend']] <- lstLegend
                if (!is.null(lstLegend))  chartobj[[t]][['legend']] <- lstLegend
                if (type[1] %in% c('scatter','bubble','line','bar','linesmooth','histogram',
                                   'area','areasmooth')){
                    chartobj[[t]][['xAxis']] <- lstXAxis
                    chartobj[[t]][['yAxis']] <- lstYAxis
                }else if(type[1] %in% c('map')){
                    chartobj[[t]][['roamController']] <- 
                        list(show=TRUE,
                              mapTypeControl=list(),
                              width=60, height=90,
                              x=vecPos(pos[['roam']])[1],
                              y=vecPos(pos[['roam']])[2]
                    )
                    chartobj[[t]][['roamController']][['mapTypeControl']][[mapType]] <- TRUE
                }else if (type[1] %in% c('radar','radarfill')){
                    chartobj[[t]][['polar']] <- lstPolar
                }
            }else if (t>1){
                chartobj[[t]] <- list(title=lstTitle,series=lstSeries)
            }
        }
        }# loop end over z
    #----------Finally plot it---------
    if (!is.null(z)) {
        output <- echart(list(timeline=lstTimeline,options=chartobj))
    }else{
        output <- echart(chartobj)
    }
    if (!is.null(theme$width)) if (is.numeric(theme$width)) output$width <- theme$width
    if (!is.null(theme$height)) if (is.numeric(theme$height)) output$height <- theme$height
    if (all(is.na(Data[,yvar]))) return('') else return(output)
}