/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/*
         * cltp : Column type used
         * DATA     : Display Data
         * RD       : Radio Button
         * CH       : Check Box
         * TB       : TextBox
         * ACList   : AutoComplete List
         * ACAjax   : AutoComplete Ajax
         * RM       : Remove
         * 
*/

function HC_GridView(GridViewName,pParentClassV)
{
    this.GridViewName = GridViewName || "";
    this.Height = 200;
    this.Width = 200;
    this.DefaultColumnWidth = 100;
    this.Header = true;
    this.Footer = true;
    this.RowsHeader = true;
    this.Selection = true;
    this.SelectedRows = "";
    this.SelectedColumns = "";
    this.SelectedRowsActual = "";
    this.ScrollX = true;
    this.ScrollY = true;
    this.DefaultWidth = false;
    this.Paging = false;
    this.LinesPerPage = 0;
    this.TotalPages = 0;
    this.CurrentPage = 0;
    this.WordWrap = false;
    this.CSSClasses = "table HCGrid table-bordered HCGrid_T1 HCGrid_F1";
    this.data = {matrix:[]};
    this.basedata = {matrix:[]};
    this.searchdata = {matrix:[]};
    this.columns = {matrix:[]};
    this.FocusRowIndex = 0;
    this.isSearching = false;
    this.isSearched = false;
    this.DynamicSearch = true;
    this.SearchText = "";
    this.ParentClassV = pParentClassV || null;
    this.FormName = "";
    this.AjaxEnable = false;
    this.AjaxID = "";
    this.AjaxSearchColumns = "";
    this.AjaxColumnList = "";
    this.FirstRowBlank = false;
    this.CellIDEnable = false;
    this.isRefreshing = false;
    this.Ajax = new HC_Ajax();
    this.SearchTextBox = new HC_TextBox(GridViewName+"_search");
    this.Container = "";
    this.SearchingColumns = "";
    this.enableProgress = false;
    this.ProgressBar = new HC_ProgressBar();
    this.Theme = "TC";
    this.GridFont = "F2";
    this.FontSize = "";
    this.SearchStyle = "A";              // 'L' for Left Searching and 'A' For Any Where Search;
    this.Visibility = true;
    this.Test = 0;
    this.SelectMode = "R";          //N for None , R for Row, C for Cell
    this.AllowFocus = false;
    this.HTMLContainer = "";
    
    
    this.setSelectionMode = function(sm){
        this.SelectMode = sm;
    };
    
    this.getSelectionMode = function(){
        return this.SelectMode;
    };
    
    this.HideAllRows = function(){
        var id = this.getID();
        $("#" + id + " > tbody > tr").hide();
    };
    
    this.ShowAllRows = function(){
        var id = this.getID();
        $("#" + id + " > tbody > tr").show();
    };
    
    this.ExportToExcel = function()
    {
        var aj = new HC_Ajax("ExprtToExcel");
        aj.addFormData("columns", JSON.stringify(this.columns.matrix));
        aj.addFormData("data", JSON.stringify(this.getJSON()));
        //aj.TranData1 = this.columns.matrix;
        //alert(JSON.stringify(this.getJSON()));
        //aj.TranData = this.getJSON();
        var parent = this;
        this.ProgressBar.openProgress();
        aj.CallServer(function(data){
           
           //alert(data);
           var data = JSON.parse(data).msg;
           parent.ProgressBar.closeProgess();
           try{
            
            var md = new HC_BSModal(parent.getID() + "_ExpModel");
            if(parent.Container==="")
                md.CreateJQObject(parent.HTMLContainer);
            else
                md.Create(parent.HTMLContainer);
            
            md.Create(parent.Container);
            md.OpenModal();
            
            $("#" + md.getID() + "_body").html("<a href='data:application/vnd.openxmlformats-officedocument.spreadsheetml.sheet;base64,"+data+"'>Download File</a>");
            
           }catch(e){
               alert(e);
           }
            
        });
    };
    
    this.setVisibiliy = function(tf){
        this.Visibility = tf;
        if(tf)
            $("#" + this.getID() + "_GridViewContainer").show();
        else
           $("#" + this.getID() + "_GridViewContainer").hide(); 
    };
    
    this.genFromAjaxID = function(pContainer,AjaxID){
        this.Ajax.AjaxID = AjaxID;
        var parent = this;
        var i;
        this.Ajax.CallServer(function(data){
            //parent.data = JSON.parse(data);
            parent.Create(pContainer);
            var jsd = new HC_Json(data);
            
            for(i=0;i<jsd.getArColumnLength();i++)
            {
                parent.AddColumn(jsd.getArKFI(i),jsd.getArKFI(i));
            }
            
            parent.populateUsingJSON(data);
            
        });
    };
    
    this.createColumnJSON = function(json)
    {
        for(var i=0;i<json.length;i++)
        {
            this.AddColumn(json[i].cnm,json[i].lbl,json[i].width);
            //this.HeaderText(i,json[i].lbl);   
        }
    };
    
    this.populateUsingJSON_Blank = function(data)
    {
        var jsData = JSON.parse(data);
        var fRow = JSON.stringify(jsData[0]);
        
        var fRowJ = JSON.parse(fRow);
        
        for (var key in fRowJ) {
            fRowJ[key]="";
        }
        
        jsData.unshift(fRowJ);
        
        this.populateUsingJSON(JSON.stringify(jsData));
        
    };
    
    this.populateUsingJSON = function(data,chgInBase)
    {
        
        this.AssginJSONToGridView(JSON.parse(data),chgInBase);
        //alert(this.Paging);
        //this.Test++;
        //this.setColumnHeaderText(0,this.Test);
        
        if(this.Paging===true){
            
            //alert(this.TotalPages);
            
            this.setPagingLength(this.LinesPerPage);
            
            //alert(this.TotalPages);
            
            this.gotoPage(0);
            //alert(data);
        }
        else{
            //alert("Sess");
            this.SyncJSONToGridView();
        }
        this.defineEvents();
        this.SelectSingleRow(0);
    };
    
    this.populatefromAjax = function(AjaxID,WhereCL,idsr,clsr){
        this.Ajax.AjaxID = AjaxID || this.Ajax.AjaxID;
        this.Ajax.CMN_WhereCL = WhereCL || this.Ajax.CMN_WhereCL;
        this.Ajax.CMN_WhereData = '';
        var parent = this;
        
        var id = this.getID();
        
        try{
            this.ParentClassV.PopulateAjaxStarts(AjaxID);
        }catch(e){} 

        try{
            window[id+"_PopulateAjaxStarts"](AjaxID);
        }catch(e){}
        
        this.Ajax.CallServer(function(data){
            //alert(data);
            parent.populateUsingJSON(data);
            
            if(idsr!==undefined)
                parent.focusRowSearch(clsr,idsr);
            
            try{
                this.ParentClassV.PopulateAjaxEnds(data);
            }catch(e){} 

            try{
                window[id+"_PopulateAjaxEnds"](data);
            }catch(e){}
            
        });
    };
    
    
    this.populatefromAjax = function(AjaxID,WhereCL,idsr,clsr){
        this.Ajax.AjaxID = AjaxID || this.Ajax.AjaxID;
        this.Ajax.CMN_WhereCL = WhereCL || this.Ajax.CMN_WhereCL;
        this.Ajax.CMN_WhereData = '';
        var parent = this;
        
        var id = this.getID();
        
        try{
            this.ParentClassV.PopulateAjaxStarts(AjaxID);
        }catch(e){} 

        try{
            window[id+"_PopulateAjaxStarts"](AjaxID);
        }catch(e){}
        
        this.Ajax.CallServer(function(data){
            //alert(data);
            parent.populateUsingJSON(data);
            
            if(idsr!==undefined)
                parent.focusRowSearch(clsr,idsr);
            
            try{
                this.ParentClassV.PopulateAjaxEnds(data);
            }catch(e){} 

            try{
                window[id+"_PopulateAjaxEnds"](data);
            }catch(e){}
            
        });
    };
    
    this.getID = function()
    {
        if(this.Container!=="")
            return this.Container + "_" + this.GridViewName;
        else
            return this.GridViewName;
    };
    
    this.setTheme = function(pTheme){
        var id = this.getID();
        
        $("#" + id + "_GridViewContainer").removeClass("HCG_GridViewBack_" + this.Theme);
        $("#" + id).removeClass("HCGrid_" + this.Theme);
        
        this.Theme = pTheme || this.Theme;
        
        $("#" + id + "_GridViewContainer").addClass("HCG_GridViewBack_" + this.Theme);
        $("#" + id).addClass("HCGrid_" + this.Theme);
        
    };
    
    this.setFont = function(pGridFont){
        var id = this.getID();
        
        this.GridFont = pGridFont || this.GridFont;
        
        $("#" + id).removeClass("HCGrid_" + this.GridFont);
        
        $("#" + id).addClass("HCGrid_" + this.GridFont);
        
    };
    
    this.setFontSize = function(pFontSize){
        var id = this.getID();
        
        $("#" + id).css("font-size",pFontSize + "pt");
        
    };
    
    this.generateGV = function(GridContainer,ObjTF,pGridViewName)
    {
         this.GridViewName = pGridViewName || this.GridViewName;
         if(ObjTF)
         {
            this.Container = "";
         }
         else
         {
            this.Container = GridContainer;
         }
        // alert(this.Container);
        var id = this.getID();
        var dv = $("<div id='" + id + "_GridViewContainer' class='HCG_GridViewBack_" + this.Theme + "' ></div>");

        var tbl = $("<table id='" + id + "'/>");
        tbl.append($("<thead/>"));
        tbl.append($("<tbody/>"));
        tbl.append($("<tfoot/>"));
        
        tbl.prop('class',this.CSSClasses);

        if(ObjTF===false){
            $("#" + GridContainer).append(dv);
         }
         else{
             GridContainer.append(dv);
        }
        
        dv.append(tbl);
        
        this.setHeader();
        this.setFooter();
        
        this.setFont();
        this.setTheme();
        
    };
    
    this.Create = function(GridContainer,pGridViewName)
    {
        this.HTMLContainer = GridContainer;
        this.generateGV(GridContainer,false,pGridViewName);
    };
    
    this.CreateGridObject = function(GridContainer,pGridViewName)
    {
        this.HTMLContainer = GridContainer;
        this.generateGV(GridContainer,true,pGridViewName);
    };
    
    this.Dispose = function()
    {
        var id = this.getID();
        this.data = {matrix:[]};
        this.columns = {matrix:[]};
        $("#" + id).remove();
        $("#" + id + "_GridViewContainer").remove();
    };
    
    this.setHeader = function() {
        var id = this.getID();
        if(this.columns.matrix!==null){
        var cl = "<tr><th class='TDHead'></th>",i;
        for (i=0;i<this.columns.matrix.length;i++){
            cl = cl + "<th class='TDBody' style=\"" + 'min-width:' + this.columns.matrix[i].width + 'px' + "\">";
            cl = cl + this.setGRIDData(this.columns.matrix[i].lbl);
            cl = cl + "</th>";
        }
        cl = cl + "</tr>";
        $("#" + id + " > thead").append(cl);
        }
    };

    this.setFooter = function() {
        var id = this.getID();
        var cl = "<tr><th class='TDHead'></th>",i;
        for (i=0;i<this.columns.matrix.length;i++){
            cl = cl + "<th class='TDBody' style=\"" + 'min-width:'+this.columns[i].matrix.width+'px' + "\">" + this.HCG_AssignCellData(this.columns.matrix[i].footTXT) + "</th>";
        }
        cl = cl + "</tr>";
        $("#" + id + " > tfoot").append(cl);
    };
    
    
    
    this.AddColumn = function(CLName,CLLabel,CLWidth,CLType,FTxt,FVl) {
    
        var id = this.getID();

        var ClmnTmpl = JSON.parse('{"cltp":"Data","lbl":"","width":"","footTXT":"","footVL":"","cnm":"","hidden":"N"}');

        if(CLName!==undefined)
            ClmnTmpl.cnm = CLName;

        if(CLLabel!==undefined)
            ClmnTmpl.lbl = CLLabel;
        
        if(CLLabel!==undefined){
            ClmnTmpl.lbl = CLLabel;
            $("#" + id + " > thead > tr").append("<th class='TDBody HCG_noselect'>" + this.getGDFormat(CLLabel) + "</th>");
        }
        else
            $("#" + id + " > thead > tr").append("<th class='TDBody HCG_noselect'>" + this.getGDFormat("") + "</th>");

        if (CLWidth!==undefined){
            ClmnTmpl.width = CLWidth;
        }
        else{
            ClmnTmpl.width = this.DefaultColumnWidth;
        }

        if(CLType!==undefined)
            ClmnTmpl.cltp = CLType;

        if(FTxt!==undefined)
        {
            $("#" + id + " > tfoot > tr").append("<td>" + this.getGDFormat(FTxt) + "</td>");
            ClmnTmpl.footTXT = FTxt;

            if(FVl!==undefined)
                ClmnTmpl.footVL = FVl;
        }
        else
            $("#" + id + " > tfoot > tr").append("<th class='TDBody HCG_noselect'>" + this.getGDFormat("") + "</th>");
    
        $("#" + id + " > thead > tr th:last-child").attr('style','min-width:'+ClmnTmpl.width+'px;');
        $("#" + id + " > tbody > tr td:last-child").attr('style','min-width:'+ClmnTmpl.width+'px');
        $("#" + id + " > tfoot > tr th:last-child").attr('style','min-width:'+ClmnTmpl.width+'px');

        $("#" + id + " > tbody > tr").append("<td class='TDBody'>" + this.getGDFormat("") + "</td>");

        this.columns.matrix.push(ClmnTmpl);
    
        try{
            window[id+"_AddColumn"](CLName,CLLabel);
        }catch(e){};
    };
    
    this.getColumnAutoFocus = function(idx) {
    
        return this.columns.matrix[idx].AutoFocus;

    };
    
    this.setColumnHide = function(idx) {
    
        var id = this.getID();
        
        this.columns.matrix[idx].hidden = "Y";
        
        $("#" + id + " > thead > tr th.TDBody").eq(idx).hide();
        $("#" + id + " > tbody > tr td.TDBody").eq(idx).hide();
        $("#" + id + " > tfoot > tr th.TDBody").eq(idx).hide();

        this.SyncColumnHideAll();

    };
    
    this.setColumnShow = function(idx) {
    
        var id = this.getID();
        
        this.columns.matrix[idx].hidden = "N";
        
        $("#" + id + " > thead > tr th.TDBody").eq(idx).show();
        $("#" + id + " > tbody > tr td.TDBody").eq(idx).show();
        $("#" + id + " > tfoot > tr th.TDBody").eq(idx).show();

        this.SyncColumnHideAll();

    };
    
    
    this.setColumnHeaderText = function(idx,txt) {
    
        var id = this.getID();
        
        if(this.columns.matrix[idx]!=undefined)
            this.columns.matrix[idx].lbl = txt;
        
        $("#" + id + " > thead > tr th.TDBody").eq(idx).html(this.getGDFormat(txt));
        
    };
    
    this.setColumnFooterText = function(idx,txt) {
    
        var id = this.getID();
        
        if(this.columns.matrix[idx]!=undefined)
            this.columns.matrix[idx].footTXT = txt;
        
        $("#" + id + " > tfoot > tr th.TDBody").eq(idx).html(this.getGDFormat(txt));
        
    };
    
    this.setColumnFooterValue = function(idx,txt) {
    
        if(this.columns.matrix[idx]!=undefined)
            this.columns.matrix[idx].footVL = txt;
        
    };
    
    this.getColumnHeaderText = function(idx) {
    
        return this.columns.matrix[idx].lbl;
        
    };
    
    this.getColumnFooterText = function(idx) {
    
        return this.columns.matrix[idx].footTXT;
        
    };
    
    this.getColumnFooterValue = function(idx) {
    
        return this.columns.matrix[idx].footVL;
        
    };
    
    this.setColumnWidth = function(idx,CLWidth) {
    
        var id = this.getID();
        
        this.columns.matrix[idx].width = CLWidth;
        $("#" + id + " > thead > tr th.TDBody").eq(idx).prop('style','min-width:'+CLWidth+'px');
        $("#" + id + " > tbody > tr td.TDBody").eq(idx).prop('style','min-width:'+CLWidth+'px');
        $("#" + id + " > tfoot > tr th.TDBody").eq(idx).prop('style','min-width:'+CLWidth+'px');

        this.SyncColumnWidthAll();
    };
    
    this.addRow = function(pos) {
        var id = this.getID();
        
        var tr;
        
        var dt = JSON.parse(this.getDataRow());
        
        //$("#bingo").val(JSON.stringify(this.data.matrix));
        
        if(this.data.matrix.length>0)
        {
            if(pos===undefined){
                tr = $("#" + id).find("> tbody > tr:last");
                this.data.matrix.push(dt);
            }
            else{
                if(pos>0)
                    tr = $("#" + id).find("> tbody > tr").eq(pos-1);
                else
                    tr = $("#" + id).find("> tbody > tr").eq(pos);
                this.data.matrix.splice(pos,0,dt);
            }

            var trNew = tr.clone();
            if(pos===0)
                tr.before(trNew);
            else
                tr.after(trNew);

           trNew.children("td.TDBody").html(this.getGDFormat(""));
           trNew.addClass("HCG_RowSearched");

        }
        else
        {
            //$("#bingo").val(JSON.stringify(this.data.matrix));
            var rw = this.getTableRow();
            $("#" + id).find("tbody").html(rw);
            this.data.matrix.push(dt);
        }
        
        
        var rwpos = -1;
        
        this.SyncRowNo();
        
        
        this.basedata.matrix = this.data.matrix;
        
        if(pos!==undefined)
            rwpos = pos;
        else
            rwpos = this.data.matrix.length - 1;
        
        this.SyncColumnWidthRow(rwpos);
        this.SyncColumnHideRow(rwpos);
        
        try{
            this.ParentClassV.GridViewAddRow(rwpos);
        }catch(e){};
        
        try{
            window[id+"_AddRow"](rwpos);
        }catch(e){};
    };
    
    
    this.addRowHTML = function(pos) {
        var id = this.getID();
        
        var tr;
        if($("#" + id).find("> tbody > tr ").length>0)
        {
            
            if(pos===undefined){
                tr = $("#" + id).find("> tbody > tr:last");
            }
            else{
                if(pos>0)
                    tr = $("#" + id).find("> tbody > tr").eq(pos-1);
                else
                    tr = $("#" + id).find("> tbody > tr").eq(pos);
            }
            
            var trNew = tr.clone();
            if(pos===0)
                tr.before(trNew);
            else
                tr.after(trNew);

           trNew.children("td.TDBody").html(this.getGDFormat(""));
           
           this.SyncColumnHideRow(rwpos);
           
           //trNew.addClass("HCG_RowSearched");

        }
        else
        {
            var rw = this.getTableRow();
            $("#" + id).find("tbody").html(rw);
        }
        
        this.SyncColumnWidthAll();
        
        
        var rwpos = -1;
        
        if(pos!==undefined)
            rwpos = pos;
        else
            rwpos = (eval($("#" + id).find("> tbody > tr").length) - 1);
        
        try{
            this.ParentClassV.GridViewAddRowHTML(rwpos);
        }catch(e){};
        
        try{
            window[id+"_AddRowHTML"](rwpos);
        }catch(e){};
    };
    
    this.getColumnName = function(idx){
        return this.columns.matrix[idx].cnm;
    };
    
    this.setColumnName = function(idx,cnm){
        this.columns.matrix[idx].cnm = cnm;
    };
    
    this.getColumnIndex = function(key){
        for(i=0;i<this.columns.matrix.length;i++)
        {
            if(this.columns.matrix[i].cnm===key)
                return i;
        }
        return -1;
    };
    
    this.getDataRow = function() {
    var cl = "",i;
    for (i=0;i<this.columns.matrix.length;i++){
        cl = cl + ",\"" + this.columns.matrix[i].cnm + "\":\"\"";
    }
    cl = "{" + cl.substring(1) + "}";
    return cl;
    };
    
    this.getTableRow = function() {
        var cl = "<tr class='HCG_RowSearched'><td class='TDHead HCG_noselect'></td>",i;
        for (i=0;i<this.columns.matrix.length;i++){
            cl = cl + "<td class='TDBody HCG_noselect' style=\"" + 'min-width:'+this.columns.matrix[i].width+'px' + "\">" + this.getGDFormat("") + "</td>";
        }
        cl = cl + "</tr>";
        return cl;
    };
    
    this.getGDFormat = function(txt){
        return "<div class='TDOverflow'>" + txt + "</div>";
    };

    this.showFooter = function(tf) {
        var id = this.getID();
        
        if(tf!==undefined)
        {
            this.Footer = tf;
            if(tf)
                $("#" + id+' > tfoot').show();
            else
                $("#" + id+' > tfoot').hide();
        }
    };
    
    this.showHeader = function(tf) {
        var id = this.getID();

        if(tf!==undefined)
        {
            this.Header = tf;
            if(tf)
                $("#" + id+' > thead').show();
            else
                $("#" + id+' > thead').hide();
        }
        
    };
    
    this.HCG_AssignCellData = function (data)
    {
        data = data.trim();
        if(data==="")
            return this.getGDFormat("");
        else
            return data;
    };
    
    this.setHTML = function(r,c,text){
        var id = this.getID();
        if(text!=null){
            $("#" + id + " > tbody > tr ").eq(r).children("td.TDBody").eq(c).find("div").html(text);
            this.setJSONMatrix(r,c,text);
        }
        else{
            $("#" + id + " > tbody > tr ").eq(r).children("td.TDBody").eq(c).find("div").html("");
            this.setJSONMatrix(r,c,"");
        }
    };
    
    this.setHTMLKey = function(r,key,text){
        var id = this.getID();
        var c = this.getColumnIndex(key);
        if(text!=null){
            $("#" + id + " > tbody > tr ").eq(r).children("td.TDBody").eq(c).find("div").html(text);
            this.setJSONMatrix(r,c,text);
        }
        else{
            $("#" + id + " > tbody > tr ").eq(r).children("td.TDBody").eq(c).find("div").html("");
            this.setJSONMatrix(r,c,"");
        }
    };
    
    this.setJSONMatrix = function(r,c,text) {
        var clnm = this.getColumnName(c);
        this.data.matrix[r][clnm] = text.toString();
    };
    
    this.getHTML = function(r,c){
        var id = this.getID();
        return $("#" + id + " > tbody > tr ").eq(r).children("td.TDBody").eq(c).children("div").html();
    };
    
    this.getHTMLKey = function(r,key){
        var id = this.getID();
        var c = this.getColumnIndex(key);
        return $("#" + id + " > tbody > tr ").eq(r).children("td.TDBody").eq(c).children("div").html();
    };
    
    this.getHTMLActual = function(r,c){
        var id = this.getID();
        return $("#" + id + " > tbody > tr ").eq(r).children("td.TDBody").eq(c).children("div").find("span").html();
    };
    
    this.getValue = function(r,c) {
        var clnm = this.getColumnName(c);
        return this.data.matrix[r][clnm];
    };
    
    this.setValue = function(r,c,data) {
        var clnm = this.getColumnName(c);
        this.data.matrix[r][clnm] = data.toString();
    };
    
    this.getRowLength = function() {
        
        //$("#inf").html(JSON.stringify(this.data.matrix));
        
        return this.data.matrix.length;
        
    };
    
    this.getRowLength_Search = function() {
        var id = this.getID();
        if(this.isSearched)
            return $("#" + id + " > tbody > tr.HCG_RowSearched").length - 1;
        else
            return 0;
    };

    this.getColumnLength = function() {
        return this.columns.matrix.length;
    };
    
    this.setGridViewHeight = function(hgt) {
        var id = this.getID();
        if(hgt!==undefined){
            this.Height = hgt.toString();
            $("#" + id + ' > tbody').prop("style","height:"+hgt+"px");
        }
    };
    
    this.FooterText = function(idx,text) {
        var id = this.getID();
        if(text!==undefined){
            this.columns.matrix[idx].footTXT = text.toString();
            $("#" + id+' > tfoot > th.TDBody').eq(idx).children("div").html(text);
        }
        else{
            return this.columns.matrix[idx].footTXT;
        }
    };

    this.FooterValue = function(idx,value) {
        if(value!==undefined){
            this.columns.matrix[idx].footVL = value.toString();
        }
        else{
            return this.columns.matrix[idx].footVL;
        }
    };

    this.showRowHeader = function(tf) {
        var id = this.getID();
        
        if(tf!==undefined)
        {
            this.RowsHeader = tf;
            if(tf){
                $("#" + id+' > thead > tr th.TDHead').show();
                $("#" + id+' > tbody > tr td.TDHead').show();
                $("#" + id+' > tfoot > tr th.TDHead').show();
            }
            else{
                $("#" + id+' > thead > tr th.TDHead').hide();
                $("#" + id+' > tbody > tr td.TDHead').hide();
                $("#" + id+' > tfoot > tr th.TDHead').hide();
            }
        }
    };

    this.HeaderText = function(idx,text) {
        var id = this.getID();
        if(text!==undefined){
            $("#" + id+' > thead th.TDBody').eq(idx).children("div").html(text);
        }
        else
        {
            return $("#" + id+' > thead th.TDBody').eq(idx).children("div").html();
        }
    };
    
    this.ColumnName = function(idx,text) {
        if(text!==undefined){
            this.columns.matrix[idx].lbl = text.toString();
        }
        else
        {
            return this.columns.matrix[idx].lbl;
        }
    };
    
    this.clearRowHTML = function(pos) {
        var id = this.getID();
        $("#" + id).find("> tbody > tr").eq(pos).children("td div").html("");
    };

    this.clearGridViewHTML = function() {
        var id = this.getID();
        $("#" + id).find("> tbody > tr td.TDBody div").html("");
    };
    
    this.clearGridView = function() {
        var i,j;
        var id = this.getID();
        $("#" + id).find("> tbody > tr td.TDBody div").html("");
        
        for(i=0;i<this.getRowLength();i++){
            for(j=0;j<this.getColumnLength();j++){
                var clnm = this.getColumnName(j);
                this.data.matrix[i][clnm] = "";
            }
        }
    };
    
    this.setScrollBarY = function(tf) {
       var id = this.getID();
       if(tf!==undefined)
       {
           this.ScrollY = tf;
           if(tf)
               $("#" + id).find("> tbody,thead,tfoot").addClass("HCGrid_ScrollY");
           else
               $("#" + id).find("> tbody,tbody,tfoot").removeClass("HCGrid_ScrollY");
       }
    };

    this.setScrollBarX = function(tf) {
       var id = this.getID();
       if(tf!==undefined)
       {
           this.ScrollX = tf;
           if(tf){
               $("#" + id).addClass("HCGrid_ScrollX_table");
               $("#" + id).find("> tbody").addClass("HCGrid_ScrollX_tbody");
           }
           else{
                $("#" + id).removeClass("HCGrid_ScrollX_table");
                $("#" + id).find("> tbody").addClass("HCGrid_ScrollX_tbody");
           }
       }
    };

    this.getGridWidth = function() {
       var tw = 0,i;
       for (i=0;i<this.columns.matrix.length;i++){
            tw += eval(this.columns.matrix[i].width);
        }
        tw += 30;
       return tw;
    };

    this.setDefaultWidth = function(tf) {
       var id = this.getID();
       var cw = this.getGridWidth();
       if(tf!==undefined)
       {
           this.DefaultColumnWidth = tf;
           if(tf){
               $("#" + id).css("width","");
           }
           else{
               if(this.ScrollY)
                cw += 20;
               $("#" + id).css("width",cw+"px");
               if(this.isSearching)
                $("#" + id+"_search").css("width",cw+"px");
           }
       }
    };
    
    this.setGridViewWidth = function(wd) {
        var id = this.getID();
        if(wd!==undefined){
            this.Width = wd.toString();
            $("#" + id).css("width",wd+"px");
               if(this.isSearching)
                $("#" + id+"_search").css("width",wd+"px");
       }
    };
    
    this.setGridViewWidthFull = function() {
        var id = this.getID();
        if(wd!==undefined){
            //this.Width = wd.toString();
            $("#" + id).css("width",+"100%");
               if(this.isSearching)
                $("#" + id+"_search").css("width","100%");
       }
    };
    
    this.setAssignAlignment=function(obj,aln)
    {
        obj.removeClass("TDLeft");
        obj.removeClass("TDRight");
        obj.removeClass("TDCenter");

        if(aln==="C")
            obj.addClass("TDCenter");

        if(aln==="L")
            obj.addClass("TDLeft");

        if(aln==="R")
            obj.addClass("TDRight");

    };

    this.setColumnHeaderAlignment = function(idx,aln) {
        var id = this.getID();
        this.setAssignAlignment($("#" + id).find("> thead > tr th.TDBody").eq(idx).children("div"),aln);
    };

    this.setColumnFooterAlignment = function(idx,aln) {
        var id = this.getID();
        this.setAssignAlignment($("#" + id).find("> tfoot > tr th.TDBody").eq(idx).children("div"),aln);
    };

    this.setColumnAlignment = function(idx,aln) {
        var id = this.getID(),i;
        var ttrow = $("#" + id).find("> tbody > tr").length;

        for(i=0;i<ttrow;i++){
            this.setAssignAlignment($("#" + id).find("> tbody > tr").eq(i).children("td.TDBody").eq(idx).children("div"),aln);
        }

        this.setColumnHeaderAlignment(idx,aln);
        this.setColumnFooterAlignment(idx,aln);

    };

    this.setAlignment = function(rw,cl,aln) {
        var id = this.getID();
        this.setAssignAlignment($("#" + id).find("> tbody > tr").eq(rw).children("td.TDBody").eq(cl).children("div"),aln);
    };

    this.setSelection = function(tf) {
        if(tf!==undefined)
        {
            this.Selection = tf;
        }
    };

    this.SyncRowNo = function() {
        var id = this.getID();
        var rc;
        var cc = this.getColumnLength();
        var i=0,j=0;
        
        if(this.Paging)
        {
            rc = this.LinesPerPage;
            
            for(i=0;i<rc;i++)
            {
                var pg = (rc * this.CurrentPage);
                $("#" + id).find("> tbody > tr").eq(i).find("td.TDHead").html((i+pg)+1);
                this.setAssignAlignment($("#" + id).find("> tbody > tr").eq(i).find("td.TDHead"),"C");
            }
        }
        else
        {
            rc = this.getRowLength();
        
            for(i=0;i<rc;i++)
            {
                $("#" + id).find("> tbody > tr").eq(i).find("td.TDHead").html(i+1);
                this.setAssignAlignment($("#" + id).find("> tbody > tr").eq(i).find("td.TDHead"),"C");
            }
        }
        
        for(i=0;i<rc;i++)
        {
            for(j=0;j<cc;j++){
                $("#" + id).find("> tbody > tr").eq(i).find("td.TDBody").eq(j).prop("id",this.GridViewName+"_"+(i+1)+"_"+(j+1));
                $("#" + id).find("> tbody > tr").eq(i).find("td.TDBody").eq(j).find("div").prop("id",this.GridViewName+"_"+(i+1)+"_"+(j+1)+"_div");
            }
        }
        
    };
    
    this.SyncColumnWidthAll = function() {
        var tr;
        var i=0;
        
        if(this.Paging)
            tr = this.LinesPerPage;
        else
            tr = this.getRowLength();
        
        for(i=0;i<tr;i++)
        {
            this.SyncColumnWidthRow(i);
        }
    };
    
    this.SyncColumnWidthRow = function(ridx) {
        var id = this.getID();
        var tc = this.getColumnLength();
        for(var j=0;j<tc;j++){
            
            $("#" + id).find("> tbody > tr").eq(ridx).find("td.TDBody").eq(j).css("min-width",+this.columns.matrix[j].width);
            
        }
    };
    
    this.SyncColumnHideAll = function() {
        var tr;
        var i=0;
        
        if(this.Paging)
            tr = this.LinesPerPage;
        else
            tr = this.getRowLength();
        
        for(i=0;i<tr;i++)
        {
            this.SyncColumnHideRow(i);
        }
    };
    
    this.SyncColumnHideRow = function(ridx) {
        var id = this.getID();
        var tc = this.getColumnLength();
        for(var j=0;j<tc;j++){
            if(this.columns.matrix[j].hidden==="Y"){
                $("#" + id).find("> tbody > tr").eq(ridx).find("td.TDBody").eq(j).hide();
            }
            else
                $("#" + id).find("> tbody > tr").eq(ridx).find("td.TDBody").eq(j).show();
        }
    };

    this.SelectDataSingle = function(i,j) {
        var id = this.getID();
        this.ClearSelection();
        $("#" + id).find("> tbody > tr").eq(i).find("td.TDBody").eq(j).addClass("HCG_DataSelect_" + this.Theme);
    };

    this.SelectSingleHeader = function(idx) {
        var id = this.getID();
        var rc = this.getRowLength();
        var i=0;
        for(i=0;i<rc;i++)
        {
            $("#" + id).find("> tbody > tr").eq(i).find("td.TDBody").eq(idx).addClass("HCG_DataSelect_" + this.Theme);
        }
    };

    this.SelectHeaders = function() {
        var i;
        var ar = this.SelectedColumns.toString().split(":");
        for(i=0;i<ar.length;i++)
        {
            this.SelectSingleHeader(ar[i]);
        }
    };

    this.getPageNoFromRowIndex = function(idx)
    {
        return Math.floor(eval(idx) / eval(this.LinesPerPage));
    };
    
    this.getPageRowIndexFromRowIndex = function(idx)
    {
        return eval(idx) % eval(this.LinesPerPage);
    };
    
    this.getRowIndexFromPageRowIndex = function(idx)
    {
        return (eval(this.LinesPerPage) * eval(this.CurrentPage)) + eval(idx);
    };
    
    this.SelectSingleRow = function(idx) {
        
        var id = this.getID();
        var rc = this.getColumnLength();
        var i=0;
        
        //this.setColumnHeaderText(1,idx);
        if(this.SelectMode==="R"){
            for(i=0;i<rc;i++)
            {
                $("#" + id).find("> tbody > tr").eq(idx).find("td.TDBody").eq(i).addClass("HCG_DataSelect_" + this.Theme);
            }
        }
        //this.FocusRowIndex = idx;
        
        //alert(idx);
        
        try{
            if(this.Paging){
                this.ParentClassV.GridViewRowSelected(this.getRowIndexFromPageRowIndex(idx));
            }
            else
                this.ParentClassV.GridViewRowSelected(idx);
        }catch(e){} 

        try{
            window[id+"_GridViewRowSelected"](idx);
        }catch(e){}
        
    };

    this.SelectRows = function() {
        if(this.SelectedRows.toString().indexOf(":")>=0){
            var ar = this.SelectedRows.toString().split(":");
            for(i=0;i<ar.length;i++)
            {
                if(ar[i]!=="")
                    this.SelectSingleRow(ar[i]);
            }
        }
        else{
            this.SelectSingleRow(this.SelectedRows);
        }
    };
    
    this.SelectCell = function(ri,ci) {
        if(this.SelectMode==="C"){
            var id = this.getID();
            $("#" + id).find("> tbody > tr").eq(ri).find("td.TDBody").eq(ci).addClass("HCG_DataSelect_" + this.Theme);
        }
    };
    
    this.ClearSelection = function() {
        var id = this.getID();
        $("#" + id).find("> tbody > tr td.TDBody").removeClass("HCG_DataSelect_" + this.Theme);
        this.SelectedColumns = "";
        this.SelectedRows = "";
    };

    this.ClearSelectionIndex = function(idx) {
        var id = this.getID();
        $("#" + id).find("> tbody > tr").eq(idx).find("td.TDBody").removeClass("HCG_DataSelect_" + this.Theme);
        var sr = this.SelectedRows + ":";
        sr = sr.replace(idx+":","");
        if(sr!=="")
        {
            var ar = sr.split(":");
            sr = "";
            for(var i=0;i<ar.length-1;i++)
            {
                if(ar[i]!==""){
                var ri = ar[i] - 1;
                sr = sr + ":" + ri;
                }
            }
            this.SelectedRows = sr.substr(1);
        }
        else
            this.SelectedRows = "";
    };

    this.isSelectedRow = function(idx) {
        var sr = "";
        if(this.SelectedRows.length===1)
            sr = this.SelectedRows + ":";
        else
            sr = this.SelectedRows;
        var ar = sr.toString().split(":");
        if(ar.indexOf(idx.toString())>=0)
            return true;
        else
            return false;
    };
    
    this.isSelectedColumn = function(idx) {
        var ar = this.SelectedColumns.toString().split(":");
        if(ar.indexOf(idx)>=0)
            return true;
        else
            return false;
    };
    
    this.SyncJSONToGridView = function() {
        var id = this.getID();
        var tr,tc;
        tr = this.getRowLength();
        tc = this.getColumnLength();
        var i,j,clnm,ci;
        $("#" + id + " tbody").html("");
        //var trr = this.getTableRow();
        if(this.AjaxColumnList.trim()===""){
            for(i=0;i<tr;i++){
                this.addRowHTML();
                for(j=0;j<tc;j++){
                    clnm = this.getColumnName(j);
                    ci = this.getColumnIndex(clnm);
                    $("#" + id + " > tbody > tr ").eq(i).children("td.TDBody").eq(ci).children("div").html(this.data.matrix[i][clnm]);
                }
            }
        }
        else
        {
            var json = new HC_Json(JSON.stringify(this.data.matrix));
            for(i=0;i<tr;i++){
                this.addRowHTML();
                for(j=0;j<tc;j++){
                    clnm = this.getColumnName(j);
                    if(this.AjaxColumnList.indexOf(clnm)>=0){
                        $("#" + id + " > tbody > tr ").eq(i).children("td.TDBody").eq(j).children("div").html(json.getArVK(i,clnm));
                    }
                }
            }
        }
    };
    
    this.SyncJSONToRow = function(ri,di) {
        var id = this.getID();
        var j,clnm,ci;
        //alert(id);
        for(ji=0;ji<this.getColumnLength();ji++)
        {
            clnm = this.getColumnName(ji);
            ci = this.getColumnIndex(clnm);
            $("#" + id + " > tbody > tr ").eq(ri).children("td.TDBody").eq(ci).find("div").html(this.data.matrix[di][clnm]);
        }
    };
    
    this.AssginJSONToGridView = function(json,chgInBase) {
        this.data.matrix = [];
        this.data.matrix = json;
        if(chgInBase==true || chgInBase==undefined)
        {
            this.basedata.matrix = this.data.matrix;
        }
    };
    
    this.clearHTMLRows = function() {
        var id = this.getID();
        try{
            //$("#"+this.GridViewName+" tbody tr").slice(1).remove();
            $("#" + id+" > tbody > tr").remove();
        }catch(e){alert(e);}
    };
    
    this.clearAllRows = function() {
        this.data.matrix = [];
        this.clearHTMLRows();
    };
    
    this.generateGridView_JSON_Columns = function(GridContainer,json)
    {
        this.Create(GridContainer);
        
        //Generate Columns Starts
        //var obj = json[0];
        for (i=0;i<json.length;i++){
          this.AddColumn(json[i].cnm,json[i].lbl,json[i].width);
        }
        //Generate Columns Ends
        
        this.clearHTMLRows();
        
        //this.AssginJSONToGridView(json);
        
        if(this.FirstRowBlank){  //add a blank data to json
            var dt = JSON.parse(this.getDataRow());
            this.data.matrix.splice(0,0,dt);
        }
        
        this.SyncJSONToGridView();
        
    };
    
    
    this.setPagingLength = function(ln) {
        var id = this.getID();
        
        if (ln!=='')
            ln = eval(ln);
        else
            ln = eval(this.LinesPerPage);

        this.LinesPerPage = ln.toString();

        var rln = -1;

        rln = this.data.matrix.length;

        var tPG = Math.floor(rln/ln);

        if((rln % ln)===0)
            tPG--;
        
        this.TotalPages = tPG.toString();

        //this.gotoPage(0);

        //if(!this.isPagingEnable())
           // this.enablePaging(ln);
    };

    this.isPagingEnable = function() {
        var id = this.getID();
        if($("#"+id+"_ul").length>0)
            return true;
        else
            return false;
    };

    this.enablePaging = function(pgLength) {

        if(!this.Paging)
        {
        var id = this.getID();

        var parent = this;
        
        this.Paging = true; 

        var ul = $("<ul id='" + id + "_ul'/>");
        ul.prop('class','pagination pagination-sm');
        ul.prop('style','margin-top:-12px');

        var fst = $("<li/>");
        var lnk = $("<a class=page-link href=#>First</a>").click(function(){ parent.firstPage(); });
        fst.append(lnk);
        fst.prop('class','page-item');
        ul.append(fst);

        var fst = $("<li/>");
        var lnk = $("<a class=page-link href=#><<</a>").click(function(){ parent.prevPage(); });
        fst.append(lnk);
        fst.prop('class','page-item');
        ul.append(fst);

        var cp = $("<li><a class=page-link href=# id='" + id + "_currPG'>1</a></li>");
        cp.prop('class','page-item');
        ul.append(cp);

        var fst = $("<li/>");
        var lnk = $("<a class=page-link href=#>>></a>").click(function(){ parent.nextPage(); });
        fst.append(lnk);
        fst.prop('class','page-item');
        ul.append(fst);

        var fst = $("<li/>");
        var lnk = $("<a class=page-link href=#>Last</a>").click(function(){ parent.lastPage(); });
        fst.append(lnk);
        fst.prop('class','page-item');
        ul.append(fst);

        $("#"+id).parent().append(ul);

        this.setPagingLength(pgLength);
    }
        //this.gotoPage(0);
    };

    this.disablePaging = function() {

        var id = this.getID();

        $("#"+id+"_ul").remove();

        $('#' + id + " > tbody > tr").css('display','table-row').animate({opacity:1}, 300);

    };

    this.gotoPage = function(idx) {
        //alert(idx);
        var id = this.getID();
        var stRow = Math.floor(eval(idx) * eval(this.LinesPerPage));
        var enRow;
        
        this.CurrentPage = idx;
        
        if((eval(stRow)+eval(this.LinesPerPage)) <= this.getRowLength())
            enRow = (eval(stRow)+eval(this.LinesPerPage));
        else
            enRow = this.getRowLength();
        
        var nops = enRow - stRow;

        this.clearHTMLRows();
        
        dti = stRow;
        //alert(dti);
        for(ii=0;ii<eval(nops);ii++)
        {
            try{
            this.addRowHTML();
            this.SyncJSONToRow(ii,dti);
            dti++;
            }catch(e){
                alert("Error : " + e);
            }
            
             var id = this.getID();
        }
        
        $("#" + id + " > tbody > tr td.TDBody").fadeOut(); 
        $("#" + id + " > tbody > tr td.TDBody").fadeIn(100);
        this.SyncRowNo();
        
        $("#"+id+"_currPG").html(eval(idx)+1);

        try{
            this.ParentClassV.GridViewPaging(idx);
        }catch(e){} 

        try{
            window[id+"_Paging"](idx);
        }catch(e){}

    };

    this.prevPage = function() {
        if(eval(this.CurrentPage)>0)
           this.gotoPage(eval(this.CurrentPage)-1);
    };

    this.nextPage = function() {
        if(eval(this.CurrentPage)<eval(this.TotalPages))
           this.gotoPage(eval(this.CurrentPage)+1);
    };

    this.firstPage = function() {
        this.gotoPage(0);
    };

    this.lastPage = function() {
        this.gotoPage(eval(this.TotalPages));
    };
    
    this.focusFirstRow = function() {
        this.focusRow(0);
    };
    
    this.focusPrevRow = function() {
        if(this.FocusRowIndex>0)
           this.focusRow(eval(this.FocusRowIndex)-1);
    };

    this.focusNextRow = function() {
        if(eval(this.FocusRowIndex)<this.getRowLength()-1){
            this.focusRow(eval(this.FocusRowIndex)+1);
        }
    };
    
    this.focusLastRow = function() {
            this.focusRow(eval(this.getRowLength()-1));
    };
    
    this.getSearchIndex = function(key,value) {
        var i;
        for(i=0;i<this.data.matrix.length;i++)
        {
            if(this.data.matrix[i][key]===value)
                return i;
        }
        return -1;
    };
    
    this.rowHeightTill = function(rw){
        var th = 0;
        var id = this.getID();
        for(i=0;i<=rw;i++)
            th = eval(th) + eval($("#"+id+" > tbody > tr").eq(i).height());
        return th;
    };
    
    this.columnWidthTill = function(rw){
        var th = 0;
        for(i=0;i<=rw;i++)
            th = th + eval(this.columns.matrix[i].width);
        return th;
    };
    
    this.focusRow = function(idx) {

        var id = this.getID();
        
        this.FocusRowIndex = idx;
        
        var ridx;
        if(this.Paging){
            
            if(idx%eval(this.LinesPerPage)===0)
            {
            var pi = Math.floor(eval(idx) / eval(this.LinesPerPage));
            
            if(pi!==this.CurrentPage)
                this.gotoPage(pi);
            }
            //this.setColumnHeaderText(2,idx + " @ " + pi + " : " + this.CurrentPage);
            
            ridx = eval(idx) % eval(this.LinesPerPage);
        }
        else
            ridx = idx;
        
        rw = $('#' + id + " > tbody > tr").eq(ridx); 
        if(eval(rw.height())>0){
        
            //$('#' + id + " tbody").scrollTop((rw.height() * (idx + 1)) - $('#' + id + " tbody").height());
            //fmStockIN.getControlKey("id").setText(this.rowHeightTill(idx) + " :  " + idx + " : " + this.isSearched);
            $('#' + id + " > tbody").scrollTop(this.rowHeightTill(ridx) - $('#' + id + " tbody").height());
            
            this.ClearSelection();
            this.SelectedRows = ridx.toString();
            this.SelectRows();
            
            
            //if(idx>0)
                //alert("yahan aaya");
        }
        
        try{
            this.ParentClassV.GridViewFocusRow(idx);
        }catch(e){} 

        try{
            window[id+"_GridViewSearchStart"]();
        }catch(e){}
            
    };
    
    
    this.focusRowSearch = function(key,SearchData) {

        var i;
        
        for(i=0;i<this.data.matrix.length;i++)
        {
            if(this.data.matrix[i][key]===SearchData){
                if(this.Paging)
                    this.gotoPage(this.getPageNoFromRowIndex(i));
                this.focusRow(i);
                break;
            }            
        }
    };
    
    this.setSearching = function() {

        var id = this.getID();
        
        this.isSearching = true;

        var parent = this;
        
        if($("#" + id + "_search").length===0)
        {
            
            //GridViewName+"_search"
            //var txtsrh = $("<input type='text' id='" + id + "_search' class='HCG_SearchTextBox' autocomplete='off' />");

            var dv = $("<div></div>");
            dv.insertBefore("#"+id);
            
            this.SearchTextBox.generateControlJQObject(dv,id+"_search");
            this.SearchTextBox.setLabel("Search in GridView (Table)");
           
            //txtsrh.insertBefore("#"+id);
            $('#'+id+'_search').unbind("keyup");
            $('#'+id+'_search').keyup(function(e){ 
                      
                if(e.which === 27){ 
                    parent.ParentClassV.EscapePressed();
                }

                if(parent.DynamicSearch){
                    
                    if(parent.DynamicSearch)
                    {
                        if(parent.SearchText!=$(this).val())
                            parent.SearchGRID(($(this).val()));
                    }
                    
                    if(e.which === 13){ 
                        if(parent.ParentClassV!==null){
                            var rwi = parent.FocusRowIndex;
                            try{
                                parent.ParentClassV.DataSelected(parent.getJSONMatrix(rwi),rwi);
                            }catch(e){} 
                            try{
                            window[id+"_DataSelected"](parent.getJSONMatrix(rwi),rwi);
                            }catch(e){}
                        }
                        else{
                            
                            try{
                                var rwi = parent.FocusRowIndex;
                                window[id+"_DataSelected"](parent.getJSONMatrix(rwi),rwi);
                                }catch(e){}
                            
                        }
                            
                    }
                }
                else{
                    if(e.which === 13){ 
                        parent.SearchGRID($(this).val()); 
                    } 
                }

            });

            $('#'+id+'_search').unbind("keydown");
            $('#'+id+'_search').keydown(function(e){ 

                parent.SearchText = $(this).val();

                if(e.which === 38){ 
                    parent.focusPrevRow(); 
                }
                if(e.which === 40){ 
                    parent.focusNextRow(); 
                }
            });

        }

        this.focusRow(0);
    };

    
    this.setFocusOnSearch = function() {
        var id = this.getID();
        if(this.isSearching)
            $('#'+id+'_search').focus();
    };

    this.setDynamicSearch = function(tf){
        if(tf!==undefined){
            this.DynamicSearch=tf;
        }
    };

    this.RefreshGrid = function()
    {
        this.isRefreshing = true;
        this.SearchGRID('');
    };
    
    this.removeRow = function(idx)
    {
        var id = this.getID();
        this.data.matrix.splice(idx,1);
        $("#"+id+ " > tbody > tr").eq(idx).remove();
        this.SyncRowNo();
        this.basedata.matrix = this.data.matrix;
    };
    
    this.getAjaxData = function(x)
    {
        var id = this.getID();
        
        this.Ajax.FormName = this.FormName;
        this.Ajax.AjaxID = this.AjaxID;
        this.Ajax.CMN_WhereCL = this.AjaxSearchColumns;
        this.Ajax.CMN_WhereData = x;
        
        var parent = this;
        
        if(this.enableProgress)
            this.ProgressBar.openProgress();
        
        this.Ajax.CallServer(function(data){
            
            if(parent.enableProgress)
                parent.ProgressBar.closeProgess();
            
            parent.AssginJSONToGridView(JSON.parse(data));
            
            if(parent.FirstRowBlank)
            {
                var dt = JSON.parse(parent.getDataRow());
                parent.data.matrix.splice(0,0,dt);
            }
            parent.SyncJSONToGridView();
            
            if(!parent.isRefreshing){
                parent.focusRow(0);
                parent.isRefreshing = false;
            }
            parent.defineEvents();

            try{
                parent.ParentClassV.GridViewSearchEnd();
            }catch(e){} 

            try{
                window[id+"_GridViewSearchEnd"]();
            }catch(e){}
            
        });
    };


    this.FindInSearchingColumns = function(clnm)
    {
        if(this.SearchingColumns!=="")
        {
            var ar = this.SearchingColumns.split(',');
            for(var i=0;i<ar.length;i++)
            {
                if(clnm===ar[i])
                    return true;
            }
            return false;
        }
        else
            return true;
    };
    
    this.ShowAllRows = function(){
        var id = this.getID();
        this.SearchGRID("");
    };
    
    this.SearchGRID = function(x) {

        //var id = this.getID();
        
        if(x==="")
            this.SearchText = "";
        
        if(x!==""){
            //alert("Search " + x);
        try{
        var srdata = x.toUpperCase();

        this.SearchText = srdata;

        //this.ProgressBar.openProgress();

        this.data.matrix = this.basedata.matrix;
        this.searchdata.matrix = [];
        
        for (var i=0;i<this.data.matrix.length;i++)
        {
            for(var j=0;j<this.columns.matrix.length;j++)
            {
                var clnm = this.getColumnName(j);
                
                var matdata = "";
                
                if(this.data.matrix[i][clnm]!=null)
                    matdata = this.data.matrix[i][clnm].toString().toUpperCase();
                else
                    matdata = "";
                
                if(this.FindInSearchingColumns(clnm)){
                    if(this.SearchStyle==="A"){
                        if(matdata.includes(srdata) && x!==""){
                            this.searchdata.matrix.push(this.data.matrix[i]);
                            //alert(JSON.stringify(this.data.matrix[i]));
                            break;
                        }
                    }
                    else{
                        if(matdata.substring(0,x.length)===srdata && x!==""){
                            this.searchdata.matrix.push(this.data.matrix[i]);
                            //alert(JSON.stringify(this.data.matrix[i]));
                            break;
                        }
                    }
                }
            }
        }
            //alert(JSON.stringify(this.basedata.matrix));
        this.populateUsingJSON(JSON.stringify(this.searchdata.matrix),false);

        //this.ProgressBar.closeProgess();

        this.focusFirstRow();

        }
        catch(e){
            alert(e);
        }

        }
        else{
            this.populateUsingJSON(JSON.stringify(this.basedata.matrix),false);
        }

        try{
            this.ParentClassV.GridViewSearchEnd(x);
        }catch(e){} 

        //$("#" + id + "_search").val(x);
    };

    this.setwordWrap = function(tf) {
       var id = this.getID();
       if(tf!==undefined) {
           this.WordWrap = tf;
           if(tf){
               $("#" + id).find("> tbody > tr > td.TDBody div").removeClass("TDOverflow");
           }
           else
               $("#" + id).find("> tbody > tr > td.TDBody div").addClass("TDOverflow");
       }
   };
   
   this.getJSON = function() {
       return this.data.matrix;
   };
   
   this.getJSONMatrix = function(idx) {
       return this.data.matrix[idx];
   };
   
   this.getSelectedJSON = function(){
       return this.getJSONMatrix(eval(this.FocusRowIndex));
   };
    //Event Section Starts
    
    this.defineEvents = function(){
        
        var id = this.getID();
        
        //alert(this.Selection);
        //alert(id);
        //alert($("#"+id).length);
        
        var parent = this;
        $("#"+id).find("> tbody > tr > td.TDBody").unbind("click");
        $("#"+id).find("> tbody > tr > td.TDBody").click(function(){   //click event on body matrix
        
        var cl = eval($(this).index()) - 1;
        var rw = eval($(this).parent().index());
        
        //alert(parent.columnWidthTill(cl) + "       " +  $('#' + id + " tbody").width());
        //alert(parent.columnWidthTill(cl) - $('#' + id + " tbody").width());
        //$('#' + id).scrollLeft(0);
        
        try{
            parent.ParentClassV.MatrixClick(parent.getJSONMatrix(rw),rw,cl,parent.getHTML(rw,cl),parent.getValue(rw,cl));
            //The following functions used call parent 
        }catch(e){} 
        
        try{
            window[id+"_MatrixClick"](rw,cl);
        }catch(e){}
        
        if(parent.Selection)
        {
           parent.ClearSelection();
        }
        
    });
    
    $("#"+id).find("> thead > tr > th.TDBody").unbind("click");
    $("#"+id).find("> thead > tr > th.TDBody").click(function(){   //click event on column header
        var idx = eval($(this).index()) - 1;
        try{
            window[id+"_ColumnHeaderClick"](idx);
        }catch(e){}
        
        if(parent.Selection)
        {
            if(window.event.ctrlKey)
                parent.SelectedColumns = parent.SelectedColumns + ":" + idx;
            else{
                parent.ClearSelection();
                parent.SelectedColumns = idx;
            }
            parent.SelectHeaders();
        }
    });
    
    $("#"+id).find("> tbody > tr > td.TDHead").unbind("click");
    $("#"+id).find("> tbody > tr > td.TDHead").click(function(){  //click event on row header
        var idx = $(this).parent().index();
        try{
            window[id+"_RowHeaderClick"](idx);
        }catch(e){}
        
        if(parent.Selection)
        {
            if(window.event.ctrlKey){
                if(parent.SelectedRows.length===0){
                    parent.SelectedRows = "";
                }
                parent.SelectedRows = parent.SelectedRows + ":" + idx;
            }
            else{
                parent.ClearSelection();
                parent.SelectedRows = idx;
            }
            parent.SelectRows();
        }
    });
    
    $("#"+id).find("> tbody > tr ").unbind("dblclick");
    $("#"+id).find("> tbody > tr ").dblclick(function(){  //click event on row header
        var idx = $(this).index();
        
        try{
            window[id+"_RowDoubleClick"](idx,parent.getJSONMatrix(idx));
        }catch(e){}
        
        try{
            parent.ParentClassV.GridViewRowDoubleClick(idx,parent.getJSONMatrix(idx));
        }catch(e){} 
        
    });
    
    
    $("#"+id).find("> tbody > tr ").unbind("click");
    $("#"+id).find("> tbody > tr ").click(function(){  //click event on row header
        var idx = $(this).index();
        
        (new HC_Timer()).CallAfter(function()
        {
            parent.focusRow(idx);
        },200);
        
        try{
            window[id+"_RowClick"](idx,parent.getJSONMatrix(idx));
        }catch(e){}
        
        try{
            parent.ParentClassV.GridViewRowClick(idx,parent.getJSONMatrix(idx));
        }catch(e){} 
        
    });
    
    $("#"+id).find("> thead > tr > th.TDHead").unbind("click");
    $("#"+id).find("> thead > tr > th.TDHead").click(function(){ //click event on center
        try{
            window[id+"_CenterClick"]();
        }
        catch(e){}
        
        var slcl = "";
        
        if(parent.Selection)
        {
            parent.ClearSelection();
            
            for(i=0;i<parent.getColumnLength();i++)
                slcl = slcl + ":" + i;
            
            if(slcl!=="")
                parent.SelectedColumns = slcl.substring(1);
            
            parent.SelectHeaders();
        }
        
        
    });
    
    $("#"+id).find("> thead > tr > th.TDBody").unbind("mousedown");
    $("#"+id).find("> thead > tr > th.TDBody").mousedown(function(e){ //Right click evnet on header
        var idx = eval($(this).index()) - 1;
        try{
            if(e.button === 2)
            window[id+"_ColumnHeaderClick_Right"](idx);
        }
        catch(e){}
    });
    
    $("#"+id).find("> tbody > tr > td.TDHead").unbind("mousedown");
    $("#"+id).find("> tbody > tr > td.TDHead").mousedown(function(e){ //Right click event on row header
        var idx = $(this).parent().index();
        try{
            if(e.button===2)
            window[id+"_RowHeaderClick_Right"](idx);
        }
        catch(e){}
    });
    
    $("#"+id).find("> thead > tr > th.TDHead").unbind("mousedown");
    $("#"+id).find("> thead > tr > th.TDHead").mousedown(function(e){ //Right click event on center
        try{
            if(e.button===2)
            window[id+"_CenterClick_Right"]();
        }
        catch(e){}
    });
    
    $("#"+id).find("> thead > tr > th.TDBody").unbind("dblclick");
    $("#"+id).find("> thead > tr > th.TDBody").dblclick(function(){   //Double event on column header
        var idx = eval($(this).index()) - 1;
        try{
            window[id+"_ColumnHeaderClick_Double"](idx);
        }
        catch(e){}
    });
    
    $("#"+id).find("> tbody > tr > td.TDHead").unbind("dblclick");
    $("#"+id).find("> tbody > tr > td.TDHead").dblclick(function(){  //Double event on row header
        var idx = $(this).parent().index();
        try{
            window[id+"_RowHeaderClick_Double"](idx);
        }
        catch(e){}
    });
    
    $("#"+id).find("> thead > tr > th.TDHead").unbind("dblclick");
    $("#"+id).find("> thead > tr > th.TDHead").dblclick(function(){ //Double event on center
        try{
            window[id+"_CenterClick_Double"]();
        }
        catch(e){}
    });
    
    var stColSel,enColSel;
    
    $("#"+id).find("> thead > tr > th.TDBody").unbind("mousedown");
    $("#"+id).find("> thead > tr > th.TDBody").unbind("mouseup");
    $("#"+id).find("> thead > tr > th.TDBody").mousedown(function(e){
        stColSel = eval($(this).index()) - 1;
    }).mouseup(function(ee){
        enColSel = eval($(this).index()) - 1;
        
        if(enColSel<stColSel){
            t = enColSel;
            enColSel = stColSel;
            stColSel = t;
        }
        
        var slcl = "";
        
        if(parent.Selection)
        {
            parent.ClearSelection();
            
            for(i=stColSel;i<=enColSel;i++)
                slcl = slcl + ":" + i;
            
            if(slcl!=="")
                parent.SelectedColumns = slcl.substring(1);
            
            parent.SelectHeaders();
        }
        
    });
    
    var stRowSel,enRowSel;
    
    $("#"+id).find("> tbody > tr > td.TDHead").unbind("mousedown");
    $("#"+id).find("> tbody > tr > td.TDHead").unbind("mouseup");
    $("#"+id).find("> tbody > tr > td.TDHead").mousedown(function(e){
        if(e.shiftKey)
            stRowSel = eval($(this).parent().index());
    }).mouseup(function(ee){
        if(ee.shiftKey){
            enRowSel = eval($(this).parent().index());

            if(enRowSel<stRowSel){
                t = enRowSel;
                enRowSel = stRowSel;
                stRowSel = t;
            }

            var slrw = "";

            if(parent.Selection)
            {
                parent.ClearSelection();

                for(i=stRowSel;i<=enRowSel;i++)
                    slrw = slrw + ":" + i;

                if(slrw!=="")
                    parent.SelectedRows = slrw.substring(1);
                parent.SelectRows();
            }
        }
        
    });
        
    $("#"+id).unbind("scroll");
    $("#"+id).on('scroll', function () {
    $("#"+id + " > *").width($("#"+id).width() + $("#"+id).scrollLeft());
    });
        
    
    };
    
    
    this.getRowObject = function(rwi)
    {
       var id = this.GridViewName;
       return $("#"+id+" > tbody > tr").eq(rwi);
    };
    
    this.getCellObject = function(rwi,cli)
    {
       var id = this.GridViewName;
       return $("#"+id+" > tbody > tr").eq(rwi).find("td.TDBody").eq(cli);
    };
    
    //Event Section Ends
    
};

