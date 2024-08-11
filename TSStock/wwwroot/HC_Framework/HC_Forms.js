/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/*
    Columns Format : {cnm:"",lbl:"",placeholder:"",text:"",value:"",ctp:"",vtp:"",ro:"",container:"",maxlen:"",nextctl:"",json:null,ajaxid:"",selidcol:"",selcol:"",whcol:""}
 */

/* 
 
 Control Types Available : (Control Type)
    
        a) TB : for TextBox : {cnm:"sid",width:"60",lbl:"Student ID : ",placeholder:"",ctp:"TB",required:"N",vtp:"S",validERR:"",ro:"Y",maxlen:"",nextctl:"sname",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"R0",bscol:"6",group:"",tab:"T1",tabtitle:"Personal Details"}
        b) TBDate : for TextBox with Date : {cnm:"dob",width:"100",lbl:"Date of Birth : ",placeholder:"Date of Birth : ",ctp:"TBDate",required:"Y",vtp:"D",validERR:"",ro:"N",maxlen:"",nextctl:"gen",json:"",ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"R2",bscol:"6",group:"",tab:"T1",tabtitle:""}
        c) ACList : for Autocomplete using List : {cnm:"aqual",width:"100",lbl:"Academic Qualification : ",placeholder:"Academic Qualification : ",ctp:"ACList",required:"Y",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"tqual",json:"",ajaxid:"ajQualification",selidcol:"qid",selcol:"qualification",showcol:"qid,qualification",whcol:"qid,qualification",row:"",bscol:"",group:"",tab:"T2",tabtitle:"Academics"}
        d) ACAjax :  for Autocomplete using AJAX : 
        e) Select :  for Dropdown : 
        f) ACCheckBox : for AutoComplete with CheckBox : 
        g) CheckBox : for CheckBoxs : {cnm:"status",width:"110",lbl:"Status : ",placeholder:"Status : ",ctp:"CheckBox",required:"Y",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"",json:[{"id":"Available","value":"Available"},{"id":"Not Available","value":"Not Available"}],ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"",bscol:"",group:"",tab:"",tabtitle:""}
        h) Radio : for Radio Buttons : {cnm:"status",width:"110",lbl:"Status : ",placeholder:"Status : ",ctp:"Radio",required:"Y",vtp:"S",validERR:"",ro:"N",maxlen:"",nextctl:"",json:[{"id":"Available","value":"Available"},{"id":"Not Available","value":"Not Available"}],ajaxid:"",selidcol:"",selcol:"",showcol:"",whcol:"",row:"",bscol:"",group:"",tab:"",tabtitle:""}

Validation Type : (Validation Type)
    
        a) ND : for decimal only Numbers (10100) with prefix of minus symbox - 
        a) D : for decimal only Numbers (10100) with no extra characters
        b) NF : for floating point value like 2.5 , 3.5 etc inclues (.) with prefix of minus symbox -.
        b) F : for floating point value like 2.5 , 3.5 etc inclues (.) .
        c) M : for mobile numbers only 10 digits allowed with no extra characters
        d) L : for land line numbers with 11 12 13 digits and may contain - 
        e) E : for email id format like test@test.com
        f) W : for website format format like http(s)://www.king.com
        g) C : for PINCODE format contains only 6 digit
        h) S : for String format contains any character
        i) DT : for date format (dd-mm-yyyy)
        j) TM : for date format (00:00)
        k) PAN : for pan card format AAAAA9999A
        l) UID : for UID card format 0000-0000-0000
        m) IP : for IP Address format 000.000.000.000

 */

