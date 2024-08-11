/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/*
    Columns Format : {cnm:"",lbl:"",placeholder:"",text:"",value:"",ctp:"",vtp:"",ro:"",container:"",maxlen:"",nextctl:"",json:null,ajaxid:"",selidcol:"",selcol:"",whcol:""}
 */

/* 
 
 Control Types Available : (Control Type)
    
        a) String : for String : {cnm:"sid",width:"60",lbl:"Student ID : ",placeholder:"",ctp:"TB",required:"N",vtp:"S",validERR:"",ro:"Y",maxlen:"",nextctl:"sname",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"R0",bscol:"6",group:"",tab:"T1",tabtitle:"Personal Details"}
        b) Number : for Number Queries : {cnm:"dob",width:"100",lbl:"Date of Birth : ",placeholder:"Date of Birth : ",ctp:"TBDate",required:"Y",vtp:"D",validERR:"",ro:"N",maxlen:"",nextctl:"gen",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"R2",bscol:"6",group:"",tab:"T1",tabtitle:""}
        c) Date : for Date Queries : {cnm:"aqual",width:"100",lbl:"Academic Qualification : ",placeholder:"Academic Qualification : ",ctp:"ACList",required:"Y",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"tqual",json:"",ajaxid:"ajQualification",selidcol:"qid",selcol:"qualification",showcol:"qid,qualification",whcol:"qid,qualification",row:"",bscol:"",group:"",tab:"T2",tabtitle:"Academics"}
        d) AutoComplete : for String : {cnm:"sid",width:"60",lbl:"Student ID : ",placeholder:"",ctp:"TB",required:"N",vtp:"S",validERR:"",ro:"Y",maxlen:"",nextctl:"sname",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"R0",bscol:"6",group:"",tab:"T1",tabtitle:"Personal Details"}

 */