/*

$.fn.HCG_sortSingle = function(ci) {
   var js = $(this).HCG_getJSON();
   if(tf===true){
        $(this).find("tbody td.TDBody div").removeClass("TDOverflow");
        js.HSGridHead.wordWrap = "Y";
    }
    else{
        $(this).find("tbody td.TDBody div").addClass("TDOverflow");
        js.HSGridHead.wordWrap = "N";
    }
    $(this).HCG_setJSON(js);
};

$.fn.HCG_removeRow = function(pos) {
    var id = $(this).attr("id");
    $('#'+id).find("tbody tr").eq(pos).remove();
};

*/

function HC_GridView_Transaction(pGridViewName,pParentClassV)
{
   this.GridView = new HC_GridView(pGridViewName,this);
   this.GridViewName = pGridViewName || "";
   this.ParentClassV = pParentClassV || null;
   this.Container = "";
   this.ActiveRow = -1;
   this.ActiveCol = -1;
   this.Control = null;
   this.prevCellDIV = null;
   this.Columns = [];
   this.ButtonGroup = new HC_ButtonGroup(pGridViewName+"_btngroup",this);
   this.Container = "";
   this.DisableAddNewRow = false;
   this.AutoFocus = true;
   
   this.enableAutoFocus = function(){
        this.AutoFocus = true;
   };
   
   this.disableAutoFocus = function(){
        this.AutoFocus = false;
   };
   
   this.Create = function(GridContainer,json,GRDName)
   {
        this.GridViewName = GRDName || this.GridViewName;
        var parent = this;
        this.Container = GridContainer;
        var bc = GridContainer; 
        var id = this.GridViewName;
        
        var dv = $("<div id='" + bc + "_TranMenuContainer'></div>");
        $("#" + GridContainer).append(dv);
        
        this.ButtonGroup.CreateJObject($("#"+bc+"_TranMenuContainer"),id+"_TranMenuContainer");
        this.ButtonGroup.setButtonLeft();
       
        this.ButtonGroup.addButton(id+"_TranMenuContainer"+"btngriddel","Delete Selected");
        this.ButtonGroup.addButton(id+"_TranMenuContainer"+"btngriddelall","Delete All (Refresh)");
        this.ButtonGroup.addButton(id+"_TranMenuContainer"+"btngridclearsel","Clear Selection");
       
        this.ButtonGroup.setEvent(0,function(){
            parent.removeSelected();

             try{
                 window[id+"_deleteSelected"](parent.Container);
             }catch(e){}
        });
       
        this.ButtonGroup.setEvent(1,function(){
            parent.refreshRows();

            try{
                 window[id+"_deleteAll"](parent.Container);
             }catch(e){}
        });

        this.ButtonGroup.setEvent(2,function(){
            parent.GridView.ClearSelection(parent.Container);

            try{
                 window[id+"_clearSelection"]([parent.Container]);
             }catch(e){}
        });
        
        var dv = $("<div id='" + bc + "_TranGrid'></div>");
        $("#" + GridContainer).append(dv);
        this.GridView.CreateGridObject($("#"+bc+"_TranGrid"),id);
        $("#"+id).addClass("HC_GridView_Transaction");
        this.Columns = JSON.parse(json);
        
        for(var i=0;i<this.Columns.length;i++)
        {
            this.GridView.AddColumn(this.Columns[i].cnm,this.Columns[i].lbl,this.Columns[i].width);
            //this.GridView.HeaderText(i,);
        }
        this.GridView.setDefaultWidth(false);
        this.GridView.setScrollBarX(true);
        this.GridView.setScrollBarY(true);
        this.GridView.addRow();
        this.GridView.defineEvents();
        this.GridView.setwordWrap(true);
    };
   
    this.groupButtonClicked = function(btnidx)
    {
            
    };

    this.setFocusGridView = function(rwi,cli)
    {
        var id = this.GridViewName;
        try{
             $("#"+id+" > tbody > tr").eq(rwi).find("td.TDBody").eq(cli).click();
        }catch(eee){alert(eee);}
        //alert(rwi+"     "+cli);
    };
   
   this.focusNext = function(rwi,cli)
   {
        var ncli = this.getNextColumnIndex(cli);
        if(ncli<cli){
            if((rwi+1)===this.GridView.getRowLength()){
                if(!this.DisableAddNewRow){
                    this.GridView.addRow();
                    this.GridView.defineEvents();
                }
            }
            this.setFocusGridView((rwi+1),ncli);
        }
        else{
            this.setFocusGridView(rwi,ncli);
        }
   };
   
   this.getNextColumnIndex = function(cli)
   {
       for(i=cli+1;i<this.Columns.length;i++)  
       {
           if(this.Columns[i].editable==="Y")
               return i;
       }    
       for(i=0;i<cli;i++)  
       {
           if(this.Columns[i].editable==="Y")
               return i;
       }
       return -1;
   };
   
   this.getCellObject = function(rwi,cli)
   {
       var id = this.GridViewName;
       return $("#"+id+" > tbody > tr").eq(rwi).find("td.TDBody").eq(cli);
   };
   
   this.getDIVObject = function(rwi,cli)
   {
       var id = this.GridViewName;
       return $("#"+id+" > tbody > tr").eq(rwi).find("td.TDBody").eq(cli).find("div");
   };
   
   this.HC_ACJson_DataSelected = function(rwjson,rwi)
   {
       var id = this.GridViewName;
        try{
            window[id+"_DataSelected"](this.ActiveRow,this.ActiveCol,rwjson,rwi,this.Container);
        }catch(e){}
   };
   
   this.HC_ACList_DataSelected = function(rwjson,rwi)
   {
       var id = this.GridViewName;
       
        try{
            window[id+"_DataSelected"](this.ActiveRow,this.ActiveCol,rwjson,rwi,this.Container);
        }catch(e){}
   };
   
   this.HC_DatePicker_DataSelected = function(vl,DateObject)
   {
       var id = this.Container;
        try{
            window[id+"_DatePickerDataSelected"](this.ActiveRow,this.ActiveCol,vl,DateObject,this.Container);
        }catch(e){}
   };
   
   this.HC_TextBox_DataSelected = function(txt)
   {
       var id = this.Container;
       try{
            window[id+"_TextBoxDataSelected"](this.ActiveRow,this.ActiveCol,txt,this.Container);
       }catch(e){}
   };
   
   //click event for GridView 
   this.MatrixClick = function(json,rwi,cli)
   {
       var id = this.GridViewName;
       //alert(rwi);
       //alert(cli);
        if(this.AutoFocus){
            if(this.Columns[cli].editable==="Y")
            {
                var parent = this;
                
                
                try{

                    var ctlnm = "ctl_"+this.GridViewName;

                    if(this.ActiveCol!==cli || this.ActiveRow!==rwi){

                       if(this.Control!==null){
                           
                           var dvo = this.getDIVObject(this.ActiveRow,this.ActiveCol);
                           this.getDIVObject(this.ActiveRow,this.ActiveCol).show();
                           if(this.ActiveCol!=-1 && this.ActiveRow!=-1)
                                this.GridView.setHTML(parent.ActiveRow,parent.ActiveCol,$("#"+ctlnm).val());
                           this.RemoveGridControl();
                        }

                        var scrvl = this.GridView.columnWidthTill(this.GridView.getColumnLength()-1) - this.GridView.columnWidthTill(cli);

                        //alert(scrvl);

                        //document.getElementById(ctlnm).scrollIntoView();

                        var bw = $('#' + id).width();
                        var wct = parent.GridView.columnWidthTill(cli);

                        (new HC_DelayCall()).Call(function(){
                            if(bw<wct)
                            {
                                if(cli<parent.GridView.getColumnLength()-1)
                                    $("#" + id).scrollLeft(scrvl+parent.GridView.columns.matrix[cli].width);
                                    //$("#" + id).scrollLeft(scrvl+250);
                                //else
                                    //$("#" + id).scrollLeft(scrvl+500);
                            }
                            else{
                                //alert("ttt");
                                $('#' + id).scrollLeft(0);
                            }
                        });

                        this.ActiveCol = cli;
                        this.ActiveRow = rwi;
                        if(this.Columns[cli].ctp==="TB")
                            this.Control = new HC_TextBox(ctlnm,this);
                        else
                            if(this.Columns[cli].ctp==="ACAjax"){
                                this.Control = new HC_AutoCompleteAjax(ctlnm,this.Columns[cli].selcol,this.Columns[cli].selidcol,this.Columns[cli].ajaxid,this.Columns[cli].whcol,this.Columns[cli].json,this);
                        }
                        else
                            if(this.Columns[cli].ctp==="TBDate"){
                                this.Control = new HC_DatePicker(ctlnm,this);
                        }
                        else
                            if(this.Columns[cli].ctp==="ACList"){
                                this.Control = new HC_AutoCompleteJSON(ctlnm,this.Columns[cli].selcol,this.Columns[cli].selidcol,this.Columns[cli].showcol,this.Columns[cli].json,this);
                        }

                        var CellObject = this.getCellObject(rwi,cli);
                        var DIVObject = this.getDIVObject(rwi,cli);
                        var txt = DIVObject.html();
                        this.Control.TextBox.BSEnable = false;
                        this.Control.generateControlJQObject(CellObject);

                        if(this.Columns[cli].ctp==="ACList" && this.Columns[cli].ajaxid!==""){
                            this.Control.populatefromAjaxandSearch(this.Columns[cli].ajaxid,this.Columns[cli].whcol,this.Columns[cli].selcol,txt);
                        }
                        else{
                            this.Control.setText(txt);
                        }

                        if(this.Columns[cli].ctp==="ACList"){
                            this.Control.TextBox.setWidth(this.Columns[cli].width-28);
                        }
                        else{
                            this.Control.TextBox.setWidth(this.Columns[cli].width-5);
                        }
                        DIVObject.hide();
                        this.Control.TextBox.addClass("HC_GridView_Transaction_TextBox");
                        this.Control.TextBox.setFocus();

                       if(this.Columns[cli].ctp==="ACList"){
                            if(this.Columns[cli].ACColWidth!=="")
                                this.Control.ACColWidth = this.Columns[cli].ACColWidth;
                            else
                                this.Control.GridView.setGridViewHeight(100);
                       }

                        try{
                            //alert(id);
                            window[id+"_MatrixEnter"](this.ActiveRow,this.ActiveCol,this.Control,$("#tttg"),this.Container);
                        }catch(e){}

                        $("#"+ctlnm).keyup(function(e){
                             if(e.which===13)
                             {
                                 try{

                                    parent.getDIVObject(parent.ActiveRow,parent.ActiveCol).show();
                                    parent.GridView.setHTML(parent.ActiveRow,parent.ActiveCol,$("#"+ctlnm).val());

                                    try{
                                        window[id+"_MatrixLeave"](parent.ActiveRow,parent.ActiveCol,parent.Control,$("#"+ctlnm),parent.Container);
                                    }catch(e){}

                                    parent.RemoveGridControl();
                                    parent.Control = null;

                                    parent.focusNext(parent.ActiveRow,parent.ActiveCol);

                                 }catch(ewe){alert(ewe);}
                             }
                        });

                    }

               }catch(eee){alert(eee);}
           }
           else{
               this.focusNext(rwi,cli);
           }
       }
   };
   
   this.GridViewAddRow = function()
   {
       var id = this.GridViewName;
       try{
            window[id+"_GridViewAddRow"]();
        }catch(e){}
   };
   
   this.HC_AutoCompleteJSON_OpenSearch = function()
   {
       var id = this.GridViewName;
       var ht = this.GridView.rowHeightTill(this.ActiveRow) - $('#' + id + " tbody").height();
       ht = ht + 180;
       $('#' + id + " > tbody").scrollTop((ht));
   };
   
   this.OpenDatePicker = function()
   {
       var id = this.GridViewName;
       var ht = this.GridView.rowHeightTill(this.ActiveRow) - $('#' + id + " tbody").height();
       ht = ht + 240;
       $('#' + id + " > tbody").scrollTop((ht));
   };
   
   this.Dispose = function()
   {
        if(this.Control!==null)
            this.Control.Dispose();
        
        this.GridView.Dispose();
        this.ButtonGroup.Dispose();
        this.Control = null;         
   };
   
   this.validateRow = function(idx)
   {
       var i = 0;
       var parent = this;
       for(i=0;i<this.Columns.length;i++)
       {
           if(this.Columns[i].required==="Y")
           {
               if(this.GridView.getHTML(idx,i)==="")
               {
                   alert("Please provide " + this.Columns[i].lbl + ".");
                   this.setFocusGridView(idx,i);
                   return false;
               }
           }
       }
       for(i=0;i<this.Columns.length;i++)
       {
           var vtp = this.Columns[i].vtp;
           var data = this.GridView.getHTML(idx, i);
           var lbl = this.Columns[i].lbl;
           var vl = new HC_Validation();
           if(vtp!=="S" && this.Columns[i].editable==="Y")
           {
               if(data!=="")
               {
                   try{
                   if(!vl.getValidationStatus(data,vtp)){
                       alert(lbl + " : " + vl.getValidationMessage(vtp));
                       this.setFocusGridView(idx,i);
                       return false;
                   }
                   }catch(e){
                       alert(e);
                   }
               }
           }
       }
       return true;
   };
   
   
   this.validateGridView = function()
   {
       var i = 0;
       for(i=0;i<(this.GridView.getRowLength()-1);i++)
       {
           if(!this.validateRow(i))
               return false;
       }
       return true;
   };
   
   
   this.refreshRows = function()
   {
        this.GridView.clearAllRows();
        this.GridView.addRow();
        //this.GridView.defineEvents();
        this.GridView.addRow();
        this.GridView.defineEvents();
        
        this.ActiveCol = -1;
        this.ActiveRow = -1;
        //this.setFocusGridView(0,0);
   };
   
   
   this.removeSelected = function()
   {
       var id = this.GridViewName;
       var i;
       try{
       
       while(this.GridView.SelectedRows!=="")
       {
            for(i=0;i<this.GridView.getRowLength();i++)
            {
                if(this.GridView.isSelectedRow(i))
                {
                    this.GridView.removeRow(i);
                    this.GridView.ClearSelectionIndex(i);
                    break;  
                }
            }
       }
       }catch(eee){alert(eee);}
       
       var rl = eval(this.GridView.getRowLength());
       
       this.RemoveGridControl();
       
       if(rl===0)
           this.refreshRows();
       else
       {
           $("#"+id+ " > tbody > tr").remove();
           this.GridView.SyncJSONToGridView();
           if(rl===1){
               this.GridView.addRow();
               this.GridView.SyncRowNo();
           }
           this.GridView.defineEvents();
           this.setFocusGridView(0,0);
       }
   };
   
   this.setFocus = function()
   {
       this.setFocusGridView(0,0);
   };
   
   
   this.RemoveGridControl = function()
   {    
        if(this.Control!==null)
            this.Control.Dispose();
   };
   
   
   
};