function HC_Forms(FRMName,pParentClassV)
{
    this.FormName = FRMName || "";
    this.IsFormOpen = false;
    this.GridView = new HC_GridView(FRMName+"_GridView",this);
    this.Fields = [];
    this.FormData = [];
    this.Controls = [];
    this.Container = "";
    this.isValidated = false;
    this.tmpCTL = "";
    this.Validation = new HC_Validation();
    this.GroupBox = new HC_GroupBoxes(FRMName + "_GroupBox");
    this.Tabs = new HC_Tabs(FRMName + "_Tabs");
    this.Rows = new HC_BSRows(FRMName + "_Rows");
    this.GridViewWidth = 800;
    this.GridViewHeight = 500;
    this.FirstFocusControl = "";
    this.FormActive = false;
    this.ParentClassV = pParentClassV || null;
    this.WhereColumn = "";
    this.CurrentRowIndex = -1;
    this.CurrentFormStatus = "";
    this.ExternalValidationEnable = false;
    this.CurrentID  = "";
    this.SearchColumns = "";
    this.Ajax = new HC_Ajax(this.FormName + "_Ajax");
    this.Modal = new HC_BSModal(FRMName+"_Modal",this);
    this.ReadOnly = false;
    this.ButtonGrGrid = new HC_ButtonGroup(FRMName+"_ButtonGroupGrid",this);
    this.ButtonGrForm = new HC_ButtonGroup(FRMName+"_ButtonGroupForm",this);
    this.ProgressBar = new HC_ProgressBar();
    this.Heading = "";
    this.ShowHeading = true;
    this.EnableDefaultMenuEvent = true;
    this.MenuGroup = new HC_MenuGroup(FRMName+"_MenuGroup",this);
    this.Generated = false;
    this.FormOnly = false;
    this.GridViewOnly = false;
    this.ModalType = "L";
    this.getID = function()
    {
        if(this.Container!=="")
            return this.Container + "_" + this.FormName;
        else
            return this.FormName;
    };
    
    this.Dispose = function()
    {
        var id = this.getID();
        try{
            this.Rows.Dispose();
            this.GroupBox.Dispose();
            this.Tabs.Dispose();
            this.GridView.Dispose();
            this.Controls = [];
            $("#"+id+"_Grid").remove();
            $("#"+id+"_Form").remove();
            this.Generated = false;
            this.FormActive = false;
        }catch(e){alert(e);}
    };
    
    this.CreateForm = function(pContainer,pFRMName)
    {
        if(!this.Generated){
            this.Container = pContainer || this.Container;
            this.FormName = pFRMName || this.FormName;

            var BaseContainer = this.Container;
            var BaseContainer_id = this.Container + "_" + this.FormName;
            var id = this.FormName;

            this.CreateMenuButton();
            this.CreateHeading(BaseContainer_id);
            
            if($("#"+BaseContainer_id+"_Grid").length===0){
                var dvgrd = $("<div id='" + BaseContainer_id + "_Grid'></div>");
                $("#" + BaseContainer).append(dvgrd);
                var dvform = $("<div id='" + BaseContainer_id + "_Form'></div>");
                $("#" + BaseContainer).append(dvform);
                
                
                this.generateForm(BaseContainer_id+"_Form");
                
               
                try{
                if(!this.FormOnly)
                    this.generateGridView(BaseContainer_id+"_Grid",BaseContainer_id+"_GridView");
                }catch(e){
                    alert(e);
                }
                
                 
            }
            
            $("#"+BaseContainer_id+"_Form").hide();
            $("#"+BaseContainer_id+"_Grid").hide();

            this.Generated = true;
        }
        
        try{
            this.ParentClassV.Form_Created(pContainer,FRMName);
            //The following functions used call parent 
        }catch(e){}
    };
    
    this.CreateHeading = function(id)
    {
        var dvhead = $("<div id='" + id + "_Heading'></div>");
        $("#" + this.Container).append(dvhead);
        if(this.ShowHeading)
            $("#"+id+"_Heading").html("<h5 class='mt-4'>" + this.Heading + "</h5>");
    };
    
    this.CreateMenuButton = function()
    {
         var BaseContainer = this.Container;
         var bc_id = this.getID();
         var parent = this;
         
         var dvmenu = $("<div id='" + bc_id + "_Menu' style='margin-top:5px;margin-bottom:-45px'></div>"); //Create Menu DIV
         $("#" + BaseContainer).append(dvmenu);
         
         this.ButtonGrGrid.CreateJObject($("#"+bc_id+"_Menu"));
         this.ButtonGrGrid.addButton(bc_id+"_Menu"+"btnnew","New Record");
         this.ButtonGrGrid.addButton(bc_id+"_Menu"+"btnedit","Edit Record");
         this.ButtonGrGrid.addButton(bc_id+"_Menu"+"btndel","Delete Record");
         this.ButtonGrGrid.addButton(bc_id+"_Menu"+"btnexp","Export To Excel");
         
         var parent = this;
         this.ButtonGrGrid.setEvent(0,function(){
              parent.OpenNewForm();
              try{
                parent.ParentClassV.FormMenuClick("New");
              }catch(e){};
              try{
               window[parent.FormName+"_FormMenuClick"](parent.Container,"New");
              }catch(e){};
         });
         
         this.ButtonGrGrid.setEvent(1,function(){
              parent.EditForm();
              try{
               parent.ParentClassV.FormMenuClick("Edit");
              }catch(e){};
              try{
               window[parent.FormName+"_FormMenuClick"](parent.Container,"Edit");
              }catch(e){};
         });
         
         this.ButtonGrGrid.setEvent(2,function(){
             parent.DeleteForm();
             try{
              parent.ParentClassV.FormMenuClick("Delete");
             }catch(e){};
             try{
              window[parent.FormName+"_FormMenuClick"](parent.Container,"Delete");
             }catch(e){};
         });
         
         
         this.ButtonGrGrid.setEvent(3,function(){
             parent.GridView.ExportToExcel();
         });
         
         this.ButtonGrForm.CreateJObject($("#"+bc_id+"_Menu"));
         this.ButtonGrForm.addButton(bc_id+"_Menu"+"btnsave","Save Record");
         this.ButtonGrForm.addButton(bc_id+"_Menu"+"btnclear","Clear Form");
         this.ButtonGrForm.addButton(bc_id+"_Menu"+"btncancel","Cancel");
         this.ButtonGrForm.setVisible(false);
         
         this.ButtonGrForm.setEvent(0,function(){
             if(parent.EnableDefaultMenuEvent)
              parent.SaveForm();
              try{
               parent.ParentClassV.FormMenuClick("Save");
              }catch(e){};
              try{
               window[parent.FormName+"_FormMenuClick"](parent.Container,"Save");
              }catch(e){};
         });
                  
         this.ButtonGrForm.setEvent(1,function(){
             parent.ClearForm();
             try{
              parent.ParentClassV.FormMenuClick("Clear");
            }catch(e){};
            try{
              window[parent.FormName+"_FormMenuClick"](parent.Container,"Clear");
            }catch(e){};
         });
         
         this.ButtonGrForm.setEvent(2,function(){
            parent.CancelForm();
            try{
              parent.ParentClassV.FormMenuClick("Cancel");
            }catch(e){};
            try{
              window[parent.FormName+"_FormMenuClick"](parent.Container,"Cancel");
            }catch(e){};
         });
    };
    
    this.RemoveMenuButton = function()
    {
        this.ButtonGrForm.Dispose();
        this.ButtonGrGrid.Dispose();
    };
    
    this.ShowMenuButton = function(MenuNM,tf)
    {
        if(MenuNM==="Form"){
            this.ButtonGrForm.setVisible(tf);
            this.ButtonGrGrid.setVisible(!tf);
        }
        else
        {
            this.ButtonGrForm.setVisible(!tf);
            this.ButtonGrGrid.setVisible(tf);
        }
    };
    
    this.HideAllMenuButton = function(tf)
    {
        this.ButtonGrForm.setVisible(!tf);
        this.ButtonGrGrid.setVisible(!tf);
    };
    
    this.generateForm = function(pContainer)
    {
         var cont = pContainer;
         var gbi,tbi,rwi;
         
        for(var ci=0;ci<this.Fields.length;ci++){
             var tb = null;
             
             cont = this.GenerateControlContainer(ci,pContainer);
             
             if(this.Fields[ci].ctp==="TB")
                tb = new HC_TextBox(this.FormName+"_"+this.Fields[ci].cnm,this);
             else
             if(this.Fields[ci].ctp==="TBDate"){
                tb = new HC_DatePicker(this.FormName+"_"+this.Fields[ci].cnm,this);
             }
             else
             if(this.Fields[ci].ctp==="ACList"){
                 tb = new HC_AutoCompleteJSON(this.FormName+"_"+this.Fields[ci].cnm,this.Fields[ci].selcol,this.Fields[ci].selidcol,this.Fields[ci].showcol,this.Fields[ci].json,this);
             }
             else
             if(this.Fields[ci].ctp==="ACAjax"){
                 tb = new HC_AutoCompleteAjax(this.FormName+"_"+this.Fields[ci].cnm,this.Fields[ci].selcol,this.Fields[ci].selidcol,this.Fields[ci].ajaxid,this.Fields[ci].whcol,this);
             }
             else
             if(this.Fields[ci].ctp==="Radio"){
                 tb = new HC_Radio(this.FormName+"_"+this.Fields[ci].cnm,this.Fields[ci].json,this);
             }
             else
             if(this.Fields[ci].ctp==="CheckBox"){
                 tb = new HC_CheckBox(this.FormName+"_"+this.Fields[ci].cnm,this.Fields[ci].json,this);
             }
             
             tb.generateControlJQObject($("#"+cont));
             //alert(tb.getID());  
             //alert(this.Fields[ci].lbl);
             //tb.Container = pContainer;
             this.Controls.push(tb);
             tb.setLabel(this.Fields[ci].lbl + " : ");
             
             if(this.Fields[ci].ctp==="ACList"){
                 
                 if(this.Fields[ci].ajaxid!=="")
                    this.Controls[ci].populatefromAjax(this.Fields[ci].ajaxid,this.Fields[ci].whcol);
                
                if(this.Fields[ci].ACColWidth!=="")
                    this.Controls[ci].ACColWidth = this.Fields[ci].ACColWidth;
                
                if(this.Fields[ci].whcol!=="")
                    this.Controls[ci].GridView.SearchingColumns = this.Fields[ci].whcol;
                
                //this.Controls[ci].GridView.defineEvents();
                
             }
             
             tb.NextControl = this.Fields[ci].nextctl;
             
             if(this.Fields[ci].ctp==="TB"){
                 tb.TextBox.setValidationType(this.Fields[ci].vtp);
                 if(this.Fields[ci].maxlen!=="")
                    tb.TextBox.setMaxLength(this.Fields[ci].maxlen);
             }
             
             if(this.Fields[ci].ro==="Y"){
                 tb.setReadOnly(true);
             }
             
             if(this.Fields[ci].bscol!==""){
                 tb.setBSColumn(this.Fields[ci].bscol);
             }
             
         }
         
         if(this.isContainTabs()){
            if(gbi>=0 && tbi>=0)
                 this.GroupBox.GroupBoxes[0].Tabs.setActive(0);  
             else{
                 this.Tabs.setActive(0);    
             }
         }
             
    };
    
    this.setHeading = function(txt)
    {
        this.Heading = txt;
    };
    
    this.setShowHeading = function(tf)
    {
        this.ShowHeading = tf;
        var id = this.getID();
        $("#"+id+"_Menu").css("margin-bottom","0px");
        if(tf)
            $("#"+id+"_Heading").show();
        else
            $("#"+id+"_Heading").hide();
    };
    
    this.getControlFromIndex = function(idx)
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
        this.GroupBox.Container = pContainer;
        this.Rows.Container = pContainer;
        this.Tabs.Container = pContainer;
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
                        this.GroupBox.GroupBoxes[gbi].Tabs.GenerateTabContainer();

                    tbi = this.GroupBox.GroupBoxes[gbi].Tabs.Create(this.Fields[i].tab,this.Fields[i].tabtitle);
                }
                else
                {
                   tbi = this.GroupBox.GroupBoxes[gbi].Tabs.getTabIndex(this.Fields[i].tab);
                }
            }
            else{
                if(!this.Tabs.isTabExists(this.Fields[i].tab))
                {
                    if(!this.Tabs.isContainerGenerated){
                        this.Tabs.Container = pContainer;
                        this.Tabs.Create();
                    }
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

                    rwi = this.GroupBox.GroupBoxes[gbi].Tabs.Tabs[tbi].Rows.addRow(this.Fields[i].row);
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
                    rwi = this.GroupBox.GroupBoxes[gbi].Rows.Create(this.Fields[i].row);
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
                    rwi = this.Tabs.Tabs[tbi].Rows.Create(this.Fields[i].row);
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
    
    this.validateForm = function(){
        this.isValidated = true;
        this.tmpCTL=null;
        var tctl;
        var tab;
        var i;
        if(this.isContainTabs())
            this.ClearAllTabError();
        
        for(i=0;i<this.Fields.length;i++){
            
            if(this.Fields[i].required==="Y"){
                tctl = this.Controls[i].validateBlank();
                if(tctl!==null)
                {
                    this.isValidated = false;
                    if(this.tmpCTL===null)
                        this.tmpCTL = tctl;
                    
                    this.Fields[i].validERR = "Blank";
                    
                    if(this.Fields[i].tab!==""){
                        tab = this.getSelectedTab(i);
                        tab.setErrorClass(true);
                    }
                }
                else
                {
                    this.Fields[i].validERR = "";
                }
            }
        }
        
        /*if(this.isValidated){
            
            for(i=0;i<this.Fields.length;i++)
            {
                if(this.Fields[i].vtp!=="S")
                {
                    if(!this.Validation.validateVTP(this.Fields[i].cnm,"",this.Fields[i].vtp))
                    {
                        this.isValidated = false;
                        if(this.tmpCTL==="")
                            this.tmpCTL = this.Fields[i].cnm;

                        this.Fields[i].validERR = this.Fields[i].vtp;

                        if(this.Fields[i].tab!==""){
                            tab = this.getSelectedTab(i);
                            tab.setErrorClass(true);
                        }
                    }
                    else
                    {
                        this.Fields[i].validERR = "";
                    }
                }
            }
        }*/
        
        if(!this.isValidated){
                        
            var ci = this.getControlIndex(this.tmpCTL.CTLName);
            
            if(ci>0){
            if(this.Fields[ci].tab!=="")
                this.getSelectedTab(ci).setActive();
            }
            this.tmpCTL.setFocus();
        }
        
        return this.isValidated;
        
    };
    
    this.ClearAllTabError = function()
    {
        if(this.isContainGroups())
        {
            for(var i=0;i<this.GroupBox.GroupBoxes.length;i++)
                this.GroupBox.GroupBoxes[i].Tabs.clearErrorClasses();
        }
        else
           
        this.Tabs.clearErrorClasses();
        
    };
    
    this.AssignFields = function(jsonfields)
    {
        this.Fields = JSON.parse(jsonfields);
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
    
    this.generateGridView = function(pContainer,pContID)
    {
        this.Ajax.FormName = this.FormName;
        this.Ajax.AjaxID = "showGRID";
        var parent = this;
        this.GridView.CreateGridObject($("#"+pContainer),pContID);
        this.Ajax.CMN_WhereCL = this.SearchColumns;
        this.Ajax.CMN_WhereData = '';
        
        for(i=0;i<this.Fields.length;i++)
        {
            this.GridView.AddColumn(this.Fields[i].cnm,this.Fields[i].lbl,this.Fields[i].width);
        }
        
        this.GridView.FirstRowBlank=false;
        
        this.GridView.setSearching(true);
        
        this.GridView.setScrollBarX(true);
        this.GridView.setScrollBarY(true);
        
        this.GridView.setFocusOnSearch();
        
        this.GridView.FormName = this.FormName;
        this.GridView.AjaxEnable = true;
        this.GridView.AjaxID = "showGRID";
        this.GridView.AjaxSearchColumns = this.SearchColumns;
        
        try{
            this.ProgressBar.openProgress();
        }catch(e){alert(e);}
        this.Ajax.CallServer(function(data){
            //alert(data);
            try{
                
                parent.ProgressBar.closeProgess();
                parent.GridView.populateUsingJSON(data);
                
                /*parent.ProgressBar.closeProgess();
                parent.GridView.AssginJSONToGridView(JSON.parse(data));
                parent.GridView.SyncJSONToGridView();
                parent.GridView.defineEvents();
                //alert("fdsdf");
                if(parent.GridView.getRowLength()>0)
                {
                    parent.GridView.SelectSingleRow(0);
                }*/
            }catch(e){alert(e);}
        });
           
    };
    
    this.gotoNextControl = function(ctl,nxctl)
    {
        this.setControlFocus_Key(nxctl);
        
        try{
            if(this.ParentClassV!==null){
                this.ParentClassV.gotoNextControl(ctl,nxctl);
        }
        }catch(e){};
    };
    
    this.setControlFocus_Index = function(idx)
    {
        if(idx>0){
            if(this.Fields[idx].tab!==""){
                var tidx = this.Tabs.getTabIndex(this.Fields[idx].tab);
                this.Tabs.setActive(tidx);
            }
        }
    };
    
    this.setControlFocus_Key = function(ctl)
    {
        var idx = this.getControlIndexFromKey(ctl);
        if(idx>0){
            if(this.Fields[idx].tab!==""){
                var tidx = this.Tabs.getTabIndex(this.Fields[idx].tab);
                this.Tabs.setActive(tidx);
            }
            this.getControlKey(ctl).setFocus();
        }
    };
    
    this.FocusFirstControl = function()
    {
        var parent = this;
        if(this.FirstFocusControl!==""){
            (new HC_DelayCall()).Call(function () {
                parent.setControlFocus_Key(parent.FirstFocusControl);
            });
        }  
    };
    
    this.OpenNewForm = function()
    {
        if(!this.GridViewOnly){
            if(!this.FormActive){
                this.OpenFormFinal(this.Container,"NF");
                this.CurrentFormStatus = "New";
            }
            else
                alert("Form is Already Active");
        }
    };
    
    
    this.ClearForm = function()
    {
        var conf = confirm("Clear will clear all data entered in your screen \nDo you want to proceed (OK/Cancel)");
        if(conf){
        this.clearAll();
        
        try{
            this.ParentClassV.FormClear();
        }catch(e){};
        try{
            window[this.FormName+"_FormClear"](this.Container);
        }catch(e){};
        this.FocusFirstControl();
        }
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
        var id = this.getID();
        if(!this.ReadOnly){
            this.ShowGridView();
            this.HideForm();
            this.CurrentFormStatus = "Grid";
            try{
                window[id+"_OpenGridView"]();
            }catch(e){};
        }
    };
    
    this.CloseForm = function()
    {
        var id = this.getID();
        this.ShowGridView();
        this.HideForm();
        this.GridView.RefreshGrid();
        
        try{
            window[id+"_CloseForm"]();
        }catch(e){};
    };
    
    this.CloseGridView = function()
    {
        
    };
    
    this.ShowForm = function()
    {
        var id = this.getID();
        $("#"+id+"_Form").show();
    };
    
    this.HideForm = function()
    {
        var id = this.getID();
        $("#"+id+"_Form").hide();
    };
    
    this.ShowGridView = function()
    {
        var id = this.getID();
        $("#"+id+"_Grid").show();
    };
    
    this.HideGridView = function()
    {
        var id = this.getID();
        $("#"+id+"_Grid").hide();
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
        if(this.CurrentFormStatus!=="Grid"){
            if(this.CurrentFormStatus!=="Delete"){
                if(this.CurrentFormStatus==="Edit"){
                    this.CurrentRowIndex = this.getSelectedGridRowIndex(this.CurrentRowIndex,this.WhereColumn);
                    this.GridView.focusRow(this.CurrentRowIndex);
                }
                else
                if(this.CurrentFormStatus==="New")
                    this.GridView.focusRow(this.GridView.getRowLength() - 1);
            }
            else
                this.GridView.focusRow(0);
            this.GridView.setFocusOnSearch();
        }
    };
    
    this.AssignJSONArrayToForm = function(json)
    {
        this.clearAll();
        for(var i=0;i<this.Fields.length;i++)
        {
            if(json.getArVK(0,this.Fields[i].cnm)!==null){
                this.Controls[i].setText(json.getArVK(0,this.Fields[i].cnm));
                this.Controls[i].setValue(json.getArVK(0,this.Fields[i].cnm));
            }
            else{
                this.Controls[i].setText(json.getArVK(0,""));
                this.Controls[i].setValue(json.getArVK(0,""));
            }
        }
    };
    
    this.AssignJSONToForm = function(json)
    {
        this.clearAll();
        for(var i=0;i<this.Fields.length;i++)
        {
            this.Controls[i].setText(json.getVK(this.Fields[i].cnm));
            //this.Controls[i].setValue(json.getVK(this.Fields[i].cnm));
        }
    };
    
    this.EditForm = function()
    {
        if(!this.FormActive)
        {
            this.DataSelected(this.GridView.getSelectedJSON(),this.CurrentRowIndex);
        }
    };
    
    this.DataSelected = function(json,rwi)
    {
        var js = new HC_Json(JSON.stringify(json));
        if(!this.GridViewOnly){
            this.OpenFormFinal(this.Container,"FE","JSON",js);
            this.CurrentFormStatus = "Edit";
            this.CurrentRowIndex = json[this.WhereColumn];
            if(this.ParentClassV!==null){
                this.ParentClassV.EditSelected(json,rwi);
            }
        }
    };
    
    this.getSelectedGridRowIndex = function(data,jskey)
    {
        var json = this.GridView.getJSON();
        for(var i=0;i<this.GridView.getRowLength();i++)
        {
            if(data===json[i][jskey])
                return i;
        }
        return 0;
    };
    
    this.CancelForm = function()
    {
        if(!this.ReadOnly && !this.FormOnly){
            if(this.FormActive){
                var d = confirm("Are you sure want to cancel editing");
                if(d)
                {
                    try{
                    this.ShowGridView();
                    this.HideForm();
                    this.CurrentFormStatus = "Cancel";
                    this.GridView.RefreshGrid();
                    this.FormActive = false;
                    this.ButtonGrForm.setVisible(false);
                    this.ButtonGrGrid.setVisible(true);
                    }catch(e)
                    {}
                    
                    try{
                        window[this.FormName+"_CancelForm"]();
                    }catch(e){};
                }
            }
        }
    };
    
    this.getSelectedTab = function(idx)
    {
        var group = this.Fields[idx].group;
        var tab = this.Fields[idx].tab;
        var gbi,tbi;
        if(group!=="" && tab!=="")
        {
            gbi = this.GroupBox.getGBIndex(group);
            tbi = this.GroupBox.GroupBoxes[gbi].Tabs.getTabIndex(tab);
            return this.GroupBox.GroupBoxes[gbi].Tabs.Tabs[tbi];
        }
        else
        {
            tbi = this.Tabs.getTabIndex(tab);
            return this.Tabs.Tabs[tbi];
        }
    };
    
    this.NextControl = function(CTLName,NCTLName)
    {
        var idx = this.getControlIndex(NCTLName);
        var tab = this.getSelectedTab(idx);
        
        tab.setActive();
        
        $("#"+NCTLName).focus();
        $("#"+NCTLName).select();
    };
    
    this.getControlIndex = function(CTLName)
    {
        for(i=0;i<this.Fields.length;i++)
            if(this.Fields[i].cnm===CTLName)
                return i;
        return -1;
    };
    
    this.ExternalValidationStatus = function()
    {
        if (this.ExternalValidationEnable===false)
            return true;
        else{
            try{
                return window[this.FormName+"_ExternalValidation"]();
            }catch(e){}
        }
        return true;
    };
    
    this.SaveForm = function()
    {
        if(!this.ReadOnly){
            if(this.FormActive){
            var parent = this;
            try{
                this.validateForm();

                if(this.isValidated)
                {
                    if(this.ExternalValidationStatus())
                    {
                        
                        this.Ajax.FormName = this.FormName;
                        this.Ajax.AjaxID = "Save";
                        this.SyncFormData();
                        this.SyncAdditionalData();
                        
                        
                        //alert(JSON.stringify(this.Ajax.json));
                        
                        try{
                            window[parent.FormName+"_SaveFormStart"]();
                        }catch(e){};
                        
                        this.Ajax.CallServer(function(data) { 
                            
                            //(data);
                            
                            var jsn = JSON.parse(data);
                            alert(jsn.msg);

                            //parent.CurrentID = jsn.id;
                            
                            if(!parent.FormOnly){
                                try{
                                parent.ShowGridView();
                                parent.HideForm();
                                parent.PopulateGridViewFromAjax(jsn.id);
                                parent.GridView.SearchTextBox.setFocus();
                                parent.FormActive = false;
                                parent.ButtonGrForm.setVisible(false);
                                parent.ButtonGrGrid.setVisible(true);
                                }catch(e){
                                    alert(e);
                                }
                            }
                            else{
                                parent.clearAll();
                                parent.FocusFirstControl();
                            }
                            
                            try{
                                window[parent.FormName+"_SaveFormEnd"](jsn.id,parent.CurrentFormStatus,jsn.msg,jsn.adl);
                            }catch(e){};

                        });
                        
                    }
                }
            }catch(ee){alert(ee);}
            }
        }
    };
    
    this.PopulateGridViewFromAjax = function(id){
        
        this.GridView.Ajax.FormName = this.FormName;
        this.GridView.Ajax.AjaxID = "showGRID";
        this.GridView.Ajax.CMN_WhereCL = this.SearchColumns;
        this.GridView.populatefromAjax(undefined,undefined,id,this.WhereColumn);
        
        
    };
    
    this.DeleteForm = function()
    {
        try{
        var data = this.GridView.getSelectedJSON()[this.WhereColumn];
        this.DeleteSearch(this.WhereColumn,data);                
        }catch(ee){alert(ee);}
    };
    
    this.DeleteSearch = function(whcolumn,data)
    {
        if(!this.ReadOnly){
            if(!this.FormActive){
                var d = confirm("Are you sure want to delete record");
                if(d)
                {
                    var parent = this;
                    try{

                        this.Ajax.FormName = this.FormName;
                        this.Ajax.clearFormData();
                        this.Ajax.addFormData(whcolumn,data,data);
                        this.Ajax.AjaxID = "Delete";
                        
                        try{
                            window[this.FormName+"_DeleteFormStart"]();
                        }catch(e){};

                        this.CurrentFormStatus = "Delete";

                        this.Ajax.CallServer(function(data) { 
                            
                            //alert(data);
                            var jsn = JSON.parse(data);
                            alert(jsn.msg);

                            parent.CurrentID = jsn.id;

                            parent.PopulateGridViewFromAjax();

                            try{
                            window[parent.FormName+"_DeleteFormEnd"](jsn.id,jsn.msg,jsn.adl);
                            }catch(e){};

                        });

                    }catch(e){}
                }
            }
        }
    };
    
    this.DeleteSearchManual = function(whcolumn,data)
    {
            var parent = this;
            try{

            this.Ajax.FormName = this.FormName;
            this.Ajax.clearFormData();
            this.Ajax.addFormData(whcolumn,data,data);
            this.Ajax.AjaxID = "Delete";

            try{
                window[this.FormName+"_DeleteFormStart"]();
            }catch(e){};

            this.CurrentFormStatus = "Delete";

            this.Ajax.CallServer(function(data) { 

                var jsn = JSON.parse(data);
                alert(jsn.msg);

                try{
                window[parent.FormName+"_DeleteFormEnd"](jsn.id,jsn.msg,jsn.adl);
                }catch(e){};

            });

        }catch(e){}
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
    
    this.GenerateModal = function(pContainer)
    {
        if($("#"+pContainer+"_"+this.FormName+"_Modal").length===0)
        {
            this.Modal.ModalType = this.ModalType;
            this.Modal.CreateJQObject($("#"+pContainer),pContainer+"_"+this.FormName+"_Modal");
        }
    };
    
    this.MoveFormTo = function(pNewContainer)
    {
        $("#" + this.getID() + "_Menu").detach().appendTo('#'+pNewContainer);
        $("#" + this.getID() + "_Heading").detach().appendTo('#'+pNewContainer);
        $("#" + this.getID() + "_Grid").detach().appendTo('#'+pNewContainer);
        $("#" + this.getID() + "_Form").detach().appendTo('#'+pNewContainer);
    };
    
    this.OpenModal = function()
    {
        this.Modal.OpenModal();
        try{
            if(this.ParentClassV!==null)
                this.ParentClassV.Form_OpenModal();
        }catch(e){};
        try{
            window[this.getID()+"_OpenModal"]();
        }catch(e){};
    };
    
    this.ViewFormReadOnly = function(json)
    {
        this.CreateForm(this.Container);
        this.GenerateModal(this.Container);
        this.OpenModal();
        this.AssignJSONToForm(json);
        this.setReadOnlyAll(true);
        $('#'+this.Modal.ModalName+"_body").html("");
        $("#" + this.getID() + "_Heading").clone().appendTo('#'+this.Modal.ModalName+"_body");
        $("#" + this.getID() + "_Form").clone().appendTo('#'+this.Modal.ModalName+"_body").show();
        this.setReadOnlyAll(false);
    };
    
    this.OpenFormFinal = function(pContainer,OpenTP,SearchTP,SearchData,FormRO)
    {
        
        /*
         * 
         * @param {type} pContainer
         * @returns {undefined}
         * 
         OpenTP Parameters
            1 ) NR      : GridView With Insert Update Delete
            2 ) GVRO    : GridView ReadOnly 
            3 ) NRMO    : GridView in Modal With Insert Update Delete
            4 ) GROMO   : GridView ReadOnly in Modal
            5 ) FO      : Form Only
            6 ) FE      : Form Editable
            7 ) FOMO    : Form Only in Modal
         */
        var FunMSG = "Open";
        this.CreateForm(pContainer);
        this.HideAllMenuButton(true);
        this.HideForm();
        this.HideGridView();
        var pJson;
        if(OpenTP==="NR" || OpenTP==="GVRO" || OpenTP==="GROMO" || OpenTP==="NRMO"){
            
            this.OpenGridView();
            this.GridView.setFocusOnSearch();
            this.GridView.setGridViewHeight(271);
            this.GridView.setScrollBarX(true);
            
            FunMSG += "_Grid";
            
        }
        
        if(OpenTP==="FO" || OpenTP==="FOMO" || OpenTP==="FE" || OpenTP==="NF")
        {
            this.ShowForm();
             if(!FormRO){
                this.FocusFirstControl();
             }
            this.clearAll();
            this.FormActive = true;
            this.ShowMenuButton("Form",true);
            
            FunMSG += "_Form";
            
            if(OpenTP==="FE")
                FunMSG += "_Edit";
            
            if(OpenTP==="NF")
                FunMSG += "_New";
        }
        
        if(OpenTP==="NRMO" || OpenTP==="GROMO" || OpenTP==="FOMO")
        {
            this.GenerateModal(pContainer);
            this.OpenModal();
            this.MoveFormTo(this.Modal.ModalName+"_body");
            
            FunMSG += "_Modal";
        }
        
        if(OpenTP==="NR" || OpenTP==="NRMO"){
            this.ShowMenuButton("Grid",true);
        }
        
        if(OpenTP==="FO" || OpenTP==="FOMO")
        {
             this.FormOnly = true;
             this.ButtonGrForm.setVisibleAll(2,false);
        }
        
        if(OpenTP==="GVRO" || OpenTP==="GROMO"){
            this.ReadOnly = true;
            this.GridViewOnly = true;
            this.ButtonGrGrid.setHideAll();
        }
        
        if(SearchTP==="KEY")
        {
            this.SearchRecord(SearchData);
            
            FunMSG += "_KEY";
        }
        
        if(SearchTP==="JSON")
        {
            pJson = SearchData;
            this.AssignJSONToForm(SearchData);
            
            FunMSG += "_JSON";
        }
        
        if(FormRO===true){
            this.setReadOnlyAll(true);
            this.ButtonGrForm.setVisible(false);
            this.ButtonGrGrid.setVisible(false);
            FunMSG += "_ReadOnly";
        }
        
        try{
            if(this.ParentClassV!==null)
                this.ParentClassV.Form_OpenForm(this.Container,FunMSG,pJson);
        }catch(e){};
        
        try{
            window[this.FormName+"_Open"](this.Container,FunMSG,pJson);
        }catch(e){};
      
        
        
    };
    
    this.SearchRecord=function(data,clmn){
        var parent = this;
        this.WhereColumn = clmn || this.WhereColumn;
        this.Ajax.clearFormData();
        var id = data;
        this.Ajax.addFormData(this.WhereColumn,id,id);
        this.Ajax.FormName = this.FormName;
        this.Ajax.AjaxID = "Search";

        try{
        window[this.FormName+"_AjaxSearchingStart"](this.Container,id);
        }catch(e){};

        this.Ajax.CallServer(function(data) {
            try{
                //alert(data)
                var json = new HC_Json(data);
                pJson = json; 
                parent.AssignJSONArrayToForm(json);

                try{
                    window[parent.FormName+"_AjaxSearchingEnd"](parent.Container,id,data);
                }catch(e){};

            }catch(e){alert(e);}
        });
        
    };
    
    
    this.btnCloseClick = function()
    {
        try{
            window[this.FormName+"_CloseModalForm"]();
        }catch(e){};
        
        //this.Modal.removeModal();
        
    };
    
    this.btnOKClick = function()
    {
        try{
            window[this.FormName+"_CloseModalForm"]();
        }catch(e){};
        
        //this.Modal.removeModal();
        
    };
    
    this.setReadOnlyAll = function(tf)
    {
        var i;
        for(i=0;i<this.Controls.length;i++){
            this.Controls[i].setReadOnly(tf);
        }
    };
    
    this.GridViewRowDoubleClick = function(rwi,json)
    {
        var id = this.getID();
        try{
        if($("#"+id+"_MenuContainer").length>0)
            $("#"+id+"_MenuContainer").remove();
        
        $("#"+this.Container).append("<div id='" + id + "_MenuContainer' class='list-group'></div>");
        this.MenuGroup.OpenMenuModal($("#"+id+"_MenuContainer"));
        
        this.MenuGroup.setMenuGroupLabel("Record Menu");
        this.MenuGroup.addMenu(id + "_menunew","New");
        this.MenuGroup.addMenu(id + "_menuedit","Edit");
        this.MenuGroup.addMenu(id+"_menudelete","Delete");
        this.MenuGroup.addMenu(id+"_menuview","View");
        this.MenuGroup.Toggle();
        
        var parent = this;
        
        this.MenuGroup.setEvent(0,function(){
            parent.MenuGroup.Modal.CloseModal();
            parent.OpenNewForm();
        });
        
         this.MenuGroup.setEvent(1,function(){
             parent.MenuGroup.Modal.CloseModal();
             parent.DataSelected(json,rwi);
        });
        
        this.MenuGroup.setEvent(2,function(){
            parent.MenuGroup.Modal.CloseModal();
            parent.DeleteForm();
        });
        
        this.MenuGroup.setEvent(3,function(){
            parent.MenuGroup.Modal.CloseModal();
            try{
                var js = new HC_Json(JSON.stringify(json));
                parent.ViewFormReadOnly(js);
            }catch(e){alert(e);}
        });
        
        }catch(e){alert(e);}
    };
    
    this.GridViewRowClick = function(idx,json)
    {
        this.GridView.setFocusOnSearch();
    };
    
    this.OpenFormModalReadOnly = function(pContainer,x)
    {
        var id = pContainer + "_" + this.FormName;
        this.OpenFormFinal(pContainer,"FOMO","KEY",x,true);
        $("#"+id+"_Heading").css("margin-top","40px");
    };
    
    this.OpenFormModalEditable = function(pContainer,x)
    {
        this.OpenFormFinal(pContainer,"FOMO","KEY",x);
    };
    
    this.OpenFormEditable = function(pContainer,x)
    {
        this.OpenFormFinal(pContainer,"FO","KEY",x);
    };
    
    this.setControlBackColorIndex = function(idx,Color){
       this.getControlFromIndex(idx).setBackColor(Color);
    };
    
    this.getControlBackColorIndex = function(idx){
        return this.getControlFromIndex(idx).getBackColor();
    };
    
    this.setControlBackColorKey = function(key,Color){
       this.getControlKey(key).setBackColor(Color);
    };
    
    this.getControlBackColorKey = function(key){
        return this.getControlKey(key).getBackColor();
    };
    
    this.setControlBackColorAll = function(Color){
       for(i=0;i<this.Controls.length;i++)
           this.getControlFromIndex(i).setBackColor(Color);
    };
    
};


function HC_TransactionForms(FRMName)
{
    this.FormName = FRMName;
    this.Container = "";
    this.Form = new HC_Forms(FRMName,this);
    this.TranGridView = new HC_GridView_Transaction(FRMName+"_TranGridView",this);
    this.Ajax = new HC_Ajax(this.FormName + "_Ajax");
    this.Modal = new HC_BSModal(FRMName+"_modal",this);
    this.ReadOnly = false;
    this.TranGridJSON = null;
    this.FormActive = true;
    this.ButtonGrGridTran = new HC_ButtonGroup(FRMName+"_ButtonGroupGrid",this);
    this.ButtonGrFormTran = new HC_ButtonGroup(FRMName+"_ButtonGroupForm",this);
    this.PrimaryColumn = "";
    
    this.FormMenuClick = function(btn){
        var id = this.Form.getID();
        if(btn==="Cancel"){
            $("#"+id+"_TranGridView_Container").hide();
        }
        if(btn==="Save"){
            this.SaveForm();
        }
    };
   
    this.Dispose = function(){
        this.TranGridView.Dispose();
        this.Form.Dispose();
    };
    
    this.CreateForm = function(pContainer){
    
        this.Form.CreateForm(pContainer);
        
    };
    
    this.Form_Created = function(pContainer,FRMName)
    {
        try{
            this.FormName = FRMName || this.FormName;
            this.Container = pContainer || this.Container;
            
            //alert(this.Container);
            
            this.Form.EnableDefaultMenuEvent = false;
            
            var id = this.Form.getID();
            if($("#"+id+"_TranGridView_Container").length===0){
                var trgridcont = $("<div id='" + id + "_TranGridView_Container'></div>");
                $("#" + pContainer).append(trgridcont);
                this.TranGridView.Create(id+"_TranGridView_Container",JSON.stringify(this.TranGridJSON),this.FormName+"_TranGridView");
                this.TranGridView.Container = pContainer;
                $("#"+id+"_TranGridView_Container").hide();
            }
        }catch(e){alert(e);}
    };
    
    this.OpenFormFinal = function(pContainer,OpenTP,SearchTP,SearchData,FormRO)
    {
        this.Form.OpenFormFinal(pContainer,OpenTP,SearchTP,SearchData,FormRO);
    };
    
    this.RefreshTranGrid = function()
    {
        this.TranGridView.GridView.setGridViewHeight(270);
        this.TranGridView.GridView.setDefaultWidth(false);
        this.TranGridView.GridView.setScrollBarX(false);
        this.TranGridView.GridView.clearAllRows();
        this.TranGridView.GridView.addRow();
        this.TranGridView.GridView.addRow();
        this.TranGridView.GridView.defineEvents();
    };
    
    this.Form_OpenForm = function(pContainer,FunMSG,pJson)
    {
        var id = this.Form.getID();
        if(FunMSG==="Open_Form_New" || FunMSG==="Open_Form")
        {
            $("#"+id+"_TranGridView_Container").show();
            this.RefreshTranGrid();
            this.FormActive = true;
        }
        
        if(FunMSG==="Open_Form_Modal" || FunMSG==="Open_Form_Modal_KEY" || FunMSG=="Open_Form_Modal_KEY_ReadOnly")
        {
            $("#"+id+"_TranGridView_Container").detach().appendTo('#'+this.Form.getID()+"_Modal_body");
            $("#"+id+"_TranGridView_Container").show();
            this.RefreshTranGrid();
            this.FormActive = true;
        }
        
        if(FunMSG==="Open_Form_Edit")
        {
            this.EditSelected(pJson,0);
        }
    };
    
    this.OpenNewForm = function()
    {
        this.Form.OpenNewForm();
    };
    
    
    this.gotoNextControl = function(ctl,nxctl)
    {
        if(nxctl==="GridView")
        {
            this.TranGridView.setFocus();
        }
    };
    
    this.SaveForm = function()
    {
        var id = this.Form.getID();
        if(!this.ReadOnly){
            if(this.FormActive){
            var parent = this;
            try{
                this.Form.validateForm();
                
                if(this.Form.isValidated)
                {
                    if(this.Form.ExternalValidationStatus())
                    {
                        try{
                            window[this.FormName+"_SaveFormStart"]();
                        }catch(e){};

                        this.Ajax.FormName = this.Form.FormName;
                        this.Ajax.AjaxID = "Save";
                        this.SyncFormData();
                        this.SyncAdditionalData();
                        this.Ajax.addTransactionData(this.TranGridView.GridView.getJSON());
                        
                        this.Ajax.CallServer(function(data) { 

                            //alert(data);
                            
                            var jsn = JSON.parse(data);
                            alert(jsn.msg);

                            //parent.CurrentID = jsn.id;
                            
                            if(parent.Form.FormOnly===false){
                                $("#"+id+"_TranGridView_Container").hide();
                            
                                try{
                                parent.Form.ShowGridView();
                                parent.Form.HideForm();
                                
                                parent.Form.ButtonGrForm.setVisible(false);
                                parent.Form.ButtonGrGrid.setVisible(true);
                                
                                parent.Form.GridView.RefreshGrid();
                                
                                }catch(e){alert(e);}                                
                                
                                
                            }
                            parent.Form.FormActive = false;
                            
                            try{
                                window[parent.FormName+"_SaveFormEnd"](jsn.id,parent.CurrentFormStatus,jsn.msg,jsn.adl);
                            }catch(e){};

                        });
                        
                    }
                }
            }catch(ee){alert(ee);}
            }
        }
    };
  
    this.SyncFormData = function()
    {
        this.Ajax.clearFormData();
        for(i=0;i<this.Form.Fields.length;i++)
        {
            this.Ajax.addFormData(this.Form.Fields[i].cnm,this.Form.Controls[i].Text,this.Form.Controls[i].Value);
        }
    };
    

    this.SyncAdditionalData = function()
    {
        this.Ajax.clearAdditional();
        for (var x in GP){
            this.Ajax.addAdditional(x,GP[x]);
        }
    };
    
    this.EditSelected = function(json,rwi)
    {
        var id = this.Form.getID();
        try{
            if(json[this.PrimaryColumn]!==undefined){
                this.Form.ButtonGrForm.setVisible(true);
                this.Ajax.AjaxID = "Details";
                this.Ajax.FormName = this.FormName;
                this.Ajax.clearFormData();
                this.Ajax.addFormData(this.PrimaryColumn,json[this.PrimaryColumn],json[this.PrimaryColumn]);
                var parent = this;
                this.Ajax.CallServer(function(data) 
                { 
                    try{
                        $("#"+id+"_TranGridView_Container").show();
                        parent.TranGridView.GridView.AssginJSONToGridView(JSON.parse(data));
                        parent.TranGridView.GridView.SyncJSONToGridView();
                        parent.TranGridView.GridView.addRow();
                        parent.TranGridView.GridView.defineEvents();
                        parent.TranGridView.GridView.setGridViewHeight(270);
                        parent.TranGridView.GridView.setDefaultWidth(true);
                        parent.TranGridView.GridView.setScrollBarX(true);
                        parent.Form.FormActive = true;
                    }catch(e){alert(e);}
                });
            }
        }catch(ee){alert(ee);}
        
    };
    
    this.CancelForm = function()
    {
        var id = this.Form.getID();
        this.Form.CancelForm();
        $("#"+id+"_TranGridView_Container").hide();
    };
    
    
    this.EditForm = function()
    {
        if(!this.Form.FormActive)
        {
            var json = this.Form.GridView.getSelectedJSON();
            this.Form.DataSelected(json,this.Form.CurrentRowIndex);
            this.EditSelected(this.Form.CurrentRowIndex,json);
        }
    };

    this.DeleteForm = function()
    {
        try{
        var data = this.Form.GridView.getJSONMatrix(this.Form.CurrentRowIndex)[this.Form.WhereColumn];
        this.Form.DeleteSearch(this.Form.WhereColumn,data);                
        }catch(ee){alert(ee);}
    };
    
    this.ClearForm = function()
    {
        this.Form.ClearForm();
        this.RefreshTranGrid();
    };
    
    this.OpenFormModalReadOnly = function(pContainer,x)
    {
        this.Form.OpenFormModalReadOnly(pContainer,x);
        var id = this.Form.getID();
        this.Ajax.AjaxID = "Details";
        this.Ajax.FormName = this.FormName;
        this.Ajax.clearFormData();
        this.Ajax.addFormData(this.PrimaryColumn,x,x);
        var parent = this;
        
        
        this.Ajax.CallServer(function(data) 
        { 
            try{
                $("#"+id+"_TranGridView_Container").show();
                parent.TranGridView.GridView.AssginJSONToGridView(JSON.parse(data));
                parent.TranGridView.GridView.SyncJSONToGridView();
                parent.TranGridView.GridView.setDefaultWidth(true);
                parent.TranGridView.GridView.setScrollBarX(true);
                
                $("#"+id+"_TranGridView_Container").detach().appendTo("#"+parent.Form.Modal.ModalName+"_body");
                
                parent.TranGridView.GridView.setGridViewHeight(150);
                parent.TranGridView.ButtonGroup.setVisible(false);
            }catch(e){alert(e);}
        });
    };
    
    this.OpenFormModalEditable = function(pContainer,x)
    {
        this.Form.OpenFormModalEditable(pContainer,x);
        this.Form.setReadOnlyAll(false);
        var id = this.Form.getID();
        this.Ajax.AjaxID = "Details";
        this.Ajax.FormName = this.FormName;
        this.Ajax.clearFormData();
        this.Ajax.addFormData(this.PrimaryColumn,x,x);
        var parent = this;
        
        this.Ajax.CallServer(function(data) 
        { 
            try{
                
                $("#"+id+"_TranGridView_Container").show();
                parent.TranGridView.GridView.AssginJSONToGridView(JSON.parse(data));
                parent.TranGridView.GridView.SyncJSONToGridView();
                parent.TranGridView.GridView.addRow();
                parent.TranGridView.GridView.defineEvents();
                parent.TranGridView.GridView.setDefaultWidth(true);
                parent.TranGridView.GridView.setScrollBarX(true);
                
                $("#"+id+"_TranGridView_Container").detach().appendTo("#"+parent.Form.Modal.ModalName+"_body");
                
                parent.TranGridView.GridView.setGridViewHeight(200);
                parent.TranGridView.ButtonGroup.setVisible(true);
            }catch(e){alert(e);}
        });
    };
 };