function HC_Query(FRMName)
{
    this.FormName = FRMName || "";
    this.IsFormOpen = false;
    this.GridView = new HC_GridView(FRMName+"_GridView",this);
    this.Fields = [];
    this.queryColumns = [];
    this.FormData = [];
    this.Controls = [];
    this.Container = "";
    this.isValidated = false;
    this.tmpCTL = "";
    this.Validation = new HC_Validation();
    this.GroupBox = null;
    this.Tabs = null;
    this.Rows = null;
    this.GridViewWidth = 800;
    this.GridViewHeight = 500;
    this.FirstFocusControl = "";
    this.FormActive = false; 
    this.WhereColumn = "";
    this.CurrentRowIndex = -1;
    this.CurrentFormStatus = "";
    this.ExternalValidationEnable = false;
    this.CurrentID  = "";
    this.SearchColumns = "";
    this.Ajax = new HC_Ajax(this.FormName + "_Ajax");
    this.Modal = new HC_BSModal(FRMName+"_modal",this);
    this.ReadOnly = false;
    this.Date = new HC_Date();
    this.Radio = new HC_Radio(FRMName+"_radioB");
    this.Heading = "";
    this.ShowHeading = true;
    this.ButtonGroup = new HC_ButtonGroup(FRMName+"_ButtonGroup",this);
    this.ModalType = "L";
    
    this.getID = function()
    {
        return this.Container;
    };
    
    this.Dispose = function()
    {
        var id = this.getID();
        
        this.Controls = [];
        
        $("#" + id + "_Menu").remove();
        $("#" + id + "_Heading").remove();
        $("#" + id + "_Query").remove();
        $("#" + id + "_Radio").remove();
        $("#" + id + "_Grid").remove();
        
        
        this.Modal.Dispose();
        this.GridView.Dispose();
        this.ButtonGroup.Dispose();
        this.Radio.Dispose();
        
    };
    
    this.generateQuery = function(pContainer)
    {
         this.GroupBox = new HC_GroupBoxes(pContainer);
         this.Tabs = new HC_Tabs(pContainer);
         this.Rows = new HC_BSRows(pContainer);
    
         var cont = pContainer;
         var gbi,tbi,rwi;
         
         if(this.isContainTabs())
            this.Tabs.Create();
        
        for(var ci=0;ci<this.Fields.length;ci++){
             var tb = null;

             cont = this.GenerateControlContainer(ci,pContainer);
            
             if(this.Fields[ci].ctp==="String")
             {
                tb = new HC_String_Query(this.FormName+"_"+this.Fields[ci].cnm,this);
                if(this.Fields[ci].readonly==="Y")
                    tb.ReadOnly=true;
             }
             else
             if(this.Fields[ci].ctp==="Number")
                tb = new HC_Number_Query(this.FormName+"_"+this.Fields[ci].cnm,this);
             else
             if(this.Fields[ci].ctp==="Date")
                tb = new HC_Date_Query(this.FormName+"_"+this.Fields[ci].cnm,this);
             else
             if(this.Fields[ci].ctp==="AutoComplete"){
                 tb = new HC_AutoCompleteJSON(this.FormName+"_"+this.Fields[ci].cnm,this.Fields[ci].selcol,this.Fields[ci].selidcol,this.Fields[ci].showcol,this.Fields[ci].json,this);
             }
             
             tb.generateControlJQObject($("#"+cont));
             
             this.Controls.push(tb);
             tb.setLabel(this.Fields[ci].lbl);
             
             if(this.Fields[ci].ctp==="AutoComplete"){
                
                if(this.Fields[ci].ajaxid!=="")
                    this.Controls[ci].populatefromAjax(this.Fields[ci].ajaxid,this.Fields[ci].whcol);
                 
                 if(this.Fields[ci].ACColWidth!=="")
                    this.Controls[ci].ACColWidth = this.Fields[ci].ACColWidth;
             }
             
             tb.NextControl = this.Fields[ci].nextctl;
             
             if(this.Fields[ci].bscol!==""){
                 tb.setBSColumn(this.Fields[ci].bscol);
             }
             
         }
         
         if(this.isContainTabs()){
            if(gbi>=0 && tbi>=0)
                 this.GroupBox.GroupBoxes[0].Tabs.setActive(0);  
             else
                 this.Tabs.setActive(0);    
         }
             
    };
    
    this.setHeading = function(txt)
    {
        this.Heading = txt;
    };
    
    this.setShowHeading = function(tf)
    {
        this.ShowHeading = tf;
    };
    
    this.getControlIndex = function(idx)
    {
        return this.Controls[idx];
    };
    
    this.getControlKey = function(Key)
    {
        var idx = this.getControlIndexFromKey(Key);
        return this.Controls[idx];
    };
    
    this.getControlIndexFromKey = function(Key)
    {
        var i;
        for(i=0;i<this.Fields.length;i++)
            if(Key===this.Fields[i].cnm)
                return i;
        return -1;
    };
    
    this.GenerateControlContainer = function(i,pContainer)
    {
        var cont = pContainer;
        var gbi,tbi,rwi;
        gbi = tbi = rwi = -1;
        if(this.Fields[i].group!=="")
        {
            if(!this.GroupBox.isGBExists(this.Fields[i].group)){
                gbi = this.GroupBox.Create(this.Fields[i].group);
            }
            else{
                gbi = this.GroupBox.getGBIndex(this.Fields[i].group);
            }
            cont = cont + "_" + this.Fields[i].group + "_body";
        }

        if(this.Fields[i].tab!=="")
        {
            if(gbi>=0)
            {
                if(!this.GroupBox.GroupBoxes[gbi].Tabs.isTabExists(this.Fields[i].tab))
                {
                    if(!this.GroupBox.GroupBoxes[gbi].Tabs.isContainerGenerated)
                        this.GroupBox.GroupBoxes[gbi].Tabs.Create();

                    tbi = this.GroupBox.GroupBoxes[gbi].Tabs.addTab(this.Fields[i].tab,this.Fields[i].tabtitle);
                }
                else
                {
                   tbi = this.GroupBox.GroupBoxes[gbi].Tabs.getTabIndex(this.Fields[i].tab);
                }
            }
            else{
                if(!this.Tabs.isTabExists(this.Fields[i].tab))
                {
                    if(!this.Tabs.isContainerGenerated)
                        this.Tabs.Create();
                    tbi = this.Tabs.addTab(this.Fields[i].tab,this.Fields[i].tabtitle);
                }
                else
                {
                   tbi = this.Tabs.getTabIndex(this.Fields[i].tab);
                }
            }
            cont = cont + "_" + this.Fields[i].tab;
        }


        if(this.Fields[i].row!=="")
        {
            if(tbi>=0 && gbi>=0)
            {
                if(!this.GroupBox.GroupBoxes[gbi].Tabs.Tabs[tbi].Rows.isRowExists(this.Fields[i].row))
                {

                    rwi = this.GroupBox.GroupBoxes[gbi].Tabs.Tabs[tbi].Rows.Create(this.Fields[i].row);
                }
                else
                {
                   rwi = this.GroupBox.GroupBoxes[gbi].Tabs.Tabs[tbi].Rows.getRowIndex(this.Fields[i].row);
                }
            }
            else
            if(gbi>=0)
            {
                if(!this.GroupBox.GroupBoxes[gbi].Rows.isRowExists(this.Fields[i].row))
                {
                    rwi = this.GroupBox.GroupBoxes[gbi].Rows.addRow(this.Fields[i].row);
                }
                else
                {
                   rwi = this.GroupBox.GroupBoxes[gbi].Rows.getRowIndex(this.Fields[i].row);
                }
            }
            else
            if(tbi>=0)
            {
                if(!this.Tabs.Tabs[tbi].Rows.isRowExists(this.Fields[i].row))
                {
                    rwi = this.Tabs.Tabs[tbi].Rows.addRow(this.Fields[i].row);
                }
                else
                {
                   rwi = this.Tabs.Tabs[tbi].Rows.getRowIndex(this.Fields[i].row);
                }
            }
            else{
                if(!this.Rows.isRowExists(this.Fields[i].row))
                {
                    rwi = this.Rows.Create(this.Fields[i].row);
                }
                else
                {
                   rwi = this.Rows.getRowIndex(this.Fields[i].row);
                }
            }
            cont = cont + "_" + this.Fields[i].row;
        }
        
        return cont;
    };
    
    this.ClearAllTabError = function()
    {
        if(this.isContainGroups())
        {
            for(i=0;i<this.GroupBox.GroupBoxes.length;i++)
                this.GroupBox.GroupBoxes[i].Tabs.clearErrorClasses();
        }
        else
           
        this.Tabs.clearErrorClasses();
        
    };
    
    this.AssignFields = function(jsonfields,gridColumns)
    {
        this.Fields = jsonfields;
        this.queryColumns = gridColumns;
    };
    
    this.isContainGroups = function()
    {
        for(i=0;i<this.Fields.length;i++)
            if(this.Fields[i].group!=="")
                return true;
        
        return false;
    };
    
    this.isContainTabs = function()
    {
        for(i=0;i<this.Fields.length;i++)
            if(this.Fields[i].tab!=="")
                return true;
        
        return false;
    };
    
    this.isContainRows = function()
    {
        for(i=0;i<this.Fields.length;i++)
            if(this.Fields[i].row!=="")
                return true;
        
        return false;
    };
    
    
    this.groupButtonClicked = function(idx,btnnm)
    {
        if(btnnm==="btnquery")
        {
            this.RunQuery();
        }
    };
    
    this.Initialize = function(pContainer)
    {
         var id = pContainer;
         this.Container = pContainer;
         
         var dvmenu = $("<div id='" + id + "_Menu' style='margin-top:10px'></div>");
         $("#" + this.Container).append(dvmenu);
         this.ButtonGroup.CreateJObject($("#"+id+"_Menu"));
         this.ButtonGroup.addButton("btnquery","Submit");
       
         var dvhead = $("<div id='" + id + "_Heading' style='margin-top:-50px'></div>");
         
         $("#" + this.Container).append(dvhead);
         if(this.ShowHeading)
            $("#"+id+"_Heading").html("<h5 class='mt-4'>" + this.Heading + "</h5>");
         
         var dvform = $("<div id='" + id + "_Query'></div>");
         $("#" + this.Container).append(dvform);
         
         var dvradio = $("<div id='" + id + "_Radio'></div>");
         $("#" + this.Container).append(dvradio);
         
         var dvgrd = $("<div id='" + id + "_Grid'></div>");
         $("#" + this.Container).append(dvgrd);
                  
         this.generateQuery(id+"_Query");
         this.generateGridView(id+"_Grid");
         
         this.Radio.generateControl(id+"_Radio");
         this.Radio.addRadio("And : Operation","And : Operation");
         this.Radio.addRadio("Or : Operation","Or : Operation");
         
         this.Radio.setText("And : Operation");
         
         $("#"+id+"_Query").hide();
         $("#"+id+"_Grid").hide();
         
         
    };
    
    this.generateGridView = function(pContainer)
    {
        this.GridView.CreateGridObject($("#"+pContainer));
        
        for(i=0;i<this.queryColumns.length;i++)
        {
            this.GridView.AddColumn(this.queryColumns[i].cnm,this.queryColumns[i].lbl,this.queryColumns[i].width);
            //this.GridView.HeaderText(i,);   
        }
        
        this.GridView.FirstRowBlank=false;
        this.GridView.setScrollBarX(true);
        this.GridView.setScrollBarY(true);
    };
    
    this.clearAll = function()
    {
        for(i=0;i<this.Controls.length;i++)
        {
            this.Controls[i].clearAll();
        }
    };
    
    this.OpenGridView = function()
    {
        if(!this.ReadOnly){
            this.ShowGridView();
            this.ShowQuery();
            this.CurrentFormStatus = "Grid";

            try{
                window[this.FormName+"_OpenGridView"]();
            }catch(e){};
        }
    };
    
    this.CloseForm = function()
    {
        this.ShowGridView();
        this.HideForm();
        this.GridView.RefreshGrid();
    };
    
    this.CloseGridView = function()
    {
        
    };
    
    this.RunQuery = function()
    {
        var wc = this.generateWhereClause();
        this.Ajax.CMN_WhereCL = this.SearchColumns;
        this.Ajax.clearFormData();
        this.Ajax.addFormData("Query",wc,wc);
        if(this.Radio.Text==="Or : Operation")
            this.Ajax.addFormData("Operation","Or","Or");    
        else
            this.Ajax.addFormData("Operation","And","And");    
        var parent = this;
        this.Ajax.CallServer(function(data){
            try{
                parent.GridView.populateUsingJSON(data);
                //parent.GridView.AssginJSONToGridView(JSON.parse(data));
                //parent.GridView.SyncJSONToGridView();
                //parent.GridView.defineEvents();
            }catch(e){alert(e);}
            
            
            try{
               window[parent.FormName+"_QueryRun"]();
              }catch(e){};
            
        });
    };
    
    this.generateWhereClause = function()
    {
        var ci;
        var wc = "",cnm,twc,clnm;
        var opn;
        
        if(this.Radio.Text==="Or : Operation")
            opn = "or";
        else
            opn = "and";
        
        for(ci=0;ci<this.Fields.length;ci++)
        {
             if(this.Fields[ci].exclude!=="Y")
             {
                var tb = null;
                cnm = this.FormName + "_" + this.Fields[ci].cnm;
                clnm = this.Fields[ci].cnm;
                if(this.Fields[ci].ctp==="String")
                {
                   if($("#"+cnm+"_select").val()==="" || $("#"+cnm+"_select").val()==="Contains"){
                       if($("#"+cnm+"_text").val()!=="")
                           wc += " " + opn + " " + clnm + " like '%" + $("#"+cnm+"_text").val() + "%'";
                   }
                   else
                       if($("#"+cnm+"_select").val()==="Starts With")
                           wc += " " + opn + " " + clnm + " like '" + $("#"+cnm+"_text").val() + "%'";
                   else
                       if($("#"+cnm+"_select").val()==="Ends With")
                           wc += " " + opn + " " + clnm + " like '%" + $("#"+cnm+"_text").val() + "'";
                }
                else
                if(this.Fields[ci].ctp==="Number")
                {
                   twc = "";
                   if($("#"+cnm+"_selectst").val()==="" && $("#"+cnm+"_selecten").val()===""){
                       if($("#"+cnm+"_textst").val()!==""){
                           twc += " ( " + clnm + ">= " + $("#"+cnm+"_textst").val() + "";
                       }
                       if($("#"+cnm+"_texten").val()!==""){
                           if(twc!=="")
                               twc += " and " + clnm + "<= " + $("#"+cnm+"_texten").val() + " ) ";
                           else
                               twc += " ( " + clnm + "<= " + $("#"+cnm+"_texten").val() + " ) ";
                       }
                       else{
                           if(twc!=="")
                               twc += " ) ";
                       }
                       if(twc!=="")
                           wc += " " + opn + " " + twc;
                   }
                   else
                   if($("#"+cnm+"_selectst").val()!=="" && $("#"+cnm+"_selecten").val()===""){

                       if($("#"+cnm+"_textst").val()!==""){
                           twc += " ( " + clnm + $("#"+cnm+"_selectst").val() + " " + $("#"+cnm+"_textst").val() + "";
                       }
                       if($("#"+cnm+"_texten").val()!==""){
                           if(twc!=="")
                               twc += " and " + clnm + "<= " + $("#"+cnm+"_texten").val() + " ) ";
                           else
                               twc += " ( " + clnm + "<= " + $("#"+cnm+"_texten").val() + " ) ";
                       }
                       else{
                           if(twc!=="")
                               twc += " ) ";
                       }
                       if(twc!=="")
                           wc += " " + opn + " " + twc;

                   }
                   else
                   if($("#"+cnm+"_selectst").val().trim()==="" && $("#"+cnm+"_selecten").val().trim()!==""){

                       if($("#"+cnm+"_textst").val()!==""){
                           twc += " ( " + clnm + ">= " + $("#"+cnm+"_textst").val() + "";
                       }
                       if($("#"+cnm+"_texten").val()!==""){
                           if(twc!=="")
                               twc += " and " + clnm + $("#"+cnm+"_selecten").val() + " " + $("#"+cnm+"_texten").val() + " ) ";
                           else
                               twc += " ( " + clnm + $("#"+cnm+"_selecten").val() + " " + $("#"+cnm+"_texten").val() + " ) ";
                       }
                       else{
                           if(twc!=="")
                               twc += " ) ";
                       }
                       if(twc!=="")
                           wc += " " + opn + " " + twc;

                   }        
                   else
                   {

                       if($("#"+cnm+"_textst").val()!==""){
                           twc += " ( " + clnm + $("#"+cnm+"_selectst").val() + " " + $("#"+cnm+"_textst").val() + "";
                       }
                       if($("#"+cnm+"_texten").val()!==""){
                           if(twc!=="")
                               twc += " and " + clnm + $("#"+cnm+"_selecten").val() + " " + $("#"+cnm+"_texten").val() + " ) ";
                           else
                               twc += " ( " + clnm + $("#"+cnm+"_selecten").val() + " " + $("#"+cnm+"_texten").val() + " ) ";
                       }
                       else{
                           if(twc!=="")
                               twc += " ) ";
                       }
                       if(twc!=="")
                           wc += " " + opn + " " + twc;

                   }
                }
                else
                if(this.Fields[ci].ctp==="Date")
                {
                   twc = "";
                   if($("#"+cnm+"_selectst").val()==="" && $("#"+cnm+"_selecten").val()===""){
                       if($("#"+cnm+"_textst").val()!==""){
                           twc += " ( left(" + clnm + ",10)>= '" + (new HC_Date($("#"+cnm+"_textst").val())).getDBDate() + "'";
                       }
                       if($("#"+cnm+"_texten").val()!==""){
                           if(twc!=="")
                               twc += " and left(" + clnm + ",10)<= '" + (new HC_Date($("#"+cnm+"_texten").val())).getDBDate() + "' ) ";
                           else
                               twc += " ( left(" + clnm + ",10)<= '" + (new HC_Date($("#"+cnm+"_texten").val())).getDBDate() + "' ) ";
                       }
                       else{
                           if(twc!=="")
                               twc += " ) ";
                       }
                       if(twc!=="")
                           wc += " " + opn + " " + twc;
                   }
                   else
                   if($("#"+cnm+"_selectst").val()!=="" && $("#"+cnm+"_selecten").val()===""){

                       if($("#"+cnm+"_textst").val()!==""){
                           twc += " ( left(" + clnm + ",10)" + $("#"+cnm+"_selectst").val() + " '" + (new HC_Date($("#"+cnm+"_textst").val())).getDBDate() + "'";
                       }
                       if($("#"+cnm+"_texten").val()!==""){
                           if(twc!=="")
                               twc += " and left(" + clnm + ",10) <= '" + (new HC_Date($("#"+cnm+"_texten").val())).getDBDate() + "' ) ";
                           else
                               twc += " ( left(" + clnm + ",10) <= '" + (new HC_Date($("#"+cnm+"_texten").val())).getDBDate() + "' ) ";
                       }
                       else{
                           if(twc!=="")
                               twc += " ) ";
                       }
                       if(twc!=="")
                           wc += " " + opn + " " + twc;

                   }
                   else
                   if($("#"+cnm+"_selectst").val().trim()==="" && $("#"+cnm+"_selecten").val().trim()!==""){

                       if($("#"+cnm+"_textst").val()!==""){
                           twc += " ( left(" + clnm + ",10)>= '" + (new HC_Date($("#"+cnm+"_textst").val())).getDBDate() + "'";
                       }
                       if($("#"+cnm+"_texten").val()!==""){
                           if(twc!=="")
                               twc += " and left(" + clnm + ",10)" + $("#"+cnm+"_selecten").val() + " '" + (new HC_Date($("#"+cnm+"_texten").val())).getDBDate() + "' ) ";
                           else
                               twc += " ( left(" + clnm + ",10)" + $("#"+cnm+"_selecten").val() + " '" + (new HC_Date($("#"+cnm+"_texten").val())).getDBDate() + "' ) ";
                       }
                       else{
                           if(twc!=="")
                               twc += " ) ";
                       }
                       if(twc!=="")
                           wc += " " + opn + " " + twc;

                   }        
                   else
                   {

                       if($("#"+cnm+"_textst").val()!==""){
                           twc += " ( left(" + clnm + ",10)" + $("#"+cnm+"_selectst").val() + " '" + (new HC_Date($("#"+cnm+"_textst").val())).getDBDate() + "'";
                       }
                       if($("#"+cnm+"_texten").val()!==""){
                           if(twc!=="")
                               twc += " and left(" + clnm + ",10)" + $("#"+cnm+"_selecten").val() + " '" + (new HC_Date($("#"+cnm+"_texten").val())).getDBDate() + "' ) ";
                           else
                               twc += " ( left(" + clnm + ",10)" + $("#"+cnm+"_selecten").val() + " '" + (new HC_Date($("#"+cnm+"_texten").val())).getDBDate() + "' ) ";
                       }
                       else{
                           if(twc!=="")
                               twc += " ) ";
                       }
                       if(twc!=="")
                           wc += " " + opn + " " + twc;

                   }
                }
                else
                if(this.Fields[ci].ctp==="AutoComplete"){
                    if($("#"+cnm).val()!=="")
                       wc += " " + opn + " " + clnm + " = '" + $("#"+cnm).val() + "'";
                }
             }
        }
        return wc;
    };
    
    this.ShowQuery = function()
    {
        $("#"+this.Container+"_Query").show();
    };
    
    this.HideQuery = function()
    {
        $("#"+this.Container+"_Query").hide();
    };
    
    this.ShowGridView = function()
    {
        $("#"+this.Container+"_Grid").show();
    };
    
    this.HideGridView = function()
    {
        $("#"+this.Container+"_Grid").hide();
    };
    
    this.GridViewFocusRow = function(idx)
    {
        this.CurrentRowIndex = idx;
    };
    
    this.GridViewSearchStart = function()
    {
        
    };
    
    this.GridViewSearchEnd = function()
    {
        this.GridView.focusRow(0);
    };
    
    this.SyncFormData = function()
    {
        this.Ajax.clearFormData();
        for(i=0;i<this.Fields.length;i++)
        {
            this.Ajax.addFormData(this.Fields[i].cnm,this.Controls[i].Text,this.Controls[i].Value);
        }
    };
    
    this.SyncAdditionalData = function()
    {
        this.Ajax.clearAdditional();
        for (var x in GP){
            this.Ajax.addAdditional(x,GP[x]);
        }
    };
    
    this.OpenQuery = function(pContainer)
    {
        this.Initialize(pContainer);
        this.OpenGridView();
        try{
            window[this.FormName+"_OpenForm"]();
        }catch(e){};
    };
    
    this.OpenModelQuery = function(pContainer)
    {
        this.Modal.ModalType = this.ModalType;
        this.Modal.Create(pContainer);
       // alert(this.Modal.ModalName);
        this.Initialize(this.Modal.getID()+"_body");
        this.Modal.OpenModal();
        this.OpenGridView();
        
        this.GridView.setFocusOnSearch();
        
        try{
            window[this.FormName+"_OpenModalForm"]();
        }catch(e){};
    };
    
    this.btnCloseClick = function()
    {
        try{
            window[this.FormName+"_CloseModalForm"]();
        }catch(e){};
    };
    
    this.btnOKClick = function()
    {
        try{
            window[this.FormName+"_CloseModalForm"]();
        }catch(e){};
    };
    
